# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class Video
  def initialize
    
  end
  
  def get_v(recevice_code)
    case_code=TbCase.find_by_recevice_code(recevice_code).case_code
    case_code=case_code.slice( case_code.length - 7,7)
    ip_add=SysArg.find_by_code("0050")
    if  ip_add!=nil
      rrr="http://#{ip_add.val}/?c=#{case_code}-"
    else
      rrr="http://192.168.123.102/?c=#{case_code}-"
    end
    return rrr
  end
  
end
