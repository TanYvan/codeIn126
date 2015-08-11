class Menu < ActiveRecord::Base
  validates_presence_of :code, :message => "请填写编号"
  validates_presence_of :name, :message => "请填写名称"
  def validate_on_create
    if Menu.find(:all,:conditions=>"role_code='#{role_code}' and code='#{code}'").empty?
    else
      errors.add(:code,"编码重复！")
    end      
  end
  def validate_on_update
    if Menu.find(:all,:conditions=>"id<>#{id} and role_code='#{role_code}' and code='#{code}'").empty?
    else
      errors.add(:code,"编码重复！")
    end      
  end
end
