=begin
创建人：聂灵灵
创建时间：2009-5-22
类的描述：此控制器是前台日常办公时输入年月后查看月对应的仲裁庭使用信息，可以查看仲裁庭的使用人，使用类型，使
          用时间及具体时间段
页面：
字典表信息列表:/book/arbitman_book
=end
class BookController < ApplicationController
  #根据预订的月份查询本月的日历表
  def arbitroom_book
    j = params[:j]
    #页面显示仲裁庭日历信息
    @year=params[:year]
    @month=params[:month]
    if @year==nil
      @year = Date.today.to_s.slice(0,4)
    end
    if @month==nil
      @month = Date.today.to_s.slice(5,2)
    end
    @workday1 = Workday.find(:first, :conditions => ["year = ? and month = ?",@year,@month])
    @book=0
    #如果输入年份为空或者没有输入，继续在本页面
    if @year==nil or @year=="" or @workday1==nil
      flash[:notice]="很遗憾，数据库中暂时没有" + "#{@year}" +"年" + "#{@month}"+"月的数据！"
      @book=0
      render :action=>"arbitroom_book"
      #如果输入年份，则查出本月的仲裁庭使用信息日历表
    else
      @book=1
      @workdays_months = Workday.find(:all ,:order=>"date",:conditions => ["year = ? and month = ?",@year,@month])
      @workdays_months_first = Workday.find(:first, :conditions => ["year = ? and month = ?",@year,@month])
      @arr1=[]
      @arr2=[]
      @arr3=[]
      b=@workdays_months_first.weekday
      if b=='0' #礼拜天--周日
        e=7
      else
        e=b.to_i
      end
      #找到日历第一天及对应的星期，以此后每天天数循环累加放在数组@arr1[]中；
      #把这一天作为条件查询出仲裁庭的当天所有使用信息，放在一个数组里面，在页面显示出来
      for d in @workdays_months
        @arr1[e]=d.date.to_s(:db)
        @arr3[e]=d.date
        a=''
        #niell 2009-6-1 添加仲裁庭下拉框根据仲裁庭、年月查询仲裁庭月使用信息
        #如果选择仲裁庭，则查看相应仲裁庭使用信息；如果没有，就根据年月查看所有仲裁庭使用信息
        if params[:j]!=nil
          sroom=params[:j][:sittingplace]
        end
        if sroom==nil or sroom==""
          @room="所有"
          @bookroom=TbArbitroom.find(:all,:conditions=>"sittingdate='#{d.date.to_s(:db)}'and used='Y'",:order=>"open_t")
        else
          @room=TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{sroom}' and data_val<>'0000'").data_text
          @bookroom=TbArbitroom.find(:all,:conditions=>"sittingdate='#{d.date.to_s(:db)}' and used='Y' and sittingplace='#{sroom}'",:order=>"open_t")
        end
        #根据查询条件，遍历仲裁庭使用效果
        for s in @bookroom
          c=TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{s.usestyle}' and data_val<>'0000'").data_text
          q=TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{s.sittingplace}' and data_val<>'0000'").data_text
          if s.usestyle=='0001' or s.usestyle=='0002'
            uuu=User.find_by_code(s.u).name
          else
            uuu=s.userId
          end
          a=a+"预订人:#{uuu}<br>仲裁庭:#{q}<br>使用类型:#{c}<br>时间:#{s.open_t}-#{s.close_t}<br>时长:#{s.usetime}小时"
          if s.usestyle=='0001'
            arbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{s.recevice_code}' and used='Y'",:order=>"arbitmantype")
            for arbitm in arbitman
              @arbitA = TbArbitman.find(:first,:conditions=>"code='#{arbitm.arbitman}' and used='Y'")
              if @arbitA!=nil
                @nameA = @arbitA.name
              end
              a=a+"<br>" + TbDictionary.find(:first,:conditions=>"typ_code='0014' and data_val='#{arbitm.arbitmantype}' and data_val<>'0000'").data_text + ":" + @nameA
            end
          end
          if s.usestyle=='0001' or s.usestyle=='0002'
            a = a + PubTool.get_parties(s.recevice_code,1) + PubTool.get_parties(s.recevice_code,2)
          end
          #开庭的案件 不能修改、删除；预订仲裁庭的可以
          if s.usestyle!='0001' && s.usestyle!='0002'
            a=a + "<br>"+ "<div align='center'><a href='/book/arbitroom_edit?id=#{s.id}'>"+"修改"+"</a>"+ "  "+"<a href=\"/book/arbitroom_delete?id=#{s.id}\" onclick=\"return confirm('您确定要删除吗？');\">"+"删除"+"</a></div>"
          end
          a = a + "<hr size='1' width='90%' color='#0000FF' noshade>"
        end
        @arr2[e]=a+"<div align='center'><a href='/book/arbitroom_new?date1=#{@arr3[e]}'>"+"预订"+"</a></div>"
        e=e+1
      end

    end
  end
  #2009-10-12 聂灵灵 仲裁庭预订增删改
  def arbitroom_new
    @arbitroom=TbArbitroom.new()
    @arbitroom.sittingdate=params[:date1]
  end
  def arbitroom_create
    @y=Date.today.to_s.slice(0,4)
    @m=Date.today.to_s.slice(5,2)
    @arbitroom=TbArbitroom.new(params[:arbitroom])
    @arbitroom.u=session[:user_code]
    @arbitroom.u_t=Time.now()
    if @arbitroom.save
      flash[:notice]="预订成功"
      redirect_to :action=>"arbitroom_book",:year=>@y,:month=>@m
    else
      flash[:notice]="预订失败"
      render :action=>"arbitroom_new",:year=>@y,:month=>@m
    end
  end

  def arbitroom_edit
    @arbitroom=TbArbitroom.find(params[:id])
  end

  def arbitroom_update
    @y=Date.today.to_s.slice(0,4)
    @m=Date.today.to_s.slice(5,2)
    @arbitroom=TbArbitroom.find(params[:id])
    @arbitroom.u=session[:user_code]
    @arbitroom.u_t=Time.now()
    if @arbitroom.update_attributes(params[:arbitroom])
      flash[:notice]="修改成功"
      redirect_to :action=>"arbitroom_book",:year=>@y,:month=>@m
    else
      flash[:notice]="修改失败"
      render :action=>"arbitroom_edit",:year=>@y,:month=>@m
    end
  end

  def arbitroom_delete
    @y=Date.today.to_s.slice(0,4)
    @m=Date.today.to_s.slice(5,2)
    @arbitroom=TbArbitroom.find(params[:id])
    @arbitroom.used="N"
    @arbitroom.u=session[:user_code]
    @arbitroom.u_t=Time.now()
    if @arbitroom.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"arbitroom_book",:year=>@y,:month=>@m
  end
  #生成文档查看
  def to_w_a
    #页面显示仲裁庭日历信息
    @year=params[:year]
    @month=params[:month]
    if @year==nil
      @year = Date.today.to_s.slice(0,4)
    end
    if @month==nil
      @month = Date.today.to_s.slice(5,2)
    end
    @workday1 = Workday.find(:first, :conditions => ["year = ? and month = ?",@year,@month])
    @book=0
    #如果输入年份为空或者没有输入，继续在本页面
    if @year==nil or @year=="" or @workday1==nil
      flash[:notice]="很遗憾，数据库中暂时没有" + "#{@year}" +"年" + "#{@month}"+"月的数据！"
      @book=0
      render :action=>"arbitroom_book"
      #如果输入年份，则查出本月的仲裁庭使用信息日历表
    else
      @book=1
      @workdays_months = Workday.find(:all ,:order=>"date",:conditions => ["year = ? and month = ?",@year,@month])
      @workdays_months_first = Workday.find(:first, :conditions => ["year = ? and month = ?",@year,@month])
      @arr1=[]
      @arr2=[]
      b=@workdays_months_first.weekday
      if b=='0'
        e=7
      else
        e=b.to_i
      end
      #找到日历第一天及对应的星期，以此后门天数循环累加放在数组@arr1[]中；
      #把这一天作为条件查询出仲裁庭的当天所有使用信息，放在一个数组里面，在页面显示出来
      for d in @workdays_months
        @arr1[e]=d.date.to_s(:db)
        a=''
        #niell 2009-6-1 添加仲裁庭下拉框根据仲裁庭、年月查询仲裁庭月使用信息
        #如果选择仲裁庭，则查看相应仲裁庭使用信息；如果没有，就根据年月查看所有仲裁庭使用信息
        if params[:j]!=nil
          sroom=params[:j][:sittingplace]
        end
        if sroom==nil or sroom==""
          @room="所有仲裁庭"
          @bookroom=TbArbitroom.find(:all,:conditions=>"sittingdate='#{d.date.to_s(:db)}'and used='Y'",:order=>"open_t")
        else
          @room=TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{sroom}' and data_val<>'0000'").data_text
          @bookroom=TbArbitroom.find(:all,:conditions=>"sittingdate='#{d.date.to_s(:db)}'and used='Y' and sittingplace='#{sroom}'",:order=>"open_t")
        end
        #根据查询条件，遍历仲裁庭使用效果
        for s in @bookroom
          #          c=TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{s.usestyle}' and data_val<>'0000'").data_text
          #          q=TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{s.sittingplace}' and data_val<>'0000'").data_text
          if s.usestyle=='0001' or s.usestyle=='0002'
            uuu=User.find_by_code(s.u).name
          else
            uuu=s.userId
          end
          #          a=a + "预订人:#{uuu}<br>仲裁庭:#{q}<br>使用类型:#{c}<br>时间:#{s.open_t}-#{s.close_t}<br>时长:#{s.usetime}小时"
          if s.usestyle=='0001'
            @case=TbCase.find_by_recevice_code(s.recevice_code)
            casecode1=@case.case_code.slice(5,@case.case_code.length-1)
            a=a + "<div align='left'>#{s.open_t} #{casecode1}"
            if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
              cm1=" 独<strong>:</strong>"+SysArg.new.independent_arbitrator(s.recevice_code)+"</div>"
            else
              cm1=" 首<strong>:</strong>"+SysArg.new.chief_arbitrator(s.recevice_code)+"</div>"+"仲:"+SysArg.new.applicant_arbitrator(s.recevice_code)+" "+SysArg.new.respondent_arbitrator(s.recevice_code)+"<br/>"
            end
            a=a+cm1+"协:#{uuu}"
          else
            a=a + "#{s.open_t} #{uuu}"
          end
          a = a + "<br/>"
        end
        @arr2[e]=a
        e=e+1
      end

    end
  end
  
end
