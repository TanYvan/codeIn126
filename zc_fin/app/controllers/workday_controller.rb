#用于计算每一天是礼拜几，是否工作日
#创建人  苏获
#创建时间 20090518
class WorkdayController < ApplicationController
    def workday_index
        @year2=params[:year2]
        if @year2!=nil
          if WorkdayYear.find_by_year(@year2)==nil
            flash[:notice]="#{@year2}年日历还未创建！"
            render :action=>"workday_index"
          else
            @year_months = TbDictionary.find(:all, :conditions => ["typ_code = ? and state = 'Y'",9018])
          end
        end
    end


    #创建一年的日期记录
    def insertday
        @year1 = params[:year1]
        if WorkdayYear.find_by_year(@year1)!=nil
          flash[:notice]="#{@year1}年日历早已经创建过了！"
          render :action=>"workday_index"
        else
          dates_of_year(@year1)
          flash[:notice]="#{@year1}年日历创建成功！"
        end
        
    end
    #某一年的工作日列表
    def list_workday
        @month = params[:month].slice(2, 3)
        @workdays_months = Workday.find(:all, :conditions => ["year = ? and month = ?",params[:year],@month])
    end
    #编辑具体日期，设置其不为工作日
    def unset_date
        array_time =  params[:date].split('-')
        @year = array_time[0]
        @month = '00'+array_time[1]
        @workday = Workday.find(:first, :conditions => ["date = ? ",params[:date]])
        @workday.isworkday = '0'
        if @workday.save!
            flash[:notice] = "修改成功！"
            redirect_to :action => "list_month", :year => @year, :month => @month
        else
            flash[:notice] = "修改失败！"
            redirect_to :action => "list_month", :year => @year, :month => @month
        end
    end
    #编辑具体日期，设置其为工作日
    def set_date
        array_time =  params[:date].split('-')
        @year = array_time[0]
        @month = '00'+array_time[1]
        @workday = Workday.find(:first, :conditions => ["date = ? ",params[:date]])
        @workday.isworkday = '1'
        if @workday.save!
            flash[:notice] = "修改成功！"
            redirect_to :action => "list_month", :year => @year, :month => @month
        else
            flash[:notice] = "修改失败！"
            redirect_to :action => "list_month", :year => @year, :month => @month
        end
    end

    #聂灵灵 2009-5-21 工作日管理
    #把一周从周一到周日排为1-7；查月对应的星期的值：1，2，3，4，5，6，0，放在每行对应的1-7位置，如果查出的是周日值是0，
    #对应放在星期日下面；把它们放在一个数组中，在页面显示数组对应的值
    def list_month
       @month = params[:month].slice(2, 3)
       @workdays_months = Workday.find(:all ,:order=>"date",:conditions => ["year = ? and month = ?",params[:year],@month])
       @workdays_months_first = Workday.find(:first, :conditions => ["year = ? and month = ?",params[:year],@month])
       @arr1=[]
       @arr2=[]
       @arr3=[]
       b=@workdays_months_first.weekday
       if b=='0'
         e=7
       else
         e=b.to_i
       end
       #找出日对应的假期，放在数组中
       for d in @workdays_months
         @arr1[e]=d.date.to_s(:db)
         @arr2[e] = d.isworkday
         @arr3[e] = d.date
         e=e+1
       end

    end
    ##############################################################################################################
    private
    #计算这年是否闰年，插入相应的数据
    def dates_of_year(year)
        array_small = %w[01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30]

        array_common = %w[01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28]
        array_leap = %w[01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29]
        array = %w[01 03 04 05 06 07 08 09 10 11 12]
        begin
            #除2月份外的月份的处理，全当30天计算
            array.each { |m|
                array_small.each { |day1|
                    @workday = Workday.new
                    @workday.year = year
                    @workday.month = m
                    @workday.date = year + @workday.month + day1
                    @workday.weekday = weekday(year.to_i,m.to_i,day1.to_i)
                    @workday.isworkday = isworkday(@workday.weekday)
                    @workday.user = session[:user_year]
                    @workday.u_time = Time.now
                    @workday.save! }
            }


            #对二月份的处理
            if (year.to_i % 4 == 0 and year.to_i % 100 != 0) or (year.to_i % 400 == 0)
                #闰年的2月29天
                array_leap.each { |day_leap|
                    @workday = Workday.new
                    @workday.year = year
                    @workday.month = '02'
                    @workday.date = year + @workday.month + day_leap
                    @workday.weekday = weekday(year.to_i,02,day_leap.to_i)
                    @workday.isworkday = isworkday(@workday.weekday)
                    @workday.user = session[:user_year]
                    @workday.u_time = Time.now
                    @workday.save!
                }

                #平年的2月28天
            else
                array_common.each { |day_common|
                    @workday = Workday.new
                    @workday.year = year
                    @workday.month = '02'
                    @workday.date = year + @workday.month + day_common
                    @workday.weekday = weekday(year.to_i,02,day_common.to_i)
                    @workday.isworkday = isworkday(@workday.weekday)
                    @workday.user = session[:user_year]
                    @workday.u_time = Time.now
                    @workday.save!
                }

            end
            #少数月份31号的处理
            array_big = %w[01 03 05 07 08 10 12]
            array_big.each { |mon|
                @workday = Workday.new
                @workday.year = year
                @workday.month = mon
                @workday.date = year + @workday.month + '31'
                @workday.weekday = weekday(year.to_i,mon.to_i,31)
                @workday.isworkday = isworkday(@workday.weekday)
                @workday.user = session[:user_year]
                @workday.u_time = Time.now
                @workday.save!
            }
            #引用处理法定节日的函数，设置元旦、五一和国庆为非工作日
            vacation_date(year)
        rescue ActiveRecord::RecordNotSaved
            flash[:notice] = "插入记录失败！"
            redirect_to :action => "workday_index"
        else
            flash[:notice] = "成功输入记录！"
            wd=WorkdayYear.new()
            wd.year=year
            wd.used='Y'
            wd.save
            redirect_to :action => "workday_index",:year => year
        end
    end



    #计算这一天是礼拜几,用的蔡勒公式
    def weekday(year,month,date)
        if (month == 01 or month == 02)
            month_used = month + 12
            year_used = year - 1
            c = year_used/100  #年的高两位
            y = (year_used % 100)  #年的低两位
            #puts c.to_s+"  "+y.to_s + month_used.to_s
        else
            c = year/100  #年的高两位
            y = (year % 100)  #年的低两位
            month_used = month
            #puts c.to_s+"  "+y.to_s + month_used.to_s
        end
        w = ((y + y/4 + c/4 -2*c + 13*(month_used + 1)/5 + date -1) % 7)
        return w
    end
    #判断是不是工作日
    def isworkday(w)
        if (w == 0 or w == 6)
            return 0
        else
            return 1
        end
    end
    #将元旦、五一和十一设定成非工作日
    def vacation_date(year)
        #生成查询项
        @newyear = year + "-01-01"
        @laborday = year + "-05-01"
        @nationalday = year + "-10-01"
        #将元旦设为非工作日
        @new_year = Workday.find(:first, :conditions => ["date = ?",@newyear])
        @new_year.isworkday = 0
        @new_year.save!
        #将五一设为非工作日
        @labor_day = Workday.find(:first, :conditions => ["date = ?",@laborday])
        @labor_day.isworkday = 0
        @labor_day.save!
        #将国庆设为非工作日
        @national_day = Workday.find(:first, :conditions => ["date = ?",@nationalday])
        @national_day.isworkday = 0
        @national_day.save!
    end

end
