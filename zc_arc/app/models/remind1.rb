class Remind1 < ActiveRecord::Base
  validates_presence_of :day1 ,:message => "请填写延期天数"
end
