class SmsAlertController < ApplicationController
  def list
    @state={100=>"未发放",200=>"发放失败",900=>"已发放",950=>"已删除"}
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
    c="used='Y' and typ='0001' and p_typ='0001' and  send_state<900"
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
  
  def delete
    @sms=TbSmsAlert.find(params[:id])
    @sms.send_state=950
    @sms.u=session[:user_code]
    @sms.t=Time.now()
    if @sms.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  def complete
    @condi_k = params[:condi_k]
    system("cd /usr/local/zc_mes;java -Dfile.encoding=GBK -classpath /usr/local/zc_mes:/usr/local/zc_mes/empp.jar:/usr/local/zc_mes/jack.jar:./mysql-connector-java-3.0.17-ga-bin.jar  Mes #{@condi_k} ")
    array_complete = @condi_k.split(",")
    begin
      array_complete.each do |com|
        @sms = TbSmsAlert.find_by_id(com)
        @sms.send_u = session[:user_code]
        @sms.send_t = Time.now
        @sms.save
        #@sms.update_attributes(params[:remind])
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "发送完成"
      render :action => "list",:order=>params[:order],:search_condit=>params[:search_condit],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "发送完成"
      redirect_to :action => "list",:order=>params[:order],:search_condit=>params[:search_condit],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  
  def list_1
    @state={100=>"未发放",200=>"发放失败",900=>"已发放",950=>"已删除"}
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
    c="used='Y'  and typ='0001'  and p_typ='0001' and  send_state=900"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @sms_pages,@sms=paginate(:tb_sms_alerts,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def delete_2
    @sms=TbSmsAlert.find(params[:id])
    @sms.send_state=100
    @sms.u=session[:user_code]
    @sms.t=Time.now()
    if @sms.save
      flash[:notice]="转为发放成功"
      redirect_to :action=>"list_1",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="转为发放成功"
      render :action=>"list_1",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
end
