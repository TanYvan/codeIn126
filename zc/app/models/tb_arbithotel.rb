class TbArbithotel < ActiveRecord::Base
  validates_presence_of :arbitman ,:message=>"请填写仲裁员"
  validates_presence_of :days ,:message=>"请填写住宿天数"
  validates_presence_of :rooms ,:message=>"请填写房间数量"
#  def validate
#    @a=TbCase.find(:first,:conditions=>"used='Y' and recevice_code='#{self.case_code}'")
#    if @a==nil or @a==""
#      errors.add(:case_code,"请填写正确的案件号")
#    end
#  end
end
