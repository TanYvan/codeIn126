class FastMenu < ActiveRecord::Base
  def validate
    if self.code==""  or self.code==nil
      errors.add(:code,"快捷菜单编码不能为空！") 
    end 
    if self.name==""  or self.name==nil
      errors.add(:name,"快捷菜单名称不能为空！") 
    end 
    if self.menu_name==""  or self.menu_name==nil
      errors.add(:menu_name,"对应的树形菜单名称！") 
    end        
  end
end
