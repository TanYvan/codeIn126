class TbDeduction < ActiveRecord::Base
  validates_numericality_of :rmb ,:message => "金额应为数字型"
end
