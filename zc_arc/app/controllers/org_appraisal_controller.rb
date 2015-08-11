class OrgAppraisalController < ApplicationController
  def p_set
    if params[:p_typ]=='0001'
      org=TbOrg.find(:all,:conditions=>"used='Y'",:order=>'code',:select=>"code,name")
    else
      org=TbPeriod.find_by_sql("select tb_expertconsults.code as code,tb_expertconsults.name as name from tb_expertconsults where tb_expertconsults.used='Y'   order by tb_expertconsults.code")
    end
    render :update do |page|
      page.remove 'org_appraisal_org_code'
      page.replace_html 'pv_set', :partial => 'pv',:object=>org
    end
  end
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @org_appraisal=TbOrgAppraisal.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def new
    @org_appraisal=TbOrgAppraisal.new() 
    @org_appraisal.consign_t=Date.today
  end

  def create
    @org_appraisal=TbOrgAppraisal.new(params[:org_appraisal])
    @org_appraisal.recevice_code=session[:recevice_code]
    @org_appraisal.case_code=session[:case_code]
    @org_appraisal.general_code=session[:general_code]
    @org_appraisal.u=session[:user_code]
    @org_appraisal.u_t=Time.now()
    if @org_appraisal.save
      flash[:notice]="创建成功"
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"new"
    end
  end 
  
  def edit
    @org_appraisal=TbOrgAppraisal.find(params[:id])
  end
  
  def update
    @org_appraisal=TbOrgAppraisal.find(params[:id])
    if @org_appraisal.update_attributes(params[:org_appraisal])
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit"
    end
  end 
  
  def delete
     @org_appraisal=TbOrgAppraisal.find(params[:id])
     @org_appraisal.used="N"
     @org_appraisal.u=session[:user_code]
     @org_appraisal.u_t=Time.now()
     if @org_appraisal.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list"
  end
  
end
