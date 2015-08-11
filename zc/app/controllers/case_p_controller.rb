class CasePController < ApplicationController
  def case_doc
    #链接到发文
    redirect_to :controller=>"case_doc",:action=>"list",:recevice_code=>params[:recevice_code]
  end
  #办理案件中立案后结案前的案件选择。助理办案
  def list
    if params[:contr_r]==nil
      params[:contr_r]="casebase"
    end
    if params[:act_r]==nil
      params[:act_r]="edit"
    end
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_general_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
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
    c="tb_cases_state>=4 and tb_cases_state<100 and tb_cases_caseendbook_id_first is null and tb_cases_clerk='#{session[:user_code]}'"#立案未结案 tb_cases_file_submit_u=''
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    # 2----------------------------------
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=3000
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="general_code desc"
    end
    if @search_condit==nil
      @search_condit=""
    end
    sql = "select distinct recevice_code,nowdate,case_code,state,receivedate,aribitprog_num,id,finally_limit_dat from tb_cases where used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null and caseorg_id_first is null and recevice_code not in (select recevice_code from tb_check_staffs where used='Y' and typ='0001') order by #{@order}"
    @case_pages_2,@case_2=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    ## 3-----------------------------------
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=3000
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="c.general_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    if @search_condit==nil
      @search_condit=""
    end
    sql ="select distinct c.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.state as state,c.receivedate as receivedate,c.aribitprog_num as aribitprog_num,c.id as id,c.finally_limit_dat as finally_limit_dat from tb_cases as c
    where c.used='Y' and c.clerk='#{session[:user_code]}' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.caseorg_id_first is not null and c.recevice_code not in (select recevice_code from tb_check_staffs where used='Y' and typ='0001')  order by #{@order}"
    @case_pages_3,@case_3=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    # 4 ------------------------------------------
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=3000
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="c.general_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    if @search_condit==nil
      @search_condit=""
    end
    sql ="select distinct c.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.state as state,c.receivedate as receivedate,c.aribitprog_num as aribitprog_num,c.id as id,c.finally_limit_dat as finally_limit_dat from tb_cases as c
    where c.used='Y' and c.clerk='#{session[:user_code]}' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.recevice_code in (select recevice_code from tb_check_staffs where used='Y' and typ='0001') order by #{@order}"
    @case_pages_4,@case_4=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    # 5--------------------
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=3000
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="general_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"归档"}
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and  state<150 and state<>100 and caseendbook_id_first is not null and file_submit_u=''"
    @case_pages_5,@case_5=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def select
    @case=TbCase.find(params[:id])
    session[:case_code]=@case.case_code
    session[:recevice_code]=@case.recevice_code
    session[:general_code]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end
  
  #案件代收代支费用支出 案件仲裁庭费用支出 案件其它支出 当事人承担实际开支，此4个界面共用一个界面
  def list1
    if params[:contr_r]==nil
      params[:contr_r]="casebase"
    end
    if params[:act_r]==nil
      params[:act_r]="edit"
    end
    #1-----在办案件
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    c="used='Y' and state>=4 and state<100 and end_code='' and clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    # 5----已结未归档
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<>100 and state<150 and end_code<>'' and file_submit_u=''"
    @case_pages_5,@case_5=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def select1
    @case=TbCase.find(params[:id])
    session[:case_code]=@case.case_code
    session[:recevice_code]=@case.recevice_code
    session[:general_code]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end
  #立案后案件永远显示在页面上，但是助理只能看到自己办过的案件。录入办案人员报酬的时候的案件选择、
  def list_1
    @state={"1"=>"办理","2"=>"归档"}
    @hant_search_1_page_name="list_1"
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="(case tb_cases_state>=200 when true then 2 else 1 end) asc,right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state>=4 and tb_cases_caseendbook_id_first is not null and tb_cases_clerk='#{session[:user_code]}' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct (case tb_cases_state>=200 when true then 2 else 1 end) as state,tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  def select_1
    @case=TbCase.find(params[:id])
    session[:case_code_1]=@case.case_code
    session[:recevice_code_1]=@case.recevice_code
    session[:general_code_1]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end

  #立案后案件永远显示在页面上。管理层（处长）录入办案人员报酬的时候的案件选择、 
  def list_2
    @state={"1"=>"办理","2"=>"归档"}
    @remun={"Y"=>"处长确认","N"=>"未发放"}
    @hant_search_1_page_name="list_2"
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char',"tb_caseendbooks_decideDate>=\\\'2013-11-01\\\' and OrgCount >0 and get_remun_state( tb_cases_recevice_code ) ",'结案后,未确认报酬记录','select',[['','全部'],['N','是']]],['date','tb_caseendbooks_decideDate','结案日期','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','get_remun_state(tb_cases_recevice_code)','处长是否已经确认报酬','select',[['','全部'],['Y','是'],['N','否']]],['date','get_remun_dt(tb_cases_recevice_code)','处长确认报酬时间','text',[]]]
    @hant_search_1_list=['tb_cases_case_code','tb_caseendbooks_decideDate',"tb_caseendbooks_decideDate>=\\\'2013-11-01\\\' and OrgCount >0 and get_remun_state( tb_cases_recevice_code ) "]
    @order=params[:order]
    if @order==nil or @order==""
      #@order="(case tb_cases_state>=200 when true then 2 else 1 end) asc,right(tb_cases_case_code,7) desc"
      @order="tb_caseendbooks_decideDate desc,right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state>=4  and tb_cases_caseendbook_id_first is not null"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct (case tb_cases_state>=200 when true then 2 else 1 end) as state,tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_caseendbook_id_last from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  def select_2
    @case=TbCase.find(params[:id])
    session[:case_code_2]=@case.case_code
    session[:recevice_code_2]=@case.recevice_code
    session[:general_code_2]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end

  #结案后归档前，但是助理只能看到自己办过的案件。助理录入结案后信息、
  def list_3
    @hant_search_1_page_name="list_3"
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_caseendbook_id_first is not null and tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  def select_3
    @case=TbCase.find(params[:id])
    session[:case_code_3]=@case.case_code
    session[:recevice_code_3]=@case.recevice_code
    session[:general_code_3]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end

  #助理可以看到自己的咨询案件和在办案件，助理能看到自己的案件。案件发文,减交，缓交，减退
  def list_4
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    #立案阶段的案件
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100  and end_code=''"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @n1 = TbCase.count(:id,:conditions=>c)
    #已结未归档案件
    @order3=params[:order]
    if @order3==nil or @order3==""
      @order3="recevice_code desc"
    end
    @page_lines3=params[:page_lines]
    if @page_lines3==nil or @page_lines3==""
      @page_lines3= session[:lines]
    end
    c3=" used='Y' and  clerk='#{session[:user_code]}' and state>=4 and state<>100 and state<150 and end_code<>'' and file_submit_u=''"
    @case_pages3,@case3=paginate(:tb_cases,:conditions=>c3,:order=>@order3,:per_page=>@page_lines3.to_i)
    @n3 = TbCase.count(:id,:conditions=>c3)
    #咨询阶段的案件
    @order2=params[:order]
    if @order2==nil or @order2==""
      @order2="recevice_code desc"
    end
    @page_lines2=params[:page_lines]
    if @page_lines2==nil or @page_lines2==""
      @page_lines2= session[:lines]
    end
    c2="used='Y' and state=1 and (clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') "
    @case_pages2,@case2=paginate(:tb_cases,:conditions=>c2,:order=>@order2,:per_page=>@page_lines2.to_i)
    @n2 = TbCase.count(:id,:conditions=>c2)
  end

  def select_4
    @case=TbCase.find(params[:id])
    session[:case_code_4]=@case.case_code
    session[:recevice_code_4]=@case.recevice_code
    session[:general_code_4]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end
  #归档申请的案件列表，档案管理员归档使用
  def list_5
    @hant_search_1_page_name="list_5"
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],['char','tb_cases_general_code','总案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['date','date(tb_cases_file_up_t)','归档时间','text',[]],['date','date(tb_cases_file_receive_t)','接收时间','text',[]],['char','tb_cases_clerk','助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state>=200" #and clerk='#{session[:user_code]}'
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_file_num_1,tb_cases_file_num_2,tb_cases_file_typ from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @n_l=VCaseQuery1List1.find_by_sql("select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_file_num_1,tb_cases_file_num_2,tb_cases_file_typ from v_case_query1_list1s where #{c}").length
  end
  def select_5
    @case=TbCase.find(params[:id])
    session[:case_code_5]=@case.case_code
    session[:recevice_code_5]=@case.recevice_code
    session[:general_code_5]=@case.general_code
    redirect_to :controller=>params[:contr_r],:action=>params[:act_r]
  end

  def remun_list
    @rc = params[:recevice_code]
    @bank_typ = {"0001" => "本地", "0002" => "外地"}
    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @case = TbCase.find_by_recevice_code(@rc)
    @tb_extend = TbExtend.find(:all,:conditions=>{:recevice_code =>@rc, :used=>'Y'})
  end
end
