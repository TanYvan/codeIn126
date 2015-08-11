class ClerkChangeController < ApplicationController
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @change=TbClerkchange.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}'",:order=>"id") 
    end
  end
   
  def new
#    @clerks=User.find_by_sql("select code,name from users where used='Y' and code in (select user_code from user_duties where duty_code='0003') order by name")
    @change=TbClerkchange.new()
    @change.changedate = Date.today
  end
   
  def create
     @change=TbClerkchange.new(params[:change])
     @change.recevice_code=session[:recevice_code]
     @change.case_code=session[:case_code]
     @change.general_code=session[:general_code]
     @change.recevice_code=session[:recevice_code]
     @change.beforeclerk=TbCase.find_by_recevice_code(session[:recevice_code]).clerk
     @change.u=session[:user_code]
     @change.t=Time.now()
     
     @case=TbCase.find_by_case_code(session[:case_code])
     @case.clerk=@change.afterclerk
     if @change.save and @case.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
        flash[:notice]="创建失败"
        render :action=>"list"
     end
     
  end
end
