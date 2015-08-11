class RemunerationSumController < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      @arbitman=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and typ='0001'",:order=>"id") 
      @assistant=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0002'",:order=>"id") 
      @jh=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0003'",:order=>"id") 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      @arbitman=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and typ='0001'",:order=>"id") 
      @assistant=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0002'",:order=>"id") 
      @jh=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0003'",:order=>"id") 
    end
  end
  
end
