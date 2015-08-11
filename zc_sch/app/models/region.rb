class Region < ActiveRecord::Base
  
  validates_presence_of :code, :message => "请填写编号"
  validates_presence_of :name, :message => "请填写名称"
  def validate_on_create
    if Region.find(:all,:conditions=>"code='#{code}'").empty?
    else
      errors.add(:code,"编码重复！")
    end      
  end
  def validate_on_update
    if Region.find(:all,:conditions=>"id<>#{id} and code='#{code}'").empty?
    else
      errors.add(:code,"编码重复！!")
    end      
  end
  
end
