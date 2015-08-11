class TbAmail < ActiveRecord::Base
  #validates_presence_of :arbitman ,:message => "当事人不能为空"
  validates_presence_of :receviceman ,:message => "接收人不能为空"
end
