class EndRecallController < ApplicationController
  
  def case_list  
    @state={4=>'立案',5=>'组庭',6=>'开庭',100=>'终审'}
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_parties_partyname','当事人名称','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]]
    ]
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
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="(tb_cases_state=100)"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_recevice_code,tb_cases_state,tb_cases_general_code,tb_cases_receivedate,tb_cases_nowdate,tb_cases_id,tb_cases_case_code,tb_cases_clerk from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def recall_do
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    if @case.state==100
      f=TbCaseFlow.del_flow(@case.recevice_code,'0007')
      if f!=0
        @case.state=f
      end
      if @case.update_attributes(params[:case]) 
        flash[:notice]="咨询流水号:#{@case.recevice_code}。终审招回成功"
      else
        flash[:notice]="咨询流水号:#{@case.recevice_code}。终审招回失败"
      end
    end
    redirect_to :action=>"case_list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
  end
  
end
