class UrController < ApplicationController
def list
  @urs=Ur.find(:all,:order=>"role_code",:conditions=>"user_code='"+params[:uid]+"'")
end

def add
  @ur=Ur.new()
  @ur.user_code=params[:uid]
  @ur.role_code=params[:rid]
  @ur.save
  
  if @ur.save
     flash[:notice]='角色添加成功'
     @urs=Ur.find(:all,:order=>"role_code",:conditions=>"user_code='"+(params[:uid])+"'")
     text=""
     for u in @urs
     text=text  + Role.find_by_code(u.role_code).name + " "
     end
     @user=User.find_by_code(params[:uid])
     @user.role_text=text
     @user.save
  else
     flash[:notice]='角色添加失败'
  end
  
  redirect_to :controller=>"role" ,:action=>"select",:uid=>params[:uid]
end

def delete 
    ur=Ur.find(params[:id])
    ur.destroy
    @urs=Ur.find(:all,:order=>"role_code",:conditions=>"user_code='"+params[:uid]+"'")
    text=""
    for u in @urs
      text=text  + Role.find_by_code(u.role_code).name + " "
    end
    @user=User.find_by_code(params[:uid])
    @user.role_text=text
    @user.save
    flash[:notice]='角色删除成功'
    redirect_to :controller=>"ur" ,:action=>"list",:uid=>params[:uid]
end

def select
     @user=User.find_by_code(params[:uid])
     @roles=Role.find(:all,:order=>"code")
end

end
