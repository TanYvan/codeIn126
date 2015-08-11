#2009-7-20 聂灵灵   参数表信息维护
class SysArgController < ApplicationController
  def list   
    @sys_arg = SysArg.find(:all,:order=>"code")
  end
  def edit
    @sys_arg = SysArg.find(params[:id])
  end
  def update
    @sys_arg = SysArg.find(params[:id])
    if @sys_arg.update_attributes(params[:sys_arg])
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit"
    end
  end
end
