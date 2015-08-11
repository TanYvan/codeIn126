class PeriodExpireController < ApplicationController
  
  def list_expires
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @period_pages,@period =paginate(:tb_periods,:conditions=>"used='Y'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  
  def new_expert_many
    @expire_b = ExpireB.new()
  end
  
  def create_expert_many
    @expire_b = ExpireB.new(params[:expire_b])
    @expire_b.u = session[:user_code]
    @expire_b.u_t = Time.now
    if @expire_b.save
      
      @expire2=TbPeriod.find(:all,:conditions=>"used='Y'")
      for e in @expire2
        @period_expire = TbPeriodExpire.new()
        @period_expire.expire = params["expire_b"]["expire"]
        @period_expire.code = e.code
        @period_expire.name = TbExpertconsult.find_by_code(e.code).name
        @period_expire.u = session[:user_code]
        @period_expire.u_t = Time.now
        @period_expire.save
      end
      
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
    
    @expires_pages,@period_expires=paginate(:expire_bs,:conditions=>"used='Y'",:order=>"expire",:per_page=>@page_lines.to_i)
  end
  
  def expire_edit
    @expires=ExpireB.find(params[:id])
  end
  
  def expire_update
    @expires=ExpireB.find(params[:id])
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
    @expires=ExpireB.find(params[:id])
    @expires.used="N"
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    
    if @expires.save
      TbPeriodExpire.update_all("used='N'",["expire=?",@expires.expire])
      flash[:notice]="删除成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
end
