=begin
创建人：聂灵灵
创建时间：2009-7-28
类的描述：此控制器是处理裁决异议信息维护。
页面：
裁决异议信息列表:/opposition/opposition_list
创建裁决异议信息：/opposition/opposition_new
修改裁决异议信息：/opposition/opposition_edit
=end
class OppositionController < ApplicationController
  def opposition_list
    c="caseend_book_id = #{params[:caseend_book_id]} and used='Y'"
    @opposition_pages,@opposition=paginate(:tb_oppositions,:order=>'id',:conditions=>c)
  end

  def opposition_new
    @opposition=TbOpposition.new()
    @opposition.present_date=Date.today
    @opposition.advance_date=Date.today
    @opposition.reply_time=Date.today
  end

  def opposition_create
    @opposition=TbOpposition.new(params[:opposition])
    @opposition.recevice_code=session[:recevice_code]
    @opposition.case_code=session[:case_code]
    @opposition.general_code=session[:general_code]
    @opposition.caseend_book_id=params[:caseend_book_id]
    @opposition.u=session[:user_code]
    @opposition.u_t=Time.now()
    if @opposition.save
      flash[:notice]="创建成功"
      redirect_to :action=>"opposition_list",:caseend_book_id=>params[:caseend_book_id]
    else
      render :action=>"opposition_new",:caseend_book_id=>params[:caseend_book_id]
    end
  end

  def opposition_edit
    @opposition=TbOpposition.find(params[:id])
  end

  def opposition_update
    @opposition=TbOpposition.find(params[:id])
    @opposition.u=session[:user_code]
    @opposition.u_t=Time.now()
    if @opposition.update_attributes(params[:opposition])
      flash[:notice]="修改成功"
      redirect_to :action=>"opposition_list",:caseend_book_id=>params[:caseend_book_id]
    else
      flash[:notice]="修改失败"
      render :action=>"opposition_edit",:caseend_book_id=>params[:caseend_book_id]
    end
  end

  def opposition_delete
    @opposition=TbOpposition.find(params[:id])
    @opposition.used="N"
    @opposition.u=session[:user_code]
    @opposition.u_t=Time.now()
    if @opposition.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"opposition_list",:caseend_book_id=>params[:caseend_book_id]
  end
end