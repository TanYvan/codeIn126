class RemunerationAward < ActiveRecord::Base
  validates_length_of :remark, :maximum => 200, :message => "长度不得多余200个字符！"
  validates_numericality_of :grade_xs ,:message => "等级为数字型"
end