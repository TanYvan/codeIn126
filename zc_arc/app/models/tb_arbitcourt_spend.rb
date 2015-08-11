class TbArbitcourtSpend < ActiveRecord::Base
     validates_presence_of :sittingdate ,:message => "请选择开庭日期"
     validates_numericality_of :rmb_money ,:message => "金额应为数字型"
end
