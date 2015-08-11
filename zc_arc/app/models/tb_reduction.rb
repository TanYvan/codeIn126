class TbReduction < ActiveRecord::Base
  #validates_presence_of :counselor ,:message => "减交方不能为空！"
  validates_numericality_of :rmb_money ,:message => "减交金额应为数字型"
end
