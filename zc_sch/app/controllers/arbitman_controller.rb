#仲裁员管理的仲裁员信息维护部分，包含基本信息、教育信息、专业特长、培训信息、特殊要求、外语语种及财务信息等
#创建人 苏获 
#创建时间 20090508
class ArbitmanController < ApplicationController
  #显示头像的辅助函数
  #include ApplicationHelper
  #helper :arbitman
    
  #显示基本信息
  def list_arbitman           
    @hant_search_1_page_name="list_arbitman"
    @hant_search_1=[['char','spell','姓名拼音缩写','text',[]],
      ['char','name','姓名','text',[]]]
    @hant_search_1_list=['name','spell']
    @order=params[:order]
    if @order==nil or @order==""
      @order="code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 10
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
    c = "used = 'Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @tb_arbitman_pages,@tb_arbitmen =paginate(:tb_arbitmen,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)
  end
    
  #增加仲裁员
  def new_arbitman
    @tb_arbitman = TbArbitman.new
  end
  #修改基本信息
  def edit_arbitman          
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_photo = TbPhoto.find_by_arbitman_id(@tb_arbitman.id)
    @now = TbArbitmannow.find(:first,:conditions =>["arbitman_num = ?",@tb_arbitman.code])
  end

  ## 删除照片
  def delete_photo
    @tb_photo = TbPhoto.find(params[:photo_id])
    @tb_photo.used='N'
    @tb_photo.u = session[:user_code]
    @tb_photo.u_t = Time.now 
    @tb_arbitman = TbArbitman.find(@tb_photo.arbitman_id)
    @tb_arbitman.pic='N'
    if @tb_photo.save and @tb_arbitman.save
      flash[:notice] = "删除成功！"
      redirect_to :action => "edit_photo", :id => params[:id]
    else
      flash[:notice] = "删除失败！"
      redirect_to :action => "edit_photo", :id => params[:id]
    end
  end
  #显示照片
  def edit_photo
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_photo = TbPhoto.find(:first, :conditions =>["used='Y' and arbitman_id = ?",@tb_arbitman.id]) 
  end        
  ################################################################################
    
  #文件上传的代码
  def upload_file
    @arbitman = TbArbitman.find(params[:id])
    cov  = Iconv.new('gbk','utf-8')  # Iconv 编码转换
    #gbk_to_utf8 = Iconv.new('utf-8','gbk')
    file=params["photo"][:file]  # params["file"]与params[:file]作用相同
    begin
      if !file.original_filename.empty?  
        f_name="#{cov.iconv(file.original_filename)}"  
        filename_changed = @arbitman.code + "_"+ f_name 
        filename_changed_2 = @arbitman.code + "_"+ file.original_filename
        
        if File.exists?("#{RAILS_ROOT}/public/arbitman_pic/")

        else 
          Dir.mkdir("#{RAILS_ROOT}/public/arbitman_pic/")
        end
        File.open("#{RAILS_ROOT}/public/arbitman_pic/#{filename_changed_2}","wb") do |f|                         
          f.write(file.read) 
        end

        #将文件名存储到数据库
        @tb_photo = TbPhoto.new()
        @tb_photo.used='Y'
        @tb_photo.pic_name = filename_changed_2
        @tb_photo.arbitman_id = @arbitman.id
        @tb_photo.arbitman_code = @arbitman.code
        @tb_photo.u = session[:user_code]
        @tb_photo.u_t = Time.now
        @tb_photo.save  

        @arbitman.pic='Y'
        @arbitman.save

        flash[:notice] = "上传成功！"
      else
        flash[:notice] = "上传失败！" 
      end
    rescue
      flash[:notice] = "上传失败！"
    end
    redirect_to :action => "edit_photo", :id => params[:id]
    
  end


  #添加仲裁员的信息
  def create_arbitman    
    @tb_arbitman = TbArbitman.new(params[:tb_arbitman]) 
    if @tb_arbitman.code==''
      @tb_arbitman.code=SysArg.add_0008()
    end
    if @tb_arbitman.birthday!=nil
      @tb_arbitman.age=Time.now.year-@tb_arbitman.birthday.year
    else
      @tb_arbitman.birthday=nil
    end
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now    
    if  @tb_arbitman.save
      @nc=TbAribitmanNameChange.new
      @nc.name=@tb_arbitman.name
      @nc.code=@tb_arbitman.code
      @nc.u=session[:user_code]
      @nc.u_t=Time.now
      @nc.save
      flash[:notice] = "添加成功！"
      redirect_to :action => "list_arbitman" ,:page=>params[:page],:page_lines=>params[:page_lines]      
    else     
      flash[:notice] = "必填项不能为空！"        
      render :action => "new_arbitman" ,:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  #更新仲裁员记录
  def update_arbitman
    @tb_arbitman = TbArbitman.find(params[:id]) 
    
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    if @tb_arbitman.update_attributes(params[:tb_arbitman])
      if @tb_arbitman.birthday!=nil
        @tb_arbitman.age=Time.now.year-@tb_arbitman.birthday.year
      else
        @tb_arbitman.birthday=nil
      end
      @tb_arbitman.save
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_arbitman",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action=>"edit_arbitman", :id => params[:id]
    end
  end
  #删除仲裁员记录
  def delete_arbitman            
    @tb_arbitman = TbArbitman.find(params[:id]) 
    @tb_arbitman.used = 'N'
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    if @tb_arbitman.save
      flash[:notice]="删除成功"  
      redirect_to :action=>"list_arbitman",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"  
      redirect_to :action=>"list_arbitman",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  def name_edit         
    @tb_arbitman = TbArbitman.find(params[:id])
    @nc=TbAribitmanNameChange.find(:all,:conditions=>["code=?",@tb_arbitman.code],:order=>"u_t desc")
  end 
  
  def name_update       
    @tb_arbitman = TbArbitman.find(params[:id])
    if @tb_arbitman.update_attributes(params[:tb_arbitman])
      @nc=TbAribitmanNameChange.new
      @nc.name=@tb_arbitman.name
      @nc.code=@tb_arbitman.code
      @nc.u=session[:user_code]
      @nc.u_t=Time.now
      @nc.save
      flash[:notice]="更名成功"  
      redirect_to :action=>"list_arbitman",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action=>"name_edit",:id => params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
    
  #修改背景信息
  def edit_background        
    @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
  end
  #保存背景信息
  def save_background
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    @tb_arbitman.update_attributes(params[:tb_arbitman])
    redirect_to :action=>"edit_arbitman",:id => @tb_arbitman.id
  end    

  #修改财务信息
  def edit_finance        
    @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
  end
  #保存财务信息
  def save_finance
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    @tb_arbitman.update_attributes(params[:tb_arbitman])
    redirect_to :action=>"edit_arbitman",:id => @tb_arbitman.id
  end  
    
  #修改设置信息
  def edit_setting        
    @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
  end
  #保存设置信息
  def save_setting
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_arbitman.update_attributes(params[:tb_arbitman])
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now           
    redirect_to :action=>"edit_arbitman",:id => @tb_arbitman.id
  end  

  #修改可办理案件信息
  def edit_caseperyear        
    @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
  end
  #保存可办理案件信息
  def save_caseperyear
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_arbitman.update_attributes(params[:tb_arbitman])
    @tb_arbitman.user = session[:user_code]
    @tb_arbitman.u_time = Time.now         
    redirect_to :action=>"edit_arbitman",:id => @tb_arbitman.id
  end  
    
  #以下是培训处理
  #新建培训
  def new_train
    @tb_arbitman = TbArbitman.find(params[:id]) 
    @tb_train = TbTrain.new
  end
    
  #创建仲裁员培训的对象
  def create_train
    @tb_train = TbTrain.new(params[:tb_train])
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_train.arbitmannum = @tb_arbitman.code
    @tb_train.user = session[:user_code]
    @tb_train.u_time = Time.now         
    if @tb_train.save
      flash[:notice]="创建成功"
      redirect_to  :action=>"list_train", :id => @tb_arbitman.id
    else
      flash[:notice]="必填项不可为空"
      render :action=>"new_train", :id => @tb_arbitman.id        
    end
  end
     
  #显示仲裁员培训的列表
  def list_train
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_trains = TbTrain.find_trains(@tb_arbitman.code)
  end
  #修改仲裁员培训
  def edit_train
    @tb_train = TbTrain.find(params[:id])
    @tb_arbitman = TbArbitman.find_by_code(@tb_train.arbitmannum)
  end 
   
    
  #更新仲裁员培训
  def update_train
    @tb_train = TbTrain.find(params[:id])
    @tb_arbitman = TbArbitman.find_by_code(@tb_train.arbitmannum)
    @tb_train.user = session[:user_code]
    @tb_train.u_time = Time.now         
    if @tb_train.update_attributes(params[:tb_train])
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_train", :id => @tb_arbitman.id
    else
      render :action=>"edit_train", :id => params[:id]
    end
  end
  #删除培训
  def delete_train
    @train = TbTrain.find(params[:id])
    #@tb_train = TbTrain.delete(params[:id])
    @train.used = 'N'
    @tb_arbitman = TbArbitman.find_by_code(@train.arbitmannum)
    if @train.save        
      flash[:notice]="删除成功"
      redirect_to :action=>"list_train", :id => @tb_arbitman.id#确定怎么得到id进行删除
    else 
      flash[:notice]="删除失败"        
    end
  end
    
  #以下是简历处理部分
  #新建仲裁员简历
  def new_resume
    @tb_arbitman = TbArbitman.find(params[:id])       
    @tb_resume = TbResume.new
    @tb_resume.startdate=Date.today
    @tb_resume.enddate=Date.today
  end
    
  #创建仲裁员简历的对象
  def create_resume
    @tb_resume = TbResume.new(params[:tb_resume])
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_resume.arbit_id = @tb_arbitman.code
    @tb_resume.user = session[:user_code]
    @tb_resume.u_time = Time.now         
    if @tb_resume.save
      flash[:notice]="创建成功"
      redirect_to  :action=>"list_resume", :id => @tb_arbitman.id
    else
      flash[:notice]="必填项不可为空"
      render :action=>"new_resume", :id => @tb_arbitman.id      
    end
  end
     
  #修改仲裁员简历
  def edit_resume
    @tb_resume = TbResume.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_resume.arbit_id)
  end 
    
  #仲裁员简历的列表
  def list_resume
    @tb_arbitman = TbArbitman.find(params[:id])
    @arbitman_num = @tb_arbitman.code
    @tb_resumes = TbResume.find_resumes(@arbitman_num)
  end
    
  #更新仲裁员简历
  def update_resume
    @tb_resume = TbResume.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_resume.arbit_id)
    @tb_resume.user = session[:user_code]
    @tb_resume.u_time = Time.now         
    if @tb_resume.update_attributes(params[:tb_resume])
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_resume", :id => @tb_arbitman.id
    else
      render :action=>"edit_resume", :id => params[:id]
    end
  end
    
  #删除简历
  def delete_resume
    @resume= TbResume.find(params[:id])      
    @resume.used = 'N'
    @resume.user = session[:user_code]
    @resume.u_time = Time.now          
    @tb_arbitman = TbArbitman.find_by_code(@resume.arbit_id)
    if @resume.save!         
      flash[:notice]="删除成功"
      redirect_to :action=>"list_resume", :id => @tb_arbitman.id#确定怎么得到id进行删除
    else 
      flash[:notice]="删除失败"        
    end
  end
    
  #以下是外语语种处理部分
  #新建外语语种
  def new_language
    @tb_arbitman = TbArbitman.find(params[:id])   
    @tb_language = TbLanguage.new
  end
  #显示外语语种列表
  def list_language
    @tb_arbitman = TbArbitman.find(params[:id])
    @arbitman_num = @tb_arbitman.code
    @tb_languages = TbLanguage.find_languages(@arbitman_num)
  end
    
  #创建仲裁员外语语种实例，存入数据库
  def create_language
    begin
      @tb_language = TbLanguage.new(params[:tb_language])
      @tb_arbitman = TbArbitman.find(params[:id])
      @tb_language.arbitman = @tb_arbitman.code
      @tb_language.user = session[:user_code]
      @tb_language.u_time = Time.now         
      @tb_language.save!
      redirect_to :action=>"list_language", :id => @tb_arbitman.id
                
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="必填项不可为空"
      render :action=>"new_language", :id => @tb_arbitman.id       
    end
  end
    
  #修改外语语种
  def edit_language
    @tb_language = TbLanguage.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_language.arbitman)
  end
    
  #更新仲裁员外语语种
  def update_language
    @tb_language = TbLanguage.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_language.arbitman)
    @tb_language.user = session[:user_code]
    @tb_language.u_time = Time.now        
    if @tb_language.update_attributes(params[:tb_language])
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_language", :id => @tb_arbitman.id  
    else
      render :action=>"edit_language", :id => params[:id]  
    end
  end
    
  #删除语种
  def delete_language
    @language = TbLanguage.find(params[:id])      
    @language.used = 'N'
    @language.user = session[:user_code]
    @language.u_time = Time.now         
    @tb_arbitman = TbArbitman.find_by_code(@language.arbitman)
    if @language.save        
      flash[:notice]="删除成功"
      redirect_to :action=>"list_language", :id => @tb_arbitman.id#确定怎么得到id进行删除
    else 
      flash[:notice]="删除失败"        
    end
  end
    
  #以下是教育处理部分
  #新建教育的对象
  def new_educate
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_educate = TbEducate.new()
  end
  #创建教育对象
  def create_educate
    @tb_educate = TbEducate.new(params[:tb_educate])
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_educate.arbitman = @tb_arbitman.code
    @tb_educate.user = session[:user_code]
    @tb_educate.u_time = Time.now
    if @tb_educate.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list_educate", :id => @tb_arbitman.id
    else
      flash[:notice]="必填项不可为空"
      render :action=>"new_educate", :id => @tb_arbitman.id        
    end
  end
    
  #显示仲裁员受教育的列表
  def list_educate
    @tb_arbitman = TbArbitman.find(params[:id])
    @tb_educates = TbEducate.find_educates(@tb_arbitman.code)
  end
    
  #修改教育信息
  def edit_educate
    @tb_educate = TbEducate.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_educate.arbitman)
  end
  #更新仲裁员教育信息
  def update_educate
    @tb_educate = TbEducate.find(params[:id])
    @tb_arbitman = TbArbitman.find_or_create_by_code(@tb_educate.arbitman)
    @tb_educate.user = session[:user_code]
    @tb_educate.u_time = Time.now
    if @tb_educate.update_attributes(params[:tb_educate])
      flash[:notice]="修改成功"  
      redirect_to :action=>"list_educate", :id => @tb_arbitman.id  
    else
      render :action=>"edit_educate",  :id => params[:id]  
    end
  end   
    
  #删除教育信息
  def delete_educate
    @educate = TbEducate.find(params[:id])      
    @educate.used = 'N'
    @educate.user = session[:user_code]
    @educate.u_time = Time.now         
    @tb_arbitman = TbArbitman.find_by_code(@educate.arbitman)
    if @educate.save         
      flash[:notice]="删除成功"
      redirect_to :action=>"list_educate", :id => @tb_arbitman.id#确定怎么得到id进行删除
    else 
      flash[:notice]="删除失败"        
    end
  end

  #显示仲裁员精通专业信息
  def list_speciality
    @arbitman_num = params[:arbitman_num]
    @id = TbArbitman.find(@arbitman_num)
    @specialities = Special.find(:all, :conditions =>["arbitman_num = ? and used = 'Y'",@arbitman_num],:order => "id") 
    #@specialities = Special.find_specialities(@arbitman_id)        
  end

  #创建仲裁员精通专业信息记录
  def create_speciality
    @speciality = Special.new
    @speciality.speciality_num = params[:speciality_num]
    @speciality.arbitman_num = params[:arbitman_num]
    @speciality.user = session[:user_code]
    @speciality.u_time = Time.now
    if @speciality.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list_speciality", :arbitman_num => params[:arbitman_num]
    else
      flash[:notice]="创建失败"
      render :action=>"special_select", :arbitman_num => params[:arbitman_num]           
    end
  end
  #删除仲裁员精通专业信息记录
  def delete_speciality
    @speciality = Special.find(params[:id])
    #@tb_speciality = Special.delete(params[:id])
    @speciality.used = 'N'
    @speciality.user = session[:user_code]
    @speciality.u_time = Time.now        
    @tb_arbitman = TbArbitman.find(@speciality.arbitman_num)
    if @speciality.save         
      flash[:notice]="删除成功"
      redirect_to :action=>"list_speciality", :arbitman_num => params[:arbitman_num]#确定怎么得到id进行删除
    else 
      flash[:notice]="删除失败"        
    end        
  end
  #选择业务专长
  def special_select
    @arbitman_num = params[:arbitman_num]
    @specials = TbDictionary.find(:all, :conditions =>["typ_code = 9012 and state = 'Y'"])
  end
    
    
    
  private
  #由仲裁员编号得到仲裁员姓名
  def get_arbitname(arbitnum)
    @arbitmanname = get_name(arbitnum)
  end
  #为查询组织sql语句
  def prepare_sql(arbitmanName,spell)
    @name = arbitmanName
    @spell = spell
    sql="select name, sex, addr, company, telo, postcode from tb_arbitmen"
    if @name != nil and @name != ""
      sql += " where Name = '" + @name +"'"
    end
    if @spell != nil and @spell != ""
      sql += " and Spell = '" + @spell+"'"
    end
    return sql                       
  end
    
    
  protected
  def validate
    errors.add(:name, "should not be blank!") if name.nil?
    errors.add(:code, "should not be blank!") if code.nil?
  end
      
end