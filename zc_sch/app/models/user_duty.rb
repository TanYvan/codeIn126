class UserDuty < ActiveRecord::Base
  def validate_on_create
    d=UserDuty.find(:all,:conditions=>"user_code='"+user_code+"' and duty_code='"+duty_code+"'" )
    if d.empty?
    else
      errors.add_to_base("职务重复添加！")
    end
  end
end
