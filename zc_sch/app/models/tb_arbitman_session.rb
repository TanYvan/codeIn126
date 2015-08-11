class TbArbitmanSession < ActiveRecord::Base
    validates_presence_of :arbitman_num, :message => "请选择仲裁员" 
#    validates_presence_of :course_hour, :message => "请填写时长"
    def self.find_sessions
        find(:all,:conditions => ["added='y' and used = 'Y'"],:order =>"session_code")
    end    
    #找出某位仲裁员参与活动的列表
    def self.find_arbitman_sessions(arbitman_num)
        @arbitman_num = arbitman_num
        find(:all, :conditions => ["arbitman_num = ? and used = 'Y'",@arbitman_num], :order => "id")
    end
    
    def self.find_sessions_with_code(code)
        @code = code
        find(:all, :conditions => ["session_code = ? and used = 'Y'",@code])
    end
    #查找仲裁员应参加活动次数
    def self.find_should_count(arbitManNum)
        @sessions = find(:all, :conditions => ["arbitman_num = ? and used = 'Y'",arbitManNum])
        return @sessions.size
    end
    #查找仲裁员活动请假次数
    def self.find_leave_count(arbitManNum)
        @sessions = find(:all, :conditions => ["arbitman_num = ? and state = 0002 and used = 'Y'",arbitManNum])
        return @sessions.size
    end
    #查找仲裁员活动无故缺席次数
    def self.find_absent_count(arbitManNum)
        @sessions = find(:all, :conditions => ["arbitman_num = ? and state = 0003 and used = 'Y'",arbitManNum])
        return @sessions.size
    end
    #查找仲裁员实际参加活动次数
    def self.find_attend_count(arbitManNum)
        @sessions = find(:all, :conditions => ["arbitman_num = ? and state = 0001 and used = 'Y'",arbitManNum])
        return @sessions.size
    end
end
