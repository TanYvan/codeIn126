class CaseendBook2Controller < ApplicationController
  
  def p_set
    recevice_code=params[:recevice_code]
    endStyle=params[:endStyle]
    ### 以下是华南仲裁委的个性化处理
    @case=TbCase.find_by_recevice_code(recevice_code)
    aribitprog_num=@case.aribitprog_num
    num=''
    if endStyle=='0001' or endStyle=='0002'
      num=SysArg.add_0021()
      num2=num
      num="awd" + num
      if aribitprog_num=="0001" or aribitprog_num=="0002"
        num=num + 'd'
      end
      if endStyle=='0002'
        num=num + 's'
      end
    elsif endStyle=='0003'
      num=SysArg.add_0022()
      num2=num
      num="dst" + num
      if aribitprog_num=="0001" or aribitprog_num=="0002"
        num=num + 'd'
      end
    end 
    arbitBookNum=num
    ### 处理裁决书结案号
    num2=num2.slice(5,3)
    if aribitprog_num=='0001' or aribitprog_num=='0002'
      file_arbitBookNum='D' + num2.to_i.to_s
    else
      file_arbitBookNum=num2.to_i.to_s
    end
#    file_arbitBookNum=file_arbitBookNum
    @case.end_code=arbitBookNum
    @case.file_arbitBookNum=file_arbitBookNum
    @case.save
    ###############
    render :update do |page| 
      page.remove 'caseendbook_file_arbitBookNum'
      page.remove 'caseendbook_arbitBookNum'
      page.remove 'code_create'
      page.replace_html 'pv_1', :partial => 'pv1',:object=>file_arbitBookNum
      page.replace_html 'pv_2', :partial => 'pv2',:object=>arbitBookNum
    end
  end
  
  
  
  def case_list
    @hant_search_1_page_name="case_list"
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
    c="tb_cases_state>=4 and tb_cases_state<=100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  def caseendbook_list
    @case=nil#当前办理案件
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @caseendbook=TbCaseendbook.find(:all,:order=>'id',:conditions=>c)
  end
  
  
  def caseendbook_new
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseendbook=TbCaseendbook.new()
    @caseendbook.file_arbitBookNum=@case.file_arbitBookNum
    @caseendbook.arbitBookNum=@case.end_code
    @caseendbook.decideDate=Date.today
    @caseendbook.sendDate=Date.today
    @caseendbook.isSendDate=Date.today
    session[:recevice_code] = params[:recevice_code]    
  end

  def caseendbook_create
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    if @case.end_code==nil or @case.end_code=='' or @case.file_arbitBookNum==nil or @case.file_arbitBookNum==''
      flash[:notice]="创建失败,请在保存之前单击按钮生成结案号！"
      render :action=>"caseendbook_new",:recevice_code=>params[:recevice_code]
    else
      @caseendbook=TbCaseendbook.new(params[:caseendbook])      
      ### 以下是华南仲裁委的个性化处理
  #    @case=TbCase.find_by_recevice_code(params[:recevice_code])
  #    aribitprog_num=@case.aribitprog_num
  #    num=''
  #    if @caseendbook.endStyle=='0001' or @caseendbook.endStyle=='0002'
  #      num=SysArg.add_0021()
  #      num2=num
  #      num="awd" + num
  #      if aribitprog_num=="0001" or aribitprog_num=="0002"
  #        num=num + 'd'
  #      end
  #      if @caseendbook.endStyle=='0002'
  #        num=num + 's'
  #      end
  #    elsif @caseendbook.endStyle=='0003'
  #      num=SysArg.add_0022()
  #      num="dst" + num
  #      if aribitprog_num=="0001" or aribitprog_num=="0002"
  #        num=num + 'd'
  #      end
  #    end 
  #    @caseendbook.arbitBookNum=num
  #    ### 处理裁决书结案号
  #    num2=num2.slice(5,3)
  #    if aribitprog_num=='0001' or aribitprog_num=='0002'
  #      file_arbitBookNum='D' + num2.to_i.to_s
  #    else
  #      file_arbitBookNum=num2.to_i.to_s
  #    end
  #    @caseendbook.file_arbitBookNum=file_arbitBookNum
      #################
      @caseendbook.recevice_code=params[:recevice_code]
      @caseendbook.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @caseendbook.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @caseendbook.u=session[:user_code]
      @caseendbook.u_t=Time.now()
      #把结案号、裁决书结案号同步到tb_cases表
      @case.end_code=@caseendbook.arbitBookNum
      @case.file_arbitBookNum=@caseendbook.file_arbitBookNum
      if @caseendbook.save and @case.save

        flash[:notice]="创建成功"

        @case=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
        t_caseendbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate asc")
        t_caseendbook_f=SysArg.get_first_record(t_caseendbook)
        if t_caseendbook_f==nil
          @case.caseendbook_id_first=nil
        else
          @case.caseendbook_id_first=t_caseendbook_f.id
        end

        t_caseendbook_l=SysArg.get_last_record(t_caseendbook)
        if t_caseendbook_l==nil
          @case.caseendbook_id_last=nil
        else
          @case.caseendbook_id_last=t_caseendbook_l.id
        end

        @case.save

        redirect_to :action=>"caseendbook_list",:recevice_code=>params[:recevice_code]
      else
        flash[:notice]="创建失败"
        render :action=>"caseendbook_new",:recevice_code=>params[:recevice_code]
      end
    end
     
  end

  def caseendbook_edit
    @caseendbook=TbCaseendbook.find(params[:id])
    session[:recevice_code] = params[:recevice_code]
    @id = params[:id]
  end

  def caseendbook_update
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @caseendbook=TbCaseendbook.find(params[:id])
    @caseendbook.u=session[:user_code]
    @caseendbook.u_t=Time.now()
    if @caseendbook.update_attributes(params[:caseendbook])
      
      #把结案号、裁决书结案号同步到tb_cases表
      @case.end_code=@caseendbook.arbitBookNum
      @case.file_arbitBookNum=@caseendbook.file_arbitBookNum
      @case.save
      
      flash[:notice]="修改成功"
      
      @case=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
      t_caseendbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate asc")
      t_caseendbook_f=SysArg.get_first_record(t_caseendbook)
      if t_caseendbook_f==nil
        @case.caseendbook_id_first=nil
      else
        @case.caseendbook_id_first=t_caseendbook_f.id
      end

      t_caseendbook_l=SysArg.get_last_record(t_caseendbook)
      if t_caseendbook_l==nil
        @case.caseendbook_id_last=nil
      else
        @case.caseendbook_id_last=t_caseendbook_l.id
      end

      @case.save
      
      redirect_to :action=>"caseendbook_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"caseendbook_edit",:recevice_code=>params[:recevice_code]
    end
  end

  def caseendbook_delete
    @caseendbook=TbCaseendbook.find(params[:id])
    @caseendbook.used="N"
    @caseendbook.u=session[:user_code]
    @caseendbook.u_t=Time.now()
    if @caseendbook.save
      
      @case=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
      t_caseendbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate asc")
      t_caseendbook_f=SysArg.get_first_record(t_caseendbook)
      if t_caseendbook_f==nil
        @case.caseendbook_id_first=nil
      else
        @case.caseendbook_id_first=t_caseendbook_f.id
      end

      t_caseendbook_l=SysArg.get_last_record(t_caseendbook)
      if t_caseendbook_l==nil
        @case.caseendbook_id_last=nil
      else
        @case.caseendbook_id_last=t_caseendbook_l.id
      end

      @case.save
      
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"caseendbook_list",:recevice_code=>params[:recevice_code]
  end
  
  
  def book_list
    c="p_id=#{params[:p_id]} and typ='0002' and used='Y'"
    @book=CaseBook.find(:all,:order=>'id',:conditions=>c)
    @id = params[:p_id]
  end
  
  def book_new
    @book=CaseBook.new()
  end
   
  def book_create
    @book=CaseBook.new(params[:book])
    @book.recevice_code=params[:recevice_code]
    @book.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @book.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    @book.typ="0002"
    @book.p_id=params[:p_id]
    ###  以下是华南仲裁委的个性化
    aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
    book_code=SysArg.add_0031()
    @book.book_code=book_code
    ###
    @book.u=session[:user_code]
    @book.u_t=Time.now()
    if @book.save
      flash[:notice]="创建成功"
      redirect_to :action=>"book_list",:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render :action=>"book_new" ,:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
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
      redirect_to :action=>"book_list",:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"book_edit" ,:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
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
        @yea=@case.receivedate.to_s.slice(0,4)
        File.open("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}","w+"){}
        if File.delete("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}")==1
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
    redirect_to :action=>"book_list",:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
  end
  
  def book_upload
    @book=CaseBook.find(params[:id])
  end
  
  def book_upload_do
    @endbook=TbCaseendbook.find(params[:p_id])
    #@endbook.book_num=@endbook.book_num + 1
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @yea=@case.receivedate.to_s.slice(0,4)
    @doc.book_u=session[:user_code]
    @doc.book_dat=Time.now

    @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@endbook.id}_#{@doc.id}.doc"
    
    utf8_to_gbk  = Iconv.new('gbk','utf-8')  
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename  
    file = params["file"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{RAILS_ROOT}/casedocs")
      Dir.mkdir("#{RAILS_ROOT}/casedocs/")  
    end
    if !File.exists?("#{RAILS_ROOT}/casedocs/#{@yea}")
      Dir.mkdir("#{RAILS_ROOT}/casedocs/#{@yea}")  
    end
    if !File.exists?("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}")
      Dir.mkdir("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}")  
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    begin
      content = file.read  #gbk_to_utf8.iconv
      #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
      f = File.new("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}", "wb")
      f.write(content)
      f.close
      if !file.original_filename.empty?    
        @doc.save
        #@endbook.save
        flash[:notice] = "文件上传成功"
      else
        flash[:notice] = "文件上传失败"

      end
    rescue
      #      flash[:notice] = "文件上传失败！"
    end
    redirect_to :action=>"book_list",:p_id=>params[:p_id],:recevice_code=>params[:recevice_code]
  end
  
  def book_down
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.receivedate.to_s.slice(0,4)
    name=TbCaseendbook.find(@doc.p_id).arbitBookNum
    if name==nil
      name='裁决书.doc'
    end
    send_file("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}",:filename=>"#{name}.doc")
  end
  
  def book_destroy
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.receivedate.to_s.slice(0,4)
    File.open("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}","w+"){}
    if File.delete("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")==1
      @doc.book_u=session[:user_code]
      @doc.book_dat=Time.now
      @doc.book_name=""
      @doc.save
      flash[:notice] = "文件删除成功"
    else
      flash[:notice] = "文件删除失败"
    end
    redirect_to :action=>"book_list",:p_id=>@doc.p_id,:recevice_code=>params[:recevice_code]
  end
  
end

