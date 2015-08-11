class CaseConsultationController < ApplicationController
  def p_set
    typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{params[:p_typ]}'",:order=>'data_val',:select=>"data_val,data_text")
    render :update do |page|
      page.remove 'case_casetype_num2'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  def party_set
    party=TbParty.find(:all,:conditions=>"partytype=#{params[:partytype]} and used='Y' and recevice_code='#{params[:recevice_code]}'",:order=>'partyname',:select=>"partyname,id")
    render :update do |page|
      page.remove 'agent_party_id'
      page.replace_html 'party_set', :partial => 'par',:object=>party
    end
  end
  def p_list
    partyname=params[:partyname]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    partyname=cov.iconv(partyname)
    if partyname.strip!='' and PubTool.new().sql_check_3(partyname)!=false
    p_case=VCaseQuery1List1.find_by_sql("select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, 
tb_cases_end_code,tb_cases_clerk from v_case_query1_list1s where tb_parties_partyname like '%#{partyname}%'")
    else
      p_case=nil
    end
    render :update do |page|
      page.replace_html 'p_list', :partial => 'p_l',:object=>p_case
    end
  end
  def rate_set
    render :update do |page|
      page.remove 'amount_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end
  
  def a_list
    company=params[:company]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    company=cov.iconv(company)
    
    if company.strip!='' and PubTool.new().sql_check_3(company)!=false
    p=TbAgent.find_by_sql("select distinct company,addr from tb_agents where company like '%#{company}%'")
    else
      p=nil
    end
    render :update do |page|
      page.replace_html 'a_list', :partial => 'a_l',:object=>p
    end
  end
  
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]],['date','receivedate','咨询日期','text',[]],['number','amount','争议金额','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    if session["0001"]=="Y"
      c="used='Y' and state=1 and recevice_code_limit_dat>='#{Date.today}'"
    elsif session["0003"]=="Y"
      c="used='Y' and state=1 and (clerk='#{session[:user_code]}' or clerk='' or clerk is null) and recevice_code_limit_dat>='#{Date.today}'"
    else
      c="1=2"
    end
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def new
    @t_typ=TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val+" "+p.data_text,p.data_val]}
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    oopp=TbDictionary.find(:first,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val")
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{oopp.data_val}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}

    @case=TbCase.new()
    @case.receivedate=Date.today()
  end

  def create
    @case=TbCase.new(params[:case])
    @case.clerk_2=session[:user_code]
    @case.u=session[:user_code]
    @case.u_t=Time.now()
    @case.recevice_code_limit_dat=@case.receivedate + SysArg.find_by_code("1010").val.to_i
    @case.recevice_code=SysArg.add_0001()
    if TbCaseFlow.check(@case.recevice_code,'0001')
      f=TbCaseFlow.add_flow(@case.recevice_code,'0001')
      if f!=0
        @case.state=f
      end
      if @case.save
        flash[:notice]="创建成功，咨询流水号:#{@case.recevice_code}"
        redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order]
      else
        flash[:notice]="创建失败"
        redirect_to :action=>"new",:search_condit=>params[:search_condit],:order=>params[:order]
      end
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end

  def edit
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @t_typ=TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val + " " + p.data_text,p.data_val]}
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{@case.casetype_num}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @placed=TbShouldCharge.find(:all,:conditions=>"used='Y' and recevice_code='#{params[:recevice_code]}' and (typ='0001' or typ='0004') and re_rmb_money<>0")
  end

  def update
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case.clerk_2=session[:user_code]
    @case.u=session[:user_code]
    @case.u_t=Time.now()
    if @case.update_attributes(params[:case])
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def delete
    @case=TbCase.find(params[:id])
    @case.used="N"
    @case.u=session[:user_code]
    @case.u_t=Time.now()
    TbCaseFlow.del_flow(@case.recevice_code,'0001')
    if @case.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
  
  def case_doc
    #发文session
