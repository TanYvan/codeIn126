#仲裁员管理的增聘解聘管理，包含增聘仲裁员，解聘仲裁员以及仲裁员届信息的管理
#创建人 苏获  
#创建时间 20090508
class ArbitmannowController < ApplicationController    
  #查找符合条件的记录
  def get_arbitmen
    @name = params[:fieldname]
    @type = params[:seltype]
    @year = params[:selyear]
    @agemin = params[:agemin]
    @agemax = params[:agemax]
    sql=prepare_sql(@name,@type,@year,@agemin,@agemax)
    @tb_arbitmannows = TbArbitmannow.find_by_sql(sql)
    session[:arbitmannows_buffer] = @tb_arbitmannows
    render :partial=>page,:layout=>false
  end
    
  def list_arbitmannow
    @hant_search_1_page_name="list_arbitmannow"
    @hant_search_1=[['char','tb_arbitmen.spell','姓名拼音缩写','text',[]],
      ['char','tb_arbitmen.name','姓名','text',[]],
      ['char','tb_arbitmen.code','仲裁员编码','text',[]]]
    @hant_search_1_list=["tb_arbitmen.spell"]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_arbitmen.code asc"
    end
    p=PubTool.new()
    c="tb_arbitmen.used='Y' and tb_arbitmannows.used='Y' and tb_arbitmen.code=tb_arbitmannows.arbitman_num"
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
    end
    #@tb_arbitmannow_pages,@tb_arbitmannows =paginate(:tb_arbitmannows,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @tb_arbitmannow_pages,@tb_arbitmannows=paginate_by_sql(TbArbitmannow,"select tb_arbitmannows.arbitman_num as arbitman_num ,tb_arbitmen.name as name ,tb_arbitmen.age as age,tb_arbitmen.spell as spell   from tb_arbitmen,tb_arbitmannows where #{c}  order by #{@order}",@page_lines.to_i)
  end
  #显示对仲裁员的操作的列表，最近的操作放最上面
  def list_actions
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    @tb_arbitman_expire_log_pages,@tb_arbitman_expire_logs =
      paginate(:tb_arbitman_expire_logs,:order=>@order,:per_page=>@page_lines.to_i)
  end
    
  #新建仲裁员,增聘操作
  def new_arbitmannow
    @tb_arbitman_expire_log = TbArbitmanExpireLog.new
  end
  #选择仲裁员后填写增聘 届，理由 信息，同时存在日志表里
  def draw_arbitmannow
    @arbitman = TbArbitman.find_by_code(params[:code])
    @tb_arbitman_expire_logs = TbArbitmanExpireLog.new
    @tb_arbitman_expire_logs.dt = Date.today
  end

  #增聘仲裁员，同时在记录表和目前在聘仲裁员表中添加记录
  def create_arbitmannow
    @arbitman = TbArbitman.find_by_code(params[:code])
    @tb_arbitmannow = TbArbitmannow.new
    @tb_arbitman = TbArbitmannow.find_by_arbitman_num(params[:code])
    if @tb_arbitman == nil
      begin
        @tb_arbitman_expire_log = TbArbitmanExpireLog.new(params[:tb_arbitman_expire_logs])
        @tb_arbitman_expire_log.action_type = '0003'
        @tb_arbitman_expire_log.arbitman_name=@arbitman.name
        @tb_arbitman_expire_log.arbitman_num=@arbitman.code
        @tb_arbitman_expire_log.expire=params[:tb_arbitman_expire_logs][:expire]
        @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
        @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
        @tb_arbitman_expire_log.user = session[:user_code]
        @tb_arbitman_expire_log.u_time = Time.now
        
        #将相应的信息添加到当前聘请仲裁员表
        @tb_arbitmannow.used='Y'
        @tb_arbitmannow.arbitman_num=@arbitman.code
        @tb_arbitmannow.u = session[:user_code]
        @tb_arbitmannow.u_t = Time.now()
        
        @tb_arbitmannow.save 
        @tb_arbitman_expire_log.save
        
        flash[:notice]="增聘仲裁员成功！"  
        redirect_to :action=>"list_arbitmannow"        
      rescue 
        flash[:notice]="增聘仲裁员失败！"
        render :action=>"draw_arbitmannow",:page =>params[:page],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    else
      flash[:notice]="仲裁员"+@arbitman.name+"已经在聘！"
      
      redirect_to :action=>"list_arbitmannow"
    end
  end
  
  #批量增聘 届，理由 信息，同时存在日志表里
  def draw_arbitmannow_2
    @arbitman = TbArbitman.find_by_code(params[:code])
    @tb_arbitman_expire_logs = TbArbitmanExpireLog.new
    @tb_arbitman_expire_logs.dt = Date.today
  end
  
  #批量增聘仲裁员，同时在记录表和目前在聘仲裁员表中添加记录
  def create_arbitmannow_2
    @condi = params[:condi]
    array_con = @condi.split(",")
    begin
      array_con.each do |con|
        if TbArbitmannow.find_by_arbitman_num(con)==nil
          @tb_arbitman_expire_log=TbArbitmanExpireLog.new
          @tb_arbitman_expire_log = TbArbitmanExpireLog.new(params[:tb_arbitman_expire_logs])
          @tb_arbitman_expire_log.arbitman_num=con
          @tb_arbitman_expire_log.arbitman_name=TbArbitman.find_by_code(con).name
          @tb_arbitman_expire_log.expire=params[:tb_arbitman_expire_logs][:expire]
          @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
          @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
          @tb_arbitman_expire_log.user = session[:user_code]
          @tb_arbitman_expire_log.action_type = '0003'
          @tb_arbitman_expire_log.u_time = Time.now
          @tb_arbitman_expire_log.save
          
          #将相应的信息添加到当前聘请仲裁员表
          @tb_arbitmannow = TbArbitmannow.new
          @tb_arbitmannow.used='Y'
          @tb_arbitmannow.arbitman_num=con
          @tb_arbitmannow.u = session[:user_code]
          @tb_arbitmannow.u_t = Time.now()
          @tb_arbitmannow.save 
          
        end
         
      end  
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="批量增聘仲裁员失败！"
      render :action=>"new_dismiss",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="批量增聘仲裁员成功！"  
      redirect_to :action=>"list_arbitmannow" 
    end
      
  end

  #新建解聘理由的页面
  def new_dismiss
    @tb_arbitman_expire_logs = TbArbitmanExpireLog.new
    @arbitman_name = TbArbitman.find_by_code(params[:id])
    @tb_arbitman_expire_logs.dt = Date.today
    @tb_arbitman_expire_logs.dt
  end
  #确定解聘的操作
  def create_dismiss
    begin
      @tb_arbitman_expire_log = TbArbitmanExpireLog.new(params[:tb_arbitman_expire_logs])
      @tb_arbitman_expire_log.action_type = '0001'
      @tb_arbitman_expire_log.arbitman_num = params[:id]
      @tb_arbitman_expire_log.arbitman_name = TbArbitman.find_by_code(params[:id]).name
      @tb_arbitman_expire_log.user = session[:user_code]
      @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
      @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
      @tb_arbitman_expire_log.expire = params[:tb_arbitman_expire_logs][:expire]
      @tb_arbitman_expire_log.u_time = Time.now
      @tb_arbitman_expire_log.save
      #将相应的仲裁员在聘信息从当前聘请仲裁员表中删除
      @tb_arbitmannow = TbArbitmannow.find_by_arbitman_num(params[:id])
      @tb_arbitmannow.destroy
            
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="解聘仲裁员失败！"
      render :action=>"new_dismiss",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="解聘仲裁员成功！"
      redirect_to :action=>"list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #新建续聘理由记录
  def new_continuation
    @tb_arbitman_expire_logs = TbArbitmanExpireLog.new
    @arbitman_name = TbArbitman.find_by_code(params[:id])
    @tb_arbitman_expire_logs.dt = Date.today
  end
  #创建续聘理由记录,只添加记录到tb_arbitman_expire_log表
  def create_continuation
    @tb_arbitman_expire_log = TbArbitmanExpireLog.new(params[:tb_arbitman_expire_logs])
    @tb_arbitman_expire_log.arbitman_num = params[:id]
    @tb_arbitman_expire_log.arbitman_name = TbArbitman.find_by_code(params[:id]).name
    @tb_arbitman_expire_log.expire = params[:tb_arbitman_expire_logs][:expire]
    @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
    @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
    @tb_arbitman_expire_log.user = session[:user_code]
    @tb_arbitman_expire_log.u_time = Time.now
    @tb_arbitman_expire_log.action_type = '0002'
    if @tb_arbitman_expire_log.save
      flash[:notice] = "续聘操作成功！"
      redirect_to :action => "list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      redirect_to :action => "new_dismiss",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def new_continuation_many
    @tb_arbitman_expire_logs=TbArbitmanExpireLog.new
    @tb_arbitman_expire_logs.dt=Date.today()
  end
  #集体续聘操作
  def create_continuation_many
    @condi_k = params[:condi_k]
    array_con = @condi_k.split(",")
    begin
      array_con.each do |con|
        @tb_arbitman_expire_log = TbArbitmanExpireLog.new
        @tb_arbitman_expire_log.arbitman_num = con
        @tb_arbitman_expire_log.arbitman_name = TbArbitman.find_by_code(con).name
        @tb_arbitman_expire_log.expire = params[:tb_arbitman_expire_logs][:expire]
        @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
        @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
        @tb_arbitman_expire_log.user = session[:user_code]
        @tb_arbitman_expire_log.u_time = Time.now
        @tb_arbitman_expire_log.action_type = '0002'
        @tb_arbitman_expire_log.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "批量续聘操作失败！"
      redirect_to :action => "list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "批量续聘操作成功！"
      redirect_to :action => "list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def new_dismiss_many
    @tb_arbitman_expire_logs=TbArbitmanExpireLog.new
    @tb_arbitman_expire_logs.dt=Date.today()
  end
  #集体解聘操作
  def create_dismiss_many
    @condi_s = params[:condi_s]
    array_dis = @condi_s.split(",")
    begin
      array_dis.each do |dis|
        @tb_arbitman_expire_log = TbArbitmanExpireLog.new
        @tb_arbitman_expire_log.arbitman_num = dis
        @tb_arbitman_expire_log.arbitman_name = TbArbitman.find_by_code(dis).name
        @tb_arbitman_expire_log.expire = params[:tb_arbitman_expire_logs][:expire]
        @tb_arbitman_expire_log.dt = params[:tb_arbitman_expire_logs][:dt]
        @tb_arbitman_expire_log.reason = params[:tb_arbitman_expire_logs][:reason]
        @tb_arbitman_expire_log.user = session[:user_code]
        @tb_arbitman_expire_log.u_time = Time.now
        @tb_arbitman_expire_log.action_type = '0001'
        @tb_arbitman_expire_log.save
        #将相应的仲裁员在聘信息从当前聘请仲裁员表中删除
        @tb_arbitmannow = TbArbitmannow.find_by_arbitman_num(dis)
        @tb_arbitmannow.destroy
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "批量解聘操作失败！"
      redirect_to :action => "list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "批量解聘操作成功！"
      redirect_to :action => "list_arbitmannow",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #选择仲裁员
  def arbitman_select
    @hant_search_1_page_name="arbitman_select"
    @hant_search_1=[['char','spell','姓名拼音缩写','text',[]],['char','code','仲裁员编码','text',[]],['char','name','姓名','text',[]]]
    @page = params[:page]
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
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
    @tb_arbitman_pages,@tb_arbitmen=paginate(:tb_arbitmen,:conditions => c,:order=>"id",:per_page=>@page_lines.to_i)
  end
  ##############################################################################
  #私有函数
  ##############################################################################  
  private
  def report()
    @years=""
    y=2000
    now=Time.now.year
    @years=@years+"<option value='"+y.to_s+"'>"+y.to_s+"</option>"
    y=y+1
    while y<=now
      @years=@years+","+"<option value='"+y.to_s+"'>"+y.to_s+"</option>"
      y=y+1
    end
    @page=page

    render "st_report/report"
  end
  #建立查询语句
  def prepare_sql(name,type,year,agemin,agemax)
    sql=["select insts.inst_name as inst_name, ifnull(cnt.cnt,0) as cnt
            from (select * from institutes where inst_id<>'00') insts
            LEFT join
            (
              select institute,count(journal_id) as cnt
              from ordered_journals
              where yea=? and to_order=1 and ordered='是'
              group by institute
            ) as cnt
            on insts.inst_id=cnt.institute",year]
        
    select_str = "select tb_arbitmannows.expire, tb_arbitmannows.abirtman_id, tb_arbitmannows.status,
                      tb_arbitmen.name, tb_arbitmen.birthday from tb_arbitmannows,tb_arbitmen "
    where_str = "tb_arbitmannows.arbitman_id = tb_arbitman.code and expire = ? and name = ? and status = ?
    "
    sql = [select_str + where_str,year,name,type]
    return sql
                       
    
  end
    
  
end
