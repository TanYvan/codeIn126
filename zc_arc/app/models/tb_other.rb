class TbOther < ActiveRecord::Base
  validates_presence_of :content ,:message => "请填写内容"
end
