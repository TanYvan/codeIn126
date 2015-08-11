class CheckStaffController < ApplicationController
  def case_list  
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_general_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    hant_search_1_word=params[:hant_search_1_word]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="tb_cases_state>=4 and tb_cases_state<100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @check_staff=TbCheckStaff.find(:all,:order=>'id',:conditions=>c)
  end
  def new
    @check_staff=TbCheckStaff.new()
    @u=User.find_by_sql("select distinct users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and users.code=user_duties.user_code and user_duties.duty_code='0007' order by users.code")
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
