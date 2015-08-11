class MoneyLog < ActiveRecord::Base
  validates_numericality_of :rate ,:message => "汇率应为数字型"
end
