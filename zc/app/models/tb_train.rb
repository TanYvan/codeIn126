class TbTrain < ActiveRecord::Base
    def self.find_trains(arbitman_num)
       @arbitman_num = arbitman_num
       find(:all, :conditions =>["arbitmannum= ? and used = 'Y'",@arbitman_num], :order=> "id")
    end
end
