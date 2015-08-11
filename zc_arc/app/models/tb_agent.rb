class TbAgent < ActiveRecord::Base
#  validates_presence_of :party_id ,:message => "请选择申请人"
  validates_presence_of :name ,:message => "请填写代理人姓名"
  validates_presence_of :party_id ,:message => "请选择当事人"
  validates_presence_of :company ,:message => "请输入代理人单位信息"
  #validates_presence_of :addr ,:message => "请填写联系人地址"
end
