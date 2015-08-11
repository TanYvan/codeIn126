class CheckStaffController < ApplicationController
  def case_list  
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="used='Y' and state>=4 and state<100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @check_staff=TbCheckStaff.find(:all,:order=>'id',:conditions=>c)
  end
  def new
    @check_staff=TbCheckStaff.new()
    @u=User.find_by_sql("select distinct users.code as code,users.name as name from users,user_duties where users.code=user_duties.user_code and user_duties.duty_code='0007' order by users.code")
  end
  def create
    @check_staff=TbCheckStaff.new(params[:check_staff])
    @check_staff.recevice_code=params[:recevice_code]
    @check_staff.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @check_staff.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @check_staff.u=session[:user_code]
    @check_staff.u_t=Time.now()
    if @check_staff.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    else
      render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end
   
  def delete
    @check_staff=TbCheckStaff.find(params[:id])
    @check_staff.used="N"
    @check_staff.u=session[:user_code]
    @check_staff.u_t=Time.now()
    if @check_staff.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
  end
end
