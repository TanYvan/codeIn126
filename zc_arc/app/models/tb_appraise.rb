class TbAppraise < ActiveRecord::Base
    def self.find_appraises(arbitman_num)
        find(:all, :conditions => ["arbitman = ? and used = 'Y'",arbitman_num], :order => :id)
    end
    #
    def self.find_arbitman
        find(:all,:conditions => ["used = 'Y'"], :select => "arbitman", :order => :id)
    end
end
