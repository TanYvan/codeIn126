class TbWitne < ActiveRecord::Base
  validates_presence_of :name ,:message => "请填写证人姓名"
  validates_presence_of :addr ,:message => "请填写联系人地址"
  validates_presence_of :tel ,:message => "请填写联系电话"
  validates_presence_of :party_id ,:message => "被申请人不能为空"
end
