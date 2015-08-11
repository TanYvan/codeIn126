#结案后处理的控制器，主要对案件的撤销及不予执行、案件执行情况以及案件重审和案件反馈信息进行添加、
#修改、查看及删除的操作
#创建人 苏获
#创建时间 20090508
require "iconv"
class WindUpCaseController < ApplicationController
    ###结案后处理的控制函数#######
    #sh
    #20090505
    
    #撤销及不予执行的代码
    def  backout_and_unrun
        #当前办理案件
        if session[:recevice_code_3] != nil
            @tb_case = TbCase.find(:first, :conditions => ["recevice_code = ? ",session[:recevice_code_3]])
        else
            @tb_case = nil
        end
    end
    #保存撤销及不予执行的记录

    def save_backout_and_unrun
        @tb_case = TbCase.find_by_recevice_code(session[:recevice_code_3])        
        if  @tb_case.update_attributes!(params[:tb_case]) and @tb_case.save!
            flash[:notice] = "保存成功！"
            redirect_to :action =>"backout_and_unrun",:recevice_code =>session[:recevice_code_3]
        else
            flash[:notice] = "保存失败！"            
        end
    end
    
    #文件上传的代码
    def upload_file
        utf8_to_gbk  = Iconv.new('gbk','utf-8')  #Iconv 编码转换
        gbk_to_utf8 = Iconv.new('utf-8','gbk')
        file=params["file"][:file]  # params["file"]与params[:file]作用相同
        if !file.original_filename.empty?  
            f_name="#{utf8_to_gbk.iconv(file.original_filename)}"  
            if File.exists?("#{RAILS_ROOT}/upload/backoutandunrun/#{session[:recevice_code_3]}/")
                File.open("#{RAILS_ROOT}/upload/backoutandunrun/#{session[:recevice_code_3]}/#{f_name}","wb") do |f|  
                    f.write(file.read) 
                end
            else 
                Dir.mkdir("#{RAILS_ROOT}/upload/backoutandunrun/#{session[:recevice_code_3]}")
                File.open("#{RAILS_ROOT}/upload/backoutandunrun/#{session[:recevice_code_3]}/#{f_name}","wb") do |f|
                    f.write(file.read) 
                end
            end
                
            #将文件名存储到数据库
            begin
                @tb_backoutfile = TbBackoutfile.new
                @tb_backoutfile.filename = file.original_filename
                @tb_backoutfile.case_code = session[:case_code_3]
                @tb_backoutfile.recevice_code = session[:recevice_code_3]
                @tb_backoutfile.general_code = session[:general_code_3]
                @tb_backoutfile.user = session[:user_code]
                @tb_backoutfile.user_time = Time.now
                @tb_backoutfile.save!  
            rescue ActiveRecord::RecordNotSaved
                logger.error("上传文件记录"+session[:recevice_code_3]+"保存失败！")
                flash[:notice] = "上传文件记录保存失败"  
                redirect_to :action => "upload"
            else
                redirect_to :action => "backout_and_unrun", :recevice_code => session[:recevice_code_3]  #
                flash[:notice] = "上传成功！"
            end
        end 
    end
