class CaseTransferController < ApplicationController
  
  def case_list  
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
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
    c="used='Y'  and (state>=4 or state=-1) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def transfer_text
    @case=TbCase.find(params[:id])
  end
  
  def transfer
    @case=TbCase.find(params[:id])
      @case.state=-2
      @case.used='N'
      @case.transfer_u=session[:user_code]
      @case.transfer_t=Time.now
      if @case.update_attributes(params[:case]) 
#        if @case.case_code!='' and @case.case_code!=nil
#          cod=BlankCode.new()
#          cod.used='Y'
#          cod.typ='0001'
#          cod.code=@case.case_code.last(7)
#          cod.save
#        end
#        if @case.general_code!='' and @case.general_code!=nil
#          cod2=BlankCode.new()
#          cod2.used='Y'
#          cod2.typ='0002'
#          cod2.code=@case.general_code
#          cod2.save
#        end
        flash[:notice]="咨询流水号:#{@case.recevice_code}。案件删除成功"
      else
        flash[:notice]="转会失败"
      end
      redirect_to :action=>"case_list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
  end
  
end
