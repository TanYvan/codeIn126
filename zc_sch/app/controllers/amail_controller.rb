
class AmailController < ApplicationController
  def list
    #添加分页
    @case=nil#当前办理案件
    if session[:recevice_code_4]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_4])
      c="recevice_code='#{session[:recevice_code_4]}' and used='Y'"
      @amail=TbAmail.find(:all,:conditions=>c,:order=>"submitman desc")
    end
  end
  def new
    @amail=TbAmail.new()
    @amail.dat=Date.today
    @amail.recevicedate=Date.today
    @amail.receviceman=session[:user_code]
  end
  def create
    @amail=TbAmail.new(params[:amail])
    begin
      @amail.arbitman = params[:condi]
      if params[:amail][:material_other]!=''
        @str1 = params[:amail][:material_other]
        @str1 = @str1.strip
        @amail.material_other = @str1
        @amail.materialtype = nil
      else
        @amail.material_other=''
      end
      @amail.recevice_code=session[:recevice_code_4]
      @amail.case_code=session[:case_code_4]
      @amail.general_code=session[:general_code_4]
      @amail.u=session[:user_code]
      @amail.u_t=Time.now()
      @amail.save
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="创建失败"
      render :action=>"new",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def edit
    @amail=TbAmail.find(params[:id])
  end

  def update
    @amail=TbAmail.find(params[:id])
    begin
      @amail.arbitman = params[:condi] 
      @amail.recevice_code=session[:recevice_code_4]
      @amail.case_code=session[:case_code_4]
      @amail.general_code=session[:general_code_4]
      @amail.u=session[:user_code]
      @amail.u_t=Time.now()
      @amail.update_attributes(params[:amail])
      if params[:amail][:material_other]!=''
        @str1 = params[:amail][:material_other]
        @str1 = @str1.strip
        @amail.material_other = @str1
        @amail.materialtype = nil
      else
        @amail.material_other = ''
        @amail.materialtype=params[:amail][:materialtype]
      end
      @amail.save
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="修改失败"
      render :action=>"edit",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def delete
    @amail=TbAmail.find(params[:id])
    @amail.used="N"
    @amail.u=session[:user_code]
    @amail.u_t=Time.now()
    if @amail.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
