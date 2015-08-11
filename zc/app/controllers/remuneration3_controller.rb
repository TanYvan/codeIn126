class Remuneration3Controller < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def new
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration3.new()
  end
  
  def new_2
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration3.new()
  end
  
  def create_all
    
    s_c=TbShouldCharge.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004')  and used='Y' and recevice_code='#{session[:recevice_code_1]}'")
    if s_c==nil 
      s_c=0
    end

    s_r=TbShouldRefund.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004') and used='Y' and recevice_code='#{session[:recevice_code_1]}' and state<>3")
    if s_r==nil 
      s_r=0
    end

    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      for arb in @casearbitman
        @remun=TbRemuneration3.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.arbitman=arb.arbitman
        @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
        @remun.rmb=Tax.new.get_hand_fee(@case.aribitprog_num,s_c - s_r)
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
          TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        end
      end
      flash[:notice]="批量创建成功"
    rescue
      flash[:notice]="批量创建失败"
    end
    redirect_to :action=>"list"
  end
  
  def create
    p=params[:remun]
    if p==nil
      p=''
    else
      p=p[:arbitman]
    end
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{p}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration3.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      
      s_c=TbShouldCharge.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004')  and used='Y' and recevice_code='#{session[:recevice_code_1]}'")
      if s_c==nil 
        s_c=0
      end

      s_r=TbShouldRefund.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004') and used='Y' and recevice_code='#{session[:recevice_code_1]}' and state<>3")
      if s_r==nil 
        s_r=0
      end

      @remun.rmb=Tax.new.get_hand_fee(@case.aribitprog_num,s_c - s_r)
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
        TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="创建失败"
        redirect_to :action=>"list"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end

  def create_all_2
    
    s_c=TbShouldCharge.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004')  and used='Y' and recevice_code='#{session[:recevice_code_1]}'")
    if s_c==nil 
      s_c=0
    end

    s_r=TbShouldRefund.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004') and used='Y' and recevice_code='#{session[:recevice_code_1]}' and state<>3")
    if s_r==nil 
      s_r=0
    end

    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      for arb in @casearbitman
        @remun=TbRemuneration3.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.arbitman=arb.arbitman
        @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
        @remun.rmb=Tax.new.get_hand_fee(@case.aribitprog_num,s_c - s_r)
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
          TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        end
      end
      flash[:notice]="批量创建成功" 
    rescue
      flash[:notice]="批量创建失败"
    end
    redirect_to :action=>"list_2"
  end
  
  def create_2
    p=params[:remun]
    if p==nil
      p=''
    else
      p=p[:arbitman]
    end
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{p}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration3.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      
      s_c=TbShouldCharge.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004')  and used='Y' and recevice_code='#{session[:recevice_code_1]}'")
      if s_c==nil 
        s_c=0
      end

      s_r=TbShouldRefund.sum("re_rmb_money",:conditions=>"(typ='0001' or typ='0004') and used='Y' and recevice_code='#{session[:recevice_code_1]}' and state<>3")
      if s_r==nil 
        s_r=0
      end

      @remun.rmb=Tax.new.get_hand_fee(@case.aribitprog_num,s_c - s_r)
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
        TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="创建失败"
        redirect_to :action=>"list_2"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end
   
  def delete
    @remun=TbRemuneration3.find(params[:id])
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
    if @remun.used=='Y' and extend==nil and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration3.find(params[:id])
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
    if @remun.used=='Y'  and extend==nil and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
