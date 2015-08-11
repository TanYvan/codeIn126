=begin
创建人：聂灵灵
创建时间：2009-5-22
类的描述：此控制器是前台日常办公时输入年月后查看月对应的订房日历信息，可以查看订房的仲裁员及其案件号，订房时间，所订天数，订房日期，
          使用类型
页面：
字典表信息列表:/book_hotel/hotel
=end
class BookHotelController < ApplicationController
  def hotel
    @year=params[:year]
    @month=params[:month]
    if @year==nil
      @year = Date.today.to_s.slice(0,4)
    end
    if @month==nil
      @month = Date.today.to_s.slice(5,2)
    end
    @book=0
    @workday1 = Workday.find(:first, :conditions => ["year = ? and month = ?",@year,@month])
    #如果输入年份为空或者没有输入，继续在本页面
    if @year=="" or @year==nil or @workday1==nil
      flash[:notice]="很遗憾，数据库中暂时没有" + "#{@year}" +"年" + "#{@month}"+"月的数据！"
      @book=0
      render :action=>"hotel"
    else
      #如果输入年份，则查出本月的仲裁庭使用信息日历表
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
      #找到本月日历第一天，放在对应的星期下面，以此后面天数循环放在数组@arr1[]中
      #根据查询输入的年份和月份算出当月的日历格式；找出这个月的第一天，并确定它的日历位置，for循环中根
      #据日历的每一天查出对应的仲裁庭的当日所有信息，放在一个数组里面，在页面显示出来
      for d in @workdays_months
        @arr1[e]=d.date.to_s(:db)
        a=''
        @bookroom= TbArbithotel.find(:all,:conditions=>"usedate='#{d.date.to_s(:db)}'and used='Y'",:order=>"case_code")
        for s in @bookroom
          q=TbDictionary.find(:first,:conditions=>"typ_code='0029'  and  data_val='#{s.usestyle}'").data_text
          arb=""
          if s.arbitman!=nil and s.arbitman!='A' and s.arbitman!=' ' and s.arbitman!=''
            arb=TbArbitman.find_by_code(s.arbitman).name
          end
          a=a + "案件编号:#{s.case_code}<br>仲裁员:#{arb}<br>使用类型:#{q}<br>房间数量:#{s.rooms}间<br>住宿天数:#{s.days}天<hr size='1' width='90%' color='#0000FF' noshade>"
        end
        @arr2[e]=a
        e=e+1
      end
    end
  end
end
