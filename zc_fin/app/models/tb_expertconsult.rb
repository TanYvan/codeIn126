class TbExpertconsult < ActiveRecord::Base
  validates_uniqueness_of :code, :message => "此专家编号已经存在，请重新填写!"
  validates_presence_of :name ,:message => "请填写姓名"
  validates_presence_of :addr ,:message => "请填写地址"
  validates_presence_of :code ,:message => "请填写专家编号"
  validates_presence_of :tel ,:message => "请填写联系电话"
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
