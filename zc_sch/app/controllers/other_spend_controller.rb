class OtherSpendController < ApplicationController
  
  def case_list  
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="used='Y'  and ((clerk='#{session[:user_code]}' and state>=4 and state<=100) or ((clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') and state>=1 and state<3)) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    if PubTool.new().sql_check_3(c)!=false
      @other_spend=TbOtherSpend.find(:all,:order=>'spenddate,typ',:conditions=>c)
    end
  end
  
  def new
    @other_spend=TbOtherSpend.new()
    @other_spend.spenddate = Date.today
  end
  
  def create
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
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
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
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
    if (@c.clerk==session[:user_code] and @c.state>=4 and @c.state<=100) or (@c.clerk_2==session[:user_code] and @c.state>=1 and @c.state<3)
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
