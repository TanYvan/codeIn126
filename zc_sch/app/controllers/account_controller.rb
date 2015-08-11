#账号管理控制器，对仲裁员的账号进行审核，显示
#添加人 苏获
#添加时间 20090525
class AccountController < ApplicationController
  def list_account
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
    end
    @account =TbArbitmannow.find(:all,:conditions => "used = 'Y'",:order=>@order)    
    @u =User.find(:all,:conditions=>"used='Y' and states='Y'",:order=>@order)   
  end
    
  #修改仲裁员财务账号信息
  def edit_account
    @tb_arbitman = TbArbitman.find(params[:id])
  end
  #更新仲裁员账号信息
  def update_account
    @tb_arbitman = TbArbitman.find(params[:id]) 
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    if @tb_arbitman.update_attributes(params[:tb_arbitman]) 
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_account",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action=>"edit_account", :id => params[:id],:page=>params[:page],:page_lines=>params[:page_lines]
    end               
  end
  def edit
     @user=User.find(params[:id])
  end 
  def update
     @user=User.find(params[:id])
     @user.u=session[:user_code]
     @user.u_t=Time.now()
     if @user.update_attributes(params[:user]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list_account"
     else
	#render_text "error"
	render :action=>"edit"
     end
   end
end
