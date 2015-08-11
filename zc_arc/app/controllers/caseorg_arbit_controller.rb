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
    c="tb_cases_state>=4 and tb_cases_state<100 and tb_cases_clerk='#{session[:user_code]}' and tb_cases_end_code='' and tb_cases_state<>2 and tb_cases_state<>3"#立案未结案
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  def arbitman_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @caseorg=TbCaseorg.find_by_recevice_code(session[:recevice_code])
      if @caseorg!=nil
        params[:org_id]=@caseorg.id
      else
        params[:org_id]=0
      end
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
      @arbitman=TbCasearbitman.find(:all,:order=>'id',:conditions=>c)
    end
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
    @arbitman.recevice_code=session[:recevice_code]
    @arbitman.case_code=TbCase.find_by_recevice_code(session[:recevice_code]).case_code
    @arbitman.general_code=TbCase.find_by_recevice_code(session[:recevice_code]).general_code
    @arbitman.org_id=params[:org_id]
    @arbitman.u=session[:user_code]
    @arbitman.u_t=Time.now()
    if @arbitman.save
      flash[:notice]="创建成功"
      redirect_to :action=>"arbitman_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"arbitman_new" ,:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
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
    redirect_to :action=>"arbitman_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
  end

  def evite_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @caseorg=TbCaseorg.find_by_recevice_code(session[:recevice_code])
      if @caseorg!=nil
        params[:org_id]=@caseorg.id
      else
        params[:org_id]=0
      end
      @e={1=>"提醒",2=>"不提醒"}
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
      @evite=TbEvite.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def evite_new
    @recevice_code=session[:recevice_code]
    #    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @evite=TbEvite.new()
    @evite.requestdate=Date.today
  end

  def evite_create
    @recevice_code=session[:recevice_code]
    @evite=TbEvite.new(params[:evite])
    if params[:condi]!=''
      @s1 = params[:condi].slice(0, 1)
      if @s1=='a'
        @evite.submitman='0001' #申请人
      elsif @s1=='b'
        @evite.submitman='0002' #被申请人
      else
        @evite.submitman=nil
      end
      @evite.requestman = params[:condi].slice(1, params[:condi].length-1)
    end
    @evite.recevice_code=session[:recevice_code]
    @evite.case_code=TbCase.find_by_recevice_code(session[:recevice_code]).case_code
    @evite.general_code=TbCase.find_by_recevice_code(session[:recevice_code]).general_code
    @evite.org_id=params[:org_id]
    @evite.u=session[:user_code]
    @evite.u_t=Time.now()
    if @evite.save
      flash[:notice]="创建成功"
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"evite_new",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    end

  end

  def evite_edit
    @recevice_code=session[:recevice_code]
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @evite=TbEvite.find(params[:id])
  end

  def evite_update
    @evite=TbEvite.find(params[:id])
    @recevice_code=session[:recevice_code]
    if params[:condi]!=''
      @s1 = params[:condi].slice(0, 1)
      if @s1=='a'
        @evite.submitman='0001' #申请人
      elsif @s1=='b'
        @evite.submitman='0002' #被申请人
      else
        @evite.submitman=nil
      end
      @evite.requestman = params[:condi].slice(1, params[:condi].length-1)
    end
    @evite.u=session[:user_code]
    @evite.u_t=Time.now()
    if @evite.update_attributes(params[:evite])
      flash[:notice]="修改成功"
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"evite_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
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
      redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="设置失败"
      render :action=>"remind_change",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
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
    redirect_to :action=>"evite_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
  end

  def disc_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @caseorg=TbCaseorg.find_by_recevice_code(session[:recevice_code])
      if @caseorg!=nil
        params[:org_id]=@caseorg.id
      else
        params[:org_id]=0
      end
      @spilu={"Y"=>"是","N"=>"否"}
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
      @disc=TbDisclosure.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def disc_new
    #    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @disc=TbDisclosure.new()
    @disc.pdate=Date.today
    @disc.sendrdate=Date.today
    @disc.sendbdate=Date.today
  end

  def disc_create
    @disc=TbDisclosure.new(params[:disc])
    @disc.recevice_code=session[:recevice_code]
    @disc.case_code=TbCase.find_by_recevice_code(session[:recevice_code]).case_code
    @disc.general_code=TbCase.find_by_recevice_code(session[:recevice_code]).general_code
    @disc.org_id=params[:org_id]
    @disc.u=session[:user_code]
    @disc.u_t=Time.now()
    if @disc.save
      flash[:notice]="创建成功"
      redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"disc_new",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    end
  end

  def disc_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @disc=TbDisclosure.find(params[:id])
  end

  def disc_update
    @disc=TbDisclosure.find(params[:id])
    @disc.u=session[:user_code]
    @disc.u_t=Time.now()
    if @disc.update_attributes(params[:disc])
      flash[:notice]="修改成功"
      redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"disc_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
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
    redirect_to :action=>"disc_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
  end

  def change_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @caseorg=TbCaseorg.find_by_recevice_code(session[:recevice_code])
      if @caseorg!=nil
        params[:org_id]=@caseorg.id
      else
        params[:org_id]=0
      end
      @spilu={"Y"=>"是","N"=>"否"}
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"#org_id=#{params[:org_id]}
      @change=TbChange.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def change_new
    #    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @change=TbChange.new()
    @change.changedate=Date.today
    @arbitman_1=TbCasearbitman.new()
  end

  def change_create
    @arbitman_1=TbCasearbitman.new()
    @change=TbChange.new(params[:change])
    @change.recevice_code=session[:recevice_code]
    @change.case_code=TbCase.find_by_recevice_code(session[:recevice_code]).case_code
    @change.general_code=TbCase.find_by_recevice_code(session[:recevice_code]).general_code
    @change.org_id=params[:org_id]
    @change.u=session[:user_code]
    @change.u_t=Time.now()

    @arbitman=TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman=?",session[:recevice_code],params[:change][:arbitman_1]])
    if @arbitman!=nil
      @arbitman.used='N'
      #原来的仲裁员逻辑删除，新建立一条记录
      @arbitman_1.used='Y'
      @arbitman_1.recevice_code=session[:recevice_code]
      @arbitman_1.case_code=@arbitman.case_code
      @arbitman_1.general_code=@arbitman.general_code
      @arbitman_1.org_id=params[:org_id]
      @arbitman_1.u=session[:user_code]
      @arbitman_1.u_t=Time.now()
      @arbitman_1.arbitman=params[:change][:arbitman]
      @arbitman_1.arbitmansign=params[:change][:arbitmansign]
      @arbitman_1.currency=params[:change][:currency]
      @arbitman_1.f_money=params[:change][:f_money]
      @arbitman_1.arbitmantype=@arbitman.arbitmantype
      @change.arbitmantype=@arbitman.arbitmantype
    end
    

    if @change.save and @arbitman.save and @arbitman_1.save
      flash[:notice]="创建成功"
      redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"change_new" ,:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    end

  end

  def change_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @change=TbChange.find(params[:id])
  end

  def change_update
    @change=TbChange.find(params[:id])
    @change.u=session[:user_code]
    @change.u_t=Time.now()
    if @change.update_attributes(params[:change])
      flash[:notice]="修改成功"
      redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"change_edit",:id=>params[:id],:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
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
    redirect_to :action=>"change_list",:org_id=>params[:org_id],:recevice_code=>session[:recevice_code]
  end

  def reason_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @caseorg=TbCaseorg.find_by_recevice_code(session[:recevice_code])
      if @caseorg!=nil
        params[:org_id]=@caseorg.id
      else
        params[:org_id]=0
      end
      c="recevice_code='#{session[:recevice_code]}' and used='Y' and change_id=#{params[:change_id]}"
      @reason_pages,@reason=paginate(:tb_changereasons,:order=>'id',:conditions=>c)
    end
  end

  def reason_new
    @reason=TbChangereason.new()
  end

  def reason_create
    @reason=TbChangereason.new(params[:reason])
    @reason.recevice_code=session[:recevice_code]
    @reason.case_code=TbCase.find_by_recevice_code(session[:recevice_code]).case_code
    @reason.general_code=TbCase.find_by_recevice_code(session[:recevice_code]).general_code
    @reason.change_id=params[:change_id]
    @reason.u=session[:user_code]
    @reason.u_t=Time.now()
    if @reason.save
      flash[:notice]="创建成功"
      redirect_to :action=>"reason_list",:change_id=>params[:change_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"reason_new",:change_id=>params[:change_id],:recevice_code=>session[:recevice_code]
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
      redirect_to :action=>"reason_list",:id=>params[:id],:change_id=>params[:change_id],:recevice_code=>session[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"reason_edit",:id=>params[:id],:change_id=>params[:change_id],:recevice_code=>session[:recevice_code]
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
    redirect_to :action=>"reason_list",:change_id=>params[:change_id],:recevice_code=>session[:recevice_code]
  end

  def book_list
    c="p_id=#{params[:p_id]} and typ='0007' and used='Y'"
    @book=CaseBook.find(:all,:order=>'id',:conditions=>c)
  end

  def book_new
    @book=CaseBook.new()
  end

  def book_create
    @book=CaseBook.new(params[:book])
    @book.recevice_code=session[:recevice_code]
    @book.case_code=session[:case_code]
    @book.general_code=session[:general_code]
    @book.typ="0007"
    @book.p_id=params[:p_id]
    @book.u=session[:user_code]
    @book.u_t=Time.now()
    if @book.save
      flash[:notice]="创建成功"
      redirect_to :action=>"book_list",:p_id=>params[:p_id]
    else
      flash[:notice]="创建失败"
      render :action=>"book_new" ,:p_id=>params[:p_id]
    end
  end

  def book_edit
    @book=CaseBook.find(params[:id])
  end

  def book_update
    @book=CaseBook.find(params[:id])
    @book.u=session[:user_code]
    @book.u_t=Time.now()
    if @book.update_attributes(params[:book])
      flash[:notice]="修改成功"
      redirect_to :action=>"book_list",:p_id=>params[:p_id]
    else
      flash[:notice]="修改失败"
      render :action=>"book_edit" ,:p_id=>params[:p_id]
    end
  end

  def book_delete
    @book=CaseBook.find(params[:id])
    @book.used="N"
    @book.u=session[:user_code]
    @book.u_t=Time.now()
    if @book.save

      if @book.book_name!=nil and @book.book_name!=""
        @case=TbCase.find_by_recevice_code(@book.recevice_code)
        @yea=@case.recevice_code.slice(0,4)
        File.open("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}","w+"){}
        if File.delete("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}")==1
          @book.book_u=session[:user_code]
          @book.book_dat=Time.now
          @book.book_name=""
          @book.save
        end
      end

      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"book_list",:p_id=>params[:p_id]
  end

  def book_upload
    @book=CaseBook.find(params[:id])
  end

  def book_upload_do
    @sitting=TbEvite.find(params[:p_id])
    #@sitting.book_num=@sitting.book_num + 1
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.book_u=@case.clerk
    @doc.book_dat=Time.now

    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["file"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    file_arry = file.original_filename.split(".")
    if file_arry.size > 1
      @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}." + file.original_filename.split(".")[file_arry.size - 1]
    else
      @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}"
    end

    begin
      content = file.read  #gbk_to_utf8.iconv
      #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
      f = File.new("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}", "wb")
      f.write(content)
      f.close
      if !file.original_filename.empty?
        @doc.save
        #@sitting.save
        flash[:notice] = "文件上传成功"
      else
        flash[:notice] = "文件上传失败"

      end
    rescue
      flash[:notice] = "文件上传失败！"
    end
    redirect_to :action=>"book_list",:p_id=>params[:p_id]
  end

  def book_down
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
  end

  def book_destroy
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    File.open("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}","w+"){}
    if File.delete("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")==1
      @doc.book_u=session[:user_code]
      @doc.book_dat=Time.now
      @doc.book_name=""
      @doc.save
      flash[:notice] = "文件删除成功"
    else
      flash[:notice] = "文件删除失败"
    end
    redirect_to :action=>"book_list",:p_id=>@doc.p_id
  end

end
