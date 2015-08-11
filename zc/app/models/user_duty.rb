class UserDuty < ActiveRecord::Base
  def validate_on_create
    d=UserDuty.find(:all,:conditions=>"user_code='"+user_code+"' and duty_code='"+duty_code+"'" )
    if d.empty?
    else
      errors.add_to_base("职务重复添加！")
    end
  end
  
  #判断是否为处长，是返回"Y"，否则返回"N"
  def self.is_chuzhang(user_code)
    count(:all, :conditions => ["user_code=? and duty_code='0001'", user_code]) > 0 ? "Y" : "N"
  end

  #判断是否为助理，是返回"Y"，否则返回"N"
  def self.is_zhuli(user_code)
    count(:all, :conditions => ["user_code=? and duty_code='0003'", user_code]) > 0 ? "Y" : "N"
  end

  #判断是否可以看财务数据
  def self.is_caiwu(user_code)
    count(:all, :conditions => ["user_code=? and duty_code='0009'", user_code]) > 0 ? "Y" : "N"
  end

end
