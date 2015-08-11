class ExpireB < ActiveRecord::Base
  validates_presence_of :expire, :message => "请填写届编号"
  validates_presence_of :remark ,:message => "请填写备注信息"
  validates_uniqueness_of :expire,:message=>"届编号重复,请重新输入！"
end
