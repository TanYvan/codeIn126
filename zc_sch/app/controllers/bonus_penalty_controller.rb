class BonusPenaltyController < ApplicationController
   
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
    
  def edit
    @remun=TbBonusPenalty.find(params[:id])
  end 
  
  def edit_2
    @remun=TbBonusPenalty.find(params[:id])
  end

  def update
    @remun=TbBonusPenalty.find(params[:id])
    if @remun.used=='Y' and @remun.extend_code==''
      @remun.u=session[:user_code]
      @remun.t=Time.now()
      if @remun.update_attributes(params[:remun]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
      else
	flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
    end
  end
  
  def update_2
    @remun=TbBonusPenalty.find(params[:id])
    if @remun.used=='Y' and @remun.extend_code==''
      @remun.u=session[:user_code]
      @remun.t=Time.now()
      if @remun.update_attributes(params[:remun]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list_2"
      else
	flash[:notice]="修改失败"
        render :action=>"edit_2",:id=>params[:id]
      end
    end
  end
  
  
end
