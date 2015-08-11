class Role < ActiveRecord::Base
    validates_uniqueness_of :code,:message=>"角色编码重复,请重新输入！"
    validates_presence_of :code ,:message => "角色编码不能为空"
    validates_uniqueness_of :name,:message=>"角色名称重复,请重新输入！"
    validates_presence_of :name ,:message => "角色名称不能为空"
    
    def validate
      if self.code=="9001"  or self.code=="9002"
        errors.add(:code,"9001、9002为固定编码！")
      end   
    end
end
