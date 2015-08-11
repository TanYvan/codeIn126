class Ur < ActiveRecord::Base
  def validate_on_create
    u=Ur.find(:all,:conditions=>"user_code='"+user_code+"' and role_code='"+role_code+"'" )
    if u.empty?
    else
      errors.add_to_base("角色重复添加！")
    end
  end
end
