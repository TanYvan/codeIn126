class Expire < ActiveRecord::Base
  validates_presence_of :expire, :message => "请填写届编号"
  validates_presence_of :remark ,:message => "请填写备注信息"
end
