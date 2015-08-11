class TbCasedelay < ActiveRecord::Base
  def validate
    if self.reason=="" or self.reason==nil or self.reason.strip==""
      errors.add(:reason,"请填写原因")
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
