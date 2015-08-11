#专家会议模块控制器，专家会议列表、添加专家会议、会议参与人员名单等
#添加人 苏获
#添加时间  20090526
class ExpertMeetingController < ApplicationController
  #    def list_expert_meeting
  #        @order=params[:order]
  #        if @order==nil or @order==""
  #            @order="id desc"
  #        end
  #        @page_lines=params[:page_lines]
  #        if @page_lines==nil or @page_lines==""
  #            @page_lines= 10
  #        end
  #        c = "used = 'Y'"
  #        p=PubTool.new()
  #        if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
  #            c = c + @search_condit
  #        end
  #        @meeting_pages,@expert_meetings =paginate(:expert_meetings,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)
  #
  #    end
  def list_expert_meeting
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @meeting_pages,@expert_meetings =paginate(:expert_meetings,:conditions => c,:per_page=>@page_lines.to_i)
    end
  end
  #新建会议记录
  def new_expert_meeting
    @expert_meeting = ExpertMeeting.new()
    @expert_meeting.dat=Date.today
  end
  #添加会议记录
  def create_expert_meeting
    @expert_meeting = ExpertMeeting.new(params[:expert_meeting])
    @expert_meeting.recevice_code=session[:recevice_code]
    @expert_meeting.case_code=session[:case_code]
    @expert_meeting.general_code=session[:general_code]
    @expert_meeting.u = session[:user_code]
    @expert_meeting.u_time = Time.now
    #专家会议上传
    @book=CaseBook.new()
    @book.recevice_code=session[:recevice_code]
    @book.case_code=session[:case_code]
    @book.general_code=session[:general_code]
    @book.typ='0005'
    @book.state='0001'

    if @expert_meeting.save
      @book.p_id=@expert_meeting.id
      @book.save
      flash[:notice] = "会议记录添加成功！"
      redirect_to :action =>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "会议记录添加失败！"
      render :action =>"new_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
    
  #修改会议记录
  def edit_expert_meeting
    @expert_meeting = ExpertMeeting.find(params[:id])
  end
  #更新会议记录
  def update_expert_meeting
    @expert_meeting = ExpertMeeting.find(params[:id])
    @expert_meeting.recevice_code=session[:recevice_code]
    @expert_meeting.case_code=session[:case_code]
    @expert_meeting.general_code=session[:general_code]
    @expert_meeting.u = session[:user_code]
    @expert_meeting.u_time = Time.now
    if @expert_meeting.update_attributes(params[:expert_meeting])
      flash[:notice]="修改成功！"
      redirect_to :action=>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败！"
      render :action=>"edit_expert_meeting", :id => params[:id],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #删除会议记录
  def delete_expert_meeting
    @expert_meeting = ExpertMeeting.find(params[:id])
    @expert_meeting.used = 'N'
    @expert_meeting.u = session[:user_code]
    @expert_meeting.u_time = Time.now
    
    if @expert_meeting.save
      flash[:notice]="删除成功！"
    else
      flash[:notice]="删除失败！"
    end
    redirect_to :action=>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
  end
    
    
  #######################################################################################
  #参会专家列表
  def list_meeting_attendant
    @page_lines=params[:page_lines]
    @page_lines=session[:lines] if @page_lines==nil or @page_lines==""
    @search_condit=params[:search_condit]
    @search_condit="" if @search_condit==nil
    
    @meeting_id=params[:meeting_id]
    c="used = 'Y' and meeting_id='#{@meeting_id}'"
    @meeting_attedant_pages,@meeting_attendant=paginate(:meeting_attendant,:conditions=>c,:order=>"expert_code",:per_page=>@page_lines.to_i)
  end
  #新建参会专家
  def new_meeting_attendant
    @page_lines=params[:page_lines]
    @page_lines=session[:lines] if @page_lines==nil or @page_lines==""
    @search_condit=params[:search_condit]
    @search_condit="" if @search_condit==nil

    @meeting_id=params[:meeting_id]
    sql = "select e.code as code,e.name as name,e.sex as sex,e.tel as tel from tb_expertconsults as e,tb_periods as g where e.used='Y' and e.code=g.code and g.used='Y'"
    
    @expertconsult_pages,@tb_expertconsults=paginate_by_sql(TbExpertconsult,sql,@page_lines.to_i)
  end
  #添加参会专家
  def create_meeting_attendant
    @meeting_attedant = MeetingAttendant.new
    @meeting_attedant.meeting_id = params[:meeting_id]
    @meeting_attedant.expert_code = params[:expert_code]
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now
    if @meeting_attedant.save!
      flash[:notice]="添加成功！"
      redirect_to :action=>"list_meeting_attendant",:meeting_id=>params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="添加失败！"
      render :action=>"new_meeting_attendant", :meeting_id=>params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #删除参会专家
  def delete_meeting_attendant
    @meeting_attedant = MeetingAttendant.find(params[:id])
    @meeting_attedant.used = 'N'
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now
    if @meeting_attedant.save!
      flash[:notice]="删除参与人员成功！"
    else
      flash[:notice]="删除参与人员失败！"
    end
    redirect_to :action=>"list_meeting_attendant",:meeting_id=>params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
  end
    
  #专家会议文件 上传、下载、删除 ############################################
  def book_upload
    @book=CaseBook.find(:first,:conditions=>["used='Y' and state='0001' and recevice_code=? and typ='0005' and p_id=?",params[:recevice_code],params[:id]])
  end

  def book_upload_do
    @expert=ExpertMeeting.find(params[:id])
    @doc=CaseBook.find(:first,:conditions=>["used='Y' and state='0001' and recevice_code=? and typ='0005' and p_id=?",params[:recevice_code],params[:id]])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @doc.p_id=params[:id]
    #########################################
    @yea=@case.recevice_code.slice(0,4)
    @doc.book_u=@case.clerk
    @doc.book_dat=Time.now

    #@doc.book_name="#{@doc.typ}_#{params[:recevice_code]}_#{@expert.id}_#{@doc.id}.doc"

    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename
    file = params["file"]   #获取文档，此处为tempfile类型的
    file_arry = file.original_filename.split(".")
    if file_arry.size > 1
      @doc.book_name="#{@doc.typ}_#{params[:recevice_code]}_#{@expert.id}_#{@doc.id}." + file.original_filename.split(".")[file_arry.size - 1]
    else
      @doc.book_name="#{@doc.typ}_#{params[:recevice_code]}_#{@expert.id}_#{@doc.id}"
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
    redirect_to :action=>"list_expert_meeting",:p_id=>params[:p_id]
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
    redirect_to :action=>"list_expert_meeting",:p_id=>@doc.p_id
  end
    
end
