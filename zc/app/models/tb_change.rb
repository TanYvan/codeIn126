class TbChange < ActiveRecord::Base
  validates_presence_of :arbitman ,:message => "仲裁员不能为空"
end
