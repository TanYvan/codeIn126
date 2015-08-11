=begin
创建人：聂灵灵
创建时间：2009-5-14
类的描述：此控制器是处理日常办公的咨询工作日志信息及维护。
页面：
历史案件信息列表:/casepro/casepro_list
创建历史案件信息：/casepro/casepro_new
修改历史案件信息：/casepro/casepro_edit
=end
class CaseproController < ApplicationController

  def casepro_list
    #添加分页
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines=20
      end
      @casepro_pages,@casepro=paginate(:tb_casepros,:conditions=>"used='Y'",:order=>"happdate desc",:per_page=>@page_lines.to_i)
  end

  def casepro_new
    @casepro=TbCasepro.new()
    @casepro.happdate=Date.today
  end

  def casepro_create
     @casepro=TbCasepro.new(params[:casepro])
     @casepro.u=session[:user_code]
     @casepro.u_t=Time.now()
     if @casepro.save
        flash[:notice]="创建成功"
        redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
        render :action=>"casepro_new",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def casepro_edit
     @casepro=TbCasepro.find(params[:id])
  end

  def casepro_update
     @casepro=TbCasepro.find(params[:id])
     @casepro.u=session[:user_code]
     @casepro.u_t=Time.now()
     if @casepro.update_attributes(params[:casepro])
        flash[:notice]="修改成功"
        redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
        flash[:notice]="修改失败"
        render :action=>"casepro_edit",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def casepro_delete
     @casepro=TbCasepro.find(params[:id])
     @casepro.used="N"
     @casepro.u=session[:user_code]
     @casepro.u_t=Time.now()
     if @casepro.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