#    session[:case_code_4]=params[:case_code]
#    session[:recevice_code]=params[:recevice_code]
#    session[:general_code_4]=params[:general_code]
    #链接到发文
    redirect_to :controller=>"case_doc",:action=>"list",:recevice_code=>params[:recevice_code]
  end

   def party_list
    @partytype={1=>"申请人",2=>"被申请人"}
    @isperson={1=>"是",2=>"否"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
    end
    p=PubTool.new()
    if p.sql_check(params[:recevice_code])!=false
      @party=TbParty.find(:all,:conditions=>"used='Y' and recevice_code=#{params[:recevice_code]}",:order=>@order)
    end
  end
  
  def party_new
    @party=TbParty.new()
  end

  def party_create
    @party=TbParty.new(params[:party])
    @party.recevice_code=params[:recevice_code]
    @party.partyname=@party.partyname.strip
    @party.addr=@party.addr.strip
    @party.u=session[:user_code]
    @party.u_t=Time.now()
    if @party.save
      flash[:notice]="创建成功"
      redirect_to :action=>"party_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"party_new",:recevice_code=>params[:recevice_code]
    end
  end

  def party_edit
    @party=TbParty.find(params[:id])
  end

  def party_update
    @party=TbParty.find(params[:id])
    @party.u=session[:user_code]
    @party.u_t=Time.now()
    if @party.update_attributes(params[:party])
      @party.partyname=@party.partyname.strip
      @party.addr=@party.addr.strip
      @party.save
      flash[:notice]="修改成功"
      redirect_to :action=>"party_list",:id=>params[:id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"party_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end

  def party_delete
    @party=TbParty.find(params[:id])
    @party.used="N"
    @party.u=session[:user_code]
    @party.u_t=Time.now()
    if @party.save

      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"party_list",:recevice_code=>params[:recevice_code]
  end
  #代理人
  
  def con_list
    if @order==nil or @order==""
      @order="id asc"
    end
    p=PubTool.new()
    if p.sql_check(params[:recevice_code])!=false
      @con=TbContractsign.find(:all,:conditions=>"used='Y' and recevice_code=#{params[:recevice_code]}",:order=>"id")
    end
  end

  def con_new
    @con=TbContractsign.new()
    @con.contractdate=TbCase.find_by_recevice_code(params[:recevice_code]).acceptt
    @con.pactname=TbCase.find_by_recevice_code(params[:recevice_code]).casereason
  end

  def con_create
    @con=TbContractsign.new(params[:con])
    @con.recevice_code=params[:recevice_code]
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="创建成功"
      redirect_to :action=>"con_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"con_new" ,:recevice_code=>params[:recevice_code]
    end

  end

  def con_edit
    @con=TbContractsign.find(params[:id])
  end

  def con_update
    @con=TbContractsign.find(params[:id])
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.update_attributes(params[:con])
      flash[:notice]="修改成功"
      redirect_to :action=>"con_list",:id=>params[:id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"con_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end

  def con_delete
    @con=TbContractsign.find(params[:id])
    @con.used="N"
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"con_list",:recevice_code=>params[:recevice_code]
  end

  def clerk_select_list
    if session["0001"]=="Y"
      @clerks=User.find_by_sql("select code ,name from users where  users.used='Y' and  users.code in (select user_code from user_duties where duty_code='0003'  )")
    elsif session["0003"]=="Y"
      @clerks=User.find_by_sql("select code ,name from users where  users.used='Y' and  users.code in (select user_code from user_duties where duty_code='0003' and user_code='#{session[:user_code]}')")
    else
      @clerks=User.find_by_sql("select code ,name from users where  1=2")
    end

  end

  def clerk_select
    c=TbCase.find(params[:c_id])
    old_clerk=c.clerk
    new_clerk=params[:clerk]
    c.clerk=params[:clerk]

    tc=TbClerkchange.new()
    tc.recevice_code=TbCase.find(params[:c_id]).recevice_code
    tc.changedate=Date.today
    tc.beforeclerk=old_clerk
    tc.afterclerk=new_clerk
    tc.u=session[:user_code]
    tc.t=Time.now
    tc.falg=0

    if c.save and tc.save
      flash[:notice]="仲裁助理指定成功"
    else
      flash[:notice]="仲裁助理指定失败"
    end

    redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page]
  end

  def establishment
    c=TbCase.find_by_recevice_code(params[:recevice_code])
    if TbCaseFlow.check(c.recevice_code,'0004')
      f=TbCaseFlow.add_flow(c.recevice_code,'0004')
      c.u=session[:user_code]
      c.u_t=Time.now()
      if c.clerk==session[:user_code]
        if f!=0
          c.state=f
        end
        add_2=SysArg.add_0002()
        #### 华南仲裁委个性化
        if c.aribitprog_num=='0001' or c.aribitprog_num=='0002'
          c.case_code="SHEN D" + c.t_casetype_num + add_2
        else
          c.case_code="SHEN " + c.t_casetype_num + add_2
        end
        ####
        c.general_code=SysArg.add_0003()
        c.nowdate=Date.today

        #c.limit_dat=Workday.after_day(SysArg.find_by_code('1000').val.to_i)
        #c.finally_limit_dat=c.limit_dat

        if c.save
          flash[:notice]="#{params[:recevice_code]}案件已立案"
        else
          flash[:notice]="#{params[:recevice_code]}案件立案立案失败，如有问题请与软件供应商联系"
        end
      end
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page]
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end

  def establishment_no
    c=TbCase.find_by_recevice_code(params[:recevice_code])
    c.u=session[:user_code]
    c.u_t=Time.now()
    if TbCaseFlow.check(c.recevice_code,'0003')
      f=TbCaseFlow.add_flow(c.recevice_code,'0003')
      if c.clerk=="" or c.clerk==session[:user_code]
        if f!=0
          c.state=f
        end
        c.nowdate=Date.today
        if c.save
          flash[:notice]="#{params[:recevice_code]}案件已设置为不受理"
        else
          flash[:notice]="#{params[:recevice_code]}案件不受理，操作失败，如有问题请与软件供应商联系"
        end
      end
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page]

    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end
  #关于争议金额的处理
  def edit_dispute_amount
    @case=nil#当前办理案件
    if params[:recevice_code]==nil
    else
      @case = TbCase.find_by_recevice_code(params[:recevice_code])
      @partytype={1=>"申请人",2=>"被申请人"}
      @typ={"0001"=>"争议金额","0002"=>"追加争议金额","0003"=>"减少争议金额"}
      @amount_typ={"0001"=>"明确金额","0002"=>"不明确金额"}
      @amount1=TbCaseAmount.find(:all,:conditions=>"recevice_code='#{params[:recevice_code]}' and used='Y' and partytype=1",:order=>'id')
      @amount2=TbCaseAmount.find(:all,:conditions=>"recevice_code='#{params[:recevice_code]}' and used='Y' and partytype=2",:order=>'id')
      #申请人明确争议金额
      @applicant_definites = Cost.new.get_sum(params[:recevice_code],"1","0001")
      #被申请人明确争议金额
      @respondent_definites = Cost.new.get_sum(params[:recevice_code],"2","0001")
      #申请人不明确争议金额
      @applicant_undefinites = Cost.new.get_sum(params[:recevice_code],"1","0002")
      #被申请人不明确争议金额
      @respondent_undefinites = Cost.new.get_sum(params[:recevice_code],"2","0002")
      #申请人费用汇总
      applicant_all = @applicant_definites+@applicant_undefinites
      #被申请人费用汇总
      respondent_all = @respondent_definites+@respondent_undefinites
      #金融案件仲裁费/立案费
      if @case!=nil
        if @case.aribitprog_num == "0005"
          if applicant_all != 0
            @applicant_arbitration_fee = Cost.new.get_03_02(applicant_all)   #仲裁费
            @applicant_registration_fee = Cost.new.get_03_01(applicant_all)      #立案费
          else
            @applicant_arbitration_fee = 0
            @applicant_registration_fee = 0
          end
          if respondent_all != 0
            @respondent_arbitration_fee = Cost.new.get_03_02(respondent_all)
            @respondent_registration_fee = Cost.new.get_03_01(respondent_all)
          else
            @respondent_arbitration_fee = 0
            @respondent_registration_fee = 0
          end
          @applicant_litigation_fee = 0             #受理费
          @applicant_processing_fee = 0             #处理费
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
      #涉外案件仲裁费/立案费

        elsif @case.aribitprog_num == "0003" or @case.aribitprog_num == "0004"
          if applicant_all != 0
            @applicant_arbitration_fee = Cost.new.get_02_02(applicant_all)   #仲裁费
            @applicant_registration_fee = Cost.new.get_02_01(applicant_all)      #立案费
          else
            @applicant_arbitration_fee = 0
            @applicant_registration_fee = 0
          end
          if respondent_all != 0
            @respondent_arbitration_fee = Cost.new.get_02_02(respondent_all)
            @respondent_registration_fee = Cost.new.get_02_01(respondent_all) 
          else
            @respondent_arbitration_fee = 0
            @respondent_registration_fee = 0
          end
          @applicant_litigation_fee = 0             #受理费
          @applicant_processing_fee = 0             #处理费
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
      #国内案件受理费/处理费计算
      elsif @case.aribitprog_num == "0001" or @case.aribitprog_num == "0002"
        if respondent_all != 0
          @respondent_litigation_fee = Cost.new.get_01_01(respondent_all)
          @respondent_processing_fee = Cost.new.get_01_02(respondent_all)
        else
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
        end
        if applicant_all != 0
          @applicant_litigation_fee = Cost.new.get_01_01(applicant_all)
          @applicant_processing_fee = Cost.new.get_01_02(applicant_all)
        else
          @applicant_litigation_fee = 0
          @applicant_processing_fee = 0
        end
        @applicant_arbitration_fee = 0
        @applicant_registration_fee = 0
        @respondent_arbitration_fee = 0
        @respondent_registration_fee = 0
      end
      @applicant_sum = @applicant_arbitration_fee+@applicant_registration_fee+@applicant_litigation_fee+@applicant_processing_fee
      @respondent_sum = @respondent_arbitration_fee+@respondent_registration_fee+@respondent_litigation_fee+@respondent_processing_fee
      end
    end
  end
  
  def new_amount
    @amount=TbCaseAmount.new()
    @amount.dt=Date.today
    @amount.currency='0001'
    @amount.f_money=0
    @amount.rate=1
    @amount.rmb_money=0
  end

  def create_amount
    @amount=TbCaseAmount.new(params[:amount])
    @amount.recevice_code=params[:recevice_code]
    @amount.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @amount.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @amount.partytype=params[:partytype]
    @amount.u=session[:user_code]
    @amount.u_t=Time.now()
    if @amount.typ=="0003" and @amount.rmb_money > (Cost.new.get_sum(params[:recevice_code],@amount.partytype,"0001")  + Cost.new.get_sum(params[:recevice_code],@amount.partytype,"0002"))
      flash[:notice]="创建失败,减少争议金额不能大于原争议金额的总和！"
      render :action=>"new_amount" ,:recevice_code=>params[:recevice_code]
    else
      
      old_registration_fee=Cost.new.get_fee(params[:partytype],1,params[:recevice_code])
      old_arbitration_fee=Cost.new.get_fee(params[:partytype],2,params[:recevice_code])


      if @amount.save
        
        @money=Money.find(:all,:conditions=>"used='Y'",:order=>"code")
        for m in @money
          if params["rmb_money_"+m.code]!='0'
            @amount_detail=TbCaseAmountDetail.new()
            @amount_detail.parent_id=@amount.id
            @amount_detail.recevice_code=params[:recevice_code]
            @amount_detail.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
            @amount_detail.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
            @amount_detail.partytype=params[:partytype]
            @amount_detail.u=session[:user_code]
            @amount_detail.u_t=@amount.u_t
            @amount_detail.typ=@amount.typ
            @amount_detail.amount_typ=@amount.amount_typ
            @amount_detail.dt=@amount.dt
            @amount_detail.currency=m.code
            @amount_detail.f_money=params["f_money_"+m.code]
            @amount_detail.rate=params["rate_"+m.code]
            @amount_detail.rmb_money=params["rmb_money_"+m.code]
            @amount_detail.save
          end
        end
        
        #调用是有方法的函数，在增加争议金额的时候进行应收或应退的增加
        should_add(session[:user_code],params[:recevice_code],@amount,old_registration_fee,old_arbitration_fee)
        
        @case=TbCase.find_by_recevice_code(params[:recevice_code])
        @case.amount=Cost.new.get_sum(params[:recevice_code],"0","0000")
        @case.amount_1=Cost.new.get_sum(params[:recevice_code],"1","0000")
        @case.amount_2=Cost.new.get_sum(params[:recevice_code],"2","0000")
        if @case.save
          flash[:notice]="创建成功"
          redirect_to :action=>"edit_dispute_amount",:recevice_code=>params[:recevice_code],
                      :search_condit=>params[:search_condit],:order=>params[:order],
                      :page=>params[:page],:page_lines=>params[:page_lines]
        else
          flash[:notice]="创建失败"
          render :action=>"new_amount" ,:recevice_code=>params[:recevice_code],
                 :search_condit=>params[:search_condit],:order=>params[:order],
                 :page=>params[:page],:page_lines=>params[:page_lines]
        end
      else
        flash[:notice]="创建失败"
        render :action=>"new_amount" ,:recevice_code=>params[:recevice_code],
               :search_condit=>params[:search_condit],:order=>params[:order],
               :page=>params[:page],:page_lines=>params[:page_lines]
      end
    end
  end

  def edit_amount
    @amount=TbCaseAmount.find(params[:id])
  end

  def update_amount
    @amount=TbCaseAmount.find(params[:id])
    @amount.u=session[:user_code]
    @amount.u_t=Time.now()
    if @amount.update_attributes(params[:amount])
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      @case.amount=Cost.new.get_sum(params[:recevice_code],"0","0000")
      @case.amount_1=Cost.new.get_sum(params[:recevice_code],"1","0000")
      @case.amount_2=Cost.new.get_sum(params[:recevice_code],"2","0000")
      if @case.save
        flash[:notice]="修改成功"
        redirect_to :action=>"edit_dispute_amount",:recevice_code=>params[:recevice_code],
          :search_condit=>params[:search_condit],:order=>params[:order],
          :page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"_amount",:id=>params[:id],:recevice_code=>params[:recevice_code],
          :search_condit=>params[:search_condit],:order=>params[:order],
          :page=>params[:page],:page_lines=>params[:page_lines]
      end
    else
      flash[:notice]="修改失败"
      render :action=>"_amount",:id=>params[:id],:recevice_code=>params[:recevice_code],
        :search_condit=>params[:search_condit],:order=>params[:order],
        :page=>params[:page],:page_lines=>params[:page_lines]
    end

  end

  def delete_amount
    @amount=TbCaseAmount.find(params[:id])
    @amount.used="N"
    @amount.u=session[:user_code]
    @amount.u_t=Time.now()
    if @amount.save
      TbCaseAmountDetail.update_all("used='N'","parent_id=#{@amount.id}")
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      @case.amount=Cost.new.get_sum(params[:recevice_code],"0","0000")
      @case.amount_1=Cost.new.get_sum(params[:recevice_code],"1","0000")
      @case.amount_2=Cost.new.get_sum(params[:recevice_code],"2","0000")
      @case.save
      TbShouldCharge.update_all("used='N'","case_amount_id='#{@amount.id}'")
      TbShouldRefund.update_all("used='N'","case_amount_id='#{@amount.id}'") 
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"edit_dispute_amount",:recevice_code=>params[:recevice_code],
                :search_condit=>params[:search_condit],:order=>params[:order],
                :page=>params[:page],:page_lines=>params[:page_lines]
  end
  #代理人##############################################
  def agent_list
