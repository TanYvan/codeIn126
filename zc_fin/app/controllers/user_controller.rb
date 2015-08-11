require 'digest/sha1'
class UserController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    p=PubTool.new()
    @hant_search_1=[['char','code','编码','text',[]],['char','name','名称','text',[]],['char','states','状态','select',[['Y','Y'],['N','N']]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="code asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    hant_search_1_word=params[:hant_search_1_word]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit=" and " + hant_search_1_word
    end
    c="used_used='Y'" + @search_condit
    @user_pages, @users=paginate(:users,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def new
    @user=User.new()
  end
   
  def create
    @user=User.new(params[:user])
    @user.password=Digest::SHA1.hexdigest(params[:user][:password])
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="创建失败"
      @user.password=""
      render :action=>"new"
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
      redirect_to :action=>"list",:id=>params[:id]
    else
      #render_text "error"
      render :action=>"edit",:id=>params[:id]
    end
  end

  def show
    @user=User.find(params[:id])
  end


  def delete
    @user=User.find(params[:id])
    #     @urs=Ur.find(:all,:order=>"role_code",:conditions=>"user_code='"+User.find(params[:id]).code+"'")
    #     for u in @urs
    #       u.destroy
    #     end
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    @user.states='N'
    @user.used='N'
    @user.used_used='N'
    if @user.save
        
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list"
  end

  def change_password
    @user=User.find(params[:id])
    @user.password=""
      
  end
  
  def change_password_do
    @user=User.find(params[:id])
    @user.password=Digest::SHA1.hexdigest(params[:user][:password])
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.save
      render :text=>"密码修改成功！"
    else
      render :action =>"change_password"
    end
  end
   
  def up
    @case=TbCase.find(:all)
    l=@case.length
    i=0
    for c in @case
      i=i + 1
      ChargeUp.new.up(c.recevice_code)
      puts "#{l}: #{i}"
    end
    render :text=>"up 完成"
  end
end
