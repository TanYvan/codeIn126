class TbTzxs < ActiveRecord::Base

  def self.init(recevice_code,user_code)
    tzxs = TbTzxs.find(:first, :conditions => "used='Y' and recevice_code = #{recevice_code}")
    @case = TbCase.find_by_recevice_code(recevice_code)
    if tzxs == nil
      tzxs               = TbTzxs.new
      tzxs.recevice_code = recevice_code
      tzxs.case_code     = @case.case_code
      tzxs.general_code  = @case.general_code
      tzxs.u             = user_code
      tzxs.u_t           = Time.now()
      tzxs.save
    end
  end
  
end