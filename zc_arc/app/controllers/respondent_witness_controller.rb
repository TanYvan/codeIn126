=begin
创建人：聂灵灵
创建时间：2009-5-11
类的描述：此控制器是处理被申请人证人信息维护----被申请人证人可以选择案件，并创建被申请人证人信息及修改删除被申请人证人信息。
页面：
被申请人证人信息列表:/respondent_witness/wit_list
创建被申请人证人信息：/respondent_witness/wit_new
修改被申请人证人信息：/respondent_witness/wit_update
=end
class RespondentWitnessController < ApplicationController

    def wit_list
    @isperson={1=>"是",2=>"否"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'"
      @wit=TbWitne.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def wit_new
    @wit=TbWitne.new()
  end

  def wit_create
     @wit=TbWitne.new(params[:wit])
     @wit.partytype=2
     @wit.recevice_code=session[:recevice_code]
     @wit.case_code=session[:case_code]
     @wit.general_code=session[:general_code]
     @wit.u=session[:user_code]
     @wit.u_t=Time.now()
     if @wit.save
        flash[:notice]="创建成功"
        redirect_to :action=>"wit_list"
     else
	flash[:notice]="创建失败"
        render :action=>"wit_new"
     end

  end

  def wit_edit
     @wit=TbWitne.find(params[:id])
  end

  def wit_update
     @wit=TbWitne.find(params[:id])
     @wit.u=session[:user_code]
     @wit.u_t=Time.now()
     if @wit.update_attributes(params[:wit])
        flash[:notice]="修改成功"
        redirect_to :action=>"wit_list"
     else
	flash[:notice]="修改失败"
        render :action=>"wit_edit",:id=>params[:id]
     end

  end

  def wit_delete
     @wit=TbWitne.find(params[:id])
     @wit.used="N"
     @wit.u=session[:user_code]
     @wit.u_t=Time.now()
     if @wit.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"wit_list"
  end
end
