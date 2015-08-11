class Remuneration1Controller < ApplicationController
   
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration1.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration1.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def new_all
    @remun=TbRemuneration1.new()
  end
  
  def new
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration1.new()
  end
  
  def new_all_2
    @remun=TbRemuneration1.new()
  end
  
  def new_2
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration1.new()
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
    h=params[:remun][:h]
    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      ### 批量添加庭审和调节
      for arb in @casearbitman
        @remun=TbRemuneration1.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.typ=arb.arbitmantype
        @remun.arbitman=arb.arbitman
        @remun.h=h
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
        end
      end
      ### 批量添加仲裁员仲裁费
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration3.find(:all,:order=>'id',:conditions=>c).empty?
        @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
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
      end
      ### 助理程序处理
      clerk=TbCase.find_by_recevice_code(session[:recevice_code_1]).clerk
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration6.find(:all,:order=>'assistant',:conditions=>c).empty? and clerk!=''
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0002' and p='#{clerk}' and used='Y' and extend_code<>''")
        if extend==nil
          @remun=TbRemuneration6.new()
          @remun.recevice_code=session[:recevice_code_1]
          @remun.case_code=session[:case_code_1]
          @remun.general_code=session[:general_code_1]
          @remun.assistant=clerk
          @remun.u1=session[:user_code]
          @remun.t1=Time.now()
          if @remun.save
             TbBonusPenalty.add(session[:recevice_code_1],'0002',clerk)  
          end             
        end
      end
      ### 校核工作信息
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration5.find(:all,:order=>'typ',:conditions=>c).empty?
        c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
        @check_staff=TbCheckStaff.find(:all,:order=>'id',:conditions=>c)
        for arb in @check_staff
          extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0003' and p='#{arb.staff}' and used='Y' and extend_code<>''")
          if extend==nil
            @remun=TbRemuneration5.new()
            @remun.recevice_code=session[:recevice_code_1]
            @remun.case_code=session[:case_code_1]
            @remun.general_code=session[:general_code_1]
            @remun.typ=arb.typ
            @remun.p=arb.staff
            @remun.u1=session[:user_code]
            @remun.t1=Time.now()
            if @remun.save
              TbBonusPenalty.add(session[:recevice_code_1],'0003',@remun.p)
            end             
          end
        end
      end
      
      flash[:notice]="批量创建成功"
      redirect_to :action=>"list"
    rescue
      flash[:notice]="批量创建失败"
      render :action=>"new_all"
    end
  end
  
  def create
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{params[:remun][:arbitman]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration1.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',params[:remun][:arbitman])
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="创建失败"
        render :action=>"new"
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
    h=params[:remun][:h]
    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      ### 批量添加庭审和调节
      for arb in @casearbitman
        @remun=TbRemuneration1.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.typ=arb.arbitmantype
        @remun.arbitman=arb.arbitman
        @remun.h=h
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
        end
      end
      ### 批量添加仲裁员仲裁费
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration3.find(:all,:order=>'id',:conditions=>c).empty?
        @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
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
      end
      ### 助理程序处理
      clerk=TbCase.find_by_recevice_code(session[:recevice_code_1]).clerk
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration6.find(:all,:order=>'assistant',:conditions=>c).empty? and clerk!=''
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0002' and p='#{clerk}' and used='Y' and extend_code<>''")
        if extend==nil
          @remun=TbRemuneration6.new()
          @remun.recevice_code=session[:recevice_code_1]
          @remun.case_code=session[:case_code_1]
          @remun.general_code=session[:general_code_1]
          @remun.assistant=clerk
          @remun.u1=session[:user_code]
          @remun.t1=Time.now()
          if @remun.save
             TbBonusPenalty.add(session[:recevice_code_1],'0002',clerk)  
          end             
        end
      end
      ### 校核工作信息
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      if TbRemuneration5.find(:all,:order=>'typ',:conditions=>c).empty?
        c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
        @check_staff=TbCheckStaff.find(:all,:order=>'id',:conditions=>c)
        for arb in @check_staff
          extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0003' and p='#{arb.staff}' and used='Y' and extend_code<>''")
          if extend==nil
            @remun=TbRemuneration5.new()
            @remun.recevice_code=session[:recevice_code_1]
            @remun.case_code=session[:case_code_1]
            @remun.general_code=session[:general_code_1]
            @remun.typ=arb.typ
            @remun.p=arb.staff
            @remun.u1=session[:user_code]
            @remun.t1=Time.now()
            if @remun.save
              TbBonusPenalty.add(session[:recevice_code_1],'0003',@remun.p)
            end             
          end
        end
      end
      
      flash[:notice]="批量创建成功"
      redirect_to :action=>"list_2"
    rescue
      flash[:notice]="批量创建失败"
      render :action=>"new_all_2"
    end
  end
  
  def create_2
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{params[:remun][:arbitman]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration1.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',params[:remun][:arbitman])
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="创建失败"
        render :action=>"new_2"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end   
  end
  
  def edit
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration1.find(params[:id])
  end

  def edit_2
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration1.find(params[:id])
  end  

  def update
    @remun=TbRemuneration1.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.update_attributes(params[:remun]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
      else
	flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
    end 
  end
  
  def update_2
    @remun=TbRemuneration1.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.update_attributes(params[:remun]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list_2"
      else
	flash[:notice]="修改失败"
        render :action=>"edit_2",:id=>params[:id]
      end
    end 
  end
  
  def delete
    @remun=TbRemuneration1.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],'0001',@remun.arbitman)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration1.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],'0001',@remun.arbitman)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
