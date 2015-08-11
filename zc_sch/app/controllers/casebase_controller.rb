=begin
创建人：聂灵灵
创建时间：2009-6-11
类的描述：选择案件后可以查看案件的基本情况。
页面：
案件基本情况信息列表:/casebase/list
=end
class CasebaseController < ApplicationController
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      #查出仲裁员
      @case_arbitmen =TbCasearbitman.find(:all,:conditions=>"used='Y' and recevice_code='#{session[:recevice_code]}'")
      @arr1=""
      for a in @case_arbitmen
        @arbitmanname = TbArbitman.find(:first,:conditions=>["code=? and used='Y'",a.arbitman])
        if @arbitmanname != nil
          @arr1 += @arbitmanname.name+ " "
        end
      end
      #助理
      if @case!=nil
        @zl = User.find(:first,:conditions=>["code=? and used='Y'",@case.clerk])
        @zl = @zl.name
      end
      #结案方式
      caseendbook = TbCaseendbook.find(:first,:conditions=>["recevice_code='#{session[:recevice_code]}' and used='Y'"])
      if caseendbook != nil
        endcasestyle = caseendbook.endStyle
        @endstyle = TbDictionary.find(:first,:conditions=>"typ_code='8117' and data_val='#{endcasestyle}'")
        if @endstyle != nil
          @endstyle = @endstyle.data_text
        else
          @endstyle = " "
        end
      else
        @endstyle = " "
      end
      #申请人，被申请人地区
      @area1 = TbParty.find(:first,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=1")
      if @area1 != nil
        if @area1.area !=nil
          @area1 = Region.find_by_code(@area1.area).name
        else
          @area1 = " "          
        end
      else
        @area1 = " "
      end
      @area2 = TbParty.find(:first,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=2")
      if @area2 != nil
        if @area2.area !=nil
          @area2 = Region.find_by_code(@area2.area).name
        else
          @area2 = " "
        end
      else
        @area2 = " "
      end
      #仲裁协议类型
      if @case!=nil
        record = TbDictionary.find(:first,:conditions=>"typ_code='0003' and data_val='#{@case.aribitprotprog_num}'")
        if record != nil
          @pro_tp = record.data_text
        else
          @pro_tp = " "
        end
        #仲裁类型
        arbit_record = TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{@case.aribitprog_num}'")
        if arbit_record != nil
          @arbit_tp = arbit_record.data_text
        else
          @arbit_tp = " "
        end
      end
      #组庭日期
      case_org = TbCaseorg.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
      if case_org != nil
        @orgdate = case_org.orgdate
      else
        @orgdate = " "
      end
      #选定的制裁机构
      if @case!=nil
        arbit_agent = TbDictionary.find(:first,:conditions=>"typ_code='0004' and data_val='#{@case.agent}'")
        if arbit_agent != nil
          @arbit_agent = arbit_agent.data_text
        else
          @arbit_agent = " "
        end
      end
      ######################################################################
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @reduction_pages,@reduction=paginate(:tb_reductions,:order=>'id',:conditions=>c)
    end
  end
  #案件基本情况修改
  def p_set
    typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{params[:p_typ]}'",:order=>'data_val',:select=>"data_val,data_text")
    render :update do |page|
      page.remove 'case_casetype_num2'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  def edit
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      #      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      #      @tbcase_pages,@case=paginate(:tb_cases,:order=>'recevice_code',:conditions=>c)
      if @case!=nil
        @t_typ=TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val + " " + p.data_text,p.data_val]}
        @typ1=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
        @typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{@case.casetype_num}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
      end
    end
  end
  def update
    @case=TbCase.find_by_recevice_code(session[:recevice_code])
    if @case.update_attributes(params[:case])
      @case.case_code=@case.case_code.strip
      @case.general_code=@case.general_code.strip
      @case.save
      flash[:notice]="修改成功"
      redirect_to :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  #代理人
  
  def con_list
    if @order==nil or @order==""
      @order="id asc"
    end
    p=PubTool.new()
    if p.sql_check(params[:recevice_code])!=false
      @con_pages,@con=paginate(:tb_contractsigns,:conditions=>"used='Y' and recevice_code=#{params[:recevice_code]}")
    end
  end

  def con_new
    @con=TbContractsign.new()
    @con.contractdate=TbCase.find_by_recevice_code(params[:recevice_code]).acceptt
  end

  def con_create
    @con=TbContractsign.new(params[:con])
    @con.recevice_code=params[:recevice_code]
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="创建成功"
      redirect_to :action=>"con_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"con_new" ,:recevice_code=>params[:recevice_code]
    end

  end

  def con_edit
    @con=TbContractsign.find(params[:id])
  end

  def con_update
    @con=TbContractsign.find(params[:id])
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.update_attributes(params[:con])
      flash[:notice]="修改成功"
      redirect_to :action=>"con_list",:id=>params[:id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"con_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end

  def con_delete
    @con=TbContractsign.find(params[:id])
    @con.used="N"
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"con_list",:recevice_code=>params[:recevice_code]
  end
end
