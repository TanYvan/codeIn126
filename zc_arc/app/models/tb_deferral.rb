class TbDeferral < ActiveRecord::Base
  validates_presence_of :counselor ,:message => "缓交方不能为空！"
  validates_numericality_of :deferral_money ,:message => "缓交金额应为数字型"
end
