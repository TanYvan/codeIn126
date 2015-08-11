#合议人员
class Commentarbitman < ActiveRecord::Base
  validates_presence_of :name ,:message => "请填写姓名"
  validates_presence_of :company ,:message => "请填写所在单位"
end
