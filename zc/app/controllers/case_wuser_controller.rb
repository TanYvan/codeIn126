class CaseWuserController < ApplicationController
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @typ = AttachmentConfig.find(:all)
      @att_typ = {}
      @typ.each{|ari|
        @att_typ.merge!({ari.code => ari.name})
      }
      @user_typ = {1=>"申请人",2=>"被申请人"}
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @wuser=CaseWUser.find(:all, :conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'",:order=>"id asc")
    end
  end

  def new
    
  end

  def create
     @w_user=CaseWUser.new(params[:w_user])
     @w_user.recevice_code=session[:recevice_code]
     @w_user.u=session[:user_code]
     @w_user.u_t=Time.now()
     if @w_user.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
        render :action=>"new"
     end
  end

  def delete
     @w_user=CaseWUser.find(params[:id])
     @w_user.used="N"
     @w_user.u=session[:user_code]
     @w_user.u_t=Time.now()
     if @w_user.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list"
  end
  
end
