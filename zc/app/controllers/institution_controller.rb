=begin
创建人：聂灵灵
创建时间：2009-5-13
类的描述：此控制器是处理办理案件用户结案管理的机构评价页面的信息维护。首先判断是否选择案件，若无则选择案件,
         然后对机构评价信息进行创建及修改、删除维护。TbInstitution是实体类。
页面：
机构评价信息列表:/institution/institution_list
创建机构评价信息:/institution/institution_new
修改机构评价信息:/institution/institution_edit
=end
class InstitutionController < ApplicationController

  def institution_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @institution_pages,@institution=paginate(:tb_institutions,:order=>'id',:conditions=>c)
    end
  end

  def institution_new
    @institution=TbInstitution.new()
  end

  def institution_create
     @institution=TbInstitution.new(params[:institution])
     @institution.recevice_code=session[:recevice_code]
     @institution.case_code=session[:case_code]
     @institution.general_code=session[:general_code]
     @institution.u=session[:user_code]
     @institution.u_t=Time.now()
     if @institution.save
        flash[:notice]="创建成功"
        redirect_to :action=>"institution_list"
     else
        render :action=>"institution_new"
     end
  end

  def institution_edit
     @institution=TbInstitution.find(params[:id])
  end

  def institution_update
     @institution=TbInstitution.find(params[:id])
     @institution.u=session[:user_code]
     @institution.u_t=Time.now()
     if @institution.update_attributes(params[:institution])
        flash[:notice]="修改成功"
        redirect_to :action=>"institution_list"
     else
        flash[:notice]="修改失败"
        render :action=>"institution_edit"
     end
  end

  def institution_delete
     @institution=TbInstitution.find(params[:id])
     @institution.used="N"
     @institution.u=session[:user_code]
     @institution.u_t=Time.now()
     if @institution.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"institution_list"
  end
end
