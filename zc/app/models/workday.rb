class Workday < ActiveRecord::Base
  
  #今天的多少天后的日期
  def self.after_day(d)
    wd = Workday.find(:all,:conditions=>"date>'#{Date.today}' and isworkday='1'",:order=>"date",:limit=>d)
    return wd.last.date
  end
  
  #今天的多少天前的日期
  def self.before_day(d)
    wd = Workday.find(:all,:conditions=>"date<'#{Date.today}' and isworkday='1'",:order=>"date desc",:limit=>d)
    return wd.last.date
  end
  
  #某一天的多少天后的日期
  def self.day_after_day(dd,d)
    wd = Workday.find(:all,:conditions=>"date>'#{dd}' and isworkday='1'",:order=>"date",:limit=>d)
    return wd.last.date
  end
  
  #某一天的多少天前的日期
  def self.day_before_day(dd,d)
    wd = Workday.find(:all,:conditions=>"date<'#{dd}' and isworkday='1'",:order=>"date desc",:limit=>d)
    return wd.last.date
  end
  
end
