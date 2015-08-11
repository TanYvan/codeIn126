class ExpendDetailController < ApplicationController
    
  def list
    @state={1=>"未确认",2=>"出纳已确认",3=>"已召回",4=>"处长已确认"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
       @expend_detail=TbExpendDetail.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def new
    @expend_detail=TbExpendDetail.new()
    @expend_detail.expend_date = Date.today
  end
  
  def create
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @expend_detail=TbExpendDetail.new(params[:expend_detail])
      @expend_detail.recevice_code=params[:recevice_code]
      @expend_detail.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @expend_detail.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @expend_detail.state=1
      @expend_detail.u=session[:user_code]
      @expend_detail.u_t=Time.now()
      if @expend_detail.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end 
     
  end
  
  def edit
    @expend_detail=TbExpendDetail.find(params[:id])
  end 

  def update
    @expend_detail=TbExpendDetail.find(params[:id])
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @expend_detail.u=session[:user_code]
      @expend_detail.u_t=Time.now()
      if @expend_detail.update_attributes(params[:expend_detail]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
   
  def delete
    @expend_detail=TbExpendDetail.find(params[:id])
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
      @expend_detail.used="N"
      @expend_detail.u=session[:user_code]
      @expend_detail.u_t=Time.now()
      if @expend_detail.save
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end
  
  
end
