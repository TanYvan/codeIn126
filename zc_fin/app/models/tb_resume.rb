class TbResume < ActiveRecord::Base
    def self.find_resumes(arbitman_num)
       @arbitman_num = arbitman_num
       find(:all, :conditions =>["arbit_id = ? and used = 'Y'",@arbitman_num], :order=> "id") 
    end
end