#    # 显示裁决文件
#    def list_file
#        @tb_backoutfiles = TbBackoutfile.find(:all, :conditions => ["recevice_code = ? and used = 'Y'",session[:recevice_code_3]])
#    end
#    # 查看裁决文件
#    def show_file
#        utf8_to_gbk  = Iconv.new('gbk','utf-8')  #Iconv 编码转换
#        gbk_to_utf8 = Iconv.new('utf-8','gbk')        
#        @tb_backoutfile = TbBackoutfile.find(params[:id])
#        send_file("#{RAILS_ROOT}/upload/backoutandunrun/#{session[:recevice_code_3]}/" + utf8_to_gbk.iconv(@tb_backoutfile.filename)) unless @tb_backoutfile.filename.blank?
#       
#    end
#    # 删除裁决文件
#    def delete_file
#        @tb_backoutfile = TbBackoutfile.find(params[:id])
#        @tb_backoutfile.used = 'N'
#        @tb_backoutfile.user = session[:user_code]
#        @tb_backoutfile.user_time = Time.now
#        if @tb_backoutfile.save!
#            flash[:notice] = "删除成功！"
#            redirect_to :action => "list_file"
#        else
#            flash[:notice] = "删除失败！"
#            redirect_to :action => "list_file"
#        end          
#    end
    #显示执行情况的代码
    def show_implement
        if session[:recevice_code_3] != nil
            @tb_case = TbCase.find_by_recevice_code(session[:recevice_code_3])
        else
            @tb_case = nil    
        end    
    end
    #保存执行情况的记录
    def save_implement
        @tb_case = TbCase.find_by_recevice_code(session[:recevice_code_3])   
        if  @tb_case.update_attributes!(params[:tb_case]) and @tb_case.save!
            flash[:notice] = "保存成功！"
            redirect_to :action =>"show_implement"
        else
            flash[:notice] = "保存失败！"            
        end       
    end
    #反馈信息列表
    def list_feedback
        if session[:recevice_code_3]==nil
            @tb_case=nil
            @tb_messrets = TbMessret.find(:all, :conditions=>["used = 'Y'"],:order => "id")
        else
            @tb_case=TbCase.find_by_recevice_code(session[:recevice_code_3])
            @tb_messrets = TbMessret.find(:all, :conditions=>["used = 'Y' and recevice_code = ?",session[:recevice_code_3]],:order => "id")
        end  
    
    end
    #新建反馈信息
    def new_feedback
        @tb_messret = TbMessret.new
        @tb_messret.retdate = Date.today
    end
    #保存反馈信息
    def create_feedback
        @tb_messret = TbMessret.new(params[:tb_messret])
        @tb_messret.recevice_code = session[:recevice_code_3]
        @tb_messret.case_code = session[:case_code_3]
        @tb_messret.general_code = session[:general_code_3]        
        @tb_messret.u = session[:user_code]
        @tb_messret.user_time = Time.now       
        if  @tb_messret.update_attributes!(params[:tb_messret]) and @tb_messret.save!
            flash[:notice] = "保存成功！"
            redirect_to :action =>"list_feedback",:recevice_code =>session[:recevice_code_3]
        else
            flash[:notice] = "保存失败！"            
        end   
    end
    #编辑反馈信息
    def edit_feedback
        @tb_messret = TbMessret.find(params[:id])
    end
    #更新反馈信息
    def update_feedback
        @tb_messret = TbMessret.find(params[:id])
        @tb_messret.u = session[:user_code]
        @tb_messret.user_time = Time.now
        if @tb_messret.update_attributes!(params[:tb_messret]) and @tb_messret.save!
            flash[:notice] = "修改成功！"
            redirect_to :action => "list_feedback"
        else
            flash[:notice] = "修改失败！"
            render :action => "edit_feedback",:id => params[:id]
        end
    end
    #删除反馈信息
    def delete_feedback
        @tb_messret = TbMessret.find(params[:id])
        @tb_messret.used = 'N'
        @tb_messret.u = session[:user_code]
        @tb_messret.user_time = Time.now
        if @tb_messret.save!
            flash[:notice] = "删除成功！"
            redirect_to :action => "list_feedback"
        else
            flash[:notice] = "删除失败！"
            redirect_to :action => "list_feedback"
        end       
    end
    
    
  def book_list
    c="p_id=#{params[:p_id]} and typ='0003' and used='Y'"
    @book_pages,@book=paginate(:case_books,:order=>'id',:conditions=>c) 
  end
  
  def book_new
    @book=CaseBook.new()
  end
   
  def book_create
    @book=CaseBook.new(params[:book])
    @book.recevice_code=session[:recevice_code]
    @book.case_code=session[:case_code]
    @book.general_code=session[:general_code]
    @book.typ="0003"
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
    @case_1=TbCase.find(params[:p_id])
    @case_1.book_num=@case_1.book_num + 1
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @yea=@case.receivedate.to_s.slice(0,4)
    @doc.book_u=@case.clerk
    @doc.book_dat=Time.now

    @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@case_1.id}_#{@case_1.book_num}.doc"
    
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
        @case_1.save
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
    @yea=@case.receivedate.to_s.slice(0,4)
    send_file("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
  end
   
end
