class TbRemuneration1 < ActiveRecord::Base
  validates_presence_of :h, :message => "请填写工作时间"
  validates_presence_of :arbitman, :message => "仲裁员不能为空"
  validates_numericality_of :h ,:message => "工作时间应为数字型"
  validates_numericality_of :rmb ,:message => "报酬额应为数字型"
end
