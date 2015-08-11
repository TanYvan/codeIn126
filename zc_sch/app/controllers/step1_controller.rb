class Step1Controller < ApplicationController
  def login

  end
  def login_do
    err=0
    l_code=params[:l_code]
    p=PubTool.new()
    if p.sql_check_3(l_code)==false
      err=1
    else
      password=params[:password]
      #u=User.find(:all,:conditions=>["code=? and password=? and states='Y'",code,password])
      u=User.find(:first,:conditions=>["l_code=? and states='Y'",l_code])

      if u==nil
        err=1
      else
        err=0
      end
    end
    if err==1
      flash[:login]="登录失败，登录信息错误。"
      render :action => 'login'
    else
      u=User.find_by_l_code(l_code)
      session[:user_code_2]=u.code
      session[:user_name_2]=u.name
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0001'",u.code]).empty?
        session["0001"]='N' #0001代表处长
      else
        session["0001"]='Y'
      end
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0003'",u.code]).empty?
        session["0003"]='N' #0003代表仲裁助理
      else
        session["0003"]='Y'
      end
      redirect_to :controller=>"case_consultation3",:action=>"list"
    end

  end
  def logout
      session[:user_code_2]=nil
      session[:user_name_2]=nil
      session["0001"]=nil
      session["0003"]=nil
      render :action => 'login'
  end
end
