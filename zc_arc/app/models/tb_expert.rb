class TbExpert < ActiveRecord::Base
  validates_presence_of :presenter,:message=>"请填写提出人姓名"
  validates_presence_of :problem,:message=>"请填写拟交专家咨询的问题"
end
