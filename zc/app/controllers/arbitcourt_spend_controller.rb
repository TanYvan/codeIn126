class ArbitcourtSpendController < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @arbitcourt_spend_pages,@arbitcourt_spend=paginate(:tb_arbitcourt_spends,:order=>'recevice_code,sittingdate,typ',:conditions=>c)
    end
  end
  
  def new
    @arbitcourt_spend=TbArbitcourtSpend.new()
  end
  
  def create
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if @c.state>=4 and @c.state<=100
      @arbitcourt_spend=TbArbitcourtSpend.new(params[:arbitcourt_spend])
      @arbitcourt_spend.recevice_code=params[:recevice_code]
      @arbitcourt_spend.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @arbitcourt_spend.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @arbitcourt_spend.u=session[:user_code]
      @arbitcourt_spend.u_t=Time.now()
      if @arbitcourt_spend.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
  end
  
  def edit
    @arbitcourt_spend=TbArbitcourtSpend.find(params[:id])
  end 

  def update
    @arbitcourt_spend=TbArbitcourtSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@arbitcourt_spend.recevice_code)
    if @c.state>=4 and @c.state<=100
      @arbitcourt_spend.u=session[:user_code]
      @arbitcourt_spend.u_t=Time.now()
      if @arbitcourt_spend.update_attributes(params[:arbitcourt_spend]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
   
  def delete
    @arbitcourt_spend=TbArbitcourtSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@arbitcourt_spend.recevice_code)
    if @c.state>=4 and @c.state<=100
      @arbitcourt_spend.used="N"
      @arbitcourt_spend.u=session[:user_code]
      @arbitcourt_spend.u_t=Time.now()
      if @arbitcourt_spend.save
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end 
  
end
