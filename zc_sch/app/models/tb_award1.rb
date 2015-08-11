class TbAward1 < ActiveRecord::Base
   validates_presence_of :arbitmannum ,:message => "请在组庭时选择参与仲裁员！"
end
