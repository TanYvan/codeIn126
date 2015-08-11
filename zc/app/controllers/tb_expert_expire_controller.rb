#2010-9-13 按照仲裁员届信息添加专家届信息
class TbExpertExpireController < ApplicationController
  def list_expires
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @tb_arbitmannow_pages,@tb_arbitmannows =paginate(:tb_periods,:conditions=>"used='Y' and states<>3",:order=>@order,:per_page=>@page_lines.to_i)
  end
  def new_expert_many
    @tb_aexpert_exprire = TbExpertExpire.new()
  end
  def create_expert_many
    @tb_aexpert_exprire = TbExpertExpire.new(params[:tb_expert_expire])
    @tb_aexpert_exprire.u = session[:user_code]
    @tb_aexpert_exprire.u_t = Time.now
    if @tb_aexpert_exprire.save
      flash[:notice] = "届信息保存成功！"
      redirect_to :action => "list_expires",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "创建失败"
      render :action => "new_expert_many",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  #所有届信息
  def list_expire1
    @page_lines=params[:page_lines]
    @page_lines=session[:lines] if @page_lines.nil?
    
    @expires_pages,@tb_expert_expires=paginate(:tb_expert_expires,:conditions=>"used='Y'",:order=>"expire",:per_page=>@page_lines.to_i)
  end
  def expire_edit
    @expires=TbExpertExpire.find(params[:id])
  end
  def expire_update
    @expires=TbExpertExpire.find(params[:id])
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    if @expires.update_attributes(params[:expires])
      flash[:notice]="修改成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"expire_edit",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def expire_delete
    @expires=TbExpertExpire.find(params[:id])
    @expires.used="N"
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    
    if @expires.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

end
