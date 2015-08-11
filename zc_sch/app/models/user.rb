class User < ActiveRecord::Base
      validates_uniqueness_of :code,:message=>"编码重复,请重新输入！"
      validates_uniqueness_of :name,:message=>"名称重复,请重新输入！"
#     validates_uniqueness_of :l_code,:message=>"咨询登录编码重复,请重新输入！"
      attr_accessor :password_confirmation
      #validates_confirmation_of :password,:message=>"密码效验错误，请重新输入！"
      def validate
          if self.password==""  or self.password==nil
            errors.add(:password,"请输入密码！")
            
          end   
      end
      
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
      
     validates_presence_of :code ,:message => "请输入用户名"
     validates_presence_of :name ,:message => "请输入用户名称"
end
