class TbCasepro < ActiveRecord::Base
  def validate
    if self.app1=="" or self.app1==nil
      errors.add(:app1,"请填写申请人信息及联系方式")
    end
    if self.keyword=="" or self.keyword==nil
      errors.add(:keyword,"系争合同争议性质")
    end
  end
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
