#niell 2009-7-13 工作提醒
class RemindController < ApplicationController
  #到期提醒
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="dt1 desc,u_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @user_code=params[:user_code]
    if @user_code==nil
      @user_code=session[:user_code]
    end
    @remind_pages,@remind=paginate(:reminds,:conditions=>"used='Y' and (state=1 or state=2) and uu='#{@user_code}' and dt1<='#{Date.today.to_s(:db)}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #未到期提醒
  def will_list
    @order=params[:order]
    if @order==nil or @order==""
      @order="dt1 desc,u_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @remind_pages,@remind=paginate(:reminds,:conditions=>"used='Y' and (state=1 or state=2) and uu='#{session[:user_code]}'  and dt1>'#{Date.today.to_s(:db)}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #历史提醒
  def histroy_list
    @order=params[:order]
    if @order==nil or @order==""
      @order="dt1 desc,u_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @remind_pages,@remind=paginate(:reminds,:conditions=>"used='Y' and state=3 and uu='#{session[:user_code]}' ",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #创建自定义提醒
  def remind_new
    @remind=Remind.new()
    @remind.dt1=Date.today
  end
  def remind_create
    @remind=Remind.new(params[:remind])
    @remind.state=1
    @remind.typ='0002'
    @remind.uu=session[:user_code]
    @remind.u=session[:user_code]
    @remind.u_t=Time.now()

    if @remind.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"remind_new",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #确定完成
  def complete
    @condi_k = params[:condi_k]
    array_complete = @condi_k.split(",")
    begin
      array_complete.each do |com|
        @remind = Remind.find_by_id(com)
        @remind.state=3
        @remind.dt3 = Time.now
        @remind.u = session[:user_code]
        @remind.u_t = Time.now
        @remind.update_attributes(params[:remind])
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "标记失败"
      render :action => "list",:page=>params[:page],:page_lines=>params[:page_lines],:user_code=>params[:user_code]
    else
      flash[:notice] = "标记成功"
      redirect_to :action => "list",:page=>params[:page],:page_lines=>params[:page_lines],:user_code=>params[:user_code]
    end
  end
  #确定延迟
  def delay_create
    @condi_s = params[:condi_s]
    arary_delay = @condi_s.split(",")
    begin
      arary_delay.each do |delayd|
        @remind = Remind.find_by_id(delayd)
        @remind1=Remind1.new
        @remind1.remind_id = delayd
        @remind1.day1 = params[:remind1][:day1]        #延期天数        
        @remind1.dt1 = @remind.dt1 #原来日期
        @remind1.contents = @remind.contents #提醒内容
        @remind1.dt2 = @remind.dt1 + params[:remind1][:day1].to_i
        @remind1.state = 2
        @remind1.u = session[:user_code]
        @remind1.u_t = Time.now   
        @remind1.save        
        #原来的一条提醒记录也改变了
        @remind.dt1=@remind.dt1 + params[:remind1][:day1].to_i
        @remind.dt3 = Time.now
        @remind.state = 2
        @remind.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "延期失败"
      render :action => "list",:page=>params[:page],:page_lines=>params[:page_lines],:user_code=>params[:user_code]
    else
      flash[:notice] = "延期成功"
      redirect_to :action => "list",:page=>params[:page],:page_lines=>params[:page_lines],:user_code=>params[:user_code]
    end
  end
  
  
  #收款记录信息提醒，提醒到助理
  def list_2
    @order=params[:order]
    if @order==nil or @order==""
      @order="dt1 desc,u_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @remind_pages,@remind=paginate(:reminds,:conditions=>"(reason_id like '%tb_charges-%1') and used='Y' and (state=1 or state=2) and uu='#{session[:user_code]}' and dt1<='#{Date.today.to_s(:db)}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #收款提醒确定完成
  def complete_2
    @condi_k = params[:condi_k]
    array_complete = @condi_k.split(",")
    begin
      array_complete.each do |com|
        @remind = Remind.find_by_id(com)
        @remind.state=3
        @remind.dt3 = Time.now
        @remind.u = session[:user_code]
        @remind.u_t = Time.now
        @remind.update_attributes(params[:remind])
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "标记失败"
      render :action => "list_2",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "标记成功"
      redirect_to :action => "list_2",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #收款提醒确定延迟
  def delay_create_2
    @condi_s = params[:condi_s]
    arary_delay = @condi_s.split(",")
    begin
      arary_delay.each do |delayd|
        @remind = Remind.find_by_id(delayd)
        @remind1=Remind1.new
        @remind1.remind_id = delayd
        @remind1.day1 = params[:remind1][:day1]        #延期天数        
        @remind1.dt1 = @remind.dt1 #原来日期
        @remind1.contents = @remind.contents #提醒内容
        @remind1.dt2 = @remind.dt1 + params[:remind1][:day1].to_i
        @remind1.state = 2
        @remind1.u = session[:user_code]
        @remind1.u_t = Time.now   
        @remind1.save        
        #原来的一条提醒记录也改变了
        @remind.dt1=@remind.dt1 + params[:remind1][:day1].to_i
        @remind.dt3 = Time.now
        @remind.state = 2
        @remind.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "延期失败"
      render :action => "list_2",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "延期成功"
      redirect_to :action => "list_2",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  
  #收款记录信息提醒，提醒到助理
  def list_3
    @order=params[:order]
    if @order==nil or @order==""
      @order="dt1 desc,u_t desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @remind_pages,@remind=paginate(:reminds,:conditions=>"((reason_id like '%tb_charge_corrs-%1') or (reason_id like 'case_nowdate_t%')) and used='Y' and (state=1 or state=2) and uu='#{session[:user_code]}' and dt1<='#{Date.today.to_s(:db)}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #收款提醒确定完成
  def complete_3
    @condi_k = params[:condi_k]
    array_complete = @condi_k.split(",")
    begin
      array_complete.each do |com|
        @remind = Remind.find_by_id(com)
        @remind.state=3
        @remind.dt3 = Time.now
        @remind.u = session[:user_code]
        @remind.u_t = Time.now
        @remind.update_attributes(params[:remind])
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "标记失败"
      render :action => "list_3",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "标记成功"
      redirect_to :action => "list_3",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #收款提醒确定延迟
  def delay_create_3
    @condi_s = params[:condi_s]
    arary_delay = @condi_s.split(",")
    begin
      arary_delay.each do |delayd|
        @remind = Remind.find_by_id(delayd)
        @remind1=Remind1.new
        @remind1.remind_id = delayd
        @remind1.day1 = params[:remind1][:day1]        #延期天数        
        @remind1.dt1 = @remind.dt1 #原来日期
        @remind1.contents = @remind.contents #提醒内容
        @remind1.dt2 = @remind.dt1 + params[:remind1][:day1].to_i
        @remind1.state = 2
        @remind1.u = session[:user_code]
        @remind1.u_t = Time.now   
        @remind1.save        
        #原来的一条提醒记录也改变了
        @remind.dt1=@remind.dt1 + params[:remind1][:day1].to_i
        @remind.dt3 = Time.now
        @remind.state = 2
        @remind.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "延期失败"
      render :action => "list_3",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "延期成功"
      redirect_to :action => "list_3",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
end