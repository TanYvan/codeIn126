#2009-12-9  niell  仲裁员信息
class CaseorgArbitController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    c="tb_cases_state>=4 and tb_cases_state<100 and tb_cases_clerk='#{session[:user_code]}'"#立案未结案
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
#  def select
#    session[:case_code]=params[:case_code]
#    params[:recevice_code]=params[:recevice_code]
#    session[:general_code]=params[:general_code]
#
#    redirect_to :action=>"arbitman_list"
#  end
  def arbitman_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseorg=TbCaseorg.find_by_recevice_code(params[:recevice_code])
    if @caseorg!=nil
      params[:org_id]=@caseorg.id
    else
       params[:org_id]=0
    end
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
    @arbitman=TbCasearbitman.find(:all,:order=>'id',:conditions=>c)
  end
  def rate_set
    render :update do |page|
      page.remove 'arbitman_currency'
      page.remove 'arbitman_rmb_money'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Region.find_by_code(TbArbitman.find_by_code(params[:arbitman_code])).rate_code
    end
  end
  def arbitman_new
#    @arbitman_now=TbArbitmannow.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_arbitmannows where tb_arbitmen.code=tb_arbitmannows.arbitman_num order by tb_arbitmen.name")
    @arbitman=TbCasearbitman.new()
  end

  def arbitman_create
    @arbitman=TbCasearbitman.new(params[:arbitman])
    @arbitman.recevice_code=params[:recevice_code]
    @arbitman.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @arbitman.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @arbitman.org_id=params[:org_id]
    @arbitman.u=session[:user_code]
    @arbitman.u_t=Time.now()
    if @arbitman.save
      flash[:notice]="创建成功"
      redirect_to :action=>"arbitman_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"arbitman_new" ,:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end
  end

#  def arbitman_edit
#    @arbitman_now=TbArbitmannow.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_arbitmannows where tb_arbitmen.code=tb_arbitmannows.arbitman_num order by tb_arbitmen.name")
#    @arbitman=TbCasearbitman.find(params[:id])
#  end
#
#  def arbitman_update
#    @arbitman=TbCasearbitman.find(params[:id])
#    @arbitman.u=session[:user_code]
#    @arbitman.u_t=Time.now()
#    if @arbitman.update_attributes(params[:arbitman])
#      flash[:notice]="修改成功"
#      redirect_to :action=>"arbitman_list",:org_id=>params[:org_id]
#    else
#      flash[:notice]="修改失败"
#      render :action=>"arbitman_edit",:id=>params[:id],:org_id=>params[:org_id]
#    end
#
#  end

  def arbitman_delete
    @arbitman=TbCasearbitman.find(params[:id])
    @arbitman.used="N"
    @arbitman.u=session[:user_code]
    @arbitman.u_t=Time.now()
    if @arbitman.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"arbitman_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
  end

  def evite_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseorg=TbCaseorg.find_by_recevice_code(params[:recevice_code])
    if @caseorg!=nil
      params[:org_id]=@caseorg.id
    else
       params[:org_id]=0
    end
    @e={1=>"提醒",2=>"不提醒"}
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
    @evite=TbEvite.find(:all,:order=>'id',:conditions=>c)
  end

  def evite_new
#    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @evite=TbEvite.new()
    @evite.requestdate=Date.today
  end

  def evite_create
    @evite=TbEvite.new(params[:evite])
    @evite.recevice_code=params[:recevice_code]
    @evite.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @evite.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @evite.org_id=params[:org_id]
    @evite.u=session[:user_code]
    @evite.u_t=Time.now()
    if @evite.save
      flash[:notice]="创建成功"
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"evite_new",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end

  end

  def evite_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @evite=TbEvite.find(params[:id])
  end

  def evite_update
    @evite=TbEvite.find(params[:id])
    @evite.u=session[:user_code]
    @evite.u_t=Time.now()
    if @evite.update_attributes(params[:evite])
      flash[:notice]="修改成功"
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"evite_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end

  end

  def remind_change
    @evite=TbEvite.find(params[:id])
  end

  def remind_update
    @evite=TbEvite.find(params[:id])
    @evite.remind_t=Time.now()
    if @evite.update_attributes(params[:evite])
      flash[:notice]="设置成功"
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="设置失败"
      render :action=>"remind_change",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end

  end

  def evite_delete
    @evite=TbEvite.find(params[:id])
    @evite.used="N"
    @evite.u=session[:user_code]
    @evite.u_t=Time.now()
    if @evite.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
  end

  def disc_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseorg=TbCaseorg.find_by_recevice_code(params[:recevice_code])
    if @caseorg!=nil
      params[:org_id]=@caseorg.id
    else
       params[:org_id]=0
    end
    @spilu={"Y"=>"是","N"=>"否"}
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
    @disc=TbDisclosure.find(:all,:order=>'id',:conditions=>c)
  end

  def disc_new
