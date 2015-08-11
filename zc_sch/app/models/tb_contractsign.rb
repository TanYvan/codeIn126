class TbContractsign < ActiveRecord::Base
   validates_presence_of :pactname ,:message=>"请填写合同编号及名称"
end
