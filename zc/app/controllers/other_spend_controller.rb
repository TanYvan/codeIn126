class OtherSpendController < ApplicationController  
  
  def list
    @case=nil
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      if PubTool.new().sql_check_3(c)!=false
        @other_spend=TbOtherSpend.find(:all,:order=>'spenddate,typ',:conditions=>c)
      end
    end
  end
  
  def new
    @other_spend=TbOtherSpend.new()
    @other_spend.spenddate = Date.today
  end
  
  def create
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @other_spend=TbOtherSpend.new(params[:other_spend])
      @other_spend.recevice_code=params[:recevice_code]
      @other_spend.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @other_spend.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @other_spend.u=session[:user_code]
      @other_spend.u_t=Time.now()
      if @other_spend.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end 
  end
  
  def edit
    @other_spend=TbOtherSpend.find(params[:id])
  end 

  def update
    @other_spend=TbOtherSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@other_spend.recevice_code)
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @other_spend.u=session[:user_code]
      @other_spend.u_t=Time.now()
      if @other_spend.update_attributes(params[:other_spend]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
   
  def delete
    @other_spend=TbOtherSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@other_spend.recevice_code)
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @other_spend.used="N"
      @other_spend.u=session[:user_code]
      @other_spend.u_t=Time.now()
      if @other_spend.save
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end
  
end
