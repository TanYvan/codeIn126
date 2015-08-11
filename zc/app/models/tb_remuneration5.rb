class TbRemuneration5 < ActiveRecord::Base
  validates_presence_of :p,:message => "校核人员不能为空"
  validates_numericality_of :rmb ,:message => "报酬额应为数字型"
end
