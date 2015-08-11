class Remuneration12Controller < ApplicationController


  def list
    ca_rc = session[:recevice_code_1]
    @case = nil#当前办理案件
    unless ca_rc == nil
      @case = TbCase.find_by_recevice_code(ca_rc)
    end
  end

  # 仲裁员报酬——裁决书制作信息 列表
  def list_1
    flash.now # 设置flash信息只在当前action有效，不带入到下个action
    @case = nil #当前办理案件
    unless session[:recevice_code_1] == nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_1])
      c = "recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun = RemunerationAward.find(:all, :order => 'id', :conditions => c)
    end
  end

  # 仲裁员报酬——裁决书制作信息 新建
  def new_1
    @remun = RemunerationAward.new()
  end

  # 仲裁员报酬——裁决书制作信息 创建
  def create_1
    extend = TbBonusPenalty.find(:first,
      :conditions => "recevice_code='#{session[:recevice_code_1]}' and typ='0001'
                      and p='#{params[:remun][:p_code]}' and used='Y' and extend_code<>''"
    ) # 当前案件session[:recevice_code_1] 当前仲裁员params[:remun][:p_code] 且 已经发放

    # 不可以录入相同的记录
    rem1 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and p_code=? and typ=? and used='Y'",session[:recevice_code_1],params[:remun][:p_code],params[:remun][:typ]])
    rem2 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and typ=? and used='Y'",session[:recevice_code_1],params[:remun][:typ]])

    arbitman = TbCasearbitman.find(
      :all,
      :conditions => "used='Y' and recevice_code='#{session[:recevice_code_1]}'",
      :select =>"arbitman,arbitmantype"
    ).inject({}){|k,v| k[v.arbitman]=v.arbitmantype;k}

    if rem1.size != 0
      flash[:notice] = "创建失败,与现有记录重复！"
      redirect_to :action => "new_1"
    elsif rem2.size != 0
      flash[:notice] = "创建失败,该裁决书制作者另有他人！"
      redirect_to :action => "new_1"
    else
      if extend == nil # 该仲裁员报酬未发放  如果报酬已经发放则不可以创建
        @remun               = RemunerationAward.new(params[:remun])
        @remun.recevice_code = session[:recevice_code_1]
        @remun.case_code     = session[:case_code_1]
        @remun.general_code  = session[:general_code_1]
        @remun.p_typ         = '0001'
        @remun.arbitman_type = arbitman[params[:remun][:p_code]]
        @remun.u1            = session[:user_code]
        @remun.t1            = Time.now()
        if @remun.save
          TbBonusPenalty.add(session[:recevice_code_1], '0001', params[:remun][:p_code])
          flash[:notice] = "创建成功"
          redirect_to :action => "list_1"
        else
          flash[:notice] = "创建失败"
          render :action => "new_1"
        end
      else
        render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
      end
    end
  end

  # 仲裁员报酬——裁决书制作信息 批量创建  从裁决书报校核信息读取裁决书制作信息
  def create_1_all
    notice = ""
    # 查找所有的校核信息
    award = TbAward.find(:first,:conditions => "recevice_code='#{session[:recevice_code_1]}' and used='Y'")
    awarddetail = nil
    unless award.blank?
      awarddetail = TbAwardDetail.find(:all,
        :order => 'typ,draftsman_typ,draftsman',
        :conditions => ["recevice_code=? and used='Y' and p_id=? and draftsman_typ='0001' and (typ='0002' or typ='0003' or typ='0005') ", session[:recevice_code_1], award.id]
      )
    end
    if awarddetail.blank? or awarddetail.size == 0
      flash[:notice] = "无法根据校核信息创建，请手工创建！"
      redirect_to :action => "list_1"
    else
      type = TbDictionary.find(:all, :conditions => "typ_code='9022' and data_val<>'0000' and used='y'") # 裁决书类型
      arbitman = TbCasearbitman.find(
        :all,
        :conditions => "used='Y' and recevice_code='#{session[:recevice_code]}'",
        :select => "arbitman,arbitmantype"
      ).inject({}){|k, v| k[v.arbitman] = v.arbitmantype; k} # 仲裁员类型

      for t in type
        typ = "0003" if t.data_val == "0001"
        typ = "0002" if t.data_val == "0002"
        typ = "0005" if t.data_val == "0003"
        ad = TbAwardDetail.find(:first,
          :conditions => ["recevice_code=? and used='Y' and p_id=? and draftsman_typ='0001' and typ='#{typ}'", session[:recevice_code_1], award.id]
        )
        unless ad.blank?
          extend = TbBonusPenalty.find(
            :first,
            :conditions => "recevice_code='#{session[:recevice_code_1]}' and typ='0001'
                            and p='#{ad.draftsman}' and used='Y' and extend_code<>''"
          )
          # 不可以录入相同的记录
          rem1 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and p_code=? and typ=? and used='Y'",session[:recevice_code_1],ad.draftsman,t.data_val])
          rem2 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and typ=? and used='Y'",session[:recevice_code_1],t.data_val])

          if rem1.size != 0
            notice = notice + "与现有记录重复；<br/>"
          elsif rem2.size != 0
            notice = notice + "该裁决书制作者另有他人；<br/>"
          else
            if extend == nil  # 如果已经录入了金额或者已经发放则不可以修改
              remun               = RemunerationAward.new
              remun.used          =  'Y'
              remun.recevice_code = session[:recevice_code_1]
              remun.case_code     = session[:case_code_1]
              remun.general_code  = session[:general_code_1]
              remun.p_typ         = '0001'
              remun.typ           = t.data_val
              remun.p_code        = ad.draftsman
              remun.arbitman_type = arbitman[ad.draftsman]
              remun.remark        = ""
              remun.u1            = session[:user_code]
              remun.t1            = Time.now()
              if remun.save()
                TbBonusPenalty.add(session[:recevice_code_1], '0001',ad.draftsman)
              end
            else
              notice = notice + "仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>"
            end
          end
        end
      end
      flash[:notice] = notice.blank?? "创建完成！" : "由于以下原因，创建失败，请手工创建：<br/>"+notice
      redirect_to :action => "list_1"
    end
  end

  # 仲裁员报酬——裁决书制作信息 修改
  def edit_1
    @remun = RemunerationAward.find(params[:id])
  end

  # 仲裁员报酬——裁决书制作信息 更新
  def update_1
    rem1 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and p_code=? and typ=? and used='Y' and id<>?",session[:recevice_code_1],params[:remun][:p_code],params[:remun][:typ],params[:id]])
    rem2 = RemunerationAward.find(:all,:conditions => ["recevice_code=? and typ=? and used='Y' and id<>?",session[:recevice_code_1],params[:remun][:typ],params[:id]])

    if rem1.size != 0
      flash[:notice] = "修改失败,与现有记录重复！"
      redirect_to :action => "edit_1",:id => params[:id]
    elsif rem2.size != 0
      flash[:notice] = "修改失败,该裁决书制作者另有他人！"
      redirect_to :action => "edit_1",:id => params[:id]
    else
      arbitman = TbCasearbitman.find(
        :all,
        :conditions => "used='Y' and recevice_code='#{session[:recevice_code_1]}'",
        :select =>"arbitman,arbitmantype"
      ).inject({}){|k,v| k[v.arbitman]=v.arbitmantype;k}
      @remun = RemunerationAward.find(params[:id])
      if @remun.used=='Y' and @remun.rmb == 0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk == session[:user_code]
        params[:remun][:arbitman_type] = arbitman[params[:remun][:p_code]]
        @remun.u1 = session[:user_code]
        @remun.t1 = Time.now()
        p = @remun.p_code
        if @remun.update_attributes(params[:remun])
          # 修改裁决书信息的时候 需要更新 tb_bonus_penalty 表，否则tb_bonus_penalty的p字段不会改变
          TbBonusPenalty.del(session[:recevice_code_1],"0001",p)
          TbBonusPenalty.add(session[:recevice_code_1],"0001",params[:remun][:p_code])
          flash[:notice]="修改成功"
          redirect_to :action=>"list_1"
        else
          flash[:notice]="修改失败"
          render :action=>"edit_1",:id=>params[:id]
        end
      end
    end
  end

  # 仲裁员报酬——裁决书制作信息 删除
  def delete_1
    @remun = RemunerationAward.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used = "N"
      @remun.u1 = session[:user_code]
      @remun.t1 = Time.now()
      if @remun.save(false)
        # 删除的时候应当使用 del_set 方法，这样才可以将 view_mun 的值减 1
        TbBonusPenalty.del_set(session[:recevice_code_1],'0001',@remun.p_code,"gc_rmb",0)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_1"
    end
  end



  # 仲裁员报酬——绩效考评 列表
  def list_2
    @case = nil#当前办理案件
    unless session[:recevice_code_1] == nil
      @case = TbCase.find_by_recevice_code(session[:recevice_code_1])
      c = "recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun = RemunerationJixiao.find(:all, :order => 'arbitman_type', :conditions => c)
    end
    @casearbitman = TbCasearbitman.find_by_sql(
      "select tb_arbitmen.code as code ,tb_arbitmen.name as name
       from tb_casearbitmen ,tb_arbitmen
       where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y'
             and tb_casearbitmen.arbitman=tb_arbitmen.code
       order by tb_arbitmen.name" )
    @rs1 = TbDictionary.find(:all, :conditions => "typ_code='9023' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @rs2 = TbDictionary.find(:all, :conditions => "typ_code='9024' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @rs3 = TbDictionary.find(:all, :conditions => "typ_code='9025' and state='Y' and used='Y'", :order => 'data_val', :select => "data_val,data_text").inject({}){|f,e| f[e.data_val]=e.data_text;f}
  end

  # 仲裁员报酬——绩效考评 新建
  def new_2
    @remun = RemunerationJixiao.new()
  end

  # 仲裁员报酬——绩效考评 创建
  def create_2
    extend = TbBonusPenalty.find(
      :first,
      :conditions => "recevice_code='#{session[:recevice_code_1]}' and
                      typ='0001' and p='#{params[:remun][:p_code]}' and
                      used='Y' and extend_code<>''"
    )

    arbitman = TbCasearbitman.find(
      :all,
      :conditions => "used='Y' and recevice_code='#{session[:recevice_code]}'",
      :select =>"arbitman,arbitmantype"
    ).inject({}){|k,v| k[v.arbitman]=v.arbitmantype;k}

    rem = RemunerationJixiao.find(:all,:conditions => ["recevice_code=? and used='Y' and p_code=?",session[:recevice_code_1],params[:remun][:p_code]])
    if rem.size != 0
      flash[:notice] = "创建失败,请勿重复录入！"
      redirect_to :action => "new_2"
    else
      if extend == nil
        @remun               = RemunerationJixiao.new(params[:remun])
        @remun.recevice_code = session[:recevice_code_1]
        @remun.case_code     = session[:case_code_1]
        @remun.general_code  = session[:general_code_1]
        @remun.p_typ         = "0001"
        @remun.arbitman_type = arbitman[params[:remun][:p_code]]
        @remun.u1            = session[:user_code]
        @remun.t1            = Time.now()
        if @remun.save
          TbBonusPenalty.add(session[:recevice_code_1], '0001',  params[:remun][:p_code])
          flash[:notice] = "创建成功"
          redirect_to :action => "list_2"
        else
          flash[:notice] = "创建失败"
          render :action => "new_2"
        end
      else
        render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
      end
    end

  end

  # 仲裁员报酬——绩效考评 修改
  def edit_2
    @remun = RemunerationJixiao.find(params[:id])
  end

  # 仲裁员报酬——绩效考评 更新
  def update_2
    @remun = RemunerationJixiao.find(params[:id])
    if @remun.used == 'Y' and @remun.rmb == 0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk == session[:user_code]
      arbitman = TbCasearbitman.find(
        :all,
        :conditions => "used='Y' and recevice_code='#{@remun.recevice_code}'",
        :select =>"arbitman,arbitmantype"
      ).inject({}){|k,v| k[v.arbitman]=v.arbitmantype;k}
      @remun.u1            = session[:user_code]
      @remun.t1            = Time.now()
      params[:remun][:arbitman_type] = arbitman[@remun.p_code]
      if @remun.update_attributes(params[:remun])
        flash[:notice] = "修改成功"
        redirect_to :action => "list_2"
      else
        flash[:notice] = "修改失败"
        render :action => "edit_2", :id => params[:id]
      end
    end
  end

  # 仲裁员报酬——绩效考评 删除
  def delete_2
    @remun = RemunerationJixiao.find(params[:id])
    if @remun.used == 'Y' and @remun.rmb == 0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk == session[:user_code]
      @remun.used = "N"
      @remun.u1   = session[:user_code]
      @remun.t1   = Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_1], '0001', @remun.p_code,"zc_rmb",0)
        flash[:notice] = "删除成功"
      else
        flash[:notice] = "删除失败"
      end
      redirect_to :action => "list_2"
    end
  end

end
