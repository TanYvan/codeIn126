require 'digest/sha1'

class DocformatController < ApplicationController
  def docformat_list
    @bbjj={1=>"是",0=>"否"}
    @head_1={1=>"是",0=>"否"}
    @send_code={1=>"是",0=>"否"}
    @uuu={"Y"=>"使用","N"=>"停用"}
    @approval={1=>"审批",0=>"不审批"}
    @f_doc={1=>"生成外部函",0=>"不生成外部函"}

    @hant_search_1_page_name="docformat_list"
    @hant_search_1=[
      ['char','spell','格式函拼音','text',[]],
      ['char','name','格式函名称','text',[]],
      ['char','code','格式函编码','text',[]],
      ['char','aribitprog_num','仲裁程序','text',[]],
      ['char','path','格式函路径','text',[]],
      ['char','approval','是否需要审批','text',[]]
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
    if @order==nil
      @order="code"
    end
#    if params[:spell]=="" or params[:spell]==nil
#      c="used='Y'"
#    else
#      c="used='Y' and spell='#{params[:spell]}'"
#    end
    c="used='Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @docformat_pages, @docformat = paginate :tb_doc_formats,:conditions=>c ,:order=>@order,:per_page=>@page_lines.to_i
  end
  def docformat_new
    @docformat=TbDocFormat.new()
  end
  def docformat_create
    @docformat=TbDocFormat.new(params[:docformat])
    @docformat.u=session[:user_code]
    @docformat.u_t=Time.now()
    if @docformat.save
      flash[:notice]="创建成功"
      redirect_to :action=>"docformat_list"
    else
      flash[:notice]="创建失败"
    end
  end
  def docformat_edit
    @docformat=TbDocFormat.find(params[:id])
  end
  def docformat_update
    @docformat=TbDocFormat.find(params[:id])
    @docformat.u=session[:user_code]
    @docformat.u_t=Time.now()
    if @docformat.update_attributes(params[:docformat])
      flash[:notice]="修改成功"
      redirect_to :action=>"docformat_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"docformat_edit",:id=>params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def approval_list
    c="format_code='#{params[:format_code]}' and used='Y'"
    @approval_pages, @approval = paginate :tb_doc_format_approvals,:conditions=>c,:order=>'id',:per_page => 18
  end
  def approval_new
    @approval=TbDocFormatApproval.new()
  end
  def approval_create
    @approval=TbDocFormatApproval.new(params[:approval])
    @approval.format_code = params[:format_code]
    @approval.u=session[:user_code]
    @approval.u_t=Time.now()
    if @approval.save
      flash[:notice]="创建成功"
      redirect_to :action=>"approval_list",:format_code=>params[:format_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"approval_new",:format_code=>params[:format_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def approval_edit
    @approval=TbDocFormatApproval.find(params[:id])
  end
  def approval_update
    @approval=TbDocFormatApproval.find(params[:id])
    @approval.u=session[:user_code]
    @approval.u_t=Time.now()
    if @approval.update_attributes(params[:approval])
      flash[:notice]="修改成功"
      redirect_to :action=>"approval_list",:format_code=>params[:format_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"approval_edit",:format_code=>params[:format_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def approval_delete
    @approval=TbDocFormatApproval.find(params[:id])
    @approval.used="N"
    @approval.u=session[:user_code]
    @approval.u_t=Time.now()
    if @approval.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"approval_list",:format_code=>params[:format_code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
  
  def vie_word
    @dc=TbDocFormat.find(params[:id])
    aaa=@dc.path.split("/")
    @file_path=SysArg.find_by_code('8003').val+"\\\\"+ aaa[1]
  end
  
  def vie
    @fu=Digest::SHA1.hexdigest(session[:user_code])+User.find_by_code(session[:user_code]).password
    @dc=TbDocFormat.find(params[:id])
    #########################################
    @doc_path="http://#{SysArg.find_by_code('9000').val}:#{SysArg.find_by_code('9001').val}/#{@dc.path}"
  end
  
  def dc_update
    @dc=TbDocFormat.find(params[:FileID])
    #########################################
    fu=params[:fu]
    #########################################
    #if Digest::SHA1.hexdigest(@case.clerk)+User.find_by_code(@case.clerk).password==fu
    utf8_to_gbk  = Iconv.new('gbk','utf-8')  
    gbk_to_utf8 = Iconv.new('utf-8','gbk')
    #f_name = params["filedata"].original_filename  
    file = params["FileData"]   #获取文档，此处为tempfile类型的
    #读取文档的内容，目前不用编码转换即可正常显示，在存入数据库中时或许涉及到编码转换
    content = file.read  #gbk_to_utf8.iconv
    #新建同名文件，读取修改的文件内容用以覆盖源文件，注意路径要与读取的一致
    f = File.new("#{RAILS_ROOT}/public/#{@dc.path}", "wb")
    f.write(content)
    f.close
    if !file.original_filename.empty?    
      flash[:notice] = "保存成功"
    else
      flash[:notice] = "保存失败"
    end
    #end
  end
  #选项管理 #######################################
  def manage_list
    @code=params[:code]
    @name=TbDocFormat.find_by_code(@code).name
    @docformatobj=TbDocFormatObj.find(:all,:conditions=>["used='Y' and format_code=?",@code])
  end
  def m_new
    @code=params[:code]
    @name=TbDocFormat.find_by_code(@code).name
    @docformatobj=TbDocFormatObj.new()
  end
  def m_create
    @docformatobj=TbDocFormatObj.new(params[:docformatobj])
    @docformatobj.format_code=params[:code]
#    @docformatobj.obj_code=params[:obj_code]
    @docformatobj.u=session[:user_code]
    @docformatobj.u_t=Time.now()
    if @docformatobj.save
      flash[:notice]="创建成功"
      redirect_to :action=>"manage_list",:code=>params[:code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render_to :action=>"manage",:code=>params[:code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def m_delete
    @docformatobj=TbDocFormatObj.find(:first,:conditions=>["format_code=? and obj_code=?",params[:code],params[:obj_code]])
    @docformatobj.used="N"
    @docformatobj.u=session[:user_code]
    @docformatobj.u_t=Time.now()
    if @docformatobj.save
      flash[:notice]="删除成功"
      redirect_to :action=>"manage_list",:code=>params[:code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render_to :action=>"manage_list",:code=>params[:code],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end    
  end
end
