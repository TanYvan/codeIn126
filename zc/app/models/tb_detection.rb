class TbDetection < ActiveRecord::Base
  validates_presence_of :cost ,:message => "请填写费用"
end
