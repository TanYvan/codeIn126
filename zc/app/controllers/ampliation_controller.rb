=begin
创建人：聂灵灵
创建时间：2009-5-13
类的描述：此控制器是处理办理案件用户结案管理的案件延期页面的信息维护。首先判断是否选择案件，若无则选择案件,
         然后对延期信息进行创建及修改、删除维护。TbCasedelay是实体类。
页面：
案件延期信息列表:/ampliation/ampliation_list
创建案件延期信息：/ampliation/ampliation_new
修改案件延期信息：/ampliation/ampliation_edit
=end
class AmpliationController < ApplicationController

  def ampliation_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @ampliation=TbCasedelay.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def ampliation_new
    @ampliation=TbCasedelay.new()
    @ampliation.requestdate=Date.today
    @ampliation.delayTerm=TbCase.find_by_recevice_code(session[:recevice_code]).finally_limit_dat
    @ampliation.delayDate=Date.today   
  end

  def ampliation_create
    @ampliation=TbCasedelay.new(params[:ampliation])
    @ampliation.recevice_code=session[:recevice_code]
    @ampliation.case_code=session[:case_code]
    @ampliation.general_code=session[:general_code]
    @ampliation.u=session[:user_code]
    @ampliation.u_t=Time.now()
    if @ampliation.save
      flash[:notice]="创建成功"
      
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @case.finally_limit_dat=params[:ampliation][:delayDate]
      
#      t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@case.recevice_code}'",:order=>"orgdate")
#        
#      t_caseorg_l=SysArg.get_last_record(t_caseorg)
#      if t_caseorg_l==nil
#      else
#        t_caseorg_l.limitdate=@case.finally_limit_dat
#        t_caseorg_l.save
#      end
      
      @case.save
      flash[:notice]="修改成功"
      redirect_to :action=>"ampliation_list"
    else
      flash[:notice]="修改失败"
      render :action=>"ampliation_new"
    end
  end 
  
  def ampliation_edit
    @ampliation=TbCasedelay.find(params[:id])
  end
  
  def ampliation_update
    @ampliation=TbCasedelay.find(params[:id])
    if @ampliation.update_attributes(params[:ampliation])
      
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @case.finally_limit_dat=params[:ampliation][:delayDate]
      
#      t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@case.recevice_code}'",:order=>"orgdate")
#        
#      t_caseorg_l=SysArg.get_last_record(t_caseorg)
#      if t_caseorg_l==nil
#      else
        #t_caseorg_l.limitdate=@case.finally_limit_dat
        #t_caseorg_l.save
#      end
      
      @case.save
      
      flash[:notice]="修改成功"
      redirect_to :action=>"ampliation_list"
    else
      flash[:notice]="修改失败"
      render :action=>"ampliation_edit"
    end
  end 
  
end
