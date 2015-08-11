class TbRemuneration6 < ActiveRecord::Base
  validates_presence_of :assistant, :message => "助理不能为空"
  validates_numericality_of :rmb ,:message => "报酬额应为数字型"
end
