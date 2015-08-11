class TbPartyrequest < ActiveRecord::Base
  validates_presence_of :party_id ,:message => "被申请人不能为空"
  def validate
    if self.requestdate>self.rsenddate
      errors.add(:requestdate,"请求提交日期不能大于送交对方当事人日期，请重新填写")
    end
  end
end
