class DeductController < ApplicationController
   
  def list
    @deduct_typ={"0001"=>"奖励","0002"=>"扣减",}
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
    @deduct_typ={"0001"=>"奖励","0002"=>"扣减",}
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      @arbitman=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and typ='0001'",:order=>"id") 
      @assistant=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0002'",:order=>"id") 
      @jh=TbBonusPenalty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and used='Y' and  typ='0003'",:order=>"id") 
    end
  end
   
  def new
    @remun=TbDeduction.new()
  end
  
  def new_2
    @remun=TbDeduction.new()
  end
   
  def create
     @remun=TbDeduction.new(params[:remun])
     @remun.recevice_code=session[:recevice_code_2]
     @remun.case_code=session[:case_code_2]
     @remun.general_code=session[:general_code_2]
     @remun.typ=params[:typ]
     @remun.p=params[:p]
     @remun.u=session[:user_code]
     @remun.u_t=Time.now()
     if @remun.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
        flash[:notice]="创建失败"
        render :action=>"new"
     end
     
  end
  
  def create_2
     @remun=TbDeduction.new(params[:remun])
     @remun.recevice_code=session[:recevice_code_2]
     @remun.case_code=session[:case_code_2]
     @remun.general_code=session[:general_code_2]
     @remun.typ=params[:typ]
     @remun.p=params[:p]
     @remun.u=session[:user_code]
     @remun.u_t=Time.now()
     if @remun.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
     else
        flash[:notice]="创建失败"
        render :action=>"new_2"
     end
     
  end
  
  def delete
     @remun=TbDeduction.find(params[:id])
     @remun.used="N"
     @remun.u=session[:user_code]
     @remun.u_t=Time.now()
     if @remun.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list"
  end
  
  def delete_2
     @remun=TbDeduction.find(params[:id])
     @remun.used="N"
     @remun.u=session[:user_code]
     @remun.u_t=Time.now()
     if @remun.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list_2"
  end
  
end
