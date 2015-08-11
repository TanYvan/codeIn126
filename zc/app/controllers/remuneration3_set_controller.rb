class Remuneration3SetController < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'id',:conditions=>c) 
    end
  end
   
  def edit_all
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'arbitman',:conditions=>c) 
    end
  end
  
  def edit
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_2]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration3.find(params[:id])
  end 
  
  def edit_all_2
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration3.find(:all,:order=>'arbitman',:conditions=>c) 
    end
  end
  
  def edit_2
    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_2]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration3.find(params[:id])
  end

  def update_all
    c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
    @remun=TbRemuneration3.find(:all,:order=>'arbitman',:conditions=>c) 
    for r in @remun
      if TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{r.arbitman}' and used='Y' and extend_code=''")!=nil 
        if params["hid_name_"+r.id.to_s]!=nil
          @r_u=TbRemuneration3.find(r.id)
          if @r_u.rmb==params["old_rmb_name_"+r.id.to_s].to_f
            @r_u.grade=params["grade_name_"+r.id.to_s]
            @r_u.rmb=params["new_rmb_name_"+r.id.to_s]
            @r_u.remark=params["remark_name_"+r.id.to_s]
            @r_u.u2=session[:user_code]
            @r_u.t2=Time.now()
            if @r_u.save
              TbBonusPenalty.up_set(session[:recevice_code_2],'0001',@r_u.arbitman,'zc_rmb',params["old_rmb_name_"+r.id.to_s].to_f,@r_u.rmb)
            end
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list"
  end
  
  def update
    @remun=TbRemuneration3.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',@remun.arbitman,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
    end
  end
  
  def update_all_2
    c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
    @remun=TbRemuneration3.find(:all,:order=>'arbitman',:conditions=>c) 
    for r in @remun
      if TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{r.arbitman}' and used='Y' and extend_code=''")!=nil 
        if params["hid_name_"+r.id.to_s]!=nil
          @r_u=TbRemuneration3.find(r.id)
          if @r_u.rmb==params["old_rmb_name_"+r.id.to_s].to_f
            @r_u.grade=params["grade_name_"+r.id.to_s]
            @r_u.rmb=params["new_rmb_name_"+r.id.to_s]
            @r_u.remark=params["remark_name_"+r.id.to_s]
            @r_u.u2=session[:user_code]
            @r_u.t2=Time.now()
            if @r_u.save
              TbBonusPenalty.up_set(session[:recevice_code_2],'0001',@r_u.arbitman,'zc_rmb',params["old_rmb_name_"+r.id.to_s].to_f,@r_u.rmb)
            end
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list_2"
  end
  
  def update_2
    @remun=TbRemuneration3.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],'0001',@remun.arbitman,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
        flash[:notice]="修改成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="修改失败"
        render :action=>"edit_2",:id=>params[:id]
      end
    end
  end
   
  def delete
    @remun=TbRemuneration3.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration3.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
