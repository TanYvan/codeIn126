require 'guid'
class WUserController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','code','编码','text',[]],['char','name','名称','text',[]],['char','name_idcard','姓名（身份证）','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="name asc"
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
    c="active=1 "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @user_pages,@user=paginate(:w_user,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end

  def new
    @user=WUser.new()
  end

  def create
    file = params["file"]
    category = params["paper_type"]
    @user = WUser.new(params[:user])
    @user.code = SysArg.add_2011()
    @user.active="1"
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.save
      if ! file.blank?
          base_path = AttachmentConfig.find_by_code(category).network_dir
          s = Time.now.to_s(:db)
          aaa = s.split(" ")[0]
          bbb = s.split(" ")[1]
          year = aaa.split("-")[0]
          month = aaa.split("-")[1]
          date = aaa.split("-")[2]
          hour = bbb.split(":")[0]
          minute = bbb.split(":")[1]
          if !File.exists?("#{base_path}/#{year}")
            Dir.mkdir("#{base_path}/#{year}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}")
            Dir.mkdir("#{base_path}/#{year}/#{month}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
          end

          file_arry = file.original_filename.split(".")
          if file_arry.size > 1
            att_name="#{@user.id}." + file.original_filename.split(".")[file_arry.size - 1]
          else
            att_name="#{@user.id}"
          end

          content = file.read
          f = File.new("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{att_name}", "wb")
          f.write(content)
          f.close

          att = Attachment.new
          att.category = params["paper_type"]
          att.up_time = Time.now()
          att.file_name = att_name
          att.file_path = "#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{att_name}"
          att.file_url = "#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{att_name}"
          att.guid = ""
          att.content_type  = "text/plain"
          att.save

          @user.paperwork_id = att.id
          @user.save
        end
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order]
    else
      render :text=>"创建失败"
    end
  end

  def edit
    @user=WUser.find(params[:id])
    if (@user.paperwork_id!=0)
      @att = Attachment.find(@user.paperwork_id)
      @paper_type = @att.category
    end
  end

  def update
    file = params["file"]
    category = params["paper_type"]
    @user=WUser.find(params[:id])
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.update_attributes(params[:user])
      if ! file.blank?
          base_path = AttachmentConfig.find_by_code(category).network_dir
          s = Time.now.to_s(:db)
          aaa = s.split(" ")[0]
          bbb = s.split(" ")[1]
          year = aaa.split("-")[0]
          month = aaa.split("-")[1]
          date = aaa.split("-")[2]
          hour = bbb.split(":")[0]
          minute = bbb.split(":")[1]
          if !File.exists?("#{base_path}/#{year}")
            Dir.mkdir("#{base_path}/#{year}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}")
            Dir.mkdir("#{base_path}/#{year}/#{month}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
          end
          if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
            Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
          end

#          file_arry = file.original_filename.split(".")
          ext_name =file.original_filename.split(".").last
          file_name= Guid.new.to_s + "." + ext_name
#          if file_arry.size > 1
#            att_name="#{@user.id}." + file.original_filename.split(".")[file_arry.size - 1]
#          else
#            att_name="#{@user.id}"
#          end

          content = file.read
          f = File.new("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{file_name}", "wb")
          f.write(content)
          f.close

          att = Attachment.new
          att.category = params["paper_type"]
          att.up_time = Time.now()
          att.file_name = file.original_filename
          att.file_path = "/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{file_name}"
          att.file_url = "/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{file_name}"
          att.remark = ""
          att.guid = Guid.new.to_s
          att.content_type  = file.content_type
          att.save

          @user.paperwork_id = att.id
          @user.save
      elsif @user.paperwork_id != 0
        @att=Attachment.find(@user.paperwork_id )
        if @att
         @att.category = params["paper_type"]
         @att.save
        end
      end

      
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def delete
    @user=WUser.find(params[:id])
    @user.active = 0
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end


  def file_down
    @att=Attachment.find(params[:id])
    if @att.file_path.blank?
      fd = Extranet::FileDown.new
      path =fd.down(@att)
      @att.file_path = path
      @att.file_url = path
      @att.save
    end
    send_file(AttachmentConfig.find_by_code(@att.category).network_dir  + @att.file_path, :filename=>@att.file_name)
  end

  def change_password
    @user=WUser.find(params[:id])
    @user.password=""
  end

  def change_password_do
    @user=WUser.find(params[:id])
    @user.password=params[:user][:password]
    @user.u=session[:user_code]
    @user.u_t=Time.now()
    if @user.save
      render :text=>"密码修改成功！"
    else
      render :action =>"change_password"
    end
  end
  
end
