class TbResume < ActiveRecord::Base
    def self.find_resumes(arbitman_num)
       @arbitman_num = arbitman_num
       find(:all, :conditions =>["arbit_id = ? and used = 'Y'",@arbitman_num], :order=> "id") 
    end

    #信息同步到resume_sub.
    def syn
      @sys_2000 = SysArg.find_by_code('2000')
      if @sys_2000 && @sys_2000.val=="1"
        a = ResumeSub.find_by_p_id(self.id)
        a = ResumeSub.new unless a
        a = PubTool.new.put_to(self,a )
        a.p_id = self.id
        a.save

        self.sub_id = a.id
        self.save
      end
    end
end
