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

  def edit_all
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y' and (typ='0001' or  typ='0002') and extend_code='' "
      @remun=TbBonusPenalty.find(:all,:conditions=>c,:order=>"typ,id") 
    end
  end
  
  def edit_all_2
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y' and (typ='0001' or  typ='0002') and extend_code='' "
      @remun=TbBonusPenalty.find(:all,:conditions=>c,:order=>"typ,id") 
    end
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
  
  def update_all
    c="recevice_code='#{session[:recevice_code_2]}' and used='Y' and (typ='0001' or  typ='0002') and  extend_code='' "
    @remun=TbBonusPenalty.find(:all,:conditions=>c,:order=>"typ,id") 
    for r in @remun
      if r.extend_code==''
        if params["bonus_name_"+r.id.to_s]!=nil
          @r_u=TbBonusPenalty.find(r.id)
          if @r_u.zc_rmb==params["zc_rmb_name_"+r.id.to_s].to_f
            @r_u.bonus=params["bonus_name_"+r.id.to_s]
            @r_u.penalty=params["penalty_name_"+r.id.to_s]
            @r_u.reason=params["reason_name_"+r.id.to_s]
            @r_u.u=session[:user_code]
            @r_u.t=Time.now()
            @r_u.save
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list"
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
  
  def update_all_2
    c="recevice_code='#{session[:recevice_code_2]}' and used='Y' and (typ='0001' or  typ='0002') and  extend_code='' "
    @remun=TbBonusPenalty.find(:all,:conditions=>c,:order=>"typ,id") 
    for r in @remun
      if r.extend_code==''
        if params["bonus_name_"+r.id.to_s]!=nil
          @r_u=TbBonusPenalty.find(r.id)
          if @r_u.zc_rmb==params["zc_rmb_name_"+r.id.to_s].to_f
            @r_u.bonus=params["bonus_name_"+r.id.to_s]
            @r_u.penalty=params["penalty_name_"+r.id.to_s]
            @r_u.reason=params["reason_name_"+r.id.to_s]
            @r_u.u=session[:user_code]
            @r_u.t=Time.now()
            @r_u.save
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list_2"
  end
  
end
