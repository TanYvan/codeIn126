class RemunerationJixiao < ActiveRecord::Base
  validates_length_of :item5_remark, :maximum => 200, :message => "长度不得多余200个字符！"
  validates_length_of :item6, :maximum => 200, :message => "长度不得多余200个字符！"
end