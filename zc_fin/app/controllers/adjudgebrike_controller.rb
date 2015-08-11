class AdjudgebrikeController < ApplicationController
  def adjudgebrike_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @state={0=>"恢复",1=>"中止"}
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @adjudgebrike=TbAdjudgebrike.find(:all,:order=>'id',:conditions=>c)
    end
  end
  #    def adjudgebrike_list_update
  #      @case=TbCase.find_by_recevice_code(session[:recevice_code])
  #      if @case.update_attributes(params[:case])
  #        flash[:notice]="状态修改成功"
  #        redirect_to :action=>"adjudgebrike_list"
  #      else
  #        flash[:notice]="状态修改失败"
  #        render :action=>"adjudgebrike_list"
  #      end
  #    end
  #添加仲裁中止
  def adjudgebrike_new
    @adjudgebrike=TbAdjudgebrike.new()
    @adjudgebrike.end_date=Date.today
  end

  def adjudgebrike_create
    @adjudgebrike=TbAdjudgebrike.new(params[:adjudgebrike])
    @adjudgebrike.recevice_code=session[:recevice_code]
    @adjudgebrike.case_code=session[:case_code]
    @adjudgebrike.general_code=session[:general_code]
    @adjudgebrike.u=session[:user_code]
    @adjudgebrike.u_t=Time.now()
    @adjudgebrike.stoped=1   #中止
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case.stoped=1
    if @adjudgebrike.save and @case.save
      flash[:notice]="创建成功"
      redirect_to :action=>"adjudgebrike_list"
    else
      render :action=>"adjudgebrike_new"
    end
  end
  #修改仲裁中止
  def adjudgebrike_edit
    #    @state={0=>"恢复",1=>"中止"}
    @adjudgebrike=TbAdjudgebrike.find(params[:id])
  end

  def adjudgebrike_update
    @adjudgebrike=TbAdjudgebrike.find(params[:id])
    @adjudgebrike.u=session[:user_code]
    @adjudgebrike.u_t=Time.now()    
    if @adjudgebrike.update_attributes(params[:adjudgebrike])
      flash[:notice]="修改成功"
      redirect_to :action=>"adjudgebrike_list"
    else
      flash[:notice]="修改失败"
      render :action=>"adjudgebrike_edit",:id=>params[:id]
    end
  end
  def set_up
    @adjudgebrike=TbAdjudgebrike.find(params[:id])
    @adjudgebrike.start_date=Date.today
  end
  def adjudgebrike_set
    @adjudgebrike=TbAdjudgebrike.find(params[:id])
    @adjudgebrike.stoped=0
    @adjudgebrike.u=session[:user_code]
    @adjudgebrike.u_t=Time.now()
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case.stoped=0
    if @adjudgebrike.update_attributes(params[:adjudgebrike]) and @case.save
      flash[:notice]="恢复成功"
      redirect_to :action=>"adjudgebrike_list"
    end
  end
  #删除仲裁中止
  def adjudgebrike_delete
    @adjudgebrike=TbAdjudgebrike.find(params[:id])
    @adjudgebrike.used="N"
    @adjudgebrike.u=session[:user_code]
    @adjudgebrike.u_t=Time.now()
    if @adjudgebrike.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"adjudgebrike_list"
  end
  
end
