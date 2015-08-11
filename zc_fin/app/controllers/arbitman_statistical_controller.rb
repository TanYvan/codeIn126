#仲裁员统计的控制器
#添加人 苏获
#添加时间 20090626
class ArbitmanStatisticalController < ApplicationController
    #仲裁员聘用统计
    def employ_statistical
        @years = Expire.find(:all, :conditions => ["used = 'Y'"])
    end
    #仲裁员办案情况统计
    def handlecase_statistical
        
    end
end
