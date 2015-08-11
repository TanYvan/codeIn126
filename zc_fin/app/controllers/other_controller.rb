=begin
创建人：聂灵灵
创建时间：2009-5-8
类的描述：实体类是tb_others,table是tb_others
此类主要实现其他方面内容的创建(other下的other_new页面)，
修改(other下的other_edit页面)，
删除(other下的other_list页面)功能,
以及other下的other_list页面专家咨询信息列表功能
=end
class OtherController < ApplicationController

  def other_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @other=TbOther.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def other_new
    @other=TbOther.new()
    @other.o_date=Date.today
  end
  def other_create
    @other=TbOther.new(params[:other])
    @other.recevice_code=session[:recevice_code]
    @other.case_code=session[:case_code]
    @other.general_code=session[:general_code]
    @other.u=session[:user_code]
    @other.u_t=Time.now()
    if @other.save
      flash[:notice]="创建成功"
      redirect_to :action=>"other_list"
    else
      flash[:notice]="创建失败"
      render :action=>"other_new"
    end
  end

  def other_edit
    @other=TbOther.find(params[:id])
  end

  def other_update
    @other=TbOther.find(params[:id])
    @other.u=session[:user_code]
    @other.u_t=Time.now()
    if @other.update_attributes(params[:other])
      flash[:notice]="修改成功"
      redirect_to :action=>"other_list"
    else
      flash[:notice]="修改失败"
      render :action=>"other_edit",:id=>params[:id]
    end
  end

  def other_delete
    @other=TbOther.find(params[:id])
    @other.used="N"
    @other.u=session[:user_code]
    @other.u_t=Time.now()
    if @other.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"other_list"
  end
end
