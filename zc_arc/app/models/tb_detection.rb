class TbDetection < ActiveRecord::Base
  validates_presence_of :etectiond ,:message => "请填写检测单位"
  validates_presence_of :cost ,:message => "请填写费用"
end
