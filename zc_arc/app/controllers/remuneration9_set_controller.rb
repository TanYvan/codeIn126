class Remuneration9SetController < ApplicationController
  def rmb_set 
    render :update do |page|
      cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
      page.remove 'remun_rmb'
      page.replace_html 'rmb_set', :partial => 'rmb',:object=>TbDictionary.find(:first,:conditions=>"typ_code='0054' and data_text='#{cov.iconv(params[:remun_grade])}'").data_val
    end
  end
  
  
  def rmb_all_set 
    render :update do |page|
      cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
      val=TbDictionary.find(:first,:conditions=>"typ_code='0054' and data_text='#{cov.iconv(params[:grade])}'").data_val
      i=params[:i]
      c={"i"=>i,"val"=>val}
      page.remove 'new_rmb_id_'+params[:i]
      page.replace_html 'rmb_all_set_' + params[:i], :partial => 'rmb_all',:object=>c
    end
  end
  
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
   
  def edit_all
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
  
  def edit
    @remun=TbRemuneration9.find(params[:id])
  end 
  
  def edit_all_2
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
  
  def edit_2
    @remun=TbRemuneration9.find(params[:id])
  end

  def update_all
    c="recevice_code='#{session[:recevice_code_2]}' and used='Y'"
    @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    for r in @remun
      if TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{r.assistant}' and used='Y' and extend_code=''")!=nil 
        r_id=r.id
        if params["hid_name_"+r.id.to_s]!=nil
          @r_u=TbRemuneration9.find(r.id)
          if @r_u.rmb==params["old_rmb_name_"+r.id.to_s].to_f
            @r_u.grade=params["grade_name_"+r.id.to_s]
            @r_u.rmb=params["new_rmb_name_"+r.id.to_s]
            @r_u.remark=params["remark_name_"+r.id.to_s]
            @r_u.u2=session[:user_code]
            @r_u.t2=Time.now()
            if @r_u.save
              TbBonusPenalty.up_set(session[:recevice_code_2],'0002',@r_u.assistant,'zc_rmb',params["old_rmb_name_"+r.id.to_s].to_f,@r_u.rmb)
            end
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list"
  end
  
  def update
    @remun=TbRemuneration9.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{@remun.assistant}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],'0002',@remun.assistant,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
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
    @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    for r in @remun
      if TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{r.assistant}' and used='Y' and extend_code=''")!=nil 
        r_id=r.id
        if params["hid_name_"+r.id.to_s]!=nil
          @r_u=TbRemuneration9.find(r.id)
          if @r_u.rmb==params["old_rmb_name_"+r.id.to_s].to_f
            @r_u.grade=params["grade_name_"+r.id.to_s]
            @r_u.rmb=params["new_rmb_name_"+r.id.to_s]
            @r_u.remark=params["remark_name_"+r.id.to_s]
            @r_u.u2=session[:user_code]
            @r_u.t2=Time.now()
            if @r_u.save
              TbBonusPenalty.up_set(session[:recevice_code_2],'0002',@r_u.assistant,'zc_rmb',params["old_rmb_name_"+r.id.to_s].to_f,@r_u.rmb)
            end
          end
        end
      end
    end
    flash[:notice]="修改成功"
    redirect_to :action=>"list_2"
  end
  
  def update_2
    @remun=TbRemuneration9.find(params[:id])
    if @remun.rmb==params[:old_rmb].to_f and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{@remun.assistant}' and used='Y' and extend_code=''")!=nil 
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.update_attributes(params[:remun]) 
        TbBonusPenalty.up_set(session[:recevice_code_2],'0002',@remun.assistant,'zc_rmb',params[:old_rmb].to_f,@remun.rmb)
        flash[:notice]="修改成功"
        redirect_to :action=>"list_2"
      else
	flash[:notice]="修改失败"
        render :action=>"edit_2",:id=>params[:id]
      end
    end
  end
   
  def delete
    @remun=TbRemuneration9.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{@remun.assistant}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],'0002',@remun.assistant,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration9.find(params[:id])
    if @remun.used=='Y' and TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_2]}' and typ='0002' and p='#{@remun.assistant}' and used='Y' and extend_code=''")!=nil 
      @remun.used="N"
      @remun.u2=session[:user_code]
      @remun.t2=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_2],'0002',@remun.assistant,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
  
end
