require 'digest/sha1'

class CaseDocController < ApplicationController
  def p_set
    description=TbDocFormat.find_by_code(params[:typ]).description
    obj=TbDocFormat.find_by_code(params[:typ]).obj
    render :update do |page|
      if obj==0
        page.hide 'd_obj'
      else
        page.show 'd_obj'
      end
      page.replace_html 'pv_set', :partial => 'pv',:object=>description
      page.replace_html 'pv_set_2', :partial => 'pv_2',:object=>params[:typ]
      page.replace_html 'pv_set_obj_text', :partial => 'pv_obj_text',:object=>params[:typ]
    end
  end
  def p_set_3
    description=TbDocFormat.find_by_code(params[:typ]).description
    obj=TbDocFormat.find_by_code(params[:typ]).obj
    sss={"typ"=>params[:typ],"obj_code"=>params[:obj_code]}
    render :update do |page|
      if obj==0
        page.hide 'd_obj'
      else
        page.show 'd_obj'
      end
      page.replace_html 'pv_set', :partial => 'pv',:object=>description
      page.replace_html 'pv_set_2', :partial => 'pv_3',:object=>sss
      page.replace_html 'pv_set_obj_text', :partial => 'pv_obj_text',:object=>params[:typ]
    end
  end
  #案件列表
  def list1
    @case=nil#当前办理案件
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    #立案阶段的案件 在办案件
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @n1 = TbCase.count(:id,:conditions=>c)
    #已结未终审案件
    @order3=params[:order]
    if @order3==nil or @order3==""
      @order3="nowdate desc"
    end
    @page_lines3=params[:page_lines]
    if @page_lines3==nil or @page_lines3==""
      @page_lines3= session[:lines]
    end
    c3=" used='Y' and  clerk='#{session[:user_code]}' and state>=4 and  state<150  and  state<>100 and caseendbook_id_first is not null and file_submit_u=''"
    @case_pages3,@case3=paginate(:tb_cases,:conditions=>c3,:order=>@order3,:per_page=>@page_lines3.to_i)
    @n3 = TbCase.count(:id,:conditions=>c3)
    #咨询阶段的案件
    @order2=params[:order]
    if @order2==nil or @order2==""
      @order2="nowdate desc"
    end
    @page_lines2=params[:page_lines]
    if @page_lines2==nil or @page_lines2==""
      @page_lines2= session[:lines]
    end
    c2="used='Y' and state=1 and (clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') "
    @case_pages2,@case2=paginate(:tb_cases,:conditions=>c2,:order=>@order2,:per_page=>@page_lines2.to_i)
    @n2 = TbCase.count(:id,:conditions=>c2)

  end

  #终审后案件列表
  def case_list_arc
    @case=nil#当前办理案件
    @hant_search_1_page_name="case_list_arc"
    @hant_search_1=[['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
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
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = "used='Y' and clerk='#{session[:user_code]}' and state>=100 " + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end

  #显示案件已有发文信息
  def list
    @isperson = {1 => "是", 2 => "否"}
    @order = params[:order]
    if @order == nil or @order == ""
      @order = "id desc"
    end
    @page_lines = params[:page_lines]
    if @page_lines == nil or @page_lines == ""
      @page_lines = 30
    end
    @state = {-1 => "待重新审批", 0 => "待审批", 1 => "批准", 2 => "不批准", 3 => "需要修改" }
    @case = TbCase.find(
      :first,
      :select=>"recevice_code,receivedate,case_code,nowdate,aribitprog_num",
      :conditions =>["used='Y' and recevice_code=?",params[:recevice_code]]
     )
    @doc_pages,@doc=paginate(
      :tb_docs,
      :conditions=>["used='Y' and recevice_code=?",params[:recevice_code]],
      :order=>@order,
      :per_page=>@page_lines.to_i
    )
  end

  def new
    @doc=TbDoc.new()
    @doc.ss_t=Date.today
    @doc.obj='0100'
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code

    if @case_code==nil or @case_code==""
      @typ=TbDocFormat.find_by_sql("select code,name,spell from tb_doc_formats where used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' order by code")
    else
      if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
        if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''"
        else
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''"
        end
      else
        condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''"
      end
      @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
    end
    #合同编号、名称
    @contract_name = TbContractsign.find(:all,:conditions => ["used = 'Y' and recevice_code = ?",params[:recevice_code]])
    if PubTool.new.get_first_record(@contract_name)!=nil
      @contract_name1=""
      if @contract_name.length==1
        @contract_name=PubTool.new.get_first_record(@contract_name)
        @n1 = @contract_name.pactname.index('《')
        if @n1!=nil
          @contract_name1 = @contract_name.pactname
        else
          @contract_name1 = "《" + @contract_name.pactname + "》"
        end
      else
        @contract_name.each do |c|
          @n1 = c.pactname.index('《')
          if @n1!=nil
            @contract_name1 = @contract_name1 + c.pactname+","
          else
            @contract_name1 = @contract_name1 + "《" + c.pactname + "》" + ","
          end
        end
        @contract_name1=@contract_name1.slice(0,@contract_name1.length-1)
        #puts @contract_name1.length
      end
    else
      @contract_name1 = ""
    end
    @general_code=@case.general_code
    @case_code=@case.case_code
  end

  def create
    @doc=TbDoc.new(params[:doc])
    @doc.recevice_code=params[:recevice_code]
    check_mes=Doc_format.new.check_sub(@doc.recevice_code,@doc.typ_code)
    if check_mes[0]=="text"
      render :text=>"<link href='/stylesheets/style.css' rel='stylesheet' type='text/css'>  <br/><br/><h1 class='cRed'> #{check_mes[1]} </h1>     <br/><br/>   <a href='/case_doc/list?recevice_code=#{@doc.recevice_code}'>返回到发文列表</a>"
    else
      @doc.file_code=SysArg.add_0007()

      if TbDocFormat.find_by_code(@doc.typ_code).send_code==1
        send_code=SysArg.add_0009()
        ### 以下是华南仲裁委的个性化
        send_code1 = send_code.slice(0,4)
        send_code2 = send_code.slice(5,send_code.length).to_i.to_s
        aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
        if aribitprog_num=='0001' or aribitprog_num=='0002' or aribitprog_num=='0005' or aribitprog_num=='0006'
          send_code3 = "[" + send_code1 + "]" + "中国贸仲深字第D" + send_code2 + "号"
        else
          send_code3 = "[" + send_code1 + "]" + "中国贸仲深字第" + send_code2 + "号"
        end
        ###
        @doc.send_serial_code=send_code
        @doc.send_code=send_code3
      end

      @doc.obj=params[:doc][:obj]
      @doc.u=session[:user_code]
      @doc.t=Time.now()
      if @doc.save
        DocTrigger.new.exec(@doc.id)
        flash[:notice]="创建成功"
        if SysArg.find_by_code('8020').val=='2'
          @ex="window.open('/case_doc/opera_main?id=#{@doc.id}','newwindow','fullscreen=yes')"
        else
          @ex="window.open('/case_doc/opera_word?id=#{@doc.id}')"
        end
        #render :text=>"<script language='javascript'>  #{@ex}  </script>"
      else
        flash[:notice]="创建失败"
      end

      redirect_to :action=>"opera",:recevice_code=>params[:recevice_code],:id=>@doc.id,:check_mes=>check_mes[1]
    end
  end


  def edit
    @doc=TbDoc.find(params[:id])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    if @case_code==nil or @case_code==""
      @typ=TbDocFormat.find_by_sql("select code,name,spell from tb_doc_formats where used='Y' and  (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' order by code")
    else
      if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
        if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''"
        else
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''"
        end
      else
        condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''"
      end
      @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
    end
  end

  def update
    @doc=TbDoc.find(params[:id])
    check_mes=Doc_format.new.check_sub(@doc.recevice_code,params[:doc][:typ_code])
    if check_mes[0]=="text"
      render :text=>"<link href='/stylesheets/style.css' rel='stylesheet' type='text/css'>  <br/><br/><h1> #{check_mes[1]} </h1>     <br/><br/>   <a href='/case_doc/list?recevice_code=#{@doc.recevice_code}'>返回到发文列表</a>"
    else
      if params[:che]=='t'
        cre=1
      else
        cre=0
      end
      @doc.update_attributes(params[:doc])
      @doc.obj=params[:doc][:obj]
      @doc.u=session[:user_code]
      @doc.t=Time.now()
      if @doc.save
        DocTrigger.new.exec(@doc.id)
        flash[:notice_1]="修改成功"
      else
        flash[:notice_1]="修改失败"
      end
      redirect_to :action=>"opera",:id=>@doc.id,:cre=>cre,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:check_mes=>check_mes[1]
    end
  end


  def opera
    @doc = TbDoc.find(params[:id])
    @recevice_code = @doc.recevice_code
    @format = TbDocFormat.find_by_code(@doc.typ_code)
    @case = TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",@recevice_code]) #params[:recevice_code]
    @case_code = TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    if @case_code==nil or @case_code==""
      @typ=TbDocFormat.find_by_sql("select code,name from tb_doc_formats where used='Y' and  (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and  (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' order by code")
    else
      if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
        if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''"
        else
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''"
        end
      else
        condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''"
      end
      @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
    end
    #发文页面显示内容:
    #合同编号、名称
    @contract_name = TbContractsign.find(:all,:conditions => ["used = 'Y' and recevice_code = ?",@recevice_code])
    if PubTool.new.get_first_record(@contract_name)!=nil
      @contract_name1=""
      if @contract_name.length==1
        @contract_name=PubTool.new.get_first_record(@contract_name)
        @n1 = @contract_name.pactname.index('《')
        if @n1!=nil
          @contract_name1 = @contract_name.pactname
        else
          @contract_name1 = "《" + @contract_name.pactname + "》"
        end
      else
        @contract_name.each do |c|
          @n1 = c.pactname.index('《')
          if @n1!=nil
            @contract_name1 = @contract_name1 + c.pactname+","
          else
            @contract_name1 = @contract_name1 + "《" + c.pactname + "》"+","
          end
        end
        @contract_name1=@contract_name1.slice(0,@contract_name1.length-1)
      end
    else
      @contract_name1 = ""
    end
    @general_code=@case.general_code
    @case_code=@case.case_code
    #发文流水号
    @file_code = TbDoc.find(params[:id]).send_serial_code
    #发文编号
    @send_code = TbDoc.find(params[:id]).send_code
  end

  def opera_word
    @doc=TbDoc.find(params[:id])
    @format=TbDocFormat.find_by_code(@doc.typ_code)
    #    if @format.check_sub_code!=nil and @format.check_sub_code<>''
    #      check=Doc_format.new.check_sub(@doc.recevice_code,@doc[:typ_code])
    #      if check<>''
    #        render :text=>check
    #      end
    #    else

    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    @format_letter_str = Doc_format.new.show(@doc.id)
    @format_letter_head1_str = Doc_format.new.show_head_1(@doc.id)
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/")
      if SysArg.find_by_code('9002').val=='2'
        system "chmod 777 #{SysArg.find_by_code("8010").val}/public/fdocs/"
      end
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      if SysArg.find_by_code('9002').val=='2'
        system "chmod 777 #{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}"
      end
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      if SysArg.find_by_code('9002').val=='2'
        system "chmod 777 #{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}"
      end
    end
    @doc.c_u=session[:user_code]
    @doc.c_t=Time.now
    @doc.num=1
    @doc.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.num}.doc"
    @doc.save
    s1="#{SysArg.find_by_code("8010").val}/public/#{TbDocFormat.find_by_code(@doc.typ_code).path}"
    @target_s2="#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}"
    FileUtils.copy_file(s1,@target_s2)
    if SysArg.find_by_code('9002').val=='2'
      system "chmod 777 #{@target_s2}"
    end
    @file_path=SysArg.find_by_code('8002').val+"\\\\"+ @yea + "\\\\" +@doc.recevice_code + "\\\\" + @doc.file_name
    @head_path=SysArg.find_by_code('8000').val
    @head_1=TbDocFormat.find_by_code(@doc.typ_code).head_1
    #    end
  end

  def opera_c
    @doc=TbDoc.find(params[:id])

    @format=TbDocFormat.find_by_code(@doc.typ_code)
    #    if @format.check_sub_code!=nil and @format.check_sub_code<>''
    #      check=Doc_format.new.check_sub(@doc.recevice_code,@doc[:typ_code])
    #      if check<>''
    #        render :text=>check
    #      end
    #    end

    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    @format_letter_str=Doc_format.new.show(@doc.id)
    @format_letter_head1_str=Doc_format.new.show_head_1(@doc.id)
    @fu=Digest::SHA1.hexdigest(session[:user_code])+User.find_by_code(session[:user_code]).password
    @head_1=TbDocFormat.find_by_code(@doc.typ_code).head_1
    #end
  end

  def doc_create
    @doc=TbDoc.find(params[:FileID])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @doc_change=TbDocChange.new
    @doc_change.doc_id=@doc.id
    @doc_change.recevice_code=@doc.recevice_code
    @doc_change.file_code=@doc.file_code
    @doc_change.typ_code=@doc.typ_code
    @doc_change.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.num + 1}.doc"
    @doc_change.num=@doc.num + 1
    @doc_change.u=@case.clerk
    @doc_change.fff=0
    #########################################
    fu=params[:fu]
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.c_u=@case.clerk
    @doc.c_t=Time.now

    @doc_change.t=@doc.c_t

    @doc.num=@doc.num + 1
    @doc.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.num}.doc"
    #if Digest::SHA1.hexdigest(@case.clerk)+User.find_by_code(@case.clerk).password==fu
    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["FileData"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    content = file.read  #gbk_to_utf8.iconv
    #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
    f = File.new("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}", "wb")
    f.write(content)
    f.close
    if !file.original_filename.empty?
      @doc.save
      @doc_change.save
      flash[:notice] = "保存成功"
    else
      flash[:notice] = "保存失败"
    end
    #end
  end

  def change_list
    @doc=TbDoc.find(params[:id])
    @fff={0=>"内部函",1=>"外部函"}
    @change=TbDocChange.find(:all,:conditions=>"doc_id='#{params[:id]}'",:order=>'id desc')
  end

  def vie_word

    @doc=TbDoc.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    @file_path=SysArg.find_by_code('8002').val+"\\\\"+ @yea + "\\\\" +@doc.recevice_code + "\\\\" + @doc.file_name
  end

  def vie
    @fu=Digest::SHA1.hexdigest(session[:user_code])+User.find_by_code(session[:user_code]).password
    @doc=TbDoc.find(params[:id])
    @appro=TbDocFormat.find_by_code(@doc.typ_code)
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #if @case.clerk==session[:user_code]
    @yea=@case.recevice_code.slice(0,4)
    #########################################
    @doc_path="http://#{SysArg.find_by_code('9000').val}:#{SysArg.find_by_code('9001').val}/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}"
    #end
  end

  def doc_update
    @doc=TbDoc.find(params[:FileID])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @doc_change=TbDocChange.new
    @doc_change.doc_id=@doc.id
    @doc_change.recevice_code=@doc.recevice_code
    @doc_change.file_code=@doc.file_code
    @doc_change.typ_code=@doc.typ_code
    @doc_change.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.num + 1}.doc"
    @doc_change.num=@doc.num + 1
    @doc_change.u=@case.clerk
    @doc_change.fff=0
    #########################################
    fu=params[:fu]
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.c_u=@case.clerk
    @doc.c_t=Time.now

    @doc_change.t=@doc.c_t

    @doc.num=@doc.num + 1
    @doc.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.num}.doc"
    #if Digest::SHA1.hexdigest(@case.clerk)+User.find_by_code(@case.clerk).password==fu
    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["FileData"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    content = file.read  #gbk_to_utf8.iconv
    #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
    f = File.new("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}", "wb")
    f.write(content)
    f.close
    if !file.original_filename.empty?
      @doc.save
      @doc_change.save
      flash[:notice] = "保存成功"
    else
      flash[:notice] = "保存失败"
    end
    #end
  end

  def vie_word_f

    @doc=TbDoc.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    @file_path=SysArg.find_by_code('8002').val+"\\\\"+ @yea + "\\\\" +@doc.recevice_code + "\\\\" + @doc.f_file_name
  end

  def vie_f
    @fu=Digest::SHA1.hexdigest(session[:user_code])+User.find_by_code(session[:user_code]).password
    @doc=TbDoc.find(params[:id])
    @appro=TbDocFormat.find_by_code(@doc.typ_code)
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #if @case.clerk==session[:user_code]
    @yea=@case.recevice_code.slice(0,4)
    #########################################
    @doc_path="http://#{SysArg.find_by_code('9000').val}:#{SysArg.find_by_code('9001').val}/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.f_file_name}"
    #end
  end

  def doc_f_update
    @doc=TbDoc.find(params[:FileID])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @doc.f_num=@doc.f_num + 1
    @doc_change=TbDocChange.new
    @doc_change.doc_id=@doc.id
    @doc_change.recevice_code=@doc.recevice_code
    @doc_change.file_code=@doc.file_code
    @doc_change.typ_code=@doc.typ_code
    @doc_change.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.f_num}.doc"
    @doc_change.num=@doc.f_num
    @doc_change.u=@case.clerk
    @doc_change.fff=1
    #########################################
    fu=params[:fu]
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.cf_u=@case.clerk
    @doc.cf_t=Time.now
    @doc_change.t=@doc.c_t
    @doc.f_file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.f_num}.doc"
    #if Digest::SHA1.hexdigest(@case.clerk)+User.find_by_code(@case.clerk).password==fu
    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["FileData"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    content = file.read  #gbk_to_utf8.iconv
    #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
    f = File.new("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.f_file_name}", "wb")
    f.write(content)
    f.close
    if !file.original_filename.empty?
      @doc.save
      @doc_change.save
      flash[:notice] = "保存成功"
    else
      flash[:notice] = "保存失败"
    end
    #end
  end

  def approval
    @doc=TbDoc.find(params[:id])
    @doc.call_u=session[:user_code]
    @doc.call_t=Time.now
    @format=TbDocFormat.find_by_code(@doc.typ_code)
    @approval=TbDocFormatApproval.find(:all,:conditions=>"used='Y' and format_code='#{@format.code}'")
    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    if @format.approval==1 and TbDocApproval.find(:all,:conditions=>"doc_id=#{@doc.id}").empty?
      for p in @approval
        @appr=TbDocApproval.new
        @appr.recevice_code=@doc.recevice_code
        @appr.doc_id=@doc.id
        @appr.file_code=@doc.file_code
        @appr.send_serial_code=@doc.send_serial_code
        @appr.send_code=@doc.send_code
        @appr.a_u=p.a_u
        @appr.a_d=Workday.after_day(p.a_d)
        @appr.call_u=@doc.call_u
        @appr.call_t=@doc.call_t
        @appr.state=0
        @appr.save
      end
    end
    @doc.save
    flash[:notice]="#{@doc.file_code}号文件报批完成"
    redirect_to :action=>"opera",:recevice_code=>params[:recevice_code],:id=>params[:id]
    #   else
    #     render :text=>"助理与案件不匹配！"
    #   end
  end

  def re_approval
    @doc=TbDoc.find(params[:id])
    @format=TbDocFormat.find_by_code(@doc.typ_code)
    @doc.call_u=session[:user_code]
    @doc.call_t=Time.now
    # @approval=TbDocFormatApproval.find(:all,:conditions=>"used='Y' and format_code='#{@format.code}'")
    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    if @format.approval==1
      TbDocApproval.update_all(["state=-1,call_u='#{@doc.call_u}',call_t=?",@doc.call_t],"doc_id=#{@doc.id}")
    end
    @doc.save
    flash[:notice]="#{@doc.file_code}号文件重新报批完成"
    redirect_to :action=>"opera",:recevice_code=>params[:recevice_code],:id=>params[:id]
    #   else
    #     render :text=>"助理与案件不匹配！"
    #   end
  end

  def opera_word_f
    @doc=TbDoc.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    @format_letter_str=Doc_format.new.show(@doc.id)
    @format_letter_head1_str=Doc_format.new.show_head_1(@doc.id)
    @doc.cf_u=session[:user_code]
    @doc.cf_t=Time.now
    @doc.f_num=2
    @doc.f_file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.f_num}.doc"
    @doc.save
    s1="#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}"
    @target_s2="#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.f_file_name}"
    FileUtils.copy_file(s1,@target_s2)
    if SysArg.find_by_code('9002').val=='2'
      system "chmod 777 #{@target_s2}"
    end
    @file_path=SysArg.find_by_code('8002').val+"\\\\"+ @yea + "\\\\" +@doc.recevice_code + "\\\\" + @doc.f_file_name
    @head_path=SysArg.find_by_code('8001').val
    #end
  end

  def opera_c_f
    @doc=TbDoc.find(params[:id])
    @format_letter_str=Doc_format.new.show(@doc.id)
    @fu=Digest::SHA1.hexdigest(session[:user_code])+User.find_by_code(session[:user_code]).password
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #if @case.clerk==session[:user_code]
    @yea=@case.recevice_code.slice(0,4)
    #########################################
    @doc_path="http://#{SysArg.find_by_code('9000').val}:#{SysArg.find_by_code('9001').val}/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}"
    #end

  end

  def doc_create_f
    @doc=TbDoc.find(params[:FileID])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    if @doc.f_num==0
      @doc.f_num=@doc.num + 1
    else
      @doc.f_num=@doc.f_num + 1
    end
    @doc_change=TbDocChange.new
    @doc_change.doc_id=@doc.id
    @doc_change.recevice_code=@doc.recevice_code
    @doc_change.file_code=@doc.file_code
    @doc_change.typ_code=@doc.typ_code
    @doc_change.file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.f_num}.doc"
    @doc_change.num=@doc.f_num
    @doc_change.u=@case.clerk
    @doc_change.fff=1
    #########################################
    fu=params[:fu]
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.cf_u=@case.clerk
    @doc.cf_t=Time.now
    @doc_change.t=@doc.c_t
    @doc.f_file_name="#{@doc.typ_code}_#{@doc.file_code}_#{@doc.f_num}.doc"
    #if Digest::SHA1.hexdigest(@case.clerk)+User.find_by_code(@case.clerk).password==fu
    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["FileData"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    content = file.read  #gbk_to_utf8.iconv
    #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
    f = File.new("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.f_file_name}", "wb")
    f.write(content)
    f.close
    if !file.original_filename.empty?
      @doc.save
      @doc_change.save
      flash[:notice] = "保存成功"
    else
      flash[:notice] = "保存失败"
    end
    #end
  end

  def send_to
    @doc=TbDoc.find(params[:id])
    #if TbCase.find_by_recevice_code(@doc.recevice_code).clerk==session[:user_code]
    @doc.send_u=session[:user_code]
    @doc.send_t=Time.now
    if @doc.save
      #DocTrigger.new.exec(@doc.id)
      flash[:notice] = "发文成功"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code]
    end
    #end
  end
  #删除记录
  def doc_delete
    @tb_doc = TbDoc.find(params[:id])
    @tb_doc.used = 'N'
    @tb_doc.u = session[:user_code]
    @tb_doc.t = Time.now
    if @tb_doc.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="删除失败"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code]
    end
  end
  #选择格式函
  def p_set2
    spell=params[:spell]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    spell="#{cov.iconv(spell)}"
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    if @case_code==nil or @case_code==""
      @typ=TbDocFormat.find_by_sql("select code,name,spell from tb_doc_formats where used='Y' and  (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and  (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' order by code")
    else
      if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
        if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''"
        else
          condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''"
        end
      else
        condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''"
      end
      @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
    end
    render :update do |page|
      page.remove 'table_1'
      page.replace_html 'pv_set', :partial => 'pv_1',:object=>@typ
    end
  end
  def docformat_select
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    if params[:spell]==nil or params[:spell]==''
      if @case_code==nil or @case_code==""
        @typ=TbDocFormat.find_by_sql("select code,name,spell from tb_doc_formats where used='Y' and  (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and  (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' order by code")
      else
        if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
          if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
            condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''"
          else
            condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''"
          end
        else
          condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''"
        end
        @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
      end
    elsif PubTool.new().sql_check_3(params[:spell])!=false
      if @case_code==nil or @case_code==""
        @typ=TbDocFormat.find_by_sql("select code,name,spell from tb_doc_formats where used='Y' and  (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and  (sub_code='ft04' or sub_code='fr03' or sub_code='fmt04' or sub_code='for03' or sub_code='dfmt04' or sub_code='dfor03' or sub_code='fmt20' or sub_code='dfmt51' or sub_code='fmt53') and sub_code<>'' and (spell like '%#{params[:spell]}%' or  name like  '%#{params[:spell]}%')  order by code")
      else
        if ["0001","0002","0003","0004"].index(@case.aribitprog_num )
          if TbCasearbitman.count("used",:conditions => "used='Y' and recevice_code='" + @case.recevice_code + "'" ).to_i > 1
            condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0090' ) and sub_code<>''  and (spell like '%#{params[:spell]}%' or name like  '%#{params[:spell]}%') "
          else
            condi_condi = "used='Y' and ((aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and code<>'0091' ) and sub_code<>''  and (spell like '%#{params[:spell]}%' or name like  '%#{params[:spell]}%') "
          end
        else
          condi_condi = "used='Y' and (aribitprog_code like '%0000,%' or aribitprog_code like '%" + @case.aribitprog_num + ",%') and sub_code<>''  and (spell like '%#{params[:spell]}%' or name like  '%#{params[:spell]}%') "
        end
        @typ=TbDocFormat.find(:all,:conditions=>condi_condi,:select=>"code,name,spell",:order=>"code")
      end
    end
  end

  def doc_search
    @hant_search_1_page_name="doc_search"
    @hant_search_1=[['char','send_code','发文编号','text',[]],['char','send_serial_code','发文流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="send_serial_code desc,file_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
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
    c="used='Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_docs,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
end
