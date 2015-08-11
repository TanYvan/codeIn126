# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class TbArbitman<ActiveRecord::Base
  has_many :tb_arbitman_sessions
  validates_presence_of :code, :message => "请填写仲裁员编号"
  validates_presence_of :name ,:message => "请填写仲裁员姓名"
  validates_uniqueness_of :code, :message => "仲裁员编号不可重复"
  # validates_uniqueness_of :name, :message => "仲裁员姓名不可重复"
  def self.find_arbitman
    find(:all,:conditions => ["used = 'Y'"], :order => "id")
  end
  #为仲裁员解聘、续聘所做查询
  def self.find_arbitmannow
    find(:all,:conditions => ["used = 'Y'"], :order => "id")
  end
  #由仲裁员编号获得仲裁员姓名
  def self.get_name(num)
    find_by_sql("select name from tb_arbitmen where code = ? and used = 'Y'",num)
  end
  #为仲裁员添加头像
  #    def tb_photo
  #        TbPhoto.new(self)
  #    end
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
