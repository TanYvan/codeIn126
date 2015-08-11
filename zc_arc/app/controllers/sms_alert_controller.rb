class SmsAlertController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','p_name','姓名','text',[]],['char','mobiletel','手机号','text',[]],['char','contents','内容','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="c_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
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
    c="used='Y'  and p_typ='0001' and  send_state<=100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @sms_pages,@sms=paginate(:tb_sms_alerts,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def edit
    @sms=TbSmsAlert.find(params[:id])
  end
  
  def update
    @sms=TbSmsAlert.find(params[:id])
    @sms.u=session[:user_code]
    @sms.t=Time.now()
    if @sms.update_attributes(params[:sms])
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  def complete
    @condi_k = params[:condi_k]
    array_complete = @condi_k.split(",")
    begin
      array_complete.each do |com|
        @sms = TbSmsAlert.find_by_id(com)
        @sms.send_state=900
        @sms.send_u = session[:user_code]
        @sms.send_t = Time.now
        @sms.save
        #@sms.update_attributes(params[:remind])
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "发送成功"
      render :action => "list",:order=>params[:order],:search_condit=>params[:search_condit],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "发送成功"
      redirect_to :action => "list",:order=>params[:order],:search_condit=>params[:search_condit],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  
  def list_1
    @hant_search_1_page_name="list_1"
    @hant_search_1=[['char','p_name','姓名','text',[]],['char','mobiletel','手机号','text',[]],['char','contents','内容','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="c_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
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
    c="used='Y'  and p_typ='0001' and  send_state=900"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @sms_pages,@sms=paginate(:tb_sms_alerts,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
end
