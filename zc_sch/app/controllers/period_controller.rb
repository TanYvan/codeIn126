=begin
创建人：聂灵灵
创建时间：2009-5-26
类的描述：此控制器是日常办公时专家解聘续聘信息维护信息，包括：专家届信息列表(period_list)，
         专家届信息创建(period_new)，专家届信息修改(period_edit)
=end
class PeriodController < ApplicationController
  #专家的届信息操作
  #专家届信息列表
  def period_list
    @hant_search_1_page_name="period_list"
    @hant_search_1=[['char','tb_expertconsults.code','编码','text',[]],['char','tb_expertconsults.name','姓名','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
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
    c = "tb_periods.used = 'Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_expertconsults.name desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 5
    end
    @tb_period_pages,@tb_periods=paginate(:tb_periods,:joins=>"inner join tb_expertconsults  on tb_periods.code=tb_expertconsults.code",
      :select=>"tb_expertconsults.id as id,tb_expertconsults.code as code,tb_expertconsults.name as name",:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  #增聘专家届信息
  #   def period_new
  #     @tb_period_log = TbPeriodLog.new
  #   end
  def period_create
    @expertconsult=TbExpertconsult.find_by_code(params[:code])
    @tb_period=TbPeriod.find_by_code(params[:code])
    if @tb_period == nil#@expertconsult == nil
      begin
        @tb_period_log=TbPeriodLog.new(params[:tb_period_logs])
        @tb_period_log.action_type = '0003'
        @tb_period_log.code=@expertconsult.code
        @tb_period_log.expert_name=@expertconsult.name
        @tb_period_log.user = session[:user_code]
        @tb_period_log.u_t = Time.now
        @tb_period_log.save
        #将相应的信息添加到当前聘请仲裁员表
        @tb_period = TbPeriod.new
        @tb_period.code = @expertconsult.code
        @tb_period.user = session[:user_code]
        @tb_period.u_t = Time.now
        @tb_period.save

      rescue ActiveRecord::RecordNotSaved =>e
        flash[:notice]="增聘专家失败！"
        render :action=>"period_list",:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice]="增聘专家成功！"
        redirect_to :action=>"period_list",:page=>params[:page],:page_lines=>params[:page_lines]
      end
    else
      flash[:notice]="专家"+@expertconsult.name+"已经在聘！"
      redirect_to :action=>"period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #续聘
  def continuation
    @tb_period_logs = TbPeriodLog.new()
    @tb_period_logs.dt=Date.today
    @expertconsult = TbExpertconsult.find_by_code(params[:id])
  end
  #创建续聘理由记录,只添加记录到tb_period_log表
  def continuation_create
    @tb_period_log = TbPeriodLog.new(params[:tb_period_logs])
    @tb_period_log.code = params[:id]
    @tb_period_log.expert_name = TbExpertconsult.find_by_code(params[:id]).name
    @tb_period_log.user = session[:user_code]
    @tb_period_log.u_t = Time.now
    @tb_period_log.action_type = '0002'
    if @tb_period_log.save
      flash[:notice] = "续聘操作成功！"
      redirect_to :action => "period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      redirect_to :action => "continuation",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #解聘专家
  def dismiss
    @tb_period_logs = TbPeriodLog.new
    @tb_period_logs.dt=Date.today
    @expertconsult = TbExpertconsult.find_by_code(params[:id])
  end
  #确定解聘的操作
  def dismiss_expert
    begin
      @tb_period_log = TbPeriodLog.new(params[:tb_period_logs])
      @tb_period_log.action_type = '0001'
      @tb_period_log.code = params[:id]
      @tb_period_log.expert_name = TbExpertconsult.find_by_code(params[:id]).name
      @tb_period_log.user = session[:user_code]
      @tb_period_log.u_t = Time.now
      @tb_period_log.save
      #将相应的仲裁员在聘信息从当前聘请仲裁员表中删除
      @tb_period = TbPeriod.find_by_code(params[:id])
      @tb_period.destroy
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="解聘专家失败！"
      render :action=>"dismiss_expert",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="解聘专家成功！"
      redirect_to :action=>"period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #修改专家届信息
  def period_edit
    @period=TbPeriod.find(params[:id])
  end
  def period_update
    @period = TbPeriod.find(params[:id])
    @period.user = session[:user_code]
    @period.u_t = Time.now
    if @period.update_attributes(params[:period])
      redirect_to :action=>"period_list"
    else
      render :action=>"period_edit",:id=>params[:id]
    end
  end
  #显示对仲裁员的操作的列表，最近的操作放最上面
  def list_actions
    @hant_search_1_page_name="list_actions"
    @hant_search_1=[
      ['char','tb_period_logs.period','届','text',[]],['char','tb_period_logs.expert_name','专家姓名','text',[]],
      ['char','tb_period_logs.action_type','类型','select',[["0001","解聘"],["0002","续聘"],["0003","增聘"]]],
      ['date','tb_period_logs.dt','日期','text',[]],
      ['char','tb_period_logs.reason','理由','text',[]],
    ]
        
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="tb_period_logs.used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @order=params[:order]
    if @order==nil or @order==""
      @order="expert_name asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
    end
    @tb_period_log_pages,@tb_period_logs =
      paginate(:tb_period_logs,:joins=>" inner join tb_expertconsults on tb_period_logs.code=tb_expertconsults.code ",
      :conditions=>c,:select=>"tb_period_logs.period as period,tb_period_logs.expert_name as expert_name,tb_period_logs.dt as dt,tb_period_logs.action_type as action_type,tb_period_logs.user as user,tb_period_logs.u_t as u_t,tb_period_logs.reason as reason",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #续聘选择的多个
  def continuation_many
    @condi_k = params[:condi_k]
    array_con = @condi_k.split(",")
    begin
      array_con.each do |con|
        @tb_period_log = TbPeriodLog.new
        @tb_period_log.code = con
        @tb_period_log.expert_name = TbExpertconsult.find_by_code(con).name
        @tb_period_log.period = params[:tb_period_logs][:period]
        @tb_period_log.dt = params[:tb_period_logs][:dt]
        @tb_period_log.reason = params[:tb_period_logs][:reason]
        @tb_period_log.user = session[:user_code]
        @tb_period_log.u_t = Time.now
        @tb_period_log.action_type = '0002'
        @tb_period_log.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "集体续聘操作失败！"
      redirect_to :action => "period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "集体续聘操作成功！"
      redirect_to :action => "period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #解聘选择的多个
  def dismiss_many
    @condi_s = params[:condi_s]
    array_dis = @condi_s.split(",")
    begin
      array_dis.each do |dis|
        @tb_period_log = TbPeriodLog.new
        @tb_period_log.code = dis
        @tb_period_log.expert_name = TbExpertconsult.find_by_code(dis).name
        @tb_period_log.period = params[:tb_period_logs][:period]
        @tb_period_log.dt = params[:tb_period_logs][:dt]
        @tb_period_log.reason = params[:tb_period_logs][:reason]
        @tb_period_log.user = session[:user_code]
        @tb_period_log.u_t = Time.now
        @tb_period_log.action_type = '0001'
        @tb_period_log.save
        #将相应的专家在聘信息从当前聘请专家表中删除
        @tb_period = TbPeriod.find_by_code(dis)
        @tb_period.destroy
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "集体解聘操作失败！"
      redirect_to :action => "period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "集体解聘操作成功！"
      redirect_to :action => "period_list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #专家信息列表
  def expert_select
    @hant_search_1_page_name="expert_select"
    @hant_search_1=[['char','code','编码','text',[]],['char','name','姓名','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
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
    c = "used = 'Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @expert_pages,@expert=paginate(:tb_expertconsult,:conditions => c,:order=>"id",:per_page=>@page_lines.to_i)
  end
  #选择专家
  def draw_expert
    @expertconsult = TbExpertconsult.find_by_code(params[:code])
    @tb_period_logs = TbPeriodLog.new()
    @tb_period_logs.dt=Date.today
    @page=params[:page]
    @page_lines=params[:page_lines]
  end
    
  def new_dismiss_many
    @tb_period_logs=TbPeriodLog.new
    @tb_period_logs.dt=Date.today
  end
    
  def new_continuation_many
    @tb_period_logs=TbPeriodLog.new
    @tb_period_logs.dt=Date.today
  end
    
end
