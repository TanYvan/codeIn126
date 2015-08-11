class Remuneration11SetController < ApplicationController
  # 工时汇总  列表
  def list
    @case = nil#当前办理案件
    if session[:recevice_code_2]!=nil
      ca_rc = session[:recevice_code_2]
      TbTzxs.init(session[:recevice_code_2],session[:user_code])
      @xs = TbTzxs.find(:first, :conditions => "used = 'Y' and recevice_code = '#{ca_rc}'")

      if ca_rc == nil or @xs.blank?
      else
        @case = TbCase.find_by_recevice_code(ca_rc)

        # 查询字典表中 仲裁庭报酬调整系数的选项值
        @xishu = TbDictionary.find(:all, :conditions => "typ_code='9021' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").collect{|p|[p.data_text,p.data_val]}

        @casearbitman = TbCasearbitman.find(:all, :conditions => "recevice_code='#{ca_rc}' and used='Y'")
        # 如果当前案件只有一个仲裁员，说明是独任仲裁员
        typ = @casearbitman.size # 仲裁员类型

        # 本请求  应交
        #c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
        # 本请求  应退
        #c2 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}' and state<>3") || 0
        # 本请求  减退
        #c3 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'  and state<>3") || 0
        # 反请求  应交
        #c4 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
        # 反请求  应退
        #c5 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}' and state<>3") || 0
        # 反请求  减退
        #c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'  and state<>3") || 0

        # 此处zcf1 应当是实收费用，而不是应收费！！！！！！

        # 实交（本+反）
        c7 = TbShouldCharge.sum("re_rmb_money", :conditions => "(typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
        # 实退（本+反）
        c8 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "(typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'  and  (state = 4 or state = 2)") || 0).to_f


        # 实收 = 实交 - 实退
        c9 = c7 - c8


        #@zcf1 = (c1 - (c2 - c3)) + (c4 - (c5 - c6))      税前仲裁费 = 应收费 =  本请求应收费 + 反请求应收费； 应收费 = 应交 -（应退 - 减退）
        @zcf1 = c9
        @zcf2 = (@zcf1 * 0.945).round   # 税后仲裁费
        @zcf3 = hds(@zcf2,typ).round  # 报酬核定数
        @tzxs = tzxs(@xs.xishu) # 仲裁庭报酬调整系数
        @yyy  = (@zcf3 * @tzxs).round
        @jjj   = (@yyy * 0.55).round

        @evaluate = "yes"  # 是否计算稿酬和绩效报酬标记，yes：计算；no：不计算。如果是独任仲裁员案件，且仲裁费（税后）小于 20000，不需要计算
        if typ == 1 and @zcf2 <= 20000
          @evaluate = "no"
        end
      end
    end
  end

  # -----------------------------裁决书制作报酬----------------------------

  # 工时汇总  裁决书制作信息 列表
  def list_1
    @case = nil #当前办理案件
    unless session[:recevice_code_2] == nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_2])
      c = "recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun = RemunerationAward.find(:all, :order => 'id', :conditions => c)
    end
  end

  # 工时汇总  裁决书制作 评级
  def edit_1
    @remun = RemunerationAward.find(params[:id])
  end

  # 工时汇总  裁决书制作 评价&报酬录入
  def update_1
    evaluate = params[:evaluate]
    yyy = params[:yyy].to_i # 裁庭报酬金额
    kkk = (yyy * 0.15).round        # 撰写裁决书报酬
    remun = RemunerationAward.find(params[:id])
    bp = TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{remun.p_code}' and used='Y' and extend_code=''")
    if remun.used == 'Y' and bp != nil and remun.rmb == params[:old_rmb].to_i and  !query_state(session[:recevice_code_2])# 如果该仲裁员的报酬还未发放且未提交才可以修改
      if evaluate == "yes" # 如果是独任仲裁员案件，且仲裁费（税后）小于 20000，则只评价，不计算
        remun.rmb = (kkk * cjsdj(params[:remun][:grade])).round
      else
        remun.rmb = 0
      end
      remun.u2  = session[:user_code]
      remun.t2  = Time.now()
      if remun.update_attributes(params[:remun])
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',remun.p_code,'gc_rmb', params[:old_rmb].to_f,remun.rmb)
        flash[:notice]="操作成功"
        #redirect_to :action=>"list_1", :yyy => yyy, :evaluate => evaluate
        render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
      else
        flash[:notice]="操作失败"
        render :action=>"edit_1", :id=>params[:id], :yyy => yyy, :evaluate => evaluate
      end
    else
      flash[:notice]="操作失败，本案报酬已经发放！"
      redirect_to :action=>"edit_1", :id => params[:id], :yyy => yyy, :evaluate => evaluate
    end
  end

  # 工时汇总 裁决书制作  报酬删除
  # 当金额为零的时候是不可以删除的，TbBonusPenalty的del_set会将 view_num 的值减小1
  def delete_1
    yyy = params[:yyy]
    remun = RemunerationAward.find(params[:id])
    bp = TbBonusPenalty.find(:first,
      :conditions => "recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{remun.p_code}' and used='Y' and extend_code=''"
    )
    if bp != nil and !query_state(session[:recevice_code_2])
      remun.u2     = session[:user_code]
      remun.t2     = Time.now()
      remun.rmb    = 0
      remun.grade  = ""
      # remun.remark = "" 备注不能删，有可能是助理录入的
      if remun.update_attributes(params[:remun])
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',remun.p_code,'gc_rmb',params[:old_rmb].to_f,0)
        flash[:notice] = "修改成功"
      else
        flash[:notice]="修改失败"
      end
    else
      flash[:notice]="修改失败,本案报酬已经发放！"
    end
    # redirect_to :action=>"list_1", :yyy => yyy, :evaluate => params[:evaluate]
    render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
  end

  # -----------------------------绩效报酬----------------------------

  # 仲裁员绩效报酬评价  列表
  def list_2
    @case = nil#当前办理案件
    unless session[:recevice_code_2] == nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_2])
      c = "recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun = RemunerationJixiao.find(:all, :order => 'arbitman_type', :conditions => c)
    end
    @casearbitman = TbCasearbitman.find_by_sql(
      "select tb_arbitmen.code as code ,tb_arbitmen.name as name
       from tb_casearbitmen ,tb_arbitmen
       where tb_casearbitmen.recevice_code='#{session[:recevice_code_2]}' and tb_casearbitmen.used='Y'
             and tb_casearbitmen.arbitman=tb_arbitmen.code
       order by tb_arbitmen.name" )
    @rs1 = TbDictionary.find(:all, :conditions => "typ_code='9023' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @rs2 = TbDictionary.find(:all, :conditions => "typ_code='9024' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @rs3 = TbDictionary.find(:all, :conditions => "typ_code='9025' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
  end

  # 仲裁员绩效报酬评价  修改页面准备
  def edit_2
    @remun = RemunerationJixiao.find(params[:id])
  end

  # 仲裁员绩效报酬评价  
  def update_2
    evaluate = params[:evaluate]
    yyy = params[:yyy].to_i # 裁庭报酬金额
    lll = (yyy * 0.3).round        # 撰写裁决书报酬
    remun = RemunerationJixiao.find(params[:id])
    bp = TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{remun.p_code}' and used='Y' and extend_code=''")
    if remun.used == 'Y' and bp != nil and remun.rmb == params[:old_rmb].to_i and !query_state(session[:recevice_code_2]) # 如果该仲裁员的报酬还为发放才可以修改
      if evaluate == "yes" # 如果是独任仲裁员案件，且仲裁费（税后）小于 20000，则只评价，不计算
        remun.rmb = (lll * cjsdj(params[:remun][:grade]) * jx(remun.p_code)).round
      else
        remun.rmb = 0
      end
      
      remun.u2  = session[:user_code]
      remun.t2  = Time.now()
      if remun.update_attributes(params[:remun])
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',remun.p_code,'zc_rmb', params[:old_rmb].to_f,remun.rmb)
        flash[:notice] = "修改成功"
        # redirect_to :action => "list_2", :id => params[:id], :yyy => yyy, :evaluate => evaluate
        render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
      else
        flash[:notice] = "修改失败"
        render :action => "edit_2", :id => params[:id], :yyy => yyy, :evaluate => evaluate
      end
    else
      flash[:notice] = "修改失败，本案报酬已经发放！"
      redirect_to :action => "edit_2", :id => params[:id], :yyy => yyy, :evaluate => evaluate
    end
  end

  # 仲裁员绩效报酬评价
  def delete_2
    yyy = params[:yyy]
    remun = RemunerationJixiao.find(params[:id])
    bp = TbBonusPenalty.find(:first,
      :conditions => "recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{remun.p_code}' and used='Y' and extend_code=''"
    )
    old_rmb = remun.rmb
    if bp != nil and !query_state(session[:recevice_code_2])
      remun.u2     = session[:user_code]
      remun.t2     = Time.now()
      remun.rmb    = 0
      remun.grade  = ""
      # remun.remark = "" 备注不能删，有可能是助理录入的

      if remun.update_attributes(params[:remun])
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',remun.p_code,'zc_rmb',old_rmb,0)
        flash[:notice] = "删除成功"
      else
        flash[:notice]="删除失败"
      end
    else
      flash[:notice]="删除失败，本案报酬已经发放！"
    end
    # redirect_to :controller=>"remuneration11_set", :action=>"list_2", :yyy => yyy, :evaluate => params[:evaluate]
    render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
  end

  # ----------------------------基本报酬-----------------------------

  # 仲裁员报酬 基本报酬
  def list_3
    @case = nil #当前办理案件
    if session[:recevice_code_2] != nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_2])
      c = "recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun = RemunerationBase.find(:all, :order => 'arbitman_type', :conditions => c)
      @case_remun_state = query_state(session[:recevice_code_2]) #提交出纳状态 true：已提交  false：未提交
      @paid = true # 状态发放  true：已发放  false：未发放
      num = 0 #计数器 已发放个数
      casearbitman = TbCasearbitman.find(:all, :conditions => "recevice_code='#{session[:recevice_code_2]}' and used='Y'")
      casearbitman.each do |man|
        bp = TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{man.arbitman}' and used='Y' ")
        if !bp.blank?
         num = num + 1 if !bp.extend_code.blank?
        end
      end
      @paid = false if num == 0
    end
  end

  # 仲裁员报酬 基本报酬录入
  def update_3
    zcf2  = params[:zcf2].to_i
    yyy   = params[:yyy].to_i # 裁庭报酬金额
    jjj   = (yyy * 0.55).round        # 仲裁员基本报酬
    ca_rc = session[:recevice_code_2]
    current_case = TbCase.find_by_recevice_code(ca_rc)
    begin
      # 计算每一位仲裁员的基本报酬
      casearbitman = TbCasearbitman.find(:all, :conditions => "recevice_code='#{ca_rc}' and used='Y'")
      count = casearbitman.size
      
      casearbitman.each do |man|
        
        rem = RemunerationBase.new()
        rem.recevice_code = current_case.recevice_code
        rem.case_code     = current_case.case_code
        rem.general_code  = current_case.general_code
        rem.p_code        = man.arbitman
        rem.arbitman_type = man.arbitmantype
        rem.p_typ         = "0001"
        rem.u2            = session[:user_code]
        rem.t2            = Time.now()

        if man.arbitmantype == "0001" or man.arbitmantype == "0002" # 首席或独任
          rem.rmb     = (jjj * 0.5).round # 首席或独任仲裁员报酬为 jjj（仲裁员基本报酬）的50%
        else
          rem.rmb     = (jjj * 0.25).round # 普通仲裁员报酬为 jjj（仲裁员基本报酬）的25%
        end

        if count == 1 and zcf2 <= 20000
          rem.rmb = 6000 # 税后仲裁费如果小于等于20000且是独任案件，直接指定报酬为 6000
        end

        rem.save()

        # 在 delete_3中删除基本报酬的时候使用 del_set 方法会将 view_num 字段减 1，所以在创建的时候要先添加 然后再更新
        # 添加基本报酬的时候要给 view_num 加1 ，但是添加稿酬或者绩效报酬的时候不应该改变 view_num 字段的值
        TbBonusPenalty.add(ca_rc,'0001',rem.p_code)
        TbBonusPenalty.up_set(ca_rc,'0001',rem.p_code,'zc_rmb',0,rem.rmb)
      end
    rescue => err
      puts "==================================================================="
      puts err
      puts "==================================================================="
      flash[:notice]  = "修改失败"
    else
      flash[:notice] = "修改成功"
    end
    #render :action => "list_3", :yyy => yyy
     render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
  end

  # 仲裁员报酬 基本报酬删除
  def delete_3
    yyy = params[:yyy] # 裁庭报酬金额
    ca_rc = session[:recevice_code_2]
    remun = RemunerationBase.find(:all, :conditions => "used = 'Y' and recevice_code = '#{ca_rc}'")
    if remun.size != 0
      # 删掉之前的基本报酬记录，且将 tb_bonus_penalty 表中对应记录的 zc_rmb 扣减
      remun.each do |r|
        r.used = "N"
        r.save
        TbBonusPenalty.del_set(ca_rc,"0001",r.p_code,"zc_rmb",r.rmb)
      end
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "删除失败"
    end
    #redirect_to :action => "list_3", :yyy => yyy
    render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
  end

  # ----------------------------其他-----------------------------

  # 修改 仲裁庭报酬调整系数
  def changexs
    c = "recevice_code='#{session[:recevice_code_2]}' and used='Y'"
    award_money  = RemunerationAward.sum(:rmb,  :conditions => c) || 0
    jixiao_money = RemunerationJixiao.sum(:rmb, :conditions => c) || 0
    base_money   = RemunerationBase.sum(:rmb, :conditions => c) || 0

    xs = TbTzxs.find(params[:id])
    xs.xishu = params[:xs][:xishu]
    
    if base_money != 0  or award_money != 0 or jixiao_money != 0
      flash[:notice] = "修改失败，基本报酬、稿酬和绩效报酬都为0才允许修改！"
      redirect_to :action => "list"
    elsif xs.save() 
      flash[:notice] = "修改成功"
      redirect_to :action => "list"
    else
      flash[:notice] = "修改失败"
      render :action => "lsit", :id => params[:id]
    end
  end

  # 报酬报表
  def report
    @case = nil#当前办理案件
    ca_rc = session[:recevice_code_2]
    @xs = TbTzxs.find(:first, :conditions => "used = 'Y' and recevice_code = '#{ca_rc}'")    
    unless ca_rc == nil or @xs.blank?
      @remun_state={"N"=>"不发放","Y"=>"提交出纳发放"}
      @case = TbCase.find_by_recevice_code(ca_rc)

      # 开庭次数
      @sitting_times = TbSitting.count(:id, :conditions => " used = 'Y' AND recevice_code='#{ca_rc}'");

      # 查询字典表中 仲裁庭报酬调整系数的选项值
      @xishu = TbDictionary.find(:all, :conditions => "typ_code='9021' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").collect{|p|[p.data_text,p.data_val]}

      @casearbitman = TbCasearbitman.find(:all, :conditions => "recevice_code='#{ca_rc}' and used='Y'")
      # 如果当前案件只有一个仲裁员，说明是独任仲裁员
      typ = @casearbitman.size # 仲裁员类型

#      # 本请求  应交
#      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
#      # 本请求  减交
#      c8 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
#      # 本请求  应退
#      c2 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}' and (state = 4 or state = 2)") || 0
#      # 本请求  减退
#      c3 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'  and (state = 4 or state = 2)") || 0
#      # 反请求  应交
#      c4 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
#      # 反请求  减交
#      c9 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
#      # 反请求  应退
#      c5 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}' and (state = 4 or state = 2)") || 0
#      # 反请求  减退
#      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}' and (state = 4 or state = 2)") || 0
#
#      @zcf1 = (c1 - c8 - (c2 - c3)) + (c4 - c9 - (c5 - c6)) # 税前仲裁费 = 应收费 =  本请求应收费 + 反请求应收费； 应收费 = 应交 -（应退 - 减退）
      
      # 实交（本+反）
      c7 = TbShouldCharge.sum("re_rmb_money", :conditions => "(typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'") || 0
      # 实退（本+反）
      c8 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "(typ='0001' or typ='0004') and used='Y' and recevice_code='#{ca_rc}'  and  (state = 4 or state = 2)") || 0).to_f


      # 实收 = 实交 - 实退
      c9 = c7 - c8


      #@zcf1 = (c1 - (c2 - c3)) + (c4 - (c5 - c6))      税前仲裁费 = 应收费 =  本请求应收费 + 反请求应收费； 应收费 = 应交 -（应退 - 减退）
      @zcf1 = c9
      @zcf2 = (@zcf1 * 0.945).round   # 税后仲裁费
      @zcf3 = hds(@zcf2,typ).round  # 报酬核定数
      @tzxs = tzxs(@xs.xishu) # 仲裁庭报酬调整系数
      @yyy  = (@zcf3 * @tzxs).round
      @jjj  = (@yyy * 0.55).round
      
      @kkk  = (@yyy * 0.15).round     # 撰写裁决书报酬
      @lll  = (@yyy * 0.3).round      # 仲裁员绩效报酬
      @aaa  = 0                       # 基本报酬  首席
      @bbb  = 0                       # 基本报错  申请方
      @ccc  = 0                       # 基本报酬  被申请方




      @zcy1 = "" # 完整裁决书         承担人
      @zcy2 = "" # 仲裁庭意见         承担人
      @zcy3 = "" # 中间裁决、部分裁决  承担人

      @dj1 = "" # 完整裁决书         等级
      @dj2 = "" # 仲裁庭意见         等级
      @dj3 = "" # 中间裁决、部分裁决  等级

      @je1 = 0 # 完整裁决书         金额
      @je2 = 0 # 仲裁庭意见         金额
      @je3 = 0 # 中间裁决、部分裁决  金额

      @jx1 = (@lll * 0.5).round
      @jx2 = (@lll * 0.25).round
      @jx3 = (@lll * 0.25).round

      @dj4 = ""
      @dj5 = ""
      @dj6 = ""

      @je4 = 0
      @je5 = 0
      @je6 = 0

      @zje1 = 0
      @zje2 = 0
      @zje3 = 0  
      
      @zct = "" # 仲裁庭组成
        
      @arbitmantype = {"0001"=>"独","0002"=>"首","0003"=>"申","0004"=>"被"}
      @arbit=TbCasearbitman.find_by_sql("
        select tb_casearbitmen.arbitmantype as arbitmantype,tb_casearbitmen.arbitman as arbitman ,
               tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmansign
        from  tb_casearbitmen,tb_arbitmen,tb_dictionaries
        where tb_dictionaries.typ_code='0015' and tb_casearbitmen.recevice_code=#{@case.recevice_code} and
              tb_casearbitmen.arbitman=tb_arbitmen.code and
              tb_casearbitmen.arbitmansign=tb_dictionaries.data_val and
              tb_casearbitmen.used='Y' order by tb_casearbitmen.arbitmantype
        ")
      unless @arbit.empty?
        for arb in @arbit
          @zct += @arbitmantype[arb.arbitmantype] + ":" + arb.name(arb.arbitmansign) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          
          if arb.arbitmantype == "0001" or arb.arbitmantype == "0002"
            r_b = RemunerationBase.find(:first, :conditions => "used='Y' and recevice_code=#{ca_rc} and p_code='#{arb.arbitman}'" )
            @aaa = r_b == nil ? 0 : r_b.rmb
          elsif arb.arbitmantype == "0003"
            r_b = RemunerationBase.find(:first, :conditions => "used='Y' and recevice_code=#{ca_rc} and p_code='#{arb.arbitman}'" )
            @bbb =  r_b == nil ? 0 : r_b.rmb
          else
            r_b = RemunerationBase.find(:first, :conditions => "used='Y' and recevice_code=#{ca_rc} and p_code='#{arb.arbitman}'" )
            @ccc =  r_b == nil ? 0 : r_b.rmb
          end
        end
        @zct = @zct.slice(0,@zct.length - 30)
      end

      # 独任仲裁员案件，如果仲裁费（税后）少于20000，直接指定报酬为6000，报表页面不显示该项指。
      @evaluate = "yes"
      if @typ == 1 and @zcf2 <= 20000
        @evaluate = "no"
      end

      # 裁决书报酬
      @r_a = RemunerationAward.find(:all, :conditions => "used='Y' and recevice_code='#{ca_rc}'" )
      dj = {"0001"=>"A  很好", "0002"=>"B  较好", "0003"=>"C  一般", "0004"=>"D  差"}
      for r in @r_a
        if r.typ == "0001"
          @zcy1 = TbArbitman.find_by_code(r.p_code).name
          @dj1 = dj[r.grade]
          @je1 = r.rmb
        elsif r.typ == "0002"
          @zcy2 = TbArbitman.find_by_code(r.p_code).name
          @dj2 = dj[r.grade]
          @je2 = r.rmb
        else
          @zcy3 = TbArbitman.find_by_code(r.p_code).name
          @dj3 = dj[r.grade]
          @je3 = r.rmb
        end
      end

      # 绩效报酬
      @r_a = RemunerationJixiao.find(:all, :conditions => "used='Y' and recevice_code='#{ca_rc}'")
      jxdj = {"0001"=>"A  100%", "0002"=>"B  75%", "0003"=>"C  50%", "0004"=>"D  25%", "0005"=>"D  0%"}
      for r in @r_a
        man = TbCasearbitman.find(:first, :conditions => "recevice_code='#{ca_rc}' and arbitman='#{r.p_code}'" ) #used ='Y' and 
        if man.arbitmantype == "0001" or man.arbitmantype == "0002"
          @dj4 = jxdj[r.grade]
          @je4 = r.rmb
        elsif man.arbitmantype == "0003"
          @dj5 = jxdj[r.grade]
          @je5 = r.rmb
        else
          @dj6 = jxdj[r.grade]
          @je6 = r.rmb
        end
      end

      bonus = TbBonusPenalty.find_by_sql(
        "select b.*,a.arbitmantype from tb_bonus_penalties b
         left join tb_casearbitmen a on a.arbitman = b.p and a.used='Y'
         where b.recevice_code='#{ca_rc}' and a.recevice_code='#{ca_rc}' and b.used='Y' and b.typ='0001'
         order by a.arbitmantype
        "
      )

      for b in bonus
        if b.arbitmantype == "0001" or b.arbitmantype == "0002"
          @zje1 = b.zc_rmb*(1 + b.bonus/100 - b.penalty/100) + b.gc_rmb
        elsif  b.arbitmantype == "0003"
          @zje2 = b.zc_rmb*(1 + b.bonus/100 - b.penalty/100) + b.gc_rmb
        else
          @zje3 = b.zc_rmb*(1 + b.bonus/100 - b.penalty/100) + b.gc_rmb
        end
      end

      # 时间
      @t = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      rb = RemunerationBase.find(:first, :conditions => "used='Y' and recevice_code=#{ca_rc}")
      if !rb.blank?
        tim = rb.t2
        @t = tim.year.to_s + "年" + tim.month.to_s + "月" + tim.day.to_s + "日"
      end
    end
  end

  # 发放状态变更
  def state_change
    @case = TbCase.find_by_recevice_code(session[:recevice_code_2])
    if @case.remun_state == 'N'
      @case.remun_state = 'Y'
    else
      @case.remun_state = 'N'
    end
    @case.save
    redirect_to :action => "report"
  end

  # -----------------------------报酬调整----------------------------

  # 仲裁员总报酬列表
  def list_4
    @case = nil#当前办理案件
    unless session[:recevice_code_2] == nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_2])
      @arbitman = TbBonusPenalty.find_by_sql(
        "select b.*,a.arbitmantype from tb_bonus_penalties b
         left join tb_casearbitmen a on a.arbitman = b.p and a.used='Y'
         where b.recevice_code='#{session[:recevice_code_2]}' and a.recevice_code='#{session[:recevice_code_2]}' and b.used='Y' and b.typ='0001'
         order by a.arbitmantype
        "
      )
    end
  end

  # 仲裁员报酬调整
  def edit_4
    @remun=TbBonusPenalty.find(params[:id])
  end

  # 仲裁员报酬更新
  def update_4
    @remun=TbBonusPenalty.find(params[:id])
    if @remun.used=='Y' and @remun.extend_code=='' and !query_state(session[:recevice_code_2])
      @remun.u=session[:user_code]
      @remun.t=Time.now()
      if @remun.update_attributes(params[:remun])
        flash[:notice]="修改成功"
        #redirect_to :action=>"list_4"
        render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
      else
        flash[:notice]="修改失败"
        render :action=>"edit_4",:id=>params[:id]
      end
    else
      flash[:notice]="修改失败，本案报酬已经发放！"
      render :text => "<script type='text/javascript'>window.parent.location.reload();</script>"
    end
  end
  
  private
  # 计算报酬核定数
  # 2万以下	  1.2万（独任0.6万）
  # 2万－5万	  1.2万+超过2万部分18％
  # 5万－10万	1.74万+超过5万部分17％
  # 10万－15万	2.59万+超过10万部分16％
  # 15万－20万	3.39万+超过15万部分15％
  # 20万－25万	4.14万+超过20万部分13％
  # 25万－30万	4.79万+超过25万部分11％
  # 30万－40万	5.34万+超过30万部分7％
  # 40万－50万	6.04万+超过40万部分5％
  # 50万-100万 6.55万+超过50万部分4％
  def hds(v,typ)
    if v == 0
      return 0;
    elsif v < 20000 and typ < 3
      return 6000
    elsif v < 20000
      return 12000
    elsif v >= 20000 and v < 50000
      return 12000 + (v - 20000) * 0.18
    elsif v >= 50000 and v < 100000
      return 17400 + (v - 50000) * 0.17
    elsif v >= 100000 and v < 150000
      return 25900 + (v - 100000) * 0.16
    elsif v >= 150000 and v < 200000
      return 33900 + (v - 150000) * 0.15
    elsif v >= 200000 and v < 250000
      return 41400 + (v - 200000) * 0.13
    elsif v >= 250000 and v < 300000
      return 47900 + (v - 250000) * 0.11
    elsif v >= 300000 and v < 400000
      return 53400 + (v - 300000) * 0.07
    elsif v >= 400000 and v < 500000
      return 60400 + (v - 400000) * 0.05
    elsif v >= 500000 and v < 1000000
      return 65500 + (v - 500000) * 0.04
    elsif v >= 1000000 and v < 10000000
      return 85500 + (v - 1000000) * 0.035
    elsif v >= 10000000
      return 400500 + (v - 10000000) * 0.03
    end
  end

  # 计算仲裁庭报酬调整系数
  def tzxs(v)
    if v == "0001"
      return 1.3
    elsif v == "0002"
      return 1.2
    elsif v == "0003"
      return 1.1
    elsif v == "0004"
      return 1
    elsif v == "0005"
      return 0.9
    elsif v == "0006"
      return 0.8
    elsif v == "0007"
      return 0.7
    end
  end

  # 计算 裁决书报酬、绩效报酬  A  100%  B  75%  C  50%  D  25%  E 0%
  def cjsdj(v)
    if v == '0001'
      return 1
    elsif v == "0002"
      return 0.75
    elsif v == "0003"
      return 0.5
    elsif v == "0004"
      return 0.25
    elsif v == "0005"
      return 0
    end
  end

  # 计算绩效报酬
  def jx(code)
    arbitman = TbCasearbitman.find(:first, :conditions => "used='Y' and recevice_code='#{session[:recevice_code_2]}' and arbitman='#{code}'")
    if arbitman.arbitmantype == "0001" or arbitman.arbitmantype == "0002"
      return 0.5
    else
      return 0.25
    end
  end

  # 根据案件流水号查询案件是否已经提交出纳发放
  def query_state(recevice_code)
    @case = TbCase.find_by_recevice_code(recevice_code)
    if @case.remun_state == 'N'
      return false
    else
      return true
    end
  end
  
end
