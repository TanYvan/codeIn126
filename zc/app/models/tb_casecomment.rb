class TbCasecomment < ActiveRecord::Base
  validates_presence_of :use_time, :message => "请填写合议使用时间"
  validates_presence_of :casecomment_hour, :message => "请填写合议开始时间"
  validates_presence_of :casecomment_min, :message => "请填写合议开始时间"
end
