=begin
创建人：聂灵灵
创建时间：2009-6-8、9
类的描述：此类主要实现档案案件提交记录时人、时间、原因的提交记录；以及的提交记录信息创建(seefile下的new页面)，
修改(seefile下的edit页面)，
列表显示(seefile下的list页面)功能
=end
class SeefileController < ApplicationController
  def list
    @case=nil#当前办理案件
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    if session[:recevice_code_5]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_5])
      c="recevice_code='#{session[:recevice_code_5]}' and used='Y'"
      @pages,@seefile=paginate(:tb_seefiles,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    end
  end
  def new
    @seefile=TbSeefile.new()
    code=TbCase.find_by_recevice_code(session[:recevice_code_5]).clerk
    @seefile.man=User.find(:first,:conditions=>["used='Y' and code=?",code]).name
    @seefile.see_date = Date.today
  end
  def create
    @seefile=TbSeefile.new(params[:seefile])
    @seefile.recevice_code=session[:recevice_code_5]
    @seefile.case_code=session[:case_code_5]
    @seefile.general_code=session[:general_code_5]
    @seefile.u=session[:user_code]
    @seefile.u_t=Time.now()
    if @seefile.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="创建失败"
    end
  end

  def edit
    @seefile=TbSeefile.find(params[:id])
  end

  def update
    @seefile=TbSeefile.find(params[:id])
    @seefile.u=session[:user_code]
    @seefile.u_t=Time.now()
    if @seefile.update_attributes(params[:seefile])
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:id=>params[:id]
    end
  end

  def delete
    @seefile=TbSeefile.find(params[:id])
    @seefile.used="N"
    @seefile.u=session[:user_code]
    @seefile.u_t=Time.now()
    if @seefile.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list"
  end
end
