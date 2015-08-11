class DutyController < ApplicationController
  
  def list
  @uds=UserDuty.find(:all,:order=>"duty_code",:conditions=>"user_code='"+params[:uid]+"'")
end

def add
  @ud=UserDuty.new()
  @ud.user_code=params[:uid]
  @ud.duty_code=params[:did]
  if @ud.save
     flash[:notice]='职责添加成功'
     @uds=UserDuty.find(:all,:order=>"duty_code",:conditions=>"user_code='"+(params[:uid])+"'")
     text=""
     for u in @uds
      text=text  + Duty.find_by_code(u.duty_code).name + " "
     end
     @user=User.find_by_code(params[:uid])
     @user.duty_text=text
     @user.save
  else
     flash[:notice]='职责添加失败'
  end
  
  redirect_to :controller=>"duty" ,:action=>"select",:uid=>params[:uid]
end

def delete 
    ud=UserDuty.find(params[:id])
    ud.destroy
    @uds=UserDuty.find(:all,:order=>"duty_code",:conditions=>"user_code='"+params[:uid]+"'")
    text=""
    for u in @uds
      text=text  + Duty.find_by_code(u.duty_code).name + " "
    end
    @user=User.find_by_code(params[:uid])
    @user.duty_text=text
    @user.save
    flash[:notice]='职责删除成功'
    redirect_to :controller=>"duty" ,:action=>"list",:uid=>params[:uid]
end

def select
     #@ud=UserDuty.find_by_user_code(params[:uid])
     @dutys=Duty.find(:all,:order=>"code")
end
  
end
