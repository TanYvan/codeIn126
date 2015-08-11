class ExpertMeeting < ActiveRecord::Base
    validates_presence_of :meeting_title,:message => "请填写题目"
    validates_presence_of :record_by,:message => "请填写会议记录人"
    validates_presence_of :content,:message => "请填写具体内容"
end
