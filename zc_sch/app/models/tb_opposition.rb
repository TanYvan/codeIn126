class TbOpposition < ActiveRecord::Base
  validates_presence_of :presenter, :message => "请填写异议人"
  validates_presence_of :properties, :message => "请填写异议内容"
end
