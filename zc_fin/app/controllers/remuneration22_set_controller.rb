class Remuneration22SetController < ApplicationController
  
  def list
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration22.find(:all,:order=>'p_typ',:conditions=>c) 
    end
  end
  
  def list_2
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration22.find(:all,:order=>'p_typ',:conditions=>c) 
    end
  end
   
  def edit
    @remun=TbRemuneration22.find(params[:id])
  end 
  
  def edit_2
    @remun=TbRemuneration22.find(params[:id])
  end

  def update
    @remun=TbRemuneration22.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='#{@remun.p_typ}' and  p='#{@remun.p}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],@remun.p_typ,@remun.p,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
      else
	flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
    end
  end
  
  def update_2
    @remun=TbRemuneration22.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='#{@remun.p_typ}' and  p='#{@remun.p}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],@remun.p_typ,@remun.p,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
        flash[:notice]="修改成功"
        redirect_to :action=>"list_2"
      else
	flash[:notice]="修改失败"
        render :action=>"edit_2",:id=>params[:id]
      end
    end
  end
   
  def delete
    @remun=TbRemuneration22.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='#{@remun.p_typ}' and  p='#{@remun.p}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],@remun.p_typ,@remun.p,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration22.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='#{@remun.p_typ}' and  p='#{@remun.p}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],@remun.p_typ,@remun.p,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
