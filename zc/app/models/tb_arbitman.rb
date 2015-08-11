# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class TbArbitman<ActiveRecord::Base
  attr_accessor :password_confirmation
  has_many :tb_arbitman_sessions
  validates_presence_of :code, :message => "请填写仲裁员编号"
  #validates_presence_of :name ,:message => "请填写仲裁员姓名(系统内唯一)"
  validates_uniqueness_of :code, :message => "仲裁员编号不可重复"
  # validates_uniqueness_of :name, :message => "仲裁员姓名不可重复"
  #validates_presence_of :name_idcard, :message => "请填写仲裁员姓名(身份证)"
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


  def after_save
    task_a=Task_a.new
    task_a.t_25_by_arbitman(self.code)
  end

  #信息同步到arbitman_sub.
  def syn
    @sys_2000 = SysArg.find_by_code('2000')
    if @sys_2000 && @sys_2000.val=="1"
      a = ArbitmanSub.find_by_p_id(self.id)
      a = ArbitmanSub.new unless a
      a = PubTool.new.put_to(self,a )
      a.p_id = self.id
      a.save

      self.sub_id = a.id
      self.save
    end
  end
end
