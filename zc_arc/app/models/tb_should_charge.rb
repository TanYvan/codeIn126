class TbShouldCharge < ActiveRecord::Base
  validates_presence_of :rmb_money ,:message => "金额不能为空"
  validates_presence_of :f_money ,:message => "金额不能为空"
  validates_presence_of :rate ,:message => "汇率不能为空"
  validates_numericality_of :rmb_money ,:message => "金额应为数字型"
  validates_numericality_of :f_money ,:message => "金额应为数字型"
  validates_numericality_of :rate ,:message => "汇率应为数字型"
#  def validate 
#    if self.f_money==nil or self.f_money<0 
#      errors.add(:f_money,"非法的外币金额！")
#    end
#    if self.rate==nil or self.rate<0 
#      errors.add(:rate,"非法的汇率！")
#    end
#    if self.rmb_money==nil or self.rmb_money<0 
#      errors.add(:rmb_money,"非法的金额！")
#    end
#  end
  
  def self.count_by_sql_wrapping_select_query(sql)
    sql = sanitize_sql(sql)
    count_by_sql("select count(*) from (#{sql}) as my_table")
  end
  
  
  def self.find_by_sql_with_limit(sql, offset, limit)
    sql = sanitize_sql(sql)
    add_limit!(sql, {:limit => limit, :offset => offset})
    find_by_sql(sql)
  end
  
end
