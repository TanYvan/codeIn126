class RegularMeeting < ActiveRecord::Base
  validates_presence_of :record_by ,:message=>"请填写会议记录人"
  validates_presence_of :content ,:message=>"请填写内容"
end
