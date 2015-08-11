class TbPeriodLog < ActiveRecord::Base
    validates_presence_of :period, :message => "请填写届信息"
    validates_presence_of :dt ,:message => "请填写增聘时间"
    def self.find_expirelogs
        find(:all,:conditions => ["used = 'Y'"],:order => "id")
    end
end
