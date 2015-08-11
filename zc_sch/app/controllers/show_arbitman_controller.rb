class ShowArbitmanController < ApplicationController
#仲裁员管理的仲裁员信息维护部分，包含基本信息、教育信息、专业特长、培训信息、特殊要求、外语语种及财务信息等
#创建人 苏获 
#创建时间 20090522
    
    #显示基本信息列表
    def list_arbitman           
        @hant_search_1_page_name="list_arbitman"
        @hant_search_1=[['char','tb_arbitmen_name','姓名','text',[]],
          ['char','tb_arbitmen_spell','姓名拼音缩写','text',[]],
          ['char','tb_arbitmen_sex','性别','text',[]],
          ['char','tb_arbitmen_code','编码','text',[]],
#          ['char','name','年龄','text',[]],    
          ['char','tb_arbitmen_salutation','称呼','text',[]],
          ['char','tb_arbitmen_zy','职业分类','select',TbDictionary.find(:all,:conditions=>"typ_code='9002' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
          ['char','tb_arbitmen_company','单位','text',[]],
          ['char','tb_arbitmen_country','国籍','text',[]],
          ['char','tb_arbitmen_city','居住地','text',[]],
          ['char','tb_languages_language','外语语种','select',TbDictionary.find(:all,:conditions=>"typ_code='9008' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
          ['char','specials_speciality_num','精通专业','select',TbDictionary.find(:all,:conditions=>"typ_code='9012' and state='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
          ['char','tb_arbitmanexprires_expire','年度','text',[]]
#          ['char','name','是否参加专业培训','text',[]],
#          ['char','name','有无超审限案件','text',[]],
#          ['char','name','审结案件案件','text',[]],
#          ['char','name','一年内可办案件数','text',[]],
#          ['char','name','一年内愿意承接案件数','text',[]],
#          ['char','name','一年内实际承接案件数','text',[]]
          ]
       @hant_search_1_list=['tb_arbitmen_name','tb_arbitmen_spell','tb_arbitmen_sex',
      'tb_arbitmen_code','tb_arbitmen_salutation','tb_arbitmen_company',
      'tb_arbitmen_country','tb_arbitmen_city','tb_arbitmanexprires_expire']
        @order=params[:order]
        if @order==nil or @order==""
            @order="tb_arbitmen_code"
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
        c = "used='Y'"
        p=PubTool.new()
        if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
            c = c + @search_condit
        end        
        @tb_arbitman_pages,@tb_arbitmen =paginate_by_sql(VCaseQuery1List9,"select distinct tb_arbitmen_code,tb_arbitmen_id,
    tb_arbitmen_name,tb_arbitmen_sex,tb_arbitmen_addr,tb_arbitmen_company,tb_arbitmen_mobiletel,tb_arbitmen_postcode
    from v_case_query1_list9s where #{c} order by #{@order}",@page_lines.to_i)
    end

    #修改基本信息
    def show_arbitman
        @tb_arbitman = TbArbitman.find(params[:id])
        @tb_photo = TbPhoto.find_by_arbitman_id(@tb_arbitman.id)
        @now = TbArbitmannow.find(:first,:conditions =>["arbitman_num = ?",@tb_arbitman.code])
    end

    #显示照片
    def show_photo
        @tb_arbitman = TbArbitman.find(params[:id])
        utf8_to_gbk  = Iconv.new('gbk','utf-8')  #Iconv 编码转换
        gbk_to_utf8 = Iconv.new('utf-8','gbk') 
        @tb_photo = TbPhoto.find(:first, :conditions =>["used = 'Y' and arbitman_id = ?",@tb_arbitman.id]) 
    end        

        #修改背景信息
        def show_background        
            @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
        end

        #修改财务信息
        def show_finance        
            @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
        end
    
        #修改设置信息
        def show_setting        
            @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
        end

        #修改可办理案件信息
        def show_caseperyear        
            @tb_arbitman = TbArbitman.find_or_create_by_id(params[:id])
        end
     
        #显示仲裁员培训的列表
        def list_train
            @tb_arbitman = TbArbitman.find(params[:id])
            @tb_trains = TbTrain.find_trains(@tb_arbitman.code)
        end
    
        #仲裁员简历的列表
        def list_resume
            @tb_arbitman = TbArbitman.find(params[:id])
            @arbitman_num = @tb_arbitman.code
            @tb_resumes = TbResume.find_resumes(@arbitman_num)
        end

        #显示外语语种列表
        def list_language
            @tb_arbitman = TbArbitman.find(params[:id])
            @arbitman_num = @tb_arbitman.code
            @tb_languages = TbLanguage.find_languages(@arbitman_num)
        end    

        #显示仲裁员受教育的列表
        def list_educate
            @tb_arbitman = TbArbitman.find(params[:id])
            @tb_educates = TbEducate.find_educates(@tb_arbitman.code)
        end

        #显示仲裁员精通专业信息
        def list_speciality
            @arbitman_num = params[:arbitman_num]
            @id = TbArbitman.find(@arbitman_num)
            @specialities = Special.find(:all, :conditions =>["arbitman_num = ? and used = 'Y'",@arbitman_num],:order => "id") 
            #@specialities = Special.find_specialities(@arbitman_id)        
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
end
