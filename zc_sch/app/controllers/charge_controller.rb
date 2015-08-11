class ChargeController < ApplicationController
  
  def list
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','code','收款号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
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
    c="used='Y' and u='#{session[:user_code]}'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @charge_pages,@charge=paginate(:tb_charges,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def rate_set 
    render :update do |page|
      page.remove 'charge_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end
  
  def new
    @charge=TbCharge.new()
    @charge.c_dt=Date.today()
  end
  
  def create
     @charge=TbCharge.new(params[:charge])
     if @charge.code==''
       @charge.code=SysArg.add_0004()
     end
     @charge.typ='a'
     @charge.u=session[:user_code]
     @charge.u_t=Time.now()
     if @charge.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
        flash[:notice]="创建失败"
        render :action=>"new" 
     end
     
  end
  
  def edit
     @charge=TbCharge.find(params[:id])
   end 

   def update
     @charge=TbCharge.find(params[:id])
     if @charge.state==1 and @charge.typ='a'
       if @charge.update_attributes(params[:charge]) 
          flash[:notice]="修改成功"
          redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
       else
          flash[:notice]="修改失败"
          render :action=>"edit",:search_condit=>params[:search_condit],:id=>params[:id],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
       end
     end
   end
   
   def delete
     @charge=TbCharge.find(params[:id])
     if @charge.state==1
       @charge.used="N"
       if @charge.save     
          flash[:notice]="删除成功"
       else
          flash[:notice]="删除失败"
       end
       redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
     end
   end
  
   def split_list 
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    if @order==nil or @order==""
      @order="id asc"
    end
    c="used='Y' and typ='c' and parent_id=#{params[:charge_id]}"
    @charge=TbCharge.find(params[:charge_id])
    @split_pages,@split=paginate(:tb_charges,:order=>@order,:conditions=>c)
   end
end
