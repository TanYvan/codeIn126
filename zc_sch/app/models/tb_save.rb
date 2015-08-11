class TbSave < ActiveRecord::Base
  validates_presence_of :request_man ,:message => "申请保全人不能为空"
end
