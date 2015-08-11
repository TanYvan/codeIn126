class TbOtherSpend < ActiveRecord::Base
  validates_numericality_of :rmb_money ,:message => "金额应为数字型"
end
