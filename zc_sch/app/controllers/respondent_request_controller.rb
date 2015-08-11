=begin
创建人：聂灵灵
创建时间：2009-5-11
类的描述：此控制器是处理被申请人的信息----被申请人可以选择案件，并创建被申请人信息及修改删除被申请人信息。
页面：
被申请人信息列表:/respondent_request/request_list
创建被申请人信息：/respondent_request/request_new
修改被申请人信息：/respondent_request/request_edit
=end
class RespondentRequestController < ApplicationController

  def request_list
    @isperson={1=>"是",2=>"否"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'"
      @request=TbPartyrequest.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def request_new
    @request=TbPartyrequest.new()
    @request.requestdate=Date.today
    @request.rsenddate=Date.today
  end

  def request_create
     @request=TbPartyrequest.new(params[:request])
     @request.partytype=2
     @request.recevice_code=session[:recevice_code]
     @request.case_code=session[:case_code]
     @request.general_code=session[:general_code]
     @request.u=session[:user_code]
     @request.u_t=Time.now()
     if @request.save
        flash[:notice]="创建成功"
        redirect_to :action=>"request_list"
     else
        flash[:notice]="创建失败"
        render :action=>"request_new"
     end
  end

  def request_edit
     @request=TbPartyrequest.find(params[:id])
  end

  def request_update
     @request=TbPartyrequest.find(params[:id])
     @request.u=session[:user_code]
     @request.u_t=Time.now()
     if @request.update_attributes(params[:request])
        flash[:notice]="修改成功"
        redirect_to :action=>"request_list"
     else
	flash[:notice]="修改失败"
        render :action=>"request_edit",:id=>params[:id]
     end

  end

  def request_delete
     @request=TbPartyrequest.find(params[:id])
     @request.used="N"
     @request.u=session[:user_code]
     @request.u_t=Time.now()
     if @request.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"request_list"
  end
end
