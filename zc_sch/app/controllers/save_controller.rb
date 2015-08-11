class SaveController < ApplicationController

  def save_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      #:singular_name => "tb_save",:class_name => "TbSave"  加此标志以防冲突  niell 2009.5.5
      @save=TbSave.find(:all,:order=>'id',:conditions=>c)
    end
  end
  #创建保全管理
  def save_new
    @save=TbSave.new()
    @save.start_date=Date.today
    @save.end_date=Date.today
    @save.send_time=Date.today
  end

  def save_create
    @save=TbSave.new(params[:save])
    @save.request_man= params[:condi]
    @save.recevice_code=session[:recevice_code]
    @save.case_code=session[:case_code]
    @save.general_code=session[:general_code]
    @save.u=session[:user_code]
    @save.u_t=Time.now()
    if @save.save
      flash[:notice]="创建成功"
      redirect_to :action=>"save_list"
    else
      flash[:notice]="创建失败"
      render :action=>"save_new"
    end
  end
  #修改保全管理
  def save_edit
    @save=TbSave.find(params[:id])
  end

  def save_update
    @save=TbSave.find(params[:id])
    @save.u=session[:user_code]
    @save.u_t=Time.now()
    @save.request_man= params[:condi]
    if @save.update_attributes(params[:save])
      flash[:notice]="修改成功"
      redirect_to :action=>"save_list"
    else
      flash[:notice]="修改失败"
      render :action=>"save_edit",:id=>params[:id]
    end
  end
  #删除保全管理
  def save_delete
    @save=TbSave.find(params[:id])
    @save.used="N"
    @save.u=session[:user_code]
    @save.u_t=Time.now()
    if @save.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"save_list"
  end

end
