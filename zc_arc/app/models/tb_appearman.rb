class TbAppearman < ActiveRecord::Base
  validates_presence_of :name ,:message => "请填写出庭人员姓名"
end
