class RemunerationSetReportAController < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      @remun_state={"N"=>"不发放","Y"=>"提交出纳发放"}
    end
  end
  
  def state_change
    @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
    if @case.remun_state=='N'
      @case.remun_state='Y'
    else
      @case.remun_state='N'
    end
    @case.save
    redirect_to :action=>"list"
  end
  
end
