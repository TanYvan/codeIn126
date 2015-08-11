#账号管理控制器，对仲裁员的账号进行审核，显示
#添加人 苏获
#添加时间 20090525
class AccountController < ApplicationController
  def list_account
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @hant_search_1_page_name="list_account"
    @hant_search_1=[['char','spell','姓名拼音缩写','text',[]],['char','name','姓名','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="a.name desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="a.used='Y' and c.used='Y' and a.code=c.arbitman_num"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @account_pages,@account =paginate_by_sql(TbArbitmannow,"select a.name as name,a.id as id,a.spell as spell,a.sex as sex,a.mobiletel as mobiletel,a.bankaccount as bankaccount,a.bank_typ as bank_typ,a.bankname as bankname,a.id_card as id_card,a.addr as addr,a.bankremark as bankremark from tb_arbitmen as a,tb_arbitmannows as c where #{c} order by  #{@order}",@page_lines.to_i)

  end
  #工作人员帐号信息
   def list_account_2
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
     @u_pages,@u=paginate(:users,:order=>@order,:conditions=>"used='Y' and states='Y'",:per_page=>@page_lines.to_i)
  end
    
  #修改仲裁员财务账号信息
  def edit_account
    @tb_arbitman = TbArbitman.find(params[:id])
  end
  #更新仲裁员账号信息
  def update_account
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_arbitman.bank_u = session[:user_code]
    @tb_arbitman.bank_t = Time.now
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
        redirect_to :action=>"list_account_2"
     else
	#render_text "error"
	render :action=>"edit"
     end
   end
end