#    @isperson={1=>"是",2=>"否"}
    @partytype={1=>"申请人方",2=>"被申请人方"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
    end
    p=PubTool.new()
    if p.sql_check(params[:recevice_code])!=false
      @agent=TbAgent.find(:all,:conditions=>"used='Y' and recevice_code=#{params[:recevice_code]}",:order=>@order)
    end
  end
  def agent_new
    @agent=TbAgent.new()
  end
  def agent_create
    @agent=TbAgent.new(params[:agent])
    @agent.recevice_code=params[:recevice_code]
    @agent.name=@agent.name.strip
    @agent.addr=@agent.addr.strip
    @agent.u=session[:user_code]
    @agent.u_t=Time.now()
    if @agent.save
      flash[:notice]="创建成功"
      redirect_to :action=>"agent_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"agent_new",:recevice_code=>params[:recevice_code]
    end
  end
  def agent_edit
    @agent=TbAgent.find(params[:id])
  end
  def agent_update
    @agent=TbAgent.find(params[:id])
    @agent.u=session[:user_code]
    @agent.u_t=Time.now()
    if @agent.update_attributes(params[:agent])
      @agent.name=@agent.name.strip
      @agent.addr=@agent.addr.strip
      @agent.save
      flash[:notice]="修改成功"
      redirect_to :action=>"agent_list",:id=>params[:id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"agent_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end
  def agent_delete
    @agent=TbAgent.find(params[:id])
    @agent.used="N"
    @agent.u=session[:user_code]
    @agent.u_t=Time.now()
    if @agent.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"agent_list",:recevice_code=>params[:recevice_code]
  end
  
  
  private
  
  def should_add(user_code,recevice_code,amount,old_registration_fee,old_arbitration_fee)
    # 该函数在增加争议金额的时候进行应收或应退的增加
    # user_code  操作用户的编码
    # recevice_code 咨询流水号
    # amount 增加的争议金额信息的对象参数，根据该参数可以判断到当事人类型
    # old_registration_fee 增加前的立案费或受理费
    # old_arbitration_fee 增加前的处理费或仲裁费
    @case=TbCase.find_by_recevice_code(recevice_code)
    @partytype={"1"=>"申请人","2"=>"被申请人"}
    @case_amount_typ={"0001"=>"争议金额","0002"=>"追加争议金额","0003"=>"减少争议金额"}
    @amount_typ={"0001"=>"明确金额","0002"=>"不明确金额"}
    #添加相应的应收款信息####################################################
    new_registration_fee=Cost.new.get_fee(amount.partytype,1,recevice_code)
    new_arbitration_fee=Cost.new.get_fee(amount.partytype,2,recevice_code)

    if ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))>0#增加应收费记录 案件费用
      @should=TbShouldCharge.new()
      @should.used='Y'
      @should.recevice_code=recevice_code
      @should.case_code=@case.case_code
      @should.general_code=@case.general_code
      @should.case_amount_id=amount.id
      @should.typ="0001"
      if amount.partytype=='1'
        @should.payment='0001'
      else
        @should.payment='0002'
      end
      @should.rmb_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.currency='0001'
      @should.f_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.re_rmb_money=0
      @should.rate=1
      @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
      @should.u=user_code
      @should.u_t=Time.now()
      @should.save
      parent_id=@should.id

      if new_registration_fee - old_registration_fee !=0 #增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0002"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_registration_fee - old_registration_fee
        @should.currency='0001'
        @should.f_money= new_registration_fee - old_registration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0003"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_arbitration_fee - old_arbitration_fee
        @should.currency='0001'
        @should.f_money= new_arbitration_fee - old_arbitration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end
    elsif ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))==0 and (new_registration_fee - old_registration_fee )!=0 #增加应收费记录 案件费用
      @should=TbShouldCharge.new()
      @should.used='Y'
      @should.recevice_code=recevice_code
      @should.case_code=@case.case_code
      @should.general_code=@case.general_code
      @should.case_amount_id=amount.id
      @should.typ="0001"
      if amount.partytype=='1'
        @should.payment='0001'
      else
        @should.payment='0002'
      end
      @should.rmb_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.currency='0001'
      @should.f_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.re_rmb_money=0
      @should.rate=1
      @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
      @should.u=user_code
      @should.u_t=Time.now()
      @should.save
      parent_id=@should.id

      if new_registration_fee - old_registration_fee !=0 #增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0002"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_registration_fee - old_registration_fee
        @should.currency='0001'
        @should.f_money= new_registration_fee - old_registration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0003"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_arbitration_fee - old_arbitration_fee
        @should.currency='0001'
        @should.f_money= new_arbitration_fee - old_arbitration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end
    elsif  ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))<0  #增加应退费记录 案件费用

      @should_r=TbShouldRefund.new()
      @should_r.used='Y'
      @should_r.recevice_code=recevice_code
      @should_r.case_code=@case.case_code
      @should_r.general_code=@case.general_code
      @should_r.case_amount_id=amount.id
      @should_r.typ="0001"
      if amount.partytype=='1'
        @should_r.payment='0001'
      else
        @should_r.payment='0002'
      end
      @should_r.rmb_money= -1 * ((new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee ))
      @should_r.currency='0001'
      @should_r.f_money= -1 * ((new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee ))
      @should_r.rate=1
      @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
      @should_r.state=1
      @should_r.u=user_code
      @should_r.u_t=Time.now()
      @should_r.save
      parent_id=@should_r.id

      if new_registration_fee - old_registration_fee !=0 #增加应退费记录 立案费或受理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.case_amount_id=amount.id
        @should_r.typ="0002"
        if amount.partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * (new_registration_fee - old_registration_fee)
        @should_r.currency='0001'
        @should_r.f_money= -1 * (new_registration_fee - old_registration_fee)
        @should_r.rate=1
        @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应退费记录 仲裁费或处理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.case_amount_id=amount.id
        @should_r.typ="0003"
        if amount.partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * (new_arbitration_fee - old_arbitration_fee)
        @should_r.currency='0001'
        @should_r.f_money= -1 * (new_arbitration_fee - old_arbitration_fee)
        @should_r.rate=1
        @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：#{amount.rmb_money}￥"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.save  
      end
      
    end

  end
  
end
