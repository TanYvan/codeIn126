class TbOrg < ActiveRecord::Base
  validates_uniqueness_of :code, :message => "此机构编号已经存在，请重新填写!"
  validates_presence_of :name ,:message => "请填写姓名"
  validates_presence_of :addr ,:message => "请填写地址"
  validates_presence_of :code ,:message => "请填写机构编号"
  validates_presence_of :tel ,:message => "请填写联系电话"
end
