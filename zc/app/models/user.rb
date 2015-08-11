require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :code ,:message => "请输入用户名"
  validates_presence_of :name ,:message => "请输入用户名称"
  validates_uniqueness_of :code,:message=>"编码重复,请重新输入！"
  validates_uniqueness_of :name,:message=>"名称重复,请重新输入！"
  attr_accessor :password_confirmation

  private
  def validate_on_create
    u=User.find_by_l_code(self.l_code)
    if self.l_code!=""  and  self.l_code!=nil and u!=nil
      errors.add(:l_code,"咨询登录编码重复,请重新输入！")
    end
  end

  def validate_on_update
    u=User.find_by_sql("select * from users where id<>#{self.id} and l_code='#{self.l_code}'")
    if self.l_code!=""  and  self.l_code!=nil
      if u.empty?
      else
        errors.add(:l_code,"咨询登录编码重复,请重新输入！")
      end
    end
  end

  #用户登录验证，如果登录成功，则用户信息存入session，返回true，否则返回false
  def self.authenticate(code, password)
    user = find(:first, :conditions => ["code=? and used='Y'",code])
    if !user.nil? &&
        user.password == Digest::SHA1.hexdigest(password)
      user.name
    end
  end

end
