=begin
创建人：聂灵灵
创建时间：2009-5-11
类的描述：此控制器是管理结案处理的信息----首先判断案件是否选择案件；若没有，先选择案件；可以创建结案处理信息及修改/删除结案处理信息。
相关页面：
结案处理信息列表:/caseend_book/caseendbook_list
创建结案处理信息：/caseend_book/caseendbook_new
修改结案处理信息：/caseend_book/caseendbook_edit
=end
class CaseendBookController < ApplicationController

  def caseendbook_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @caseendbook=TbCaseendbook.find(:all,:order=>'id',:conditions=>c)
    end
  end

  #  def caseendbook_new
  #    @caseendbook=TbCaseendbook.new()
  #    @caseendbook.decideDate=Date.today
  #    @caseendbook.sendDate=Date.today
  #    @caseendbook.isSendDate=Date.today
  #  end
  #
  #  def caseendbook_create
  #    @caseendbook=TbCaseendbook.new(params[:caseendbook])
  #    appl=TbParty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'",:order=>'id')
  #    if appl!=nil
  #      @caseendbook.applicantName=appl.partyname
  #    else
  #      @caseendbook.applicantName=""
  #    end
  #    isappl=TbParty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'",:order=>'id')
  #    if isappl!=nil
  #      @caseendbook.isApplicantName=isappl.partyname
  #    else
  #      @caseendbook.isApplicantName=""
  #    end
  #    ### 以下是华南仲裁委的个性化处理
  #    aribitprog_num=TbCase.find_by_recevice_code(session[:recevice_code]).aribitprog_num
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
  #    ###
  #
  #    @caseendbook.recevice_code=session[:recevice_code]
  #    @caseendbook.case_code=session[:case_code]
  #    @caseendbook.general_code=session[:general_code]
  #    @caseendbook.u=session[:user_code]
  #    @caseendbook.u_t=Time.now()
  #
  #    if @caseendbook.save
  #
  #      #把结案号同步到tb_cases表
  #      @ceb=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate desc")
  #      @ce=SysArg.get_first_record(@ceb)
  #      @case_end_code=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
  #      if @ce==nil
  #        @case_end_code.end_code=""
  #      else
  #        @case_end_code.end_code=@ce.arbitBookNum
  #      end
  #      @case_end_code.save
  #
  #      flash[:notice]="创建成功"
  #
  #      @case=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
  #      t_caseendbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate asc")
  #      t_caseendbook_f=SysArg.get_first_record(t_caseendbook)
  #      if t_caseendbook_f==nil
  #        @case.caseendbook_id_first=nil
  #      else
  #        @case.caseendbook_id_first=t_caseendbook_f.id
  #      end
  #
  #      t_caseendbook_l=SysArg.get_last_record(t_caseendbook)
  #      if t_caseendbook_l==nil
  #        @case.caseendbook_id_last=nil
  #      else
  #        @case.caseendbook_id_last=t_caseendbook_l.id
  #      end
  #
  #      @case.save
  #
  #      redirect_to :action=>"caseendbook_list"
  #    else
  #      flash[:notice]="创建失败"
  #      render :action=>"caseendbook_new"
  #    end
  #
  #  end

  def caseendbook_edit
    @caseendbook=TbCaseendbook.find(params[:id])
    @recevice_code=params[:recevice_code]
    @caseendbook.sendDate = Date.today
    @caseendbook.isSendDate = Date.today
  end

  def caseendbook_update
    @caseendbook=TbCaseendbook.find(params[:id])
    @caseendbook.u=session[:user_code]
    @caseendbook.u_t=Time.now()
    if @caseendbook.update_attributes(params[:caseendbook])
      #把结案号同步到tb_cases表
      @ceb=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate desc")
      @ce=SysArg.get_first_record(@ceb)
      @case_end_code=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
      if @ce==nil
        @case_end_code.end_code=""
      else
        @case_end_code.end_code=@ce.arbitBookNum
      end
      @case_end_code.save

      flash[:notice]="结案成功"

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
      redirect_to :action=>"caseendbook_list"
    else
      flash[:notice]="结案失败"
      render :action=>"caseendbook_edit"
    end
  end

  #  def caseendbook_delete
  #    @caseendbook=TbCaseendbook.find(params[:id])
  #    @caseendbook.used="N"
  #    @caseendbook.u=session[:user_code]
  #    @caseendbook.u_t=Time.now()
  #    if @caseendbook.save
  #
  #
  #      #把结案号同步到tb_cases表
  #      @ceb=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate desc")
  #      @ce=SysArg.get_first_record(@ceb)
  #      @case_end_code=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
  #      if @ce==nil
  #        @case_end_code.end_code=""
  #      else
  #        @case_end_code.end_code=@ce.arbitBookNum
  #      end
  #      @case_end_code.save
  #
  #      @case=TbCase.find_by_recevice_code(@caseendbook.recevice_code)
  #      t_caseendbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseendbook.recevice_code}'",:order=>"decideDate asc")
  #      t_caseendbook_f=SysArg.get_first_record(t_caseendbook)
  #      if t_caseendbook_f==nil
  #        @case.caseendbook_id_first=nil
  #      else
  #        @case.caseendbook_id_first=t_caseendbook_f.id
  #      end
  #
  #      t_caseendbook_l=SysArg.get_last_record(t_caseendbook)
  #      if t_caseendbook_l==nil
  #        @case.caseendbook_id_last=nil
  #      else
  #        @case.caseendbook_id_last=t_caseendbook_l.id
  #      end
  #
  #      @case.save
  #
  #      flash[:notice]="删除成功"
  #    else
  #      flash[:notice]="删除失败"
  #    end
  #    redirect_to :action=>"caseendbook_list"
  #  end
  
  
  def book_list
    c="p_id=#{params[:p_id]} and typ='0002' and used='Y'"
    @book=CaseBook.find(:all,:order=>'id',:conditions=>c) 
  end
  
  #  def book_new
  #    @book=CaseBook.new()
  #  end
   
  #  def book_create
  #    @book=CaseBook.new(params[:book])
  #    @book.recevice_code=session[:recevice_code]
  #    @book.case_code=session[:case_code]
  #    @book.general_code=session[:general_code]
  #    @book.typ="0002"
  #    @book.p_id=params[:p_id]
  #    ###  以下是华南仲裁委的个性化
  #    aribitprog_num=TbCase.find_by_recevice_code(session[:recevice_code]).aribitprog_num
  #    book_code=SysArg.add_0031()
  #    @book.book_code=book_code
  #    ###
  #    @book.u=session[:user_code]
  #    @book.u_t=Time.now()
  #    if @book.save
  #      flash[:notice]="创建成功"
  #      redirect_to :action=>"book_list",:p_id=>params[:p_id]
  #    else
  #      flash[:notice]="创建失败"
  #      render :action=>"book_new" ,:p_id=>params[:p_id]
  #    end
  #  end
   
  #  def book_edit
  #    @book=CaseBook.find(params[:id])
  #  end
  #
  #  def book_update
  #    @book=CaseBook.find(params[:id])
  #    @book.u=session[:user_code]
  #    @book.u_t=Time.now()
  #    if @book.update_attributes(params[:book])
  #      flash[:notice]="修改成功"
  #      redirect_to :action=>"book_list",:p_id=>params[:p_id]
  #    else
  #      flash[:notice]="修改失败"
  #      render :action=>"book_edit" ,:p_id=>params[:p_id]
  #    end
  #  end
  
  #  def book_delete
  #    @book=CaseBook.find(params[:id])
  #    @book.used="N"
  #    @book.u=session[:user_code]
  #    @book.u_t=Time.now()
  #    if @book.save
  #
  #      if @book.book_name!=nil and @book.book_name!=""
  #        @case=TbCase.find_by_recevice_code(@book.recevice_code)
  #        @yea=@case.receivedate.to_s.slice(0,4)
  #        File.open("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}","w+"){}
  #        if File.delete("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@book.recevice_code}/#{@book.book_name}")==1
  #          @book.book_u=session[:user_code]
  #          @book.book_dat=Time.now
  #          @book.book_name=""
  #          @book.save
  #        end
  #      end
  #
  #      flash[:notice]="删除成功"
  #    else
  #      flash[:notice]="删除失败"
  #    end
  #    redirect_to :action=>"book_list",:p_id=>params[:p_id]
  #  end
  #
  #  def book_upload
  #    @book=CaseBook.find(params[:id])
  #  end
  #
  #  def book_upload_do
  #    @endbook=TbCaseendbook.find(params[:p_id])
  #    #@endbook.book_num=@endbook.book_num + 1
  #    @doc=CaseBook.find(params[:id])
  #    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
  #    #########################################
  #    @yea=@case.receivedate.to_s.slice(0,4)
  #    @doc.book_u=session[:user_code]
  #    @doc.book_dat=Time.now
  #
  #    @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@endbook.id}_#{@doc.id}.doc"
  #
  #    utf8_to_gbk  = Iconv.new('gbk','utf-8')
  #    gbk_to_utf8 = Iconv.new('utf-8','gbk')
  #    #f_name = params["filedata"].original_filename
  #    file = params["file"]   #获取文档，此处为tempfile类型的
  #    #设置文档保存的路径，自由设置
  #    if !File.exists?("#{RAILS_ROOT}/casedocs")
  #      Dir.mkdir("#{RAILS_ROOT}/casedocs/")
  #    end
  #    if !File.exists?("#{RAILS_ROOT}/casedocs/#{@yea}")
  #      Dir.mkdir("#{RAILS_ROOT}/casedocs/#{@yea}")
  #    end
  #    if !File.exists?("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}")
  #      Dir.mkdir("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}")
  #    end
  #    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
  #    begin
  #      content = file.read  #gbk_to_utf8.iconv
  #      #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
  #      f = File.new("#{RAILS_ROOT}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}", "wb")
  #      f.write(content)
  #      f.close
  #      if !file.original_filename.empty?
  #        @doc.save
  #        #@endbook.save
  #        flash[:notice] = "文件上传成功"
  #      else
  #        flash[:notice] = "文件上传失败"
  #
  #      end
  #    rescue
  #      #      flash[:notice] = "文件上传失败！"
  #    end
  #    redirect_to :action=>"book_list",:p_id=>params[:p_id]
  #  end
  
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
  
  #  def book_destroy
  #    @doc=CaseBook.find(params[:id])
  #    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
  #    @yea=@case.receivedate.to_s.slice(0,4)
  #    File.open("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}","w+"){}
  #    if File.delete("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")==1
  #      @doc.book_u=session[:user_code]
  #      @doc.book_dat=Time.now
  #      @doc.book_name=""
  #      @doc.save
  #      flash[:notice] = "文件删除成功"
  #    else
  #      flash[:notice] = "文件删除失败"
  #    end
  #    redirect_to :action=>"book_list",:p_id=>@doc.p_id
  #  end
  
end
