=begin
创建人：聂灵灵
创建时间：2009-7-1
类的描述：办理案件下案件重审信息。
页面：
案件重审信息列表:/rehearing/list
=end
class RehearingController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="general_code desc"
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
    c="used='Y' and state>=100 and state<=150 and clerk='#{session[:user_code]}' and caseendbook_id_first is not null"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>'recevice_code desc',:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def rehear
    @case = TbCase.find(params[:id])
  end
  #重新审理此案件:原有案件状态改变为重审，添加复制的新记录在相应表中
  def final
    @case1=TbCase.find_by_recevice_code(params[:recevice_code])
    @case1.state=-1
    @case1.used='Y'
    @recevice_code = @case1.recevice_code + '_R'    
    @general_code = @case1.general_code
    if @general_code==nil || @general_code==""
      @general_code==""
    else
      @general_code = @general_code + '_R'
    end
    @case_code = @case1.case_code
    if @case_code==nil || @case_code==""
      @case_code==""
    else
      @case_code = @case_code + '_R'
    end
    
    begin
      #复制案件基本信息
    @case=TbCase.find_by_sql("insert into tb_cases (used,state,recevice_code,general_code,
     case_code,clerk,casetype_num,casetype_num2,case_type1,aribitprog_num,aribitprotprog_num,agent,casereason,
     arbitprot,receivedate,recevice_code_limit_dat,amount,orgstyle,accepttime,aribittype,terms_drafting_party,special,
     nowdate,limit_dat,finally_limit_dat,re_code)
     select used,4,'#{@recevice_code}','#{@general_code}','#{@case_code}',clerk,casetype_num,
     casetype_num2,case_type1,aribitprog_num,aribitprotprog_num,agent,casereason,arbitprot,receivedate,recevice_code_limit_dat,amount,
     orgstyle,accepttime,aribittype,terms_drafting_party,special,nowdate,limit_dat,finally_limit_dat,recevice_code
        from tb_cases where tb_cases.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    begin
      #复制当事人     
      @party=TbParty.find_by_sql("insert into tb_parties (used,recevice_code,general_code,case_code,
     partytype,commissary,isperson,partyname,mobiletel,email,idnum,addr,tel,postcode,post_tel_code,
     profession,area,u,u_t)
     select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',
     partytype,commissary,isperson,partyname,mobiletel,email,idnum,addr,tel,postcode,post_tel_code,
     profession,area,u,u_t
        from tb_parties where tb_parties.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #复制当事人代理人
    begin
      @agent1=TbAgent.find_by_sql("insert into tb_agents (used,recevice_code,general_code,case_code,
    partytype,party_id,name,status,duty,postcode,addr,company,email,tel,u,u_t)
    select used ,'#{@recevice_code}','#{@general_code}','#{@case_code}',partytype,
    party_id,name,status,duty,postcode,addr,company,email,tel,u,u_t
        from tb_agents where tb_agents.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #复制申请人和被申请人仲裁请求及事实理由
    begin
      @partyrequest=TbPartyrequest.find_by_sql("insert into tb_partyrequests (used,recevice_code,
    general_code,case_code,partytype,party_id,requestdate,rsendstyle,rsenddate,asendstyle,request_text,
    factreason,u,u_t)
    select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',partytype,
    party_id,requestdate,rsendstyle,rsenddate,asendstyle,request_text,factreason,u,u_t
        from tb_partyrequests where tb_partyrequests.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #复制证人
    begin
      @witne=TbWitne.find_by_sql("insert into tb_witnes (used,recevice_code,general_code,case_code,
    partytype,party_id,name,duty,company,postcode,tel,addr,email,mobiletel,u,u_t)
    select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',partytype,
    party_id,name,duty,company,postcode,tel,addr,email,mobiletel,u,u_t
        from tb_witnes where tb_witnes.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #复制反请求信息
    begin
      @answer=TbPartyanswer.find_by_sql("insert into tb_partyanswers (used,recevice_code,
    general_code,case_code,partytype,party_id,receivedate,sendstyle,asenddate,asendstyle,answerbook,u,u_t)
    select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',partytype,
    party_id,receivedate,sendstyle,asenddate,asendstyle,answerbook,u,u_t 
        from tb_partyanswers where tb_partyanswers.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #复制保全管理
    begin
      @save=TbSave.find_by_sql("insert into tb_saves (used,recevice_code,general_code,case_code,typed,
    request_man,save_object,save_money,yard_area,save_yard,start_date,end_date,send_time,yard_arbitcon,
    u,u_t)
    select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',
    typed,request_man,save_object,save_money,yard_area,save_yard,start_date,end_date,send_time,
    yard_arbitcon,u,u_t
        from tb_saves where tb_saves.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    
    #复制案件争议金额
    begin
        @save=TbCaseAmount.find_by_sql("insert into tb_case_amounts (used,recevice_code,general_code,case_code,partytype,
    typ,amount_typ,dt,currency,f_money,rate,rmb_money,remark,u,u_t)
    select used,'#{@recevice_code}','#{@general_code}','#{@case_code}',
    partytype,typ,amount_typ,dt,currency,f_money,rate,rmb_money,remark,u,u_t
        from tb_case_amounts where tb_case_amounts.recevice_code='#{@case1.recevice_code}'")
    rescue

    end
    #修改减交信息
    TbReduction.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改缓交信息
    TbDeferral.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    
    #修改案件应收费用信息表
    TbShouldCharge.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改收款信息
    TbCharge.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改收款记录对照信息明细表
    TbChargeCorr.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改代收支出费用支出明细
    TbExpendDetail.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改案件仲裁员支出
    TbArbitcourtSpend.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改案件其它支出信息表
    TbOtherSpend.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改案件其它支出信息表
    TbShouldRefund.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    
    #修改报酬表，庭审和调解
    TbRemuneration1.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    #修改报酬表，阅卷
    TbRemuneration2.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改报酬表,裁决书 和管辖决定起草
    TbRemuneration4.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    #修改校核工作信息
    TbRemuneration5.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改仲裁员仲裁费
    TbRemuneration3.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    #修改助理仲裁费
    TbRemuneration6.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改案件工作人员报酬奖惩比例信息表
    TbBonusPenalty.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    #修改案件工作人员报酬扣减、奖励信息表
    TbDeduction.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    #修改报酬发放信息表
    TbExtend.update_all("recevice_code='#{@recevice_code}',case_code='#{@case_code}',general_code='#{@general_code}'","recevice_code='#{@case1.recevice_code}'")	
    
    #修改发文信息表
    TbDoc.update_all("recevice_code='#{@recevice_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改文书修改情况记录信息表
    TbDocChange.update_all("recevice_code='#{@recevice_code}'","recevice_code='#{@case1.recevice_code}'")
    #修改文书审批信息表
    TbDocApproval.update_all("recevice_code='#{@recevice_code}'","recevice_code='#{@case1.recevice_code}'")
    
    TbCaseFlow.add_flow(@recevice_code,'0001')
    TbCaseFlow.add_flow(@recevice_code,'0004')
    if @case1.save   
      flash[:notice]="操作成功"
      redirect_to :action=>"list"
    end

  end
end
