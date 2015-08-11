class TbParty < ActiveRecord::Base
  validates_presence_of :partyname ,:message => "请填写当事人名称"
  #validates_presence_of :addr ,:message => "请填写联系地址"
end
