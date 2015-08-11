class TbArbitmanExpireLog < ActiveRecord::Base
  def self.find_expirelogs
    find(:all,:conditions => ["used = 'Y'"],:order => "id")
  end
end
