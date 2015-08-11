class Industry < ActiveRecord::Base
  set_table_name :industry

  #信息同步到industry_sub.
  def syn
    @sys_2000 = SysArg.find_by_code('2000')
    if @sys_2000 && @sys_2000.val=="1"
      a = IndustrySub.find_by_p_id(self.id)
      a = IndustrySub.new unless a
      a = PubTool.new.put_to(self,a )
      a.p_id = self.id
      a.save

      self.sub_id = a.id
      self.save
    end
  end
end
