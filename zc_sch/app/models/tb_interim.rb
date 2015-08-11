class TbInterim < ActiveRecord::Base
  validates_presence_of :rule_num, :message => "请填写裁决书号"
  validates_presence_of :rule_reason, :message => "请填写裁决理由"
  validates_presence_of :rule_content, :message => "请填写裁决内容"
  validates_presence_of :approval_man, :message => "请填写审批人"
end
