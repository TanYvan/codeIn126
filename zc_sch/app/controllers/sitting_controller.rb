class SittingController < ApplicationController
  
  def sitting_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @sitting=TbSitting.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def sitting_new
    @room=TbArbitroom.new()
    @sitting=TbSitting.new()
    @sitting.sittingdate=Date.today
    @sitting.sendrdate=Date.today
    @sitting.sendbdate=Date.today
    @sitting.open_t = '09:30'
    @sitting.close_t = '12:00'
  end
   
  def sitting_create
    @sitting=TbSitting.new(params[:sitting])
    @sitting.recevice_code=session[:recevice_code]
    @sitting.case_code=session[:case_code]
    @sitting.general_code=session[:general_code]
    @sitting.u=session[:user_code]
    @sitting.u_t=Time.now()
    @case=TbCase.find_by_recevice_code(session[:recevice_code])
    @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @sitting.usetime = @use_time[params[:sitting][:close_t]] - @use_time[params[:sitting][:open_t]]
    if TbCaseFlow.check(@sitting.recevice_code,'0006')
      
      @room=TbArbitroom.new()
      @room.sittingdate=@sitting.sittingdate
      @room.sittingplace=@sitting.sittingplace
      @room.usetime=@sitting.usetime
      @room.open_t=@sitting.open_t
      @room.close_t=@sitting.close_t
      
      @room.recevice_code=session[:recevice_code]
      @room.case_code=session[:case_code]
      @room.general_code=session[:general_code]
      @room.usestyle="0001"
      @room.userId=User.find_by_code(session[:user_code]).name
      @room.u=session[:user_code]
      @room.u_t=Time.now()
      
      if @room.save
        f=TbCaseFlow.add_flow(@sitting.recevice_code,'0006')
        if f!=0
          @case.state=f
        end 
        if @sitting.save and @case.save
          flash[:notice]="创建成功"

          t_sitting=TbSitting.find(:all,:conditions=>"used='Y' and recevice_code='#{@sitting.recevice_code}'",:order=>"sittingdate")
          t_sitting_f=SysArg.get_first_record(t_sitting)
          if t_sitting_f==nil
            @case.sitting_id_first=nil
          else
            @case.sitting_id_first=t_sitting_f.id
          end

          t_sitting_l=SysArg.get_last_record(t_sitting)
          if t_sitting_l==nil
            @case.sitting_id_last=nil
          else
            @case.sitting_id_last=t_sitting_l.id
          end

          @case.save
          
          @room.sitting_id=@sitting.id
          @room.save
          redirect_to :action=>"sitting_list"
        end
      else
        render :action=>"sitting_new" 
      end
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end
   
  def sitting_edit
    @room=TbArbitroom.find_by_sitting_id(params[:id])
    @sitting=TbSitting.find(params[:id])
  end 

  def sitting_update
    @sitting=TbSitting.find(params[:id])
    @sitting.u=session[:user_code]
    @sitting.u_t=Time.now()
    @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @sitting.usetime = @use_time[params[:sitting][:close_t]] - @use_time[params[:sitting][:open_t]]

    
    @room=TbArbitroom.find_by_sitting_id(params[:id])
    @room.sittingdate=params[:sitting][:sittingdate]
    @room.sittingplace=params[:sitting][:sittingplace]
    @room.usetime= @sitting.usetime
    @room.open_t=params[:sitting][:open_t]
    @room.close_t=params[:sitting][:close_t]

    @room.userId=User.find_by_code(session[:user_code]).name
    @room.u=session[:user_code]
    @room.u_t=Time.now()
      
    if @room.save
      if @sitting.update_attributes(params[:sitting]) 
        flash[:notice]="修改成功"

        @case=TbCase.find_by_recevice_code(@sitting.recevice_code)
        t_sitting=TbSitting.find(:all,:conditions=>"used='Y' and recevice_code='#{@sitting.recevice_code}'",:order=>"sittingdate")
        t_sitting_f=SysArg.get_first_record(t_sitting)
        if t_sitting_f==nil
          @case.sitting_id_first=nil
        else
          @case.sitting_id_first=t_sitting_f.id
        end

        t_sitting_l=SysArg.get_last_record(t_sitting)
        if t_sitting_l==nil
          @case.sitting_id_last=nil
        else
          @case.sitting_id_last=t_sitting_l.id
        end

        @case.save

        redirect_to :action=>"sitting_list"
      end
    else
      flash[:notice]="修改失败"
      render :action=>"sitting_edit" 
    end
  end
   
  def sitting_delete
    @room=TbArbitroom.find_by_sitting_id(params[:id])
    @room.used="N"
    @room.u=session[:user_code]
    @room.u_t=Time.now()
    
    @sitting=TbSitting.find(params[:id])
    @sitting.used="N"
    @sitting.u=session[:user_code]
    @sitting.u_t=Time.now()
    @case=TbCase.find_by_recevice_code(@sitting.recevice_code)
    f=TbCaseFlow.del_flow(@sitting.recevice_code,'0006')
    if f!=0
      @case.state=f
    end 
    if @sitting.save and @case.save and @room.save
      
      t_sitting=TbSitting.find(:all,:conditions=>"used='Y' and recevice_code='#{@sitting.recevice_code}'",:order=>"sittingdate")
      t_sitting_f=SysArg.get_first_record(t_sitting)
      if t_sitting_f==nil
        @case.sitting_id_first=nil
      else
        @case.sitting_id_first=t_sitting_f.id
      end

      t_sitting_l=SysArg.get_last_record(t_sitting)
      if t_sitting_l==nil
        @case.sitting_id_last=nil
      else
        @case.sitting_id_last=t_sitting_l.id
      end

      @case.save
      
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"sitting_list"
  end
  
  def appearman_list
    c="sitting_id=#{params[:sitting_id]} and used='Y'"
    @appearman=TbAppearman.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def appearman_new
    @appearman=TbAppearman.new()
  end
   
  def appearman_create
    @appearman=TbAppearman.new(params[:appearman])
    @appearman.recevice_code=session[:recevice_code]
    @appearman.case_code=session[:case_code]
    @appearman.general_code=session[:general_code]
    @appearman.sitting_id=params[:sitting_id]
    @appearman.u=session[:user_code]
    @appearman.u_t=Time.now()
    if @appearman.save
      flash[:notice]="创建成功"
      redirect_to :action=>"appearman_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="创建失败"
      render :action=>"appearman_new" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def appearman_edit
    @appearman=TbAppearman.find(params[:id])
  end 

  def appearman_update
    @appearman=TbAppearman.find(params[:id])
    @appearman.u=session[:user_code]
    @appearman.u_t=Time.now()
    if @appearman.update_attributes(params[:appearman]) 
      flash[:notice]="修改成功"
      redirect_to :action=>"appearman_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="修改失败"
      render :action=>"appearman_edit" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def appearman_delete
    @appearman=TbAppearman.find(params[:id])
    @appearman.used="N"
    @appearman.u=session[:user_code]
    @appearman.u_t=Time.now()
    if @appearman.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"appearman_list",:sitting_id=>params[:sitting_id]
  end
  
  
  def room_list
    c="usestyle='0001' and sitting_id=#{params[:sitting_id]} and used='Y'"
    @room=TbArbitroom.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def room_new
    @room=TbArbitroom.new()
    @room.sittingdate=Date.today
  end
   
  def room_create
    @room=TbArbitroom.new(params[:room])
    @room.recevice_code=session[:recevice_code]
    @room.case_code=session[:case_code]
    @room.general_code=session[:general_code]
    @room.sitting_id=params[:sitting_id]
    @room.usestyle="0001"
    @room.userId=User.find_by_code(session[:user_code]).name
    @room.u=session[:user_code]
    @room.u_t=Time.now()
    if @room.save
      flash[:notice]="创建成功"
      redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="创建失败"
      render :action=>"room_new" ,:sitting_id=>params[:sitting_id]
    end
     
  end
   
  def room_edit
    @room=TbArbitroom.find(params[:id])
  end 

  def room_update
    @room=TbArbitroom.find(params[:id])
    @room.userId=User.find_by_code(session[:user_code]).name
    @room.u=session[:user_code]
    @room.u_t=Time.now()
    if @room.update_attributes(params[:room]) 
      flash[:notice]="修改成功"
      redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="修改失败"
      render :action=>"room_edit" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def room_delete
    @room=TbArbitroom.find(params[:id])
    @room.used="N"
    @room.u=session[:user_code]
    @room.u_t=Time.now()
    if @room.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
  end
  
  
  def hotel_list
    c="usestyle='0001' and sitting_id=#{params[:sitting_id]} and used='Y'"
    @hotel=TbArbithotel.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def hotel_new
    #    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @hotel=TbArbithotel.new()
    @hotel.usedate=Date.today
  end
   
  def hotel_create
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @hotel=TbArbithotel.new(params[:hotel])
    @hotel.recevice_code=session[:recevice_code]
    @hotel.case_code=session[:case_code]
    @hotel.general_code=session[:general_code]
    @hotel.sitting_id=params[:sitting_id]
    @hotel.usestyle="0001"
    @hotel.u=session[:user_code]
    @hotel.u_t=Time.now()
    if @hotel.save
      flash[:notice]="创建成功"
      redirect_to :action=>"hotel_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="创建失败"
      render :action=>"hotel_new" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def hotel_edit
    @arbitman_now=TbArbitmannow.find_by_sql("select distinct tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_arbitmen,tb_casearbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and  tb_arbitmen.code=tb_casearbitmen.arbitman order by tb_arbitmen.name")
    @hotel=TbArbithotel.find(params[:id])
  end 

  def hotel_update
    @hotel=TbArbithotel.find(params[:id])
    @hotel.u=session[:user_code]
    @hotel.u_t=Time.now()
    if @hotel.update_attributes(params[:hotel]) 
      flash[:notice]="修改成功"
      redirect_to :action=>"hotel_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="修改失败"
      render :action=>"hotel_edit" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def hotel_delete
    @hotel=TbArbithotel.find(params[:id])
    @hotel.used="N"
    @hotel.u=session[:user_code]
    @hotel.u_t=Time.now()
    if @hotel.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"hotel_list",:sitting_id=>params[:sitting_id]
  end
  
  def sittingdelay_list
    @isdelay={'Y'=>'是','N'=>'否'}
    c="sitting_id=#{params[:sitting_id]} and used='Y'"
    @sittingdelay=TbSittingdelay.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def sittingdelay_new
    @sittingdelay=TbSittingdelay.new()
    @sittingdelay.requestdate=Date.today
  end
   
  def sittingdelay_create
    @sittingdelay=TbSittingdelay.new(params[:sittingdelay])
    @sittingdelay.recevice_code=session[:recevice_code]
    @sittingdelay.case_code=session[:case_code]
    @sittingdelay.general_code=session[:general_code]
    @sittingdelay.sitting_id=params[:sitting_id]
    @sittingdelay.u=session[:user_code]
    @sittingdelay.u_t=Time.now()
    if @sittingdelay.save
      flash[:notice]="创建成功"
      redirect_to :action=>"sittingdelay_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="创建失败" 
      render :action=>"sittingdelay_new" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def sittingdelay_edit
    @sittingdelay=TbSittingdelay.find(params[:id])
  end 

  def sittingdelay_update
    @sittingdelay=TbSittingdelay.find(params[:id])
    @sittingdelay.u=session[:user_code]
    @sittingdelay.u_t=Time.now()
    if @sittingdelay.update_attributes(params[:sittingdelay]) 
      flash[:notice]="修改成功"
      redirect_to :action=>"sittingdelay_list",:sitting_id=>params[:sitting_id]
    else
      flash[:notice]="修改失败"
      render :action=>"sittingdelay_edit" ,:sitting_id=>params[:sitting_id]
    end
  end
   
  def sittingdelay_delete
    @sittingdelay=TbSittingdelay.find(params[:id])
    @sittingdelay.used="N"
    @sittingdelay.u=session[:user_code]
    @sittingdelay.u_t=Time.now()
    if @sittingdelay.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"sittingdelay_list",:sitting_id=>params[:sitting_id]
  end
  
  def book_list
    c="p_id=#{params[:p_id]} and typ='0001' and used='Y'"
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
    @book.typ="0001"
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
    redirect_to :action=>"book_list",:p_id=>params[:p_id]
  end
  
  def book_upload
    @book=CaseBook.find(params[:id])
  end
  
  def book_upload_do
    @sitting=TbSitting.find(params[:p_id])
    #@sitting.book_num=@sitting.book_num + 1
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    #########################################
    @yea=@case.receivedate.to_s.slice(0,4)
    @doc.book_u=@case.clerk
    @doc.book_dat=Time.now

    @doc.book_name="#{@doc.typ}_#{@doc.recevice_code}_#{@sitting.id}_#{@doc.id}.doc"
    
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
    @yea=@case.receivedate.to_s.slice(0,4)
    send_file("#{File.expand_path(RAILS_ROOT)}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
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
    redirect_to :action=>"book_list",:p_id=>@doc.p_id
  end
  
end
