class Special < ActiveRecord::Base
    def self.find_specialities(arbitman_num)
        @arbitman_num = arbitman_num
        find(:all, :conditions =>["arbitman_num = ? and used = 'Y'",@arbitman_num],:order => "id")        
    end
end
