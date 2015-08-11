class WelcomeController < ApplicationController
  #系统登录页面
  def login
    #提醒未运行标记，如果提醒服务30秒钟没有运行，则显示提示图片
    @messege_flag = (SysArg.remind_runtime_from_now > 30)
  end

  #系统登录处理验证，如果通过则进入系统，否则返回登录页面。
  def login_do
    usercode = params[:code]
    password = params[:password]
    user = User.find(:first,:conditions=>["code=? and used='Y' and password=?",usercode,Digest::SHA1.hexdigest(password)])

    if user.blank?
      flash[:login]  = "登录失败，用户名或密码错误。"
      render :action => "login"
    else
      session[:user_code] = user.code
      session[:user_name] = user.name
      session["0001"]     = UserDuty.is_chuzhang(user.code)
      session["0003"]     = UserDuty.is_zhuli(user.code)
      session["0009"]     = UserDuty.is_caiwu(user.code)

      session[:lines]     = SysArg.lines_per_page
      redirect_to :action => "main"
    end
  end

  def logout
    session[:user_code]     = nil
    session[:user_name]     = nil
    session["0001"]         = nil
    session["0003"]         = nil
    session["0009"]         = nil
    session[:lines]         = nil
    session[:case_code]     = nil
    session[:recevice_code] = nil
    session[:general_code]  = nil
    render :action => "login"
  end

  #修改个人密码页面
  def change_password
    @user = User.find_by_code(session[:user_code])
    @user.password = ""
  end

  #修改个人密码
  def change_password_do
    user = User.find_by_code(session[:user_code])
    if user.password == Digest::SHA1.hexdigest(params[:old_password])
      user.password = Digest::SHA1.hexdigest(params[:user][:password])
      if user.save
        render :text => "密码修改成功！"
      else
        render :text => "密码修改失败！"
      end
    else
      render :text => "原密码输入错误！"
    end
  end

  def main
    
  end
  
  def top
    @f = FastMenu.find_by_sql("select name, menu_id, url from fast_menus
         where role_code in
    (select role_code from urs where urs.user_code='#{session[:user_code]}' )
    order by role_code, code")
  end
  
  def right
    
  end

end
