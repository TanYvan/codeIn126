class TbInstrument < ActiveRecord::Base
  validates_presence_of :arbitman ,:message => "请选择仲裁员"
end
