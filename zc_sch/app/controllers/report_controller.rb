=begin
创建人：聂灵灵
创建时间：2009-5-12
类的描述：此控制器是处理发文呈报页面提交的信息。首先判断是否有案件，若无可以选择案件，并在相应案件下创建发文呈报信息及修改删除发文呈报信息。
页面：
发文呈报信息列表:/report/report_list
创建发文呈报信息：/report/report_new
修改发文呈报信息：/report/report_edit
=end
class ReportController < ApplicationController

  def report_list
      c="caseend_book_id = #{params[:caseend_book_id]} and used='Y'"
      @report_pages,@report=paginate(:tb_reports,:order=>'id',:conditions=>c)
  end

  def report_new
    @report=TbReport.new()
    @report.submitDate=Date.today
  end

  def report_create
     @report=TbReport.new(params[:report])
     @report.caseNo=session[:recevice_code]
     @report.recevice_code=session[:recevice_code]
     @report.case_code=session[:case_code]
     @report.general_code=session[:general_code]
     @report.caseend_book_id=params[:caseend_book_id]
     @report.u=session[:user_code]
     @report.u_t=Time.now()
     if @report.save
        flash[:notice]="创建成功"
        redirect_to :action=>"report_list",:caseend_book_id=>params[:caseend_book_id]
     else
        render :action=>"report_new",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def report_edit
     @report=TbReport.find(params[:id])
  end

  def report_update
     @report=TbReport.find(params[:id])
     @report.u=session[:user_code]
     @report.u_t=Time.now()
     if @report.update_attributes(params[:report])
        flash[:notice]="修改成功"
        redirect_to :action=>"report_list",:caseend_book_id=>params[:caseend_book_id]
     else
        flash[:notice]="修改失败"
        render :action=>"report_edit",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def report_delete
     @report=TbReport.find(params[:id])
     @report.used="N"
     @report.u=session[:user_code]
     @report.u_t=Time.now()
     if @report.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"report_list",:caseend_book_id=>params[:caseend_book_id]
  end
end
