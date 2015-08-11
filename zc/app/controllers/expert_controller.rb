=begin
创建人：聂灵灵
创建时间：2009-5-8
类的描述：实体类是tb_experts,table是tb_experts
此类主要实现专家咨询的创建(expert下的expert_new页面)，
修改(expert下的expert_edit页面)，
列表显示(expert下的expert_list页面)功能
=end
class ExpertController < ApplicationController

  def expert_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @expert=TbExpert.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def expert_new
    @expert=TbExpert.new()
    @expert.present_date=Date.today
    @expert.approval_date=Date.today
    @expert.hand_date=Date.today
    @expert.convoke_date=Date.today
    @expert.turn_date=Date.today
  end
  def expert_create
    @expert=TbExpert.new(params[:expert])
    @expert.recevice_code=session[:recevice_code]
    @expert.case_code=session[:case_code]
    @expert.general_code=session[:general_code]
    @expert.u=session[:user_code]
    @expert.u_t=Time.now()
#    专家会议上传
#    @book=CaseBook.new()
#    @book.recevice_code=session[:recevice_code]
#    @book.case_code=session[:case_code]
#    @book.general_code=session[:general_code]
#    @book.typ='0005'
#    @book.state='0001'
       
    if @expert.save
      flash[:notice]="创建成功"
      redirect_to :action=>"expert_list"
    else
      flash[:notice]="创建失败"
      render :action=>"expert_new"
    end
  end

  def expert_edit
    @expert=TbExpert.find(params[:id])
  end

  def expert_update
    @expert=TbExpert.find(params[:id])
    @expert.u=session[:user_code]
    @expert.u_t=Time.now()
    if @expert.update_attributes(params[:expert])
      flash[:notice]="修改成功"
      redirect_to :action=>"expert_list"
    else
      flash[:notice]="修改失败"
      render :action=>"expert_edit",:id=>params[:id]
    end
  end

  def expert_delete
    @expert=TbExpert.find(params[:id])
    @expert.used="N"
    @expert.u=session[:user_code]
    @expert.u_t=Time.now()
#    @book=CaseBook.find_by_id(params[:casebook_id])
#    @book.used='N'
#    @book.state='0002'

    if @expert.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"expert_list"
  end
  #专家会议文件 上传、下载、删除
#  def book_upload
#    @book=CaseBook.find(:first,:conditions=>["used='Y' and state='0001' and recevice_code=? and typ='0005'",params[:recevice_code]])
#  end
#
#  def book_upload_do
#    @expert=TbExpert.find(params[:id])
#    @doc=CaseBook.find(:first,:conditions=>["used='Y' and state='0001' and recevice_code=? and typ='0005'",params[:recevice_code]])
#    @case=TbCase.find_by_recevice_code(params[:recevice_code])
#    @doc.p_id=params[:id]
#    #########################################
#    @yea=@case.recevice_code.slice(0,4)
#    @doc.book_u=@case.clerk
#    @doc.book_dat=Time.now
#
#    @doc.book_name="#{@doc.typ}_#{params[:recevice_code]}_#{@expert.id}_#{@doc.id}.doc"
#
#    utf8_to_gbk  = Iconv.new('gbk','utf-8')
#    gbk_to_utf8 = Iconv.new('utf-8','gbk')
#    #f_name = params["filedata"].original_filename
#    file = params["file"]   #获取文档，此处为tempfile类型的
#    #设置文档保存的路径，自由设置
#    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs")
#      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/")
#    end
#    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
#      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
#    end
#    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}")
#      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}")
#    end
#    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
#    begin
#      content = file.read  #gbk_to_utf8.iconv
#      #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
#      f = File.new("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}", "wb")
#      f.write(content)
#      f.close
#      if !file.original_filename.empty?
#        @doc.save
#        #@sitting.save
#        flash[:notice] = "文件上传成功"
#      else
#        flash[:notice] = "文件上传失败"
#      end
#    rescue
#      flash[:notice] = "文件上传失败！"
#    end
#    redirect_to :action=>"expert_list",:p_id=>params[:p_id]
#  end
#
#  def book_down
#    @doc=CaseBook.find(params[:id])
#    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
#    @yea=@case.recevice_code.slice(0,4)
#    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
#  end
#
#  def book_destroy
#    @doc=CaseBook.find(params[:id])
#    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
#    @yea=@case.recevice_code.slice(0,4)
#    File.open("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}","w+"){}
#    if File.delete("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")==1
#      @doc.book_u=session[:user_code]
#      @doc.book_dat=Time.now
#      @doc.book_name=""
#      @doc.save
#      flash[:notice] = "文件删除成功"
#    else
#      flash[:notice] = "文件删除失败"
#    end
#    redirect_to :action=>"expert_list",:p_id=>@doc.p_id
#  end
end