#    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @disc=TbDisclosure.new()
    @disc.pdate=Date.today
    @disc.sendrdate=Date.today
    @disc.sendbdate=Date.today
  end

  def disc_create
    @disc=TbDisclosure.new(params[:disc])
    @disc.recevice_code=params[:recevice_code]
    @disc.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @disc.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @disc.org_id=params[:org_id]
    @disc.u=session[:user_code]
    @disc.u_t=Time.now()
    if @disc.save
      flash[:notice]="创建成功"
      redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"disc_new",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end
  end

  def disc_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @disc=TbDisclosure.find(params[:id])
  end

  def disc_update
    @disc=TbDisclosure.find(params[:id])
    @disc.u=session[:user_code]
    @disc.u_t=Time.now()
    if @disc.update_attributes(params[:disc])
      flash[:notice]="修改成功"
      redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"disc_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end

  end

  def disc_delete
    @disc=TbDisclosure.find(params[:id])
    @disc.used="N"
    @disc.u=session[:user_code]
    @disc.u_t=Time.now()
    if @disc.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
  end

  def change_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseorg=TbCaseorg.find_by_recevice_code(params[:recevice_code])
    if @caseorg!=nil
      params[:org_id]=@caseorg.id
    else
       params[:org_id]=0
    end
    @spilu={"Y"=>"是","N"=>"否"}
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
    @change=TbChange.find(:all,:order=>'id',:conditions=>c)
  end

  def change_new
#    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @change=TbChange.new()
    @change.changedate=Date.today
  end

  def change_create
    @change=TbChange.new(params[:change])
    @change.recevice_code=params[:recevice_code]
    @change.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @change.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @change.org_id=params[:org_id]
    @change.u=session[:user_code]
    @change.u_t=Time.now()
    if @change.save
      flash[:notice]="创建成功"
      redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"change_new" ,:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end

  end

  def change_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @change=TbChange.find(params[:id])
  end

  def change_update
    @change=TbChange.find(params[:id])
    @change.u=session[:user_code]
    @change.u_t=Time.now()
    if @change.update_attributes(params[:change])
      flash[:notice]="修改成功"
      redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"change_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
    end
  end

  def change_delete
    @change=TbChange.find(params[:id])
    @change.used="N"
    @change.u=session[:user_code]
    @change.u_t=Time.now()
    if @change.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>params[:recevice_code]
  end

  def reason_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
   @caseorg=TbCaseorg.find_by_recevice_code(params[:recevice_code])
    if @caseorg!=nil
      params[:org_id]=@caseorg.id
    else
       params[:org_id]=0
    end
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and change_id=#{params[:change_id]}"
    @reason_pages,@reason=paginate(:tb_changereasons,:order=>'id',:conditions=>c)
  end

  def reason_new
    @reason=TbChangereason.new()
  end

  def reason_create
    @reason=TbChangereason.new(params[:reason])
    @reason.recevice_code=params[:recevice_code]
    @reason.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @reason.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @reason.change_id=params[:change_id]
    @reason.u=session[:user_code]
    @reason.u_t=Time.now()
    if @reason.save
      flash[:notice]="创建成功"
      redirect_to :action=>"reason_list",:change_id=>params[:change_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"reason_new",:change_id=>params[:change_id],:recevice_code=>params[:recevice_code]
    end
  end

  def reason_edit
    @reason=TbChangereason.find(params[:id])
  end

  def reason_update
    @reason=TbChangereason.find(params[:id])
    @reason.u=session[:user_code]
    @reason.u_t=Time.now()
    if @reason.update_attributes(params[:reason])
      flash[:notice]="修改成功"
      redirect_to :action=>"reason_list",:id=>params[:id],:change_id=>params[:change_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"reason_edit",:id=>params[:id],:change_id=>params[:change_id],:recevice_code=>params[:recevice_code]
    end

  end

  def reason_delete
    @reason=TbChangereason.find(params[:id])
    @reason.used="N"
    @reason.u=session[:user_code]
    @reason.u_t=Time.now()
    if @reason.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"reason_list",:change_id=>params[:change_id],:recevice_code=>params[:recevice_code]
  end
end
