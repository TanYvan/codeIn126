class TbEducate < ActiveRecord::Base
    def self.find_educates(arbitman_num)
       @arbitman_num = arbitman_num
       find(:all, :conditions =>["arbitman = ? and used = 'Y'",@arbitman_num], :order=> "id")
    end
end
