class FilingCheckController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','end_code','结案号','text',[]],['char','case_code','立案号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
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
    c="used='Y' and state=200"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  
  def subm_text
    @case=TbCase.find(params[:id])
  end
  def subm
    @case=TbCase.find(params[:id])
    if@case.state==200
      if TbCaseFlow.check(@case.recevice_code,'0009')
         f=TbCaseFlow.add_flow(@case.recevice_code,'0009')
         if f!=0
           @case.state=f
         end 
         @case.file_up_u=session[:user_code]
         @case.file_up_t=Time.now
         if @case.update_attributes(params[:case]) 
            flash[:notice]="咨询号：#{@case.recevice_code}案件归档成功"
         else
            flash[:notice]="咨询号：#{@case.recevice_code}案件归档失败"
         end
         redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
       else
            render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
       end
    end
  end
end
