class TbTExtendCode < ActiveRecord::Base
  validates_uniqueness_of :t_extend_code,:message=>"发放编号重复！"
end
