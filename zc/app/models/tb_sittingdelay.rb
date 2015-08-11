class TbSittingdelay < ActiveRecord::Base
  validates_presence_of :reason ,:message => "请填写理由"
end
