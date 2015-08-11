class Workday < ActiveRecord::Base
  
  #今天的多少天后的日期
  def self.after_day(d)
    w1=Workday.find(:all,:conditions=>"date>'#{Date.today}' and isworkday='1'",:order=>"date",:limit=>d)                          
    for w2 in w1
      ww=w2
    end
    return ww.date
  end
  
  #今天的多少天前的日期
  def self.before_day(d)
    w1=Workday.find(:all,:conditions=>"date<'#{Date.today}' and isworkday='1'",:order=>"date desc",:limit=>d)                          
    for w2 in w1
      ww=w2
    end
    return ww.date
  end
  
  #某一天的多少天后的日期
  def self.day_after_day(dd,d)
    w1=Workday.find(:all,:conditions=>"date>'#{dd}' and isworkday='1'",:order=>"date",:limit=>d)                          
    for w2 in w1
      ww=w2
    end
    return ww.date
  end
  
  #某一天的多少天前的日期
  def self.day_before_day(dd,d)
    w1=Workday.find(:all,:conditions=>"date<'#{dd}' and isworkday='1'",:order=>"date desc",:limit=>d)                          
    for w2 in w1
      ww=w2
    end
    return ww.date
  end
  
end
