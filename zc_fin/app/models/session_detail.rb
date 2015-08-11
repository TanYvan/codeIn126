class SessionDetail < ActiveRecord::Base
    has_many :tb_arbitman_sessions
    validates_presence_of :session_num, :message => "请填写活动编号" 
    validates_presence_of :session_name ,:message => "请填写活动名称" 
    validates_uniqueness_of :session_num, :message => "活动编号不可重复" 
    validates_uniqueness_of :session_name, :message => "活动名称不可重复"
    
    def self.find_sessions
        find(:all,:conditions => ["used = 'Y'"],:order => "id")
    end
end
