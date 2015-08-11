class TbPartyanswer < ActiveRecord::Base
  validates_presence_of :party_id, :message => "申请人不能为空"
  def validate
    if self.receivedate>self.asenddate
      errors.add(:receivedate,"收到日期不能大于送交对方当事人日期，请重新填写")
    end
  end
end
