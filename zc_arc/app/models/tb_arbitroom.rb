class TbArbitroom < ActiveRecord::Base
  #validates_presence_of :userId ,:message => "请填写预订人姓名"
  validates_presence_of :usetime ,:message => "请填写占庭时间"
  validates_presence_of :sittingdate ,:message => "请选择使用日期"
  def  validate
      if self.sittingdate=="" or self.sittingdate==nil
            errors.add(:sittingdate,"开庭日期不能为空！")
      end    
      if  self.close_t<=self.open_t 
          errors.add(:close_t,"闭庭时间错误！闭庭时间必须大于开庭时间") 
      end
      if  self.usetime==""
        errors.add(:usetime , "请填写占庭时间")
      end
  end
  
  def  validate_on_create
      if  TbArbitroom.find(:all,:conditions=>"used='Y' and sittingplace='#{self.sittingplace}' and sittingdate='#{self.sittingdate}' and ((open_t<'#{self.open_t}' and close_t>'#{self.open_t}') or (open_t<'#{self.close_t}' and close_t>'#{self.close_t}') or (open_t>='#{self.open_t}' and close_t<='#{self.close_t}'))").empty?
      else     
          #errors.add_to_base("仲裁庭使用时间冲突！请修改开庭时间、闭庭时间。")        
          errors.add(:open_t,"与现有仲裁庭使用情况冲突！请修改开庭时间、闭庭时间。") 
          errors.add(:close_t,"与现有仲裁庭使用情况冲突！请修改开庭时间、闭庭时间。") 
      end          
  end
  
  def  validate_on_update
      if  TbArbitroom.find(:all,:conditions=>"used='Y' and sittingplace='#{self.sittingplace}' and  id <> #{self.id} and sittingdate='#{self.sittingdate}' and ((open_t<'#{self.open_t}' and close_t>'#{self.open_t}') or (open_t<'#{self.close_t}' and close_t>'#{self.close_t}') or (open_t>='#{self.open_t}' and close_t<='#{self.close_t}'))").empty?
      else      
          #errors.add_to_base("仲裁庭使用时间冲突！请修改开庭时间、闭庭时间。") 
          errors.add(:open_t,"与现有仲裁庭使用情况冲突！请修改开庭时间、闭庭时间。") 
          errors.add(:close_t,"与现有仲裁庭使用情况冲突！请修改开庭时间、闭庭时间。") 
      end          
  end
  
end
