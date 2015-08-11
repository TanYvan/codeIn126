class CaseMatterController < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @matter=CaseMatter.find(:all,:conditions=>c,:order=>'id')
    end
  end

  def new
    @matter=CaseMatter.new()
  end

  def create
     @matter=CaseMatter.new(params[:matter])
     @matter.recevice_code = session[:recevice_code]
     @matter.u=session[:user_code]
     @matter.u_t=Time.now()
     if @matter.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
        render :action=>"new"
     end

  end

  def edit
     @matter=CaseMatter.find(params[:id])
  end

  def update
     @matter=CaseMatter.find(params[:id])
     @matter.u=session[:user_code]
     @matter.u_t=Time.now()
     if @matter.update_attributes(params[:matter])
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
     else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
     end

  end

  def delete
     @matter=CaseMatter.find(params[:id])
     @matter.used="N"
     @matter.u=session[:user_code]
     @matter.u_t=Time.now()
     if @matter.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list"
  end

end
