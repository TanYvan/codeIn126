class TbCasearbitman < ActiveRecord::Base
  validates_presence_of :arbitman ,:message => "仲裁员不能为空"
  def self.count_by_sql_wrapping_select_query(sql)
    sql = sanitize_sql(sql)
    count_by_sql("select count(*) from (#{sql}) as my_table")
  end


  def self.find_by_sql_with_limit(sql, offset, limit)
    sql = sanitize_sql(sql)
    add_limit!(sql, {:limit => limit, :offset => offset})
    find_by_sql(sql)
  end

#  def after_save
#    ReportTotal2ListA.report_list_a(self.recevice_code)
#  end
  def after_save
    task_a=Task_a.new
    task_a.t_25_by_recevice_code(self.recevice_code)
  end
  
end
