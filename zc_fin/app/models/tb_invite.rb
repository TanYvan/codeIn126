class TbInvite < ActiveRecord::Base   
    validates_presence_of  :reason,:message => "请填写拒绝理由"
    def self.find_invites
       find(:all,:conditions => ["used = 'Y'"], :order=> "id") 
    end
end
