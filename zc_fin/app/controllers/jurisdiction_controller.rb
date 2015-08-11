=begin
创建人：聂灵灵
创建时间：2009-6-2
描述：实体类是TbJurisdiction,table是tb_jurisdictions
此类主要实现管辖权异议申请的创建(jurisdiction下的jurisdiction_new页面)，
修改(jurisdiction下的jurisdiction_edit页面)，
列表显示(jurisdiction下的jurisdiction_list页面)功能,
=end
class JurisdictionController < ApplicationController
  def jurisdiction_list
    @e={1=>"提醒",2=>"不提醒"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @jurisdiction=TbJurisdiction.find(:all,:order=>'registrar,id',:conditions=>c)
    end
  end

  def jurisdiction_new
    @jurisdiction=TbJurisdiction.new()
    @jurisdiction.request_date=Date.today
    @recevice_code=params[:recevice_code]
    #        @jurisdiction.transmit_date=Date.today
    #        @jurisdiction.receive_date=Date.today
    #        @jurisdiction.check_date=Date.today
    #        @jurisdiction.idea_date=Date.today
    #        @jurisdiction.checkout_date=Date.today
    #        @jurisdiction.draft_date=Date.today
    #        @jurisdiction.decide_date=Date.today
    #        @jurisdiction.parties_date=Date.today
    #        @jurisdiction.stop_date=Date.today
    #        @jurisdiction.reset_date=Date.today
  end
  
  def jurisdiction_create
    @jurisdiction=TbJurisdiction.new(params[:jurisdiction])
    begin
      if params[:condi]!=''
        @s1 = params[:condi].slice(0, 1)
        if @s1=='a'
          @jurisdiction.submitman='0001' #申请人
        elsif @s1=='b'
          @jurisdiction.submitman='0002' #被申请人
        else
          @jurisdiction.submitman=nil
        end
        @jurisdiction.request_man = params[:condi].slice(1, params[:condi].length-1)
      end
      @jurisdiction.recevice_code=session[:recevice_code]
      @jurisdiction.case_code=session[:case_code]
      @jurisdiction.general_code=session[:general_code]
      @jurisdiction.u=session[:user_code]
      @jurisdiction.u_t=Time.now()
      @jurisdiction.save
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="创建失败"
      render :action=>"jurisdiction_new"
    else
      flash[:notice]="创建成功"
      redirect_to :action=>"jurisdiction_list"
    end
  end

  def jurisdiction_edit
    @recevice_code=params[:recevice_code]
    @jurisdiction=TbJurisdiction.find(params[:id])
  end

  def jurisdiction_update
    @jurisdiction=TbJurisdiction.find(params[:id])
    begin
      if params[:condi]!=''
        @s1 = params[:condi].slice(0, 1)
        if @s1=='a'
          @jurisdiction.submitman='0001' #申请人
        elsif @s1=='b'
          @jurisdiction.submitman='0002' #被申请人
        else
          @jurisdiction.submitman=nil
        end
        @jurisdiction.request_man = params[:condi].slice(1, params[:condi].length-1)
      end
      @jurisdiction.u=session[:user_code]
      @jurisdiction.u_t=Time.now()
      @jurisdiction.update_attributes(params[:jurisdiction])
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="修改失败"
      render :action=>"jurisdiction_edit",:id=>params[:id]
    else
      flash[:notice]="修改成功"
      redirect_to :action=>"jurisdiction_list"
    end
  end

  def jurisdiction_delete
    @jurisdiction=TbJurisdiction.find(params[:id])
    @jurisdiction.used="N"
    @jurisdiction.u=session[:user_code]
    @jurisdiction.u_t=Time.now()
    if @jurisdiction.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"jurisdiction_list"
  end
   
  def remind_change
    @jurisdiction=TbJurisdiction.find(params[:id])
  end 

  def remind_update
    @jurisdiction=TbJurisdiction.find(params[:id])
    @jurisdiction.remind_t=Time.now()
    if @jurisdiction.update_attributes(params[:jurisdiction]) 
      flash[:notice]="设置成功"
      redirect_to :action=>"jurisdiction_list"
    else
      flash[:notice]="设置失败"
      render :action=>"remind_change",:id=>params[:id]
    end
     
  end

    # 合同文件上传下载
  def file_list
    c="recevice_code='#{params[:recevice_code]}' and typ='0006' and used='Y' and p_id='#{params[:p_id]}'"
    @contract = CaseBook.find(:all,:order=>'id',:conditions=>c)
  end

  def file_new
    @file = CaseBook.new()
    @file.title = "管辖权决定"
  end

  def file_create
    file = CaseBook.new(params[:file])
    file.recevice_code = params[:recevice_code]
    file.typ = "0006"
    file.p_id = params[:p_id]
    file.u = session[:user_code]
    file.u_t = Time.now()
    if file.save
      flash[:notice] = "创建成功"
      redirect_to :action => "file_list", :recevice_code => params[:recevice_code], :p_id => params[:p_id]
    else
      flash[:notice] = "创建失败"
      render :action=>"file_new", :recevice_code => params[:recevice_code], :p_id => params[:p_id]
    end
  end

  def file_edit
    @file = CaseBook.find(params[:id])
  end

  def file_update
    file = CaseBook.find(params[:id])
    file.u = session[:user_code]
    file.u_t = Time.now()
    if file.update_attributes(params[:file])
      flash[:notice] = "修改成功"
      redirect_to :action => "file_list", :recevice_code => params[:recevice_code], :p_id => params[:p_id]
    else
      flash[:notice] = "修改失败"
      render :action => "fiel_edit", :id => params[:id], :p_id => params[:p_id]
    end
  end

  def file_delete
    file = CaseBook.find(params[:id])
    file.used = "N"
    file.u = session[:user_code]
    file.u_t = Time.now()
    if file.save
      if !file.book_name.blank?
        @yea = params[:recevice_code].slice(0,4)
        File.open("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{file.recevice_code}/#{file.book_name}","w+"){}
        if File.delete("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{file.recevice_code}/#{file.book_name}") == 1
          file.book_u    = session[:user_code]
          file.book_dat  = Time.now
          file.book_name = ""
          file.save
        end
      end

      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"file_list", :recevice_code => params[:recevice_code],:p_id => params[:p_id]
  end

  def file_upload
    @file = CaseBook.find(params[:id])
  end

  def file_upload_do
    @file    = CaseBook.find(params[:id])
    @case   = TbCase.find_by_recevice_code(@file.recevice_code)
    #########################################
    @yea          = @case.recevice_code.slice(0,4)
    @file.book_u   = @case.clerk
    @file.book_dat = Time.now
    if !params["file"].blank?
      f_name         = params["file"].original_filename.split(".").last
    end
    @file.book_name = "#{@file.typ}_#{@file.recevice_code}_contractfile_#{@file.id}.#{f_name}"

    utf8_to_gbk  = Iconv.new('gbk','utf-8')
    gbk_to_utf8 = Iconv.new('utf-8','gbk')

    file = params["file"]   #获取文档，此处为tempfile类型的
    #设置文档保存的路径，自由设置
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}")
    end
    if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}")
      Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}")
    end
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    begin
      content = file.read  #gbk_to_utf8.iconv
      #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
      f = File.new("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}/#{@file.book_name}", "wb")
      f.write(content)
      f.close
      if !file.original_filename.empty?
        @file.save
        flash[:notice] = "文件上传成功"
      else
        flash[:notice] = "文件上传失败"
      end
    rescue
      flash[:notice] = "文件上传失败！"
    end
    redirect_to :action => "file_list", :recevice_code => params[:recevice_code],:p_id => @file.p_id
  end

  def file_down
    @file = CaseBook.find(params[:id])
    @yea = @file.recevice_code.slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}/#{@file.book_name}")
  end

  def file_destroy
    @file = CaseBook.find(params[:id])
    @yea = params[:recevice_code].slice(0,4)
    File.open("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}/#{@file.book_name}","w+"){}
    if File.delete("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}/#{@file.book_name}")==1
      @file.book_u    = session[:user_code]
      @file.book_dat  = Time.now
      @file.book_name = ""
      @file.save
      flash[:notice] = "文件删除成功"
    else
      flash[:notice] = "文件删除失败"
    end
    redirect_to :action => "file_list", :recevice_code => params[:recevice_code], :p_id => params[:p_id]
  end
  
end
