class CaseAttTimeManagerController < ApplicationController
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @case_time=CaseAttTimeManager.find(:all, :conditions=>["recevice_code=? and used='Y'", session[:recevice_code]], :order=>"id")
    end
  end

  #修改保全管理
  def edit
    @att_time=CaseAttTimeManager.find(params[:id])
  end

  def update
    @att_time=CaseAttTimeManager.find(params[:id])
    @att_time.u=session[:user_code]
    @att_time.u_t=Time.now()
    if @att_time.recevice_code==session[:recevice_code]
      if @att_time.update_attributes(params[:att_time])
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="修改失败"
        redirect_to :action=>"list"
      end
    else
      flash[:notice]="修改失败"
      redirect_to :action=>"list"
    end
  end
  
end
