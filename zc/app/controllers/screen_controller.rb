#2010-3-29  聂灵灵 仲裁资料
class ScreenController < ApplicationController
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    c="used='Y'"
    @new_pages,@tbnews=paginate(:tb_new,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  def new
    @tb_new=TbNew.new()
    @tb_new.create_date=Date.today
  end
  def create
    @tb_new=TbNew.new(params[:tb_new])
    @tb_new.u=session[:user_code]
    @tb_new.u_t=Time.now()
    if @tb_new.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"new",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def edit
    @tb_new=TbNew.find(params[:id])
  end
  def update
    @tb_new=TbNew.find(params[:id])
    @tb_new.u=session[:user_code]
    @tb_new.u_t=Time.now()
    if @tb_new.update_attributes(params[:tb_new])
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def delete
    @tb_new=TbNew.find(params[:id])
    @tb_new.used="N"
    @tb_new.u=session[:user_code]
    @tb_new.u_t=Time.now()
    if @tb_new.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
