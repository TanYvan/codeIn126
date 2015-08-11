class TbLanguage < ActiveRecord::Base
    def self.find_languages(arbitman_num)
       @arbitman_num = arbitman_num
        find(:all, :conditions =>["arbitman = ? and used = 'Y'",@arbitman_num],:order => "id")
    end
end
