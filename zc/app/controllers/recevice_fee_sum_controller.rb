class ReceviceFeeSumController < ApplicationController
  def list  
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_cases_recevice_code','咨询流水号','text',[]],['date','tb_cases_ReceiveDate','咨询日期','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['number','IFNULL(tb_cases_amount,0)','总争议金额','text',[]],['number','tb_cases_m_rmb_money','申请人应收费','text',[]],['number','tb_cases_m_rmb_money_2','被申请人应收费','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="(tb_cases_state=1 ) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @hant_search_1_text=params[:hant_search_1_text]
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_amount,tb_cases_agent from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end

  def list_1
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_week.ago(3600 * 24 * 7).to_date
    end
    if @d2==nil
      @d2=Time.now.at_beginning_of_week.ago(3600 * 24 * 3).to_date
    end
    @order = params[:order]
    if @order.blank?
      @order="tb_cases.amount asc"
    end

    @case=TbCase.find(:all, :joins=>"inner join tb_parties as p on p.recevice_code=tb_cases.recevice_code and p.used='Y' and tb_cases.used='Y'" , :conditions=>["tb_cases.state>=1 and tb_cases.state<>2 and tb_cases.state<>3  and tb_cases.ReceiveDate>=? and ReceiveDate<=?",@d1,@d2], :select=>"distinct tb_cases.recevice_code,tb_cases.receivedate,tb_cases.amount,tb_cases.clerk_2,tb_cases.clerk,tb_cases.agent,tb_cases.dispute_type", :order => @order)
  end

end
