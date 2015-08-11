#秘书处例会类、会议列表和基本信息
#添加人  苏获
#添加时间 20090526
class RegularMeetingController < ApplicationController
  def list_regular_meeting
      
    @order=params[:order]
    if @order==nil or @order==""
      @order="dat desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end

    @hant_search_1_r=params[:hant_search_1_r]
    @hant_search_1_page_name="list_regular_meeting"
    @hant_search_1=[
      ['date','dat','日期','text',[]],['char','record_by','会议记录人','text',[]],
      ['char','content','内容摘要','text',[]],
    ]
        
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
        
    @meeting_pages,@regular_meetings =paginate(:regular_meetings,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)          
       
  end
    
  #新建会议记录
  def new_regular_meeting
    @regular_meeting = RegularMeeting.new
    @regular_meeting.dat=Date.today
  end
  #添加会议记录
  def create_regular_meeting
    @regular_meeting = RegularMeeting.new(params[:regular_meeting])
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.save 
      flash[:notice] = "会议记录添加成功！"
      redirect_to :action =>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "会议记录添加失败！"
      render :action =>"new_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end     
  end
    
  #修改会议记录
  def edit_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id])
  end
  #更新会议记录
  def update_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id]) 
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.update_attributes(params[:regular_meeting]) 
      flash[:notice]="修改成功！"  
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败！"
      render :action=>"edit_regular_meeting", :id => params[:id]
    end        
  end
  #删除回忆记录
  def delete_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id]) 
    @regular_meeting.used = 'N'
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.save
      flash[:notice]="删除成功！"  
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败！"
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end           
  end    
    
  #######################################################################################
  #添加人 苏获
  #添加时间 20090527
  #参会人员列表
  def list_meeting_attendant
    @meeting_attedants = RegularMeetingAttendant.find(:all, :conditions => ["used = 'Y' and regular_meeting_id = ?",params[:id]])
  end
  #新建参会人员
  def new_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.new
  end
  #添加参会人员
  def create_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.new(params[:regular_meeting_attendant])
    @meeting_attedant.regular_meeting_id = params[:regular_meeting_id]
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now 
    if @meeting_attedant.save
      flash[:notice]="添加参与人员成功！"  
      redirect_to :action=>"list_meeting_attendant",:id => params[:regular_meeting_id]
    else
      flash[:notice]="添加参与人员失败！"
      render :action=>"new_meeting_attendant", :regular_meeting_id => params[:regular_meeting_id]
    end
  end
  #删除参会人员
  def delete_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.find(params[:id])
    @meeting_attedant.used = 'N'
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now         
    if @meeting_attedant.save
      flash[:notice]="删除参与人员成功！"  
      redirect_to :action=>"list_meeting_attendant",:id => params[:regular_meeting_id]
    else
      flash[:notice]="删除参与人员失败！"
      redirect_to :action=>"list_meeting_attendant", :id => params[:regular_meeting_id]
    end
  end

  def book_list
    c="p_id=#{params[:p_id]} and typ='0004' and used='Y'"
    @book=CaseBook.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def book_new
    @book=CaseBook.new()
  end
   
  def book_create
    @book=CaseBook.new(params[:book])
    @book.recevice_code="meeting"
    @book.typ="0004"
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
        #@case=TbCase.find_by_recevice_code(@book.recevice_code)
        @sitting=RegularMeeting.find(@book.p_id)
        @yea=@sitting.dat.to_s(:db).slice(0,4)
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
    @sitting=RegularMeeting.find(params[:p_id])
    #@sitting.book_num=@sitting.book_num + 1
    @doc=CaseBook.find(params[:id])
    #@case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @yea=@sitting.dat.to_s(:db).slice(0,4)
    @doc.book_u=session[:user_code]
    @doc.book_dat=Time.now

    #@doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}.doc"
    
    utf8_to_gbk  = Iconv.new('gbk','utf-8')  
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename  
    file = params["file"]   #获取文档，此处为tempfile类型的
    file_arry = file.original_filename.split(".")
    if file_arry.size > 1
      @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}." + file.original_filename.split(".")[file_arry.size - 1]
    else
      @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}"
    end
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
    @sitting=RegularMeeting.find(@doc.p_id)
    #@case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@sitting.dat.to_s(:db).slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
  end
  
  def book_destroy
    @doc=CaseBook.find(params[:id])
#    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @sitting=RegularMeeting.find(@doc.p_id)
    @yea=@sitting.dat.to_s(:db).slice(0,4)
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

