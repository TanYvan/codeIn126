class TbEvite < ActiveRecord::Base
  validates_presence_of :arbitman,:message=>"请选择回避者"
  validates_presence_of :reason,:message=>"请填写备注"
end
