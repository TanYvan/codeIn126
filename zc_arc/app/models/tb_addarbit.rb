class TbAddarbit < ActiveRecord::Base
  validates_presence_of :requestMan, :message => "请填写提出人姓名"
  validates_presence_of :content, :message => "请填写补正裁决内容"
end
