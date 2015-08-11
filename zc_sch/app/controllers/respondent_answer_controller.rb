=begin
创建人：聂灵灵
创建时间：2009-5-11
类的描述：此控制器是处理被申请人反请求信息维护----被申请人证人可以选择案件，并创建反请求信息及修改删除反请求信息。
页面：
被申请人反请求信息信息列表:/respondent_answer/answer_list
创建反请求信息信息：/respondent_answer/answer_new
修改反请求信息信息：/respondent_answer/answer_edit
=end
class RespondentAnswerController < ApplicationController

  def answer_list
    @isperson={1=>"是",2=>"否"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'"
      @answer=TbPartyanswer.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def answer_new
    @answer=TbPartyanswer.new()
    @answer.receivedate=Date.today
    @answer.asenddate=Date.today
  end

  def answer_create
     @answer=TbPartyanswer.new(params[:answer])
     @answer.partytype=2
     @answer.recevice_code=session[:recevice_code]
     @answer.case_code=session[:case_code]
     @answer.general_code=session[:general_code]
     @answer.u=session[:user_code]
     @answer.u_t=Time.now()
     if @answer.save
        flash[:notice]="创建成功"
        redirect_to :action=>"answer_list"
     else
        flash[:notice]="创建失败"
        render :action=>"answer_new"
     end

  end

  def answer_edit
     @answer=TbPartyanswer.find(params[:id])
  end

  def answer_update
     @answer=TbPartyanswer.find(params[:id])
     @answer.u=session[:user_code]
     @answer.u_t=Time.now()
     if @answer.update_attributes(params[:answer])
        flash[:notice]="修改成功"
        redirect_to :action=>"answer_list"
     else
	flash[:notice]="修改失败"
        render :action=>"answer_edit",:id=>params[:id]
     end

  end

  def answer_delete
     @answer=TbPartyanswer.find(params[:id])
     @answer.used="N"
     @answer.u=session[:user_code]
     @answer.u_t=Time.now()
     if @answer.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"answer_list"
  end
end
