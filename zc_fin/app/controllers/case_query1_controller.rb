class CaseQuery1Controller < ApplicationController   
  #   华南仲裁委案件查询
  
  #助理在办案件信息列表
  def case_now_clerk
    arr_date = Date.today.to_s.split("-")
    @arr_date1 = PubTool.new.n_to_c(arr_date[0].to_i)
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @order="tb_cases_general_code"
    @page_lines=1000
    c="tb_cases_clerk='#{session[:user_code]}' and tb_cases_state>=4 and tb_cases_state<100 and tb_cases_state<>2 and tb_cases_state<>3 and tb_cases_end_code = '' "
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_end_code,tb_cases_clerk,tb_cases_agent  from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  def every_case_clerk
    arr_date = Date.today.to_s.split("-")
    @arr_date1=PubTool.new.n_to_c(arr_date[0].to_i)
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_general_code"
    end
    @page_lines = 1000
    c="tb_cases_clerk='#{params[:user_code]}' and tb_cases_state>=4 and tb_cases_state<100 and tb_cases_caseendbook_id_first is null"
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_end_code,tb_cases_clerk,tb_cases_agent  from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  #基本情况查询
  def list_1
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @remun={"Y"=>"处长确认","N"=>"未发放"}
    @hant_search_1_page_name="list_1"
    @hant_search_1=[
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_end_code','结案号','text',[]],
      ['date','tb_cases_nowdate','立案日期','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁协议类型','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and  state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[1,"咨询"],[2,"历史"],[3,"不受理"],[4,"立案"],[5,"组庭"],[6,"开庭"],[-1,"重审"],[100,"终审"],[150,"归档申请"],[200,"已归档"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件争议金额大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件争议金额小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','总争议金额','text',[]],
      ['number','IFNULL(tb_cases_amount_1,0)','本请求争议金额','text',[]],
      ['number','IFNULL(tb_cases_amount_2,0)','反请求争议金额','text',[]],
      ['date','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','协议签订日期','text',[]],
      ['char','typed1','证据保全','select',[['0000','无'],['0001','有']]],
      ['char','typed2','财产保全','select',[['0000','无'],['0002','有']]],
      ['char','tb_cases_remun_state','报酬发放情况','select',[['Y','处长确认'],['N','未发放']]]
    ]
    @hant_search_1_list=['tb_cases_case_code',
      'tb_cases_end_code','tb_cases_terms_drafting_party','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')',
      'tb_cases_nowdate','IFNULL(tb_cases_amount,0)','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','typed1','typed2','tb_cases_remun_state']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @hant_search_1_r=params[:hant_search_1_r]
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
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_amount,tb_cases_amount_1,tb_cases_amount_2   from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List1.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list1s where #{c}")
  end

  #仲裁参与人查询
  def list_2
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_2"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(arbitman_name,\\\'\\\')','仲裁员姓名','text',[]],['char','IFNULL(party1_partyname,\\\'\\\')','申请人','text',[]],
      ['char','IFNULL(agent1_name,\\\'\\\')','申请人代理人','text',[]],['char','IFNULL(witne1_name,\\\'\\\')','申请人证人','text',[]],
      ['char','IFNULL(party2_partyname,\\\'\\\')','被申请人','text',[]],['char','IFNULL(agent2_name,\\\'\\\')','被申请人代理人','text',[]],
      ['char','IFNULL(witne2_name,\\\'\\\')','被申请人证人','text',[]],
      ['char','tb_cases_case_type1','主体类型','select',TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
      'IFNULL(arbitman_name,\\\'\\\')', 'IFNULL(party1_partyname,\\\'\\\')','IFNULL(agent1_name,\\\'\\\')','IFNULL(witne1_name,\\\'\\\')',
      'IFNULL(party2_partyname,\\\'\\\')','IFNULL(agent2_name,\\\'\\\')','IFNULL(witne2_name,\\\'\\\')'
    ]
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="tb_cases_state>=4 and tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end   
    @case_pages,@case=paginate_by_sql(VCaseQuery1List2,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list2s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List2.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list2s where #{c}")
  end
  
  #按仲裁程序查询
  def list_3
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_3"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','IFNULL(tb_cases_aribitprog_num,\\\'\\\')','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(amount2_used,\\\'\\\')','反请求','select',[["Y","有"]]],
      ['char','IFNULL(tb_saves_yard_area,\\\'\\\')','保全法院地区','select',TbDictionary.find(:all,:conditions=>"typ_code='8104' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_saves_save_yard,\\\'\\\')','法院名称','text',[]],['char','IFNULL(caseorg_used,\\\'\\\')','组庭','select',[["Y","有"]]],
      ['char','IFNULL(evite_used,\\\'\\\')','仲裁员回避','select',[["Y","有"]]],['char','IFNULL(sitting_used,\\\'\\\')','开庭','select',[["Y","有"]]],
      ['char','IFNULL(tb_cases_special,\\\'\\\')','案件备注','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code',
      'IFNULL(tb_saves_save_yard,\\\'\\\')','IFNULL(tb_cases_special,\\\'\\\')']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="tb_cases_state>=4 and tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end    
    @case_pages,@case=paginate_by_sql(VCaseQuery1List3,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list3s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List3.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list3s where #{c}")
  end
  
  #按时间查询
  def list_4
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_4"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['date','IFNULL(tb_cases_receivedate,\\\'\\\')','咨询日期','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案日期','text',[]],
      ['date','IFNULL(caseorg_orgdate,\\\'\\\')','组庭日期','text',[]],
      ['date','IFNULL(sitting_sittingdate,\\\'\\\')','开庭日期','text',[]],
      ['date','IFNULL(tb_caseendbooks_decideDate,\\\'\\\')','结案日期','text',[]],
      ['number','IFNULL(tb_cases_now_end,\\\'\\\')','立案至结案天数','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','IFNULL(tb_cases_receivedate,\\\'\\\')',
      'IFNULL(tb_cases_nowdate,\\\'\\\')','IFNULL(caseorg_orgdate,\\\'\\\')','IFNULL(sitting_sittingdate,\\\'\\\')','IFNULL(tb_caseendbooks_decideDate,\\\'\\\')',
      'IFNULL(tb_cases_now_end,\\\'\\\')'
    ]
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="tb_cases_clerk='#{session[:user_code]}' and tb_cases_state>=4"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end    
    @case_pages,@case=paginate_by_sql(VCaseQuery1List4,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list4s  where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List4.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list4s where #{c}")
  end
  
  #结案情况查询视图
  def list_5
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_5"
    @hant_search_1=[['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['date','tb_cases_nowdate','立案时间','text',[]],
      ['date','tb_caseendbooks_decideDate','结案时间','text',[]],
      ['char','IFNULL(tb_repairarbits_used,\\\'\\\')','有无补充','select',[["Y","有补充"]]],
      ['char','IFNULL(tb_addarbits_used,\\\'\\\')','有无裁决书更正','select',[["Y","有"]]],
      ['char','IFNULL(tb_caseendbooks_endStyle,\\\'\\\')','结案方式','select',TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_runstyle,\\\'\\\')','执行情况','select',TbDictionary.find(:all,:conditions=>"typ_code='9014' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_isback,\\\'\\\')','是否申请撤销','select',[["1","是"]]],
      ['char','IFNULL(tb_cases_isunrun,\\\'\\\')','是否申请不予执行','select',[["1","是"]]],
      ['number','IFNULL(tb_cases_state,\\\'\\\')','重新仲裁','select',[[-1,"是"]]],
      ['char','IFNULL(tb_casedelays_used,\\\'\\\')','有无延长审限','select',[["Y","有"]]],
    ]
    @hant_search_1_list=['tb_cases_end_code','tb_cases_general_code','tb_cases_case_code','tb_cases_nowdate','tb_caseendbooks_decideDate']
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(left(tb_caseendbooks_arbitBookNum,10),7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="tb_cases_state>=4 and tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end 
    @case_pages,@case=paginate_by_sql(VCaseQuery1List5,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_caseendbooks_arbitBookNum,tb_caseendbooks_decideDate,tb_caseendbooks_endStyle from v_case_query1_list5s  where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List5.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list5s where #{c}")
  end

  #申请人、代理人信息查询
  def list_8
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @sss={1=>"申请人",2=>"被申请人"}
    @hant_search_1_page_name="list_8"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partytype,\\\'\\\')','申(被)请人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_commissary,\\\'\\\')','法定代表人','text',[]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','申(被)请人名称','text',[]],
      ['char','IFNULL(tb_parties_addr,\\\'\\\')','申(被)请人地址','text',[]],
      ['char','IFNULL(tb_parties_postcode,\\\'\\\')','申(被)请人邮政编码','text',[]],
      ['char','IFNULL(tb_parties_tel,\\\'\\\')','申(被)请人电话','text',[]],
      ['char','IFNULL(tb_parties_email,\\\'\\\')','申(被)Email','text',[]],
      ['char','IFNULL(tb_agents_name,\\\'\\\')','代理人名称','text',[]],
      ['char','IFNULL(tb_agents_company,\\\'\\\')','所在单位','text',[]],
      ['char','IFNULL(tb_agents_addr,\\\'\\\')','代理人地址','text',[]],
      ['char','IFNULL(tb_agents_postcode,\\\'\\\')','代理人邮政编码','text',[]],
      ['char','IFNULL(tb_agents_tel,\\\'\\\')','代理人电话','text',[]],
      ['char','IFNULL(tb_agents_email,\\\'\\\')','代理人Email','text',[]],
      ['char','IFNULL(tb_agents_mobiletel,\\\'\\\')','代理人手机','text',[]],
    ]
    @hant_search_1_list=['IFNULL(tb_parties_commissary,\\\'\\\')',
      'IFNULL(tb_parties_commissary,\\\'\\\')','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_parties_addr,\\\'\\\')','IFNULL(tb_parties_postcode,\\\'\\\')',
      'IFNULL(tb_parties_postcode,\\\'\\\')','IFNULL(tb_parties_tel,\\\'\\\')','IFNULL(tb_parties_email,\\\'\\\')','IFNULL(tb_agents_name,\\\'\\\')','IFNULL(tb_agents_company,\\\'\\\')',
      'IFNULL(tb_agents_addr,\\\'\\\')','IFNULL(tb_agents_postcode,\\\'\\\')','IFNULL(tb_agents_tel,\\\'\\\')','IFNULL(tb_agents_email,\\\'\\\')','IFNULL(tb_agents_mobiletel,\\\'\\\')'
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="tb_cases_state>=4 and tb_cases_clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:v_case_query1_list8s,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @c_l=VCaseQuery1List8.find(:all,:conditions=>c)
  end
  
  #将到期案件查询
  def list_10
    @day_all=[['15天以内','01'],['30天以内','02'],['45天以内','03'],['60天以内','04'],["90天以内",'05']]
    @clerk_all=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord")
    @str1={"01"=>"15天以内","02"=>"30天以内","03"=>"45天以内","04"=>"60天以内","05"=>"90天以内"}
    @day1=params[:day1]
    @clerk=params[:clerk]
    p=PubTool.new()
    if p.sql_check_3(@day1)!=false and p.sql_check_3(@clerk)!=false 
      if @day1==nil
        @day1='01'
      end
      if @clerk==nil or @clerk==''
        s=''
      else
        s=" and clerk='#{@clerk}'"
      end
      b=Date.today
      if @day1=='01' or @day1==nil
        a=Date.today+15
        @case1=TbCase.find(:all,:conditions=>"finally_limit_dat<='#{a}' and used='Y' and state>=4 and caseendbook_id_first is null #{s}",:order=>"right(case_code,7)")
      elsif @day1=='02'
        a=Date.today+30
        @case1=TbCase.find(:all,:conditions=>"finally_limit_dat<='#{a}' and used='Y' and state>=4 and caseendbook_id_first is null #{s}",:order=>"right(case_code,7)")
      elsif @day1=='03'
        a=Date.today+45
        @case1=TbCase.find(:all,:conditions=>"finally_limit_dat<='#{a}' and used='Y' and state>=4 and caseendbook_id_first is null #{s}",:order=>"right(case_code,7)")
      elsif @day1=='04'
        a=Date.today+60
        @case1=TbCase.find(:all,:conditions=>"finally_limit_dat<='#{a}' and used='Y' and state>=4 and caseendbook_id_first is null #{s}",:order=>"right(case_code,7)")
      else  # @day1=='05'
        a=Date.today+90
        @case1=TbCase.find(:all,:conditions=>"finally_limit_dat<='#{a}' and used='Y' and state>=4 and caseendbook_id_first is null #{s}",:order=>"right(case_code,7)")
      end
    end
  end
  
  #咨询案件查询
  def list_12
    @hant_search_1_page_name="list_12"
    @hant_search_1=[['date','happdate','咨询日期','text',[]],['char','keyword','系争合同争议性质','text',[]],['char','purpuse','涉案标的','text',[]],
      ['char','app1','申请人信息及联系方式','text',[]],['char','res1','被申请人信息及联系方式','text',[]],
      ['char','agent','机构名称','select',TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','dat1','仲裁条款或协议订立的时间','text',[]],['char','term_source','仲裁条款或协议订立来源','text',[]],
      ['char','note','备注','text',[]],['char','content','处理结果小结','text',[]],['char','content2','后续跟进情况补充','text',[]],
      ['char','clerk_id','助理姓名','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])]
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
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
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="happdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @casepro_pages,@casepro=paginate(:tb_casepros,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @n_l=TbCasepro.find(:all,:conditions=>c)
    #    @date1=params[:date1]
    #    @date2=params[:date2]
    #    if @date1==nil or @date2==nil
    #      @date1 = Time.now.months_ago(2).at_beginning_of_month.to_date
    #      @date2 = Time.now.at_end_of_month.to_date
    #    end
    #    if @date1==nil or @date2==nil or @date1=="" or @date2==""
    #      flash[:notice]="请选择正确的时间！"
    #      render :action=>"list_12"
    #    elsif @date1>@date2
    #      flash[:notice]="时间有误，请重新选择！"
    #      render :action=>"list_12"
    #    else
    #      c="used='Y' and happdate>='#{@date1}' and happdate<='#{@date2}'"
    #      @casepro_pages,@casepro=paginate(:tb_casepros,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    #      @n_l=TbCasepro.find(:all,:conditions=>c)
    #    end
  end
  #处长使用    处长所使用的查询       ################################################################
  def case_now_clerk2
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @hant_search_1_page_name="case_now_clerk2"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','tb_cases_aribitprotprog_num','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[4,"立案"],[5,"组庭"],[6,"开庭"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件类型大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件类型小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','争议金额','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_clerk','tb_cases_terms_drafting_party',
      'IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')','IFNULL(tb_cases_amount,0)']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    c="tb_cases_state>=4 and tb_cases_state<100  and tb_cases_caseendbook_id_first is null"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @total_m=VCaseQuery1List1.sum(:tb_cases_amount,:conditions=>c)
    @case_l=VCaseQuery1List1.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list1s where #{c}")
    @case_ll=@case_l.length
  end

  # --------------------------------  ↓↓↓助理在办案件统计↓↓↓  --------------------------------
  # 统计表
  def case_now_clerk2_total
    @order=params[:order]
    if @order==nil or @order==""
      @order="users.name asc"
    end
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@order)!=false
      @case=TbCase.find_by_sql("select tb_cases.clerk as clerk_code,users.name as clerk_name, count(tb_cases.clerk) as n from tb_cases,users where tb_cases.clerk=users.code and  tb_cases.used='Y' and tb_cases.state>=4 and tb_cases.state<100 and end_code='' group by tb_cases.clerk order by #{@order}")
    end
  end
  
  # 每个助理的案件 详细情况信息
  def list_every
    arr_date = Date.today.to_s.split("-")
    @arr_date1=PubTool.new.n_to_c(arr_date[0].to_i)
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @hant_search_1_page_name="case_now_clerk"
    @order="tb_cases_nowdate,tb_cases_general_code asc"
    @page_lines=10000
    c="tb_cases_clerk='#{params[:user_code]}' and tb_cases_state>=4 and tb_cases_state<100  and tb_cases_end_code = '' "
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_recevice_code,tb_cases_state,tb_cases_general_code,tb_cases_case_code,tb_cases_end_code,tb_cases_clerk  from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    #    @total_m=TbCase.sum(:amount,:conditions=>["used='Y' and clerk=? and state>=4 and state<100  and end_code=''",params[:user_code]])
  end
  # --------------------------------  ↑↑↑助理在办案件统计↑↑↑  --------------------------------
  
  #基本情况查询
  def list_31
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_31"
    @hant_search_1=[
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['date','tb_cases_nowdate','立案日期','text',[]],
      ['char','tb_cases_aribitprotprog_num','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','tb_cases_state','案件状态','select',[[1,"咨询"],[2,"历史"],[3,"不受理"],[4,"立案"],[5,"组庭"],[6,"开庭"],[-1,"重审"],[100,"终审"],[150,"归档申请"],[200,"已归档"]]],
      ['char','tb_cases_terms_drafting_party','仲裁条款起草方','text',[]],
      ['char','tb_cases_clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['number','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_casetype_num','案件争议金额大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_casetype_num2','案件争议金额小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','总争议金额','text',[]],
      ['number','IFNULL(tb_cases_amount_1,0)','本请求争议金额','text',[]],
      ['number','IFNULL(tb_cases_amount_2,0)','反请求争议金额','text',[]],
      ['date','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','协议签订日期','text',[]],
      ['date','IFNULL(tb_casedelays_requestdate,\\\'\\\')','延期提出日期','text',[]],
      ['char','tb_cases_clerk_2','咨询助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','typed1','证据保全','select',[['0000','无'],['0001','有']]],
      ['char','typed2','财产保全','select',[['0000','无'],['0002','有']]],
      ['number','IFNULL(sitting_times,0)','开庭次数','text',[]]
    ]
    @hant_search_1_list=['tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code',
      'tb_cases_end_code','tb_cases_terms_drafting_party','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_cases_arbitprot,\\\'\\\')',
      'tb_cases_nowdate','IFNULL(tb_cases_amount,0)','IFNULL(tb_contractsigns_contractdate,\\\'\\\')','IFNULL(tb_casedelays_requestdate,\\\'\\\')','typed1','typed2','IFNULL(sitting_times,0)']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_amount,tb_cases_amount_1,tb_cases_amount_2 from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List1.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list1s where #{c}")
  end

  #仲裁参与人查询
  def list_32
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_32"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','IFNULL(aname,\\\'\\\')','仲裁员姓名','text',[]],['char','IFNULL(party1_partyname,\\\'\\\')','申请人','text',[]],
      ['char','IFNULL(agent1_name,\\\'\\\')','申请人代理人','text',[]],['char','IFNULL(witne1_name,\\\'\\\')','申请人证人','text',[]],
      ['char','IFNULL(party2_partyname,\\\'\\\')','被申请人','text',[]],['char','IFNULL(agent2_name,\\\'\\\')','被申请人代理人','text',[]],
      ['char','IFNULL(witne2_name,\\\'\\\')','被申请人证人','text',[]],
      ['char','tb_cases_case_type1','主体类型','select',TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','tb_cases_clerk',
      'IFNULL(aname,\\\'\\\')', 'IFNULL(party1_partyname,\\\'\\\')','IFNULL(agent1_name,\\\'\\\')','IFNULL(witne1_name,\\\'\\\')',
      'IFNULL(party2_partyname,\\\'\\\')','IFNULL(agent2_name,\\\'\\\')','IFNULL(witne2_name,\\\'\\\')'
    ]
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state>=4"
    #c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List2,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list2s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List2.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list2s where #{c}")
  end

  #按仲裁程序查询
  def list_33
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_33"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','IFNULL(tb_cases_aribitprog_num,\\\'\\\')','仲裁程序','select',TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(amount2_used,\\\'\\\')','反请求','select',[["Y","有"]]],
      ['char','IFNULL(tb_saves_yard_area,\\\'\\\')','保全法院地区','select',TbDictionary.find(:all,:conditions=>"typ_code='8104' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_saves_save_yard,\\\'\\\')','法院名称','text',[]],['char','IFNULL(caseorg_used,\\\'\\\')','组庭','select',[["Y","有"]]],
      ['char','IFNULL(evite_used,\\\'\\\')','仲裁员回避','select',[["Y","有"]]],['char','IFNULL(sitting_used,\\\'\\\')','开庭','select',[["Y","有"]]],
      ['char','IFNULL(tb_cases_special,\\\'\\\')','案件备注','text',[]],['char','tb_cases_recevice_code','咨询流水号','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','tb_cases_clerk',
      'IFNULL(tb_cases_aribitprog_num,\\\'\\\')','IFNULL(tb_cases_special,\\\'\\\')']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    #c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3"
    c="tb_cases_state>=4"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List3,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk from v_case_query1_list3s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List3.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list3s where #{c}")
  end

  #按时间查询
  def list_34
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_34"
    @hant_search_1=[
      ['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['date','IFNULL(tb_cases_receivedate,\\\'\\\')','咨询日期','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案日期','text',[]],
      ['date','IFNULL(caseorg_orgdate,\\\'\\\')','组庭日期','text',[]],
      ['date','IFNULL(sitting_sittingdate,\\\'\\\')','开庭日期','text',[]],
      ['date','IFNULL(tb_caseendbooks_decideDate,\\\'\\\')','结案日期','text',[]],
      ['number','IFNULL(tb_cases_now_end,\\\'\\\')','立案至结案天数','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],
    ]
    @hant_search_1_list=['tb_cases_general_code','tb_cases_case_code','tb_cases_end_code','tb_cases_clerk','IFNULL(tb_cases_receivedate,\\\'\\\')',
      'IFNULL(tb_cases_nowdate,\\\'\\\')','IFNULL(caseorg_orgdate,\\\'\\\')','IFNULL(sitting_sittingdate,\\\'\\\')','IFNULL(tb_caseendbooks_decideDate,\\\'\\\')',
      'IFNULL(tb_cases_now_end,\\\'\\\')'
    ]
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    #c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3"
    c="tb_cases_state>=4"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List4,"select distinct tb_cases_recevice_code,tb_cases_state,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_caseendbooks_decideDate,tb_cases_now_end from v_case_query1_list4s  where #{c} group by tb_cases_recevice_code order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List4.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list4s where #{c} group by tb_cases_recevice_code")
  end

  #结案情况查询视图
  def list_35
    @arbitmantype={"0001"=>"独","0002"=>"首","0003"=>"申","0004"=>"被"}
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_35"
    @hant_search_1=[['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]],['char','tb_cases_general_code','总案号','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['date','tb_cases_nowdate','立案时间','text',[]],
      ['date','tb_caseendbooks_decideDate','结案时间','text',[]],
      ['char','IFNULL(tb_repairarbits_used,\\\'\\\')','有无补充','select',[["Y","有补充"]]],
      ['char','IFNULL(tb_addarbits_used,\\\'\\\')','有无裁决书更正','select',[["Y","有"]]],
      ['char','IFNULL(tb_caseendbooks_endStyle,\\\'\\\')','结案方式','select',TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_runstyle,\\\'\\\')','执行情况','select',TbDictionary.find(:all,:conditions=>"typ_code='9014' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(tb_cases_isback,\\\'\\\')','是否申请撤销','select',[["1","是"]]],
      ['char','IFNULL(tb_cases_isunrun,\\\'\\\')','是否申请不予执行','select',[["1","是"]]],
      ['number','IFNULL(tb_cases_state,\\\'\\\')','重新仲裁','select',[[-1,"是"]]],
      ['char','IFNULL(tb_casedelays_used,\\\'\\\')','有无延长审限','select',[["Y","有"]]],
    ]
    @hant_search_1_list=['tb_cases_end_code','tb_cases_recevice_code','tb_cases_general_code','tb_cases_case_code','tb_cases_nowdate','tb_caseendbooks_decideDate']
    @order=params[:order]
    #按结案号数字部分降序排列 right(left(tb_caseendbooks_arbitBookNum,10),7)。由于历史数据原因，改为按案号数字部分排列
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    c="tb_cases_state>=4 "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end

    @case_pages,@case=paginate_by_sql(VCaseQuery1List5,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_caseendbooks_decideDate,tb_caseendbooks_arbitBookNum,tb_caseendbooks_endStyle,tb_cases_clerk from v_case_query1_list5s  where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List5.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list5s where #{c}")
  end

  #申请人、代理人信息查询
  def list_38
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @sss={1=>"申请人",2=>"被申请人"}
    @hant_search_1_page_name="list_38"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partytype,\\\'\\\')','申(被)请人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_commissary,\\\'\\\')','法定代表人','text',[]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','申(被)请人名称','text',[]],
      ['char','IFNULL(tb_parties_addr,\\\'\\\')','申(被)请人地址','text',[]],
      ['char','IFNULL(tb_parties_postcode,\\\'\\\')','申(被)请人邮政编码','text',[]],
      ['char','IFNULL(tb_parties_tel,\\\'\\\')','申(被)请人电话','text',[]],
      ['char','IFNULL(tb_parties_email,\\\'\\\')','申(被)Email','text',[]],
      ['char','IFNULL(tb_agents_name,\\\'\\\')','代理人名称','text',[]],
      ['char','IFNULL(tb_agents_company,\\\'\\\')','所在单位','text',[]],
      ['char','IFNULL(tb_agents_addr,\\\'\\\')','代理人地址','text',[]],
      ['char','IFNULL(tb_agents_postcode,\\\'\\\')','代理人邮政编码','text',[]],
      ['char','IFNULL(tb_agents_tel,\\\'\\\')','代理人电话','text',[]],
      ['char','IFNULL(tb_agents_email,\\\'\\\')','代理人Email','text',[]],
      ['char','IFNULL(tb_agents_mobiletel,\\\'\\\')','代理人手机','text',[]],
    ]
    @hant_search_1_list=['IFNULL(tb_parties_commissary,\\\'\\\')',
      'IFNULL(tb_parties_commissary,\\\'\\\')','IFNULL(tb_parties_partyname,\\\'\\\')','IFNULL(tb_parties_addr,\\\'\\\')','IFNULL(tb_parties_postcode,\\\'\\\')',
      'IFNULL(tb_parties_postcode,\\\'\\\')','IFNULL(tb_parties_tel,\\\'\\\')','IFNULL(tb_parties_email,\\\'\\\')','IFNULL(tb_agents_name,\\\'\\\')','IFNULL(tb_agents_company,\\\'\\\')',
      'IFNULL(tb_agents_addr,\\\'\\\')','IFNULL(tb_agents_postcode,\\\'\\\')','IFNULL(tb_agents_tel,\\\'\\\')','IFNULL(tb_agents_email,\\\'\\\')','IFNULL(tb_agents_mobiletel,\\\'\\\')'
    ]
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
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3 and tb_cases_state<>100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:v_case_query1_list8s,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @c_l = VCaseQuery1List8.find_by_sql("select * from v_case_query1_list8s where #{c}")
  end

  #申请人、代理人信息查询,excel调用导出
  def list_38_remote
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @sss={1=>"申请人",2=>"被申请人"}
    
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) desc"
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
    if params[:from].blank?
      c="tb_cases_state>=4 and tb_cases_clerk='#{session[:user_code]}'"
    else
      c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3 and tb_cases_state<>100"
    end
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @c_l = VCaseQuery1List8.find_by_sql("select * from v_case_query1_list8s where #{c}")
  end
  
  #前台基本情况查询
  def list_101
    @dat1 = Time.now.months_ago(2).at_beginning_of_month.to_date
    @dat2 = Time.now.at_end_of_month.to_date
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"归档"}
    @hant_search_1_page_name="list_101"
    @hant_search_1=[
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['date','IFNULL(tb_cases_nowdate,\\\'\\\')','立案时间 开始','text',[],@dat1],
      ['date','IFNULL(tb_cases_nowdate ,\\\'\\\')','立案时间 结束','text',[],@dat2],
      ['char','tb_cases_case_code','受案号','text',[]],
      ['char','tb_cases_end_code','结案号','text',[]]
    ]
    @hant_search_1_list=['IFNULL(tb_parties_partyname,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=9000000
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @hant_search_1_r=params[:hant_search_1_r]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
      c="tb_cases_state<>2 and tb_cases_state<>3  and tb_cases_nowdate>'#{@dat1}' and  tb_cases_nowdate<'#{@dat2}'"
    else
      c="tb_cases_state<>2 and tb_cases_state<>3 "
      @search_condit= " and " + hant_search_1_word
    end    
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit    
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code,tb_cases_nowdate,tb_cases_clerk,tb_cases_clerk_2,tb_cases_end_code from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
    
  #咨询、立案阶段的统计
  def case_now_total
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil
      @date1 = Time.now.at_beginning_of_year.to_date
    end
    if @date2==nil
      @date2 = Time.now.to_date
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="users.name asc"
    end
    c = "(tb_cases.state != -2) and tb_cases.clerk_2=users.code and  tb_cases.used='Y' and users.used='Y' and  tb_cases.receivedate>='#{@date1}' and tb_cases.receivedate<='#{@date2}'"
    @case=TbCase.find_by_sql("select users.code as users_code,users.name as clerk_name,count(users.code) as num from tb_cases,users where #{c} group by users.code order by #{@order}")
  end
  #每个助理的咨询立案信息情况
  def list_everyone
    @date1=params[:date1]
    @date2=params[:date2]
    @agent_typ={1=>"申请方",2=>"被申请方"}
    @state={4=>"立案",5=>"组庭",6=>"开庭"}
    @hant_search_1_page_name="case_now_clerk"
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate,general_code asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20000
    end
    c ="(tb_cases.state != -2)  and tb_cases.clerk_2=? and tb_cases.used='Y' and tb_cases.receivedate>=? and tb_cases.receivedate<=?"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>[c,params[:user_code],params[:date1],params[:date2]],:per_page=>@page_lines.to_i)
  end
  def expert_meeting_query
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="expert_meeting_query"
    @hant_search_1=[
      ['char','c.case_code','立案号','text',[]],
      ['char','c.end_code','结案号','text',[]],
      ['date','c.nowdate','立案日期','text',[]],
      ['char','c.aribitprotprog_num','仲裁协议类型','select',TbDictionary.find(:all,:conditions=>"typ_code='0003' and  state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['number','c.state','案件状态','select',[[1,"咨询"],[2,"历史"],[3,"不受理"],[4,"立案"],[5,"组庭"],[6,"开庭"],[-1,"重审"],[100,"终审"],[150,"归档申请"],[200,"已归档"]]],
      ['char','c.drafting_party','仲裁条款起草方','text',[]],
      ['char','c.casetype_num','案件争议金额大分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','c.casetype_num2','案件争议金额小分类','select',TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','IFNULL(c.arbitprot,\\\'\\\')','仲裁协议内容','text',[]],
      ['number','IFNULL(c.amount,0)','总争议金额','text',[]],
      ['number','IFNULL(c.amount_1,0)','本请求争议金额','text',[]],
      ['number','IFNULL(c.amount_2,0)','反请求争议金额','text',[]]
    ]
    @hant_search_1_list=['c.case_code']
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(c.case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c="1=1 "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    s=""
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,["select c.state,c.recevice_code,c.general_code,c.case_code, c.end_code,c.clerk,c.amount,c.amount_1,c.amount_2,count(e.id) as n from tb_cases as c inner join expert_meetings
 as e on c.used='Y' and e.used='Y' and c.recevice_code=e.recevice_code   where #{c} group by c.recevice_code order by ?",@order],@page_lines.to_i)
    @case_n=TbCase.find_by_sql("select count(distinct c.recevice_code) as n from tb_cases as c inner join expert_meetings 
 as e on c.used='Y' and e.used='Y' and c.recevice_code=e.recevice_code   where #{c}")
  end
  def expert_meeting_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code=? and used='Y' and id=?"
    @expert_meetings =ExpertMeeting.find(:all,:conditions =>[c,params[:recevice_code],params[:e_id]])
  end
  
  def list_50
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list_50"
    @hant_search_1=[
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_end_code','结案号','text',[]],
      ['date','tb_cases_nowdate','立案日期','text',[]],
      ['number','IFNULL(tb_cases_amount,0)','总争议金额','text',[]],
      ['char','tb_parties_partytype','当事人类型','select',[[1,"申请人"],[2,"被申请人"]]],
      ['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]]
    ]
    @hant_search_1_list=['tb_cases_case_code',
      'tb_cases_end_code','tb_cases_nowdate','IFNULL(tb_cases_amount,0)','tb_parties_partytype',
      'IFNULL(tb_parties_partyname,\\\'\\\')']
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
    @hant_search_1_text=params[:hant_search_1_text]
    @hant_search_1_r=params[:hant_search_1_r]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    
    c=" tb_cases_end_code<>'' and tb_cases_caseendbook_id_first is not null and tb_cases_state >= '100' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_amount,tb_cases_amount_1,tb_cases_amount_2   from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=VCaseQuery1List1.find_by_sql("select distinct tb_cases_recevice_code from v_case_query1_list1s where #{c}")
  end
  #
  def marke_2
    #    @tbmark=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y' and data_parent=''"])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=@case.case_code
    @user=User.find(:first,:conditions=>["code=?",session[:user_code]]).name
    arr_date = Date.today.to_s.split("-")
    arr_date[1]=arr_date[1].to_i.to_s
    arr_date[2]=arr_date[2].to_i.to_s
    @send_time=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    @casearbitman=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code,tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmantype_name from tb_casearbitmen,tb_arbitmen,tb_dictionaries where tb_casearbitmen.used='Y' and tb_dictionaries.typ_code='0014' and tb_casearbitmen.recevice_code=?  and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.arbitmantype=tb_dictionaries.data_val order by tb_casearbitmen.arbitmantype",params[:recevice_code]])
    @tbmark1=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y'"])
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
