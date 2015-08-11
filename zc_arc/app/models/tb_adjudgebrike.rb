class TbAdjudgebrike < ActiveRecord::Base
  validates_presence_of :linkman_name,:message=>"请填写终止方名称"
end
