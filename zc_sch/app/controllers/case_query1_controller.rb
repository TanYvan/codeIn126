class CaseQuery1Controller < ApplicationController
   
  #   华南仲裁委案件查询
     
  #助理在办案件信息列表
  def case_now_clerk
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @hant_search_1_page_name="case_now_clerk"
    @hant_search_1=[
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[4,"立案"],[5,"组庭"],[6,"开庭"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件类型大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件类型小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','争议金额','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_terms_drafting_party',
      'IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')','IFNULL(tb_cases_amount,0)']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}' and tb_cases_state>=4 and tb_cases_state<100 "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_end_code,tb_cases_clerk  from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  #基本情况查询
  def list_1
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_1"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁协议类型','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[1,"咨询"],[2,"历史"],[3,"不受理"],[4,"立案"],[5,"组庭"],[6,"开庭"],[-1,"重审"],[100,"结案"],[150,"归档申请"],[200,"已归档"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件争议金额大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件争议金额小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','争议金额','text',[]],
      ['date','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','协议签订日期','text',[]]
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code',
      'tb_cases_end_code','tb_cases_terms_drafting_party','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')',
      'IFNULL(tb_cases_amount,0)','IFNULL(tb_contractsigns_contractdate,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_amount  from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  #仲裁参与人查询
  def list_2
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_2"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(arbitman_name,\\\'\\\')','仲裁员姓名','text',[]],['char','IFNULL(party1_partyname,\\\'\\\')','申请人','text',[]],
      ['char','IFNULL(agent1_name,\\\'\\\')','申请人代理人','text',[]],['char','IFNULL(witne1_name,\\\'\\\')','申请人证人','text',[]],
      ['char','IFNULL(party2_partyname,\\\'\\\')','被申请人','text',[]],['char','IFNULL(agent2_name,\\\'\\\')','被申请人代理人','text',[]],
      ['char','IFNULL(witne2_name,\\\'\\\')','被申请人证人','text',[]],
      ['char','tb_cases_case_type1','主体类型','select',TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
    'IFNULL(arbitman_name,\\\'\\\')', 'IFNULL(party1_partyname,\\\'\\\')','IFNULL(agent1_name,\\\'\\\')','IFNULL(witne1_name,\\\'\\\')',
    'IFNULL(party2_partyname,\\\'\\\')','IFNULL(agent2_name,\\\'\\\')','IFNULL(witne2_name,\\\'\\\')'  
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
   
    @case_pages,@case=paginate_by_sql(VCaseQuery1List2,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list2s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  #按仲裁程序查询
  def list_3
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_3"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(tb_cases_aribitprog_num,\\\'\\\')','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(amount2_used,\\\'\\\')','反请求','select',[["Y","有"]]],
      ['char','IFNULL(tb_saves_yard_area,\\\'\\\')','保全法院地区','select',TbDictionary.find(:all,:conditions=>"typ_code='8104' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_saves_save_yard,\\\'\\\')','法院名称','text',[]],['char','IFNULL(caseorg_used,\\\'\\\')','组庭','select',[["Y","有"]]],
      ['char','IFNULL(evite_used,\\\'\\\')','仲裁员回避','select',[["Y","有"]]],['char','IFNULL(sitting_used,\\\'\\\')','开庭','select',[["Y","有"]]],
      ['char','IFNULL(tb_cases_special,\\\'\\\')','特殊情况','text',[]],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
      'IFNULL(tb_saves_save_yard,\\\'\\\')','IFNULL(tb_cases_special,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @case_pages,@case=paginate_by_sql(VCaseQuery1List3,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list3s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  #按时间查询
  def list_4
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_4"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['date','IFNULL(tb_cases_receivedate,\\\'\\\')','咨询日期','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案日期','text',[]],
      ['date','IFNULL(caseorg_orgdate,\\\'\\\')','组庭日期','text',[]],
      ['date','IFNULL(sitting_sittingdate,\\\'\\\')','开庭日期','text',[]],
      ['date','IFNULL(tb_cases_end_date,\\\'\\\')','结案日期','text',[]],
      ['number','IFNULL(tb_cases_now_end,\\\'\\\')','立案至结案天数','text',[]],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','IFNULL(tb_cases_receivedate,\\\'\\\')',
    'IFNULL(tb_cases_nowdate,\\\'\\\')','IFNULL(caseorg_orgdate,\\\'\\\')','IFNULL(sitting_sittingdate,\\\'\\\')','IFNULL(tb_cases_end_date,\\\'\\\')',
    'IFNULL(tb_cases_now_end,\\\'\\\')' 
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @case_pages,@case=paginate_by_sql(VCaseQuery1List4,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list4s  where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  #结案情况查询视图
  def list_5
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_5"
    @hant_search_1=[['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','IFNULL(tb_repairarbits_used,\\\'\\\')','有无补充','select',[["Y","有补充"]]],
      ['char','IFNULL(tb_addarbits_used,\\\'\\\')','有无裁决书更正','select',[["Y","有"]]],
      ['char','IFNULL(tb_caseendbooks_endStyle,\\\'\\\')','结案方式','select',TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_runstyle,\\\'\\\')','执行情况','select',TbDictionary.find(:all,:conditions=>"typ_code='9014' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_isback,\\\'\\\')','是否申请撤销','select',[["1","是"]]],
      ['char','IFNULL(tb_cases_isunrun,\\\'\\\')','是否申请不予执行','select',[["1","是"]]],
      ['number','IFNULL(tb_cases_state,\\\'\\\')','重新仲裁','select',[[-1,"是"]]],
      ['char','IFNULL(tb_casedelays_used,\\\'\\\')','有无延长审限','select',[["Y","有"]]],
      ]
    @hant_search_1_list=['tb_cases_end_code','tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @case_pages,@case=paginate_by_sql(VCaseQuery1List5,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list5s  where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  
  
  
  #申请人、代理人信息查询
  def list_8
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @sss={1=>"申请人",2=>"被申请人"}
    @hant_search_1_page_name="list_8"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partytype,\\\'\\\')','申(被)请人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_commissary,\\\'\\\')','法定代表人','text',[]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','申(被)请人名称','text',[]],
      ['char','IFNULL(tb_parties_addr,\\\'\\\')','申(被)请人地址','text',[]],
      ['char','IFNULL(tb_parties_postcode,\\\'\\\')','申(被)请人邮政编码','text',[]],
      ['char','IFNULL(tb_parties_tel,\\\'\\\')','申(被)请人电话','text',[]],
      ['char','IFNULL(tb_agents_name,\\\'\\\')','代理人名称','text',[]],
      ['number','IFNULL(tb_agents_company,\\\'\\\')','代理人公司','text',[]],
      ['char','IFNULL(tb_agents_addr,\\\'\\\')','代理人地址','text',[]],
      ['char','IFNULL(tb_agents_postcode,\\\'\\\')','代理人邮政编码','text',[]],
      ['char','IFNULL(tb_agents_tel,\\\'\\\')','代理人电话','text',[]],
      ['char','IFNULL(tb_agents_mobiletel,\\\'\\\')','代理人手机','text',[]],
      ]
    @hant_search_1_list=['IFNULL(tb_parties_commissary,\\\'\\\')',
      'IFNULL(tb_parties_commissary,\\\'\\\')','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_parties_addr,\\\'\\\')','IFNULL(tb_parties_postcode,\\\'\\\')',
    'IFNULL(tb_parties_postcode,\\\'\\\')','IFNULL(tb_parties_tel,\\\'\\\')','IFNULL(tb_agents_name,\\\'\\\')','IFNULL(tb_agents_company,\\\'\\\')',
    'IFNULL(tb_agents_addr,\\\'\\\')','IFNULL(tb_agents_postcode,\\\'\\\')','IFNULL(tb_agents_tel,\\\'\\\')','IFNULL(tb_agents_mobiletel,\\\'\\\')'
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    
    c="tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:v_case_query1_list8s,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  #将到期案件查询
  def list_10
    @day1=params[:day1]
    b=Date.today
    if @day1=='01' or @day1==nil
      a=Date.today+15
      @case1=TbCase.find(:all,:conditions=>"limit_dat<='#{a}' and limit_dat>='#{b}' and used='Y' and state>=1 and state<100 and state!=2 and state!=3",:order=>"recevice_code")
    elsif @day1=='02'
      a=Date.today+30
      @case1=TbCase.find(:all,:conditions=>"limit_dat<='#{a}' and limit_dat>='#{b}' and used='Y' and state>=1 and state<100 and state!=2 and state!=3",:order=>"recevice_code")
    elsif @day1=='03'
      a=Date.today+45
      @case1=TbCase.find(:all,:conditions=>"limit_dat<='#{a}' and limit_dat>='#{b}' and used='Y' and state>=1 and state<100 and state!=2 and state!=3",:order=>"recevice_code")
    elsif @day1=='04'
      a=Date.today+60
      @case1=TbCase.find(:all,:conditions=>"limit_dat<='#{a}' and limit_dat>='#{b}' and used='Y' and state>=1 and state<100 and state!=2 and state!=3",:order=>"recevice_code")
    else  # @day1=='05'
      a=Date.today+90
      @case1=TbCase.find(:all,:conditions=>"limit_dat<='#{a}' and limit_dat>='#{b}' and used='Y' and state>=1 and state<100 and state!=2 and state!=3",:order=>"recevice_code")
    end
  end
  #结案查询
  def list_11    
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil or @date2==nil
      @date1 = Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1==nil or @date2==nil or @date1=="" or @date2==""
      flash[:notice]="请选择结案时间！"
      render :action=>"list_11"
    elsif @date1>@date2
      flash[:notice]="结案时间有误，请重新选择！"
      render :action=>"list_11"
    else
      @endcase=TbCase.find(:all,:conditions=>"end_date>='#{@date1}' and end_date<='#{@date2}' and state>=100 and used='Y'",:order=>"recevice_code")
    end
  end

#处长使用    处长所使用的查询       ################################################################
  def case_now_clerk2
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @hant_search_1_page_name="case_now_clerk2"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[4,"立案"],[5,"组庭"],[6,"开庭"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件类型大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件类型小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','争议金额','text',[]],
      ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_terms_drafting_party',
      'IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')','IFNULL(tb_cases_amount,0)']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_general_code desc"
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

    c="tb_cases_state>=4 and tb_cases_state<100 "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
    #基本情况查询
  def list_31
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_31"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[1,"咨询"],[2,"历史"],[3,"不受理"],[4,"立案"],[5,"组庭"],[6,"开庭"],[-1,"重审"],[100,"结案"],[150,"归档申请"],[200,"已归档"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件争议金额大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件争议金额小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','争议金额','text',[]],
      ['date','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','协议签订日期','text',[]]
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code',
      'tb_cases_end_code','tb_cases_terms_drafting_party','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')',
      'IFNULL(tb_cases_amount,0)','IFNULL(tb_contractsigns_contractdate,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
    #仲裁参与人查询
  def list_32
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_32"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(arbitman_name,\\\'\\\')','仲裁员姓名','text',[]],['char','IFNULL(party1_partyname,\\\'\\\')','申请人','text',[]],
      ['char','IFNULL(agent1_name,\\\'\\\')','申请人代理人','text',[]],['char','IFNULL(witne1_name,\\\'\\\')','申请人证人','text',[]],
      ['char','IFNULL(party2_partyname,\\\'\\\')','被申请人','text',[]],['char','IFNULL(agent2_name,\\\'\\\')','被申请人代理人','text',[]],
      ['char','IFNULL(witne2_name,\\\'\\\')','被申请人证人','text',[]],
      ['char','tb_cases_case_type1','主体类型','select',TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
    'IFNULL(arbitman_name,\\\'\\\')', 'IFNULL(party1_partyname,\\\'\\\')','IFNULL(agent1_name,\\\'\\\')','IFNULL(witne1_name,\\\'\\\')',
    'IFNULL(party2_partyname,\\\'\\\')','IFNULL(agent2_name,\\\'\\\')','IFNULL(witne2_name,\\\'\\\')'
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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

    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List2,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list2s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  #按仲裁程序查询
  def list_33
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_33"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(tb_cases_aribitprog_num,\\\'\\\')','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(amount2_used,\\\'\\\')','反请求','select',[["Y","有"]]],
      ['char','IFNULL(tb_saves_yard_area,\\\'\\\')','保全法院地区','select',TbDictionary.find(:all,:conditions=>"typ_code='8104' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_saves_save_yard,\\\'\\\')','法院名称','text',[]],['char','IFNULL(caseorg_used,\\\'\\\')','组庭','select',[["Y","有"]]],
      ['char','IFNULL(evite_used,\\\'\\\')','仲裁员回避','select',[["Y","有"]]],['char','IFNULL(sitting_used,\\\'\\\')','开庭','select',[["Y","有"]]],
      ['char','IFNULL(tb_cases_special,\\\'\\\')','特殊情况','text',[]],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
      'IFNULL(tb_saves_save_yard,\\\'\\\')','IFNULL(tb_cases_special,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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

    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List3,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list3s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  #按时间查询
  def list_34
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_34"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['date','IFNULL(tb_cases_receivedate,\\\'\\\')','咨询日期','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案日期','text',[]],
      ['date','IFNULL(caseorg_orgdate,\\\'\\\')','组庭日期','text',[]],
      ['date','IFNULL(sitting_sittingdate,\\\'\\\')','开庭日期','text',[]],
      ['date','IFNULL(tb_cases_end_date,\\\'\\\')','结案日期','text',[]],
      ['number','IFNULL(tb_cases_now_end,\\\'\\\')','立案至结案天数','text',[]],
      ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','IFNULL(tb_cases_receivedate,\\\'\\\')',
    'IFNULL(tb_cases_nowdate,\\\'\\\')','IFNULL(caseorg_orgdate,\\\'\\\')','IFNULL(sitting_sittingdate,\\\'\\\')','IFNULL(tb_cases_end_date,\\\'\\\')',
    'IFNULL(tb_cases_now_end,\\\'\\\')'
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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

    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List4,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list4s  where #{c}  order by #{@order}",@page_lines.to_i)
  end

  #结案情况查询视图
  def list_35
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_35"
    @hant_search_1=[['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','IFNULL(tb_repairarbits_used,\\\'\\\')','有无补充','select',[["Y","有补充"]]],
      ['char','IFNULL(tb_addarbits_used,\\\'\\\')','有无裁决书更正','select',[["Y","有"]]],
      ['char','IFNULL(tb_caseendbooks_endStyle,\\\'\\\')','结案方式','select',TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_runstyle,\\\'\\\')','执行情况','select',TbDictionary.find(:all,:conditions=>"typ_code='9014' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_isback,\\\'\\\')','是否申请撤销','select',[["1","是"]]],
      ['char','IFNULL(tb_cases_isunrun,\\\'\\\')','是否申请不予执行','select',[["1","是"]]],
      ['number','IFNULL(tb_cases_state,\\\'\\\')','重新仲裁','select',[[-1,"是"]]],
      ['char','IFNULL(tb_casedelays_used,\\\'\\\')','有无延长审限','select',[["Y","有"]]],
      ]
    @hant_search_1_list=['tb_cases_end_code','tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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

    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List5,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list5s  where #{c}  order by #{@order}",@page_lines.to_i)
  end

  #申请人、代理人信息查询
  def list_38
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @sss={1=>"申请人",2=>"被申请人"}
    @hant_search_1_page_name="list_38"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partytype,\\\'\\\')','申(被)请人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_commissary,\\\'\\\')','法定代表人','text',[]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','申(被)请人名称','text',[]],
      ['char','IFNULL(tb_parties_addr,\\\'\\\')','申(被)请人地址','text',[]],
      ['char','IFNULL(tb_parties_postcode,\\\'\\\')','申(被)请人邮政编码','text',[]],
      ['char','IFNULL(tb_parties_tel,\\\'\\\')','申(被)请人电话','text',[]],
      ['char','IFNULL(tb_agents_name,\\\'\\\')','代理人名称','text',[]],
      ['number','IFNULL(tb_agents_company,\\\'\\\')','代理人公司','text',[]],
      ['char','IFNULL(tb_agents_addr,\\\'\\\')','代理人地址','text',[]],
      ['char','IFNULL(tb_agents_postcode,\\\'\\\')','代理人邮政编码','text',[]],
      ['char','IFNULL(tb_agents_tel,\\\'\\\')','代理人电话','text',[]],
      ['char','IFNULL(tb_agents_mobiletel,\\\'\\\')','代理人手机','text',[]],
      ]
    @hant_search_1_list=['IFNULL(tb_parties_commissary,\\\'\\\')',
      'IFNULL(tb_parties_commissary,\\\'\\\')','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_parties_addr,\\\'\\\')','IFNULL(tb_parties_postcode,\\\'\\\')',
    'IFNULL(tb_parties_postcode,\\\'\\\')','IFNULL(tb_parties_tel,\\\'\\\')','IFNULL(tb_agents_name,\\\'\\\')','IFNULL(tb_agents_company,\\\'\\\')',
    'IFNULL(tb_agents_addr,\\\'\\\')','IFNULL(tb_agents_postcode,\\\'\\\')','IFNULL(tb_agents_tel,\\\'\\\')','IFNULL(tb_agents_mobiletel,\\\'\\\')'
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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

    c="tb_cases_state>=-1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:v_case_query1_list8s,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  
  #前台基本情况查询
  def list_101
    @dat1 = Time.now.months_ago(2).at_beginning_of_month.to_date
    @dat2 = "select  last_day(now())"
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_101"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案时间','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]]
      ]
    @hant_search_1_list=['IFNULL(tb_parties_partyname,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_nowdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=200000
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

    c="tb_cases_state>=4 and tb_cases_state<=150 and  tb_cases_nowdate>'#{@dat1}' and  tb_cases_nowdate<(select  last_day(now()))"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_nowdate,tb_cases_clerk from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def case_now_clerk2_total
    @case=TbCase.find_by_sql("select clerk as clerk, count(clerk) as n from tb_cases where used='Y' and state>=4 and state<100 group by clerk order by clerk")
  end
  
end
