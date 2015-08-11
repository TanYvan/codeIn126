class TbRemuneration3 < ActiveRecord::Base
  validates_presence_of :arbitman, :message => "仲裁员不能为空"
  validates_numericality_of :rmb ,:message => "报酬额应为数字型"
end
