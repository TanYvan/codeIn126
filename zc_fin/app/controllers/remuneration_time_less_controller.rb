class RemunerationTimeLessController < ApplicationController
 
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
    end
  end
  
  def update
    @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
    @case.u=session[:user_code]
    @case.u_t=Time.now()
    if @case.update_attributes(params[:case])
      flash[:notice]="修改成功"
    else
      flash[:notice]="修改失败"
    end
    redirect_to :action=>"list"
  end

  def update_2
    @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
    @case.u=session[:user_code]
    @case.u_t=Time.now()
    if @case.update_attributes(params[:case])
      flash[:notice]="修改成功"
    else
      flash[:notice]="修改失败"
    end
    redirect_to :action=>"list_2"
  end
  
end
