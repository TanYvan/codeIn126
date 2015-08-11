class FileSubmitController < ApplicationController
  
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','end_code','结案号','text',[]],['char','case_code','立案号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate,general_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
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
    c="used='Y' and state>=100 and state<=150 and clerk='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def subm_text
    @case=TbCase.find(params[:id])
    if @case.caseendbook_id_last!=nil
      typ=TbCaseendbook.find(@case.caseendbook_id_last).endStyle
      if typ=='0003'
        @case.file_typ='0001'
      else
        @case.file_typ='0002'
      end
    end
    @case.file_num_1=0
    @case.file_num_2=0
    @case.file_num_3=0
  end
  def subm
    @case=TbCase.find(params[:id])
    if @case.clerk==session[:user_code] and @case.state>=100 and @case.state<150
      if TbCaseFlow.check(@case.recevice_code,'0008')
         f=TbCaseFlow.add_flow(@case.recevice_code,'0008')
         if f!=0
           @case.state=f
         end 
         @case.file_submit_u=session[:user_code]
         @case.file_submit_t=Time.now
         if @case.update_attributes(params[:case]) 
            flash[:notice]="提交成功"
         else
            flash[:notice]="提交失败"
         end
         redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
       else
            render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
       end
    end
  end
  
  def retur
    @case=TbCase.find(params[:id])
    if @case.clerk==session[:user_code] and  @case.state>=150 and @case.state<200
      f=TbCaseFlow.del_flow(@case.recevice_code,'0008')
      if f!=0
        @case.state=f
      end
      @case.file_submit_remark=""
      @case.file_submit_u=""
      if @case.save
        flash[:notice]="召回成功"
      else
        flash[:notice]="召回失败"
      end
      redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end
  
end
