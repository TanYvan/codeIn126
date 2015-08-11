class TbDoc < ActiveRecord::Base
  validates_presence_of :typ_code ,:message => "请选择类型"
end
