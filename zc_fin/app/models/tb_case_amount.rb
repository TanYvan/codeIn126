class TbCaseAmount < ActiveRecord::Base
  validates_presence_of :f_money,:message=>"请填写金额"
  validates_presence_of :rate,:message=>"请填写汇率"
  validates_presence_of :rmb_money,:message=>"请填写金额"
  validates_numericality_of :rmb_money ,:message => "金额应为数字型"
  validates_numericality_of :f_money ,:message => "金额应为数字型"
  validates_numericality_of :rate ,:message => "汇率应为数字型"
  def validate 
    if self.f_money==nil or self.f_money<0 
      errors.add(:f_money,"非法的外币金额！")
    end
    if self.rate==nil or self.rate<0 
      errors.add(:rate,"非法的汇率！")
    end
    if self.rmb_money==nil  or self.rmb_money<0 
      errors.add(:rmb_money,"非法的金额！")
    end
  end
end
