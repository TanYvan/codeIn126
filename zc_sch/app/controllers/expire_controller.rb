#2009-7-21 niell  在聘仲裁员信息表维护
class ExpireController < ApplicationController
  def list_expires
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
    end
    @tb_arbitmannow_pages,@tb_arbitmannows =paginate(:tb_arbitmannows,:conditions=>"used='Y'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #所有届信息
  def list_expire1
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=10
    end
    @expires_pages,@expires=paginate(:expires,:conditions=>"used='Y'",:order=>"expire",:per_page=>@page_lines.to_i)
  end
  def expire_edit
    @expires=Expire.find(params[:id])
  end
  def expire_update
    @expires=Expire.find(params[:id])
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
    @expires=Expire.find(params[:id])
    @expires.used="N"
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    @tb_arbitmanexprire = TbArbitmanexprire.find(:all,:conditions=>"expire='#{@expires.expire}' and used='Y'")
    if @tb_arbitmanexprire!=nil
      for a in @tb_arbitmanexprire
        @tb_arbitmanexprire1 = TbArbitmanexprire.new()
        @tb_arbitmanexprire1.expire = a.expire
        @tb_arbitmanexprire1.arbitman_num = a.arbitman_num
        @tb_arbitmanexprire1.arbitman_name = TbArbitman.find_by_code(a.arbitman_num).name
        @tb_arbitmanexprire1.used='N'
        @tb_arbitmanexprire1.u = session[:user_code]
        @tb_arbitmanexprire1.u_t = Time.now
        @tb_arbitmanexprire1.save
      end
    end
    if @expires.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    end    
  end
  
  def create_expire_many
    if Expire.find(:first,:conditions=>"expire='#{params[:expire]["expire"]}' and used='Y'")==nil
      @expire = Expire.new(params[:expire])
      @expire.expire = params[:expire]["expire"]
      @expire.remark = params[:expire]["remark"]
      @expire.u = session[:user_code]
      @expire.u_t = Time.now
      if @expire.save
        @expire2=TbArbitmannow.find(:all,:conditions=>"used='Y'")
        for e in @expire2
          @tb_arbitmanexprire = TbArbitmanexprire.new()
          @tb_arbitmanexprire.expire = params[:expire]["expire"]
          @tb_arbitmanexprire.arbitman_num = e.arbitman_num
          @tb_arbitmanexprire.arbitman_name = TbArbitman.find_by_code(e.arbitman_num).name
          @tb_arbitmanexprire.u = session[:user_code]
          @tb_arbitmanexprire.u_t = Time.now
          @tb_arbitmanexprire.save
        end
        flash[:notice] = "届信息保存成功！"
        redirect_to :action => "list_expires",:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice] = "创建失败"
        render :action => "new_expire_many",:page=>params[:page],:page_lines=>params[:page_lines]
      end
    else
      flash[:notice] = "届信息已经存在，请重新命名！"
      render :action => "new_expire_many",:page=>params[:page],:page_lines=>params[:page_lines]
    end  
  end
  
end
