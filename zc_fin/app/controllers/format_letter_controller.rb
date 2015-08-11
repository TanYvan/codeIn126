#为每个格式函生成供处理的二维数组的类
#添加人 苏获
#添加时间 20090615
class FormatLetterController < ApplicationController
    def show
        @func = "format_letter_" + params[:letter_id]
        @format_letter_str = format_letter_dfmt31
    end
    
    def up_doc
        utf8_to_gbk  = Iconv.new('gbk','utf-8')  #Iconv 编码转换
        gbk_to_utf8 = Iconv.new('utf-8','gbk')
        f_name = params["FileData"].original_filename  #
        file = params["FileData"]  
        if !File.exists?("#{RAILS_ROOT}/public/files")
            Dir.mkdir("#{RAILS_ROOT}/public/files/")  
        end
        content = file.read  #gbk_to_utf8.iconv
        f = File.new("F:\\mytest\\zc\\public\\" + f_name, "wb")
        f.write(content)
        f.close
        if !file.original_filename.empty?             
            flash[:notice] = "上传成功！"
        end
    end         

    def format_letter_dfmt04
        #拼接字串，初始化
        @format_dfmt04 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt04 = add_record("<01$$$>",@file_code,@format_dfmt04)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_dfmt04 = add_record("<02$$$>",@applicant,@format_dfmt04)  
        @format_dfmt04 = add_record("<03$$$>",@applicant,@format_dfmt04)
        #受理日期
        @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).receivedate
        if @date_receive == nil or @date_receive == ""
            @date_receive = "no"
            @format_dfmt04 = add_record("<04$$$>",@date_receive,@format_dfmt04) 
            @format_dfmt04 = add_record("<05$$$>",@date_receive,@format_dfmt04)
            @format_dfmt04 = add_record("<06$$$>",@date_receive,@format_dfmt04)
        else
            arr_date = @date_receive.to_s.split("-")
            @format_dfmt04 = add_record("<04$$$>",arr_date[0],@format_dfmt04) 
            @format_dfmt04 = add_record("<05$$$>",arr_date[1],@format_dfmt04)
            @format_dfmt04 = add_record("<06$$$>",arr_date[2],@format_dfmt04)            
        end     

        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt04 = add_record("<07$$$>",@respondent,@format_dfmt04)
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt04 = add_record("<08$$$>",@contract_name,@format_dfmt04)
        #受理费
        @litigation_fee = applicant_litigation_fee(session[:recevice_code])
        if @litigation_fee == nil or @litigation_fee == ""
            @litigation_fee = "no"
        end
        @format_dfmt04 = add_record("<09$$$>",@litigation_fee,@format_dfmt04)    
        #处理费
        @processing_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @processing_fee == nil or @processing_fee == ""
            @processing_fee = "no"
        end        
        @format_dfmt04 = add_record("<10$$$>",@processing_fee,@format_dfmt04)     
        #合计
        @total_fee = @litigation_fee + @processing_fee
        if @litigation_fee == "no" or @processing_fee == "no"
            @total_fee = "no"
        end
        @format_dfmt04 = add_record("<11$$$>",@total_fee,@format_dfmt04)        
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt04 = add_record("<12$$$>",@case_alerk,@format_dfmt04)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt04 = add_record("<13$$$>",@telephone,@format_dfmt04)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt04 = add_record("<14$$$>",@fax,@format_dfmt04)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt04 = add_record("<15$$$>",@email,@format_dfmt04)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt04 = add_record("<16$$$>",@date_of_letter,@format_dfmt04) 
            @format_dfmt04 = add_record("<17$$$>",@date_of_letter,@format_dfmt04)
            @format_dfmt04 = add_last_record("<18$$$>",@date_of_letter,@format_dfmt04)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt04 = add_record("<16$$$>",arr_date[0],@format_dfmt04) 
            @format_dfmt04 = add_record("<17$$$>",arr_date[1],@format_dfmt04)
            @format_dfmt04 = add_last_record("<18$$$>",arr_date[2].slice(0, 2),@format_dfmt04)            
        end   
    end
    
    def format_letter_dfmt05
        #拼接字串，初始化
        @format_dfmt05 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt05 = add_record("<01$$$>",@file_code,@format_dfmt05)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt05 = add_record("<02$$$>",@case_code,@format_dfmt05) 
        @format_dfmt05 = add_record("<06$$$>",@case_code,@format_dfmt05)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end   
        @format_dfmt05 = add_record("<03$$$>",@respondent,@format_dfmt05)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_dfmt05 = add_record("<04$$$>",@applicant,@format_dfmt05) 
        #签订的$$$所引起的争议（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt05 = add_record("<05$$$>",@contract_name,@format_dfmt05)
        #文件份数
        @copies = num_papers(@applicants.size)
        @format_dfmt05 = add_record("<07$$$>",@copies,@format_dfmt05) 
        @format_dfmt05 = add_record("<08$$$>",@copies,@format_dfmt05)
        @format_dfmt05 = add_record("<09$$$>",@copies,@format_dfmt05)                       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt05 = add_record("<10$$$>",@case_alerk,@format_dfmt05)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt05 = add_record("<11$$$>",@telephone,@format_dfmt05)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt05 = add_record("<12$$$>",@fax,@format_dfmt05)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt05 = add_record("<13$$$>",@email,@format_dfmt05)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt05 = add_record("<14$$$>",@date_of_letter,@format_dfmt05) 
            @format_dfmt05 = add_record("<15$$$>",@date_of_letter,@format_dfmt05)
            @format_dfmt05 = add_last_record("<16$$$>",@date_of_letter,@format_dfmt05)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt05 = add_record("<14$$$>",arr_date[0],@format_dfmt05) 
            @format_dfmt05 = add_record("<15$$$>",arr_date[1],@format_dfmt05)
            @format_dfmt05 = add_last_record("<16$$$>",arr_date[2].slice(0, 2),@format_dfmt05)            
        end          
    end
      
    def format_letter_dfmt06
        #拼接字串，初始化
        @format_dfmt06 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt06 = add_record("<01$$$>",@file_code,@format_dfmt06)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt06 = add_record("<02$$$>",@case_code,@format_dfmt06)  
        @format_dfmt06 = add_record("<08$$$>",@case_code,@format_dfmt06)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_dfmt06 = add_record("<03$$$>",@applicant,@format_dfmt06)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt06 = add_record("<04$$$>",@respondent,@format_dfmt06)
        #文件份数
        @copies = num_papers(@respondents.size)
        @format_dfmt06 = add_record("<05$$$>",@copies,@format_dfmt06)  
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end        
        @format_dfmt06 = add_record("<06$$$>",@arbit_fee,@format_dfmt06)           
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt06 = add_record("<07$$$>",@contract_name,@format_dfmt06)
       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt06 = add_record("<09$$$>",@case_alerk,@format_dfmt06)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt06 = add_record("<10$$$>",@telephone,@format_dfmt06)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt06 = add_record("<11$$$>",@fax,@format_dfmt06)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt06 = add_record("<12$$$>",@email,@format_dfmt06)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt06 = add_record("<13$$$>",@date_of_letter,@format_dfmt06) 
            @format_dfmt06 = add_record("<14$$$>",@date_of_letter,@format_dfmt06)
            @format_dfmt06 = add_last_record("<15$$$>",@date_of_letter,@format_dfmt06)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt06 = add_record("<13$$$>",arr_date[0],@format_dfmt06) 
            @format_dfmt06 = add_record("<14$$$>",arr_date[1],@format_dfmt06)
            @format_dfmt06 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_dfmt06)            
        end   
    end
    ###########################################################################
    #format_letter_dfmt07涉及到页面选项，暂时空缺
    ############################################################################
    def format_letter_dfmt07
        #拼接字串，初始化
        @format_dfmt07 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt07 = add_record("<01$$$>",@file_code,@format_dfmt07)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt07 = add_record("<02$$$>",@case_code,@format_dfmt07)  
        @format_dfmt07 = add_record("<08$$$>",@case_code,@format_dfmt07)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_dfmt07 = add_record("<03$$$>",@applicant,@format_dfmt07)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt07 = add_record("<04$$$>",@respondent,@format_dfmt07)
        #文件份数
        @copies = num_papers(@respondents.size)
        @format_dfmt07 = add_record("<05$$$>",@copies,@format_dfmt07)  
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end        
        @format_dfmt07 = add_record("<06$$$>",@arbit_fee,@format_dfmt07)           
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt07 = add_record("<07$$$>",@contract_name,@format_dfmt07)
       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt07 = add_record("<09$$$>",@case_alerk,@format_dfmt07)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt07 = add_record("<10$$$>",@telephone,@format_dfmt07)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt07 = add_record("<11$$$>",@fax,@format_dfmt07)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt07 = add_record("<12$$$>",@email,@format_dfmt07)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt07 = add_record("<13$$$>",@date_of_letter,@format_dfmt07) 
            @format_dfmt07 = add_record("<14$$$>",@date_of_letter,@format_dfmt07)
            @format_dfmt07 = add_last_record("<15$$$>",@date_of_letter,@format_dfmt07)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt07 = add_record("<13$$$>",arr_date[0],@format_dfmt07) 
            @format_dfmt07 = add_record("<14$$$>",arr_date[1],@format_dfmt07)
            @format_dfmt07 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_dfmt07)            
        end   
    end    
        
    def format_letter_dfmt09
        #拼接字串，初始化
        @format_dfmt09 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt09 = add_record("<01$$$>",@file_code,@format_dfmt09)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt09 = add_record("<02$$$>",@respondent,@format_dfmt09)   
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt09 = add_record("<03$$$>",@case_code,@format_dfmt09)            
        #被申请人受理费
        @litigation_fee = respondent_litigation_fee(session[:recevice_code])
        if @litigation_fee == nil or @litigation_fee == ""
            @litigation_fee = "no"
        end
        @format_dfmt09 = add_record("<04$$$>",@litigation_fee,@format_dfmt09)    
        #被申请人处理费
        @processing_fee = respondent_arbit_fee(session[:recevice_code]) 
        if @processing_fee == nil or @processing_fee == ""
            @processing_fee = "no"
        end        
        @format_dfmt09 = add_record("<05$$$>",@processing_fee,@format_dfmt09) 
        #其它实际费用开支费
        ################################# 空缺 ################################
        @other_fee = 0              
        @format_dfmt09 = add_record("<06$$$>",@other_fee,@format_dfmt09)
        #合计        
        if @litigation_fee != "no" and @processing_fee != "no" and @other_fee != "no"
            @total_fee = @litigation_fee.to_i + @processing_fee.to_i + @other_fee.to_i
        else
            @total_fee = "no"
        end
        @format_dfmt09 = add_record("<07$$$>",@total_fee,@format_dfmt09)           
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt09 = add_record("<08$$$>",@date_of_letter,@format_dfmt09) 
            @format_dfmt09 = add_record("<09$$$>",@date_of_letter,@format_dfmt09)
            @format_dfmt09 = add_last_record("<10$$$>",@date_of_letter,@format_dfmt09)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt09 = add_record("<08$$$>",arr_date[0],@format_dfmt09) 
            @format_dfmt09 = add_record("<09$$$>",arr_date[1],@format_dfmt09)
            @format_dfmt09 = add_last_record("<10$$$>",arr_date[2].slice(0, 2),@format_dfmt09)            
        end   
    end    
        
    def format_letter_dfmt26(respondent)
        #拼接字串，初始化
        @format_dfmt26 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt26 = add_record("<01$$$>",@file_code,@format_dfmt26)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt26 = add_record("<02$$$>",@respondent,@format_dfmt26)   
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt26 = add_record("<03$$$>",@case_code,@format_dfmt26)            
        #####################   仲裁员空缺 ######################################          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt26 = add_record("<06$$$>",@date_of_letter,@format_dfmt26) 
            @format_dfmt26 = add_record("<07$$$>",@date_of_letter,@format_dfmt26)
            @format_dfmt26 = add_last_record("<08$$$>",@date_of_letter,@format_dfmt26)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt26 = add_record("<06$$$>",arr_date[0],@format_dfmt26) 
            @format_dfmt26 = add_record("<07$$$>",arr_date[1],@format_dfmt26)
            @format_dfmt26 = add_last_record("<08$$$>",arr_date[2].slice(0, 2),@format_dfmt26)            
        end   
    end  
            
    def format_letter_dfmt26(applicant)
        #拼接字串，初始化
        @format_dfmt26 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt26 = add_record("<01$$$>",@file_code,@format_dfmt26)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |appl|
                @applicant = @applicant + appl.partyname
            end
        end       
        @format_dfmt26 = add_record("<02$$$>",@applicant,@format_dfmt26)       
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt26 = add_record("<03$$$>",@case_code,@format_dfmt26)            
        #####################   仲裁员空缺 ######################################          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt26 = add_record("<06$$$>",@date_of_letter,@format_dfmt26) 
            @format_dfmt26 = add_record("<07$$$>",@date_of_letter,@format_dfmt26)
            @format_dfmt26 = add_last_record("<08$$$>",@date_of_letter,@format_dfmt26)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt26 = add_record("<06$$$>",arr_date[0],@format_dfmt26) 
            @format_dfmt26 = add_record("<07$$$>",arr_date[1],@format_dfmt26)
            @format_dfmt26 = add_last_record("<08$$$>",arr_date[2].slice(0, 2),@format_dfmt26)            
        end   
    end  
        
    def format_letter_dfmt31
        #拼接字串，初始化
        @format_dfmt31 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt31 = add_record("<01$$$>",@file_code,@format_dfmt31)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt31 = add_record("<02$$$>",@case_code,@format_dfmt31) 
        @format_dfmt31 = add_record("<06$$$>",@case_code,@format_dfmt31)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end   
        @format_dfmt31 = add_record("<03$$$>",@respondent,@format_dfmt31)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_dfmt31 = add_record("<04$$$>",@applicant,@format_dfmt31) 
        #签订的$$$所引起的争议（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt31 = add_record("<05$$$>",@contract_name,@format_dfmt31)
        #文件份数
        @copies = num_papers(@applicants.size)
        @format_dfmt31 = add_record("<07$$$>",@copies,@format_dfmt31) 
        @format_dfmt31 = add_record("<08$$$>",@copies,@format_dfmt31)
        @format_dfmt31 = add_record("<09$$$>",@copies,@format_dfmt31) 
        @format_dfmt31 = add_record("<10$$$>",@copies,@format_dfmt31) 
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt31 = add_record("<11$$$>",@case_alerk,@format_dfmt31)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt31 = add_record("<12$$$>",@telephone,@format_dfmt31)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt31 = add_record("<13$$$>",@fax,@format_dfmt31)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt31 = add_record("<14$$$>",@email,@format_dfmt31)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt31 = add_record("<15$$$>",@date_of_letter,@format_dfmt31) 
            @format_dfmt31 = add_record("<16$$$>",@date_of_letter,@format_dfmt31)
            @format_dfmt31 = add_last_record("<17$$$>",@date_of_letter,@format_dfmt31)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt31 = add_record("<15$$$>",arr_date[0],@format_dfmt31) 
            @format_dfmt31 = add_record("<16$$$>",arr_date[1],@format_dfmt31)
            @format_dfmt31 = add_last_record("<17$$$>",arr_date[2].slice(0, 2),@format_dfmt31)            
        end          
    end
      
    def format_letter_dfmt32
        #拼接字串，初始化
        @format_dfmt32 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_dfmt32 = add_record("<01$$$>",@file_code,@format_dfmt32)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_dfmt32 = add_record("<02$$$>",@case_code,@format_dfmt32)  
        @format_dfmt32 = add_record("<08$$$>",@case_code,@format_dfmt32)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_dfmt32 = add_record("<03$$$>",@applicant,@format_dfmt32)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfmt32 = add_record("<04$$$>",@respondent,@format_dfmt32)
        #文件份数
        @copies = num_papers(@respondents.size)
        @format_dfmt32 = add_record("<05$$$>",@copies,@format_dfmt32)  
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end        
        @format_dfmt32 = add_record("<06$$$>",@arbit_fee,@format_dfmt32)           
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfmt32 = add_record("<07$$$>",@contract_name,@format_dfmt32)
       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_dfmt32 = add_record("<09$$$>",@case_alerk,@format_dfmt32)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_dfmt32 = add_record("<10$$$>",@telephone,@format_dfmt32)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_dfmt32 = add_record("<11$$$>",@fax,@format_dfmt32)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_dfmt32 = add_record("<12$$$>",@email,@format_dfmt32)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_dfmt32 = add_record("<13$$$>",@date_of_letter,@format_dfmt32) 
            @format_dfmt32 = add_record("<14$$$>",@date_of_letter,@format_dfmt32)
            @format_dfmt32 = add_last_record("<15$$$>",@date_of_letter,@format_dfmt32)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_dfmt32 = add_record("<13$$$>",arr_date[0],@format_dfmt32) 
            @format_dfmt32 = add_record("<14$$$>",arr_date[1],@format_dfmt32)
            @format_dfmt32 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_dfmt32)            
        end   
    end  
    
    def format_letter_dfor03
        #拼接字串，初始化
        @format_dfor03 = ""  
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_dfor03 = add_record("<01$$$>",@applicant,@format_dfor03)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_dfor03 = add_record("<02$$$>",@respondent,@format_dfor03)
        #案由及类别
        @casetype_num = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @casetype_num == nil or @casetype_num == ""
            @casetype_num = "no"
        else
            @casetype = TbDictionary.find_arbit_type("0002",@casetype_num).pactname
        end   
        @format_dfor03 = add_record("<03$$$>",@casetype,@format_dfor03)  
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_dfor03 = add_record("<04$$$>",@contract_name,@format_dfor03)        
        #明确争议金额
        @accounts = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001'",session[:recevice_code]],:order=>'id')
        @sum = 0
        for account in @accounts
            @sum = @sum + account.rmb_money
        end        
        @format_dfor03 = add_record("<05$$$>",@sum,@format_dfor03)            
        #被申请人受理费
        @litigation_fee = applicant_litigation_fee(session[:recevice_code])
        if @litigation_fee == nil or @litigation_fee == ""
            @litigation_fee = "no"
        end
        @format_dfor03 = add_record("<06$$$>",@litigation_fee,@format_dfor03)    
        #被申请人处理费
        @processing_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @processing_fee == nil or @processing_fee == ""
            @processing_fee = "no"
        end        
        @format_dfor03 = add_record("<07$$$>",@processing_fee,@format_dfor03) 
        #合计        
        if @litigation_fee != "no" and @processing_fee != "no" 
            @total_fee = @litigation_fee.to_i + @processing_fee.to_i
        else
            @total_fee = "no"
        end
        @format_dfor03 = add_last_record("<08$$$>",@total_fee,@format_dfor03)           
    end  
    
    def format_letter_fmt04
        #拼接字串，初始化
        @format_fmt04 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt04 = add_record("<01$$$>",@file_code,@format_fmt04)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_fmt04 = add_record("<02$$$>",@applicant,@format_fmt04)  
        @format_fmt04 = add_record("<03$$$>",@applicant,@format_fmt04)
        #受理日期
        @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).receivedate
        if @date_receive == nil or @date_receive == ""
            @date_receive = "no"
            @format_fmt04 = add_record("<04$$$>",@date_receive,@format_fmt04) 
            @format_fmt04 = add_record("<05$$$>",@date_receive,@format_fmt04)
            @format_fmt04 = add_record("<06$$$>",@date_receive,@format_fmt04)
        else
            arr_date = @date_receive.to_s.split("-")
            @format_fmt04 = add_record("<04$$$>",arr_date[0],@format_fmt04) 
            @format_fmt04 = add_record("<05$$$>",arr_date[1],@format_fmt04)
            @format_fmt04 = add_record("<06$$$>",arr_date[2],@format_fmt04)            
        end     

        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt04 = add_record("<07$$$>",@respondent,@format_fmt04)
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_fmt04 = add_record("<08$$$>",@contract_name,@format_fmt04)
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code])
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end
        @format_fmt04 = add_record("<09$$$>",@arbit_fee,@format_fmt04)         
        #受理费
        @litigation_fee = applicant_litigation_fee(session[:recevice_code])
        if @litigation_fee == nil or @litigation_fee == ""
            @litigation_fee = "no"
        end
        @format_fmt04 = add_record("<10$$$>",@litigation_fee,@format_fmt04)    
        #处理费
        @processing_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @processing_fee == nil or @processing_fee == ""
            @processing_fee = "no"
        end        
        @format_fmt04 = add_record("<11$$$>",@processing_fee,@format_fmt04)     
        #合计
        @total_fee = @litigation_fee + @processing_fee + @arbit_fee
        if @litigation_fee == "no" or @processing_fee == "no"
            @total_fee = "no"
        end
        @format_fmt04 = add_record("<12$$$>",@total_fee,@format_fmt04)        
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt04 = add_record("<13$$$>",@case_alerk,@format_fmt04)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt04 = add_record("<14$$$>",@telephone,@format_fmt04)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt04 = add_record("<15$$$>",@fax,@format_fmt04)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt04 = add_record("<16$$$>",@email,@format_fmt04)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt04 = add_record("<17$$$>",@date_of_letter,@format_fmt04) 
            @format_fmt04 = add_record("<18$$$>",@date_of_letter,@format_fmt04)
            @format_fmt04 = add_last_record("<19$$$>",@date_of_letter,@format_fmt04)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt04 = add_record("<17$$$>",arr_date[0],@format_fmt04) 
            @format_fmt04 = add_record("<18$$$>",arr_date[1],@format_fmt04)
            @format_fmt04 = add_last_record("<19$$$>",arr_date[2].slice(0, 2),@format_fmt04)            
        end           
    end
    
    def format_letter_fmt05
        #拼接字串，初始化
        @format_fmt05 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt05 = add_record("<01$$$>",@file_code,@format_fmt05)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt05 = add_record("<02$$$>",@case_code,@format_fmt05) 
        @format_fmt05 = add_record("<06$$$>",@case_code,@format_fmt05)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end   
        @format_fmt05 = add_record("<03$$$>",@respondent,@format_fmt05)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_fmt05 = add_record("<04$$$>",@applicant,@format_fmt05) 
        #签订的$$$所引起的争议（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_fmt05 = add_record("<05$$$>",@contract_name,@format_fmt05)
        #文件份数
        @copies = num_papers(@applicants.size)
        @format_fmt05 = add_record("<07$$$>",@copies,@format_fmt05) 
        @format_fmt05 = add_record("<08$$$>",@copies,@format_fmt05)
        @format_fmt05 = add_record("<09$$$>",@copies,@format_fmt05)                       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt05 = add_record("<10$$$>",@case_alerk,@format_fmt05)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt05 = add_record("<11$$$>",@telephone,@format_fmt05)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt05 = add_record("<12$$$>",@fax,@format_fmt05)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt05 = add_record("<13$$$>",@email,@format_fmt05)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt05 = add_record("<14$$$>",@date_of_letter,@format_fmt05) 
            @format_fmt05 = add_record("<15$$$>",@date_of_letter,@format_fmt05)
            @format_fmt05 = add_last_record("<16$$$>",@date_of_letter,@format_fmt05)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt05 = add_record("<14$$$>",arr_date[0],@format_fmt05) 
            @format_fmt05 = add_record("<15$$$>",arr_date[1],@format_fmt05)
            @format_fmt05 = add_last_record("<16$$$>",arr_date[2].slice(0, 2),@format_fmt05)            
        end          
    end
    
    def format_letter_fmt06
        #拼接字串，初始化
        @format_fmt06 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt06 = add_record("<01$$$>",@file_code,@format_fmt06)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt06 = add_record("<02$$$>",@case_code,@format_fmt06)  
        @format_fmt06 = add_record("<08$$$>",@case_code,@format_fmt06)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt06 = add_record("<03$$$>",@applicant,@format_fmt06)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt06 = add_record("<04$$$>",@respondent,@format_fmt06)
        #文件份数
        @copies = num_papers(@respondents.size)
        @format_fmt06 = add_record("<05$$$>",@copies,@format_fmt06)  
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end        
        @format_fmt06 = add_record("<06$$$>",@arbit_fee,@format_fmt06)           
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_fmt06 = add_record("<07$$$>",@contract_name,@format_fmt06)
       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt06 = add_record("<09$$$>",@case_alerk,@format_fmt06)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt06 = add_record("<10$$$>",@telephone,@format_fmt06)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt06 = add_record("<11$$$>",@fax,@format_fmt06)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt06 = add_record("<12$$$>",@email,@format_fmt06)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt06 = add_record("<13$$$>",@date_of_letter,@format_fmt06) 
            @format_fmt06 = add_record("<14$$$>",@date_of_letter,@format_fmt06)
            @format_fmt06 = add_last_record("<15$$$>",@date_of_letter,@format_fmt06)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt06 = add_record("<13$$$>",arr_date[0],@format_fmt06) 
            @format_fmt06 = add_record("<14$$$>",arr_date[1],@format_fmt06)
            @format_fmt06 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_fmt06)            
        end   
    end
    ###########  空缺  ####################
    def format_letter_fmt07
    end
   
    def format_letter_fmt09
        #拼接字串，初始化
        @format_fmt09 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt09 = add_record("<01$$$>",@file_code,@format_fmt09)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt09 = add_record("<02$$$>",@respondent,@format_fmt09)   
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt09 = add_record("<03$$$>",@case_code,@format_fmt09)            
        #被申请人仲裁费
        @arbit_fee = respondent_arbit_fee(session[:recevice_code])
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end
        @format_fmt04 = add_record("<04$$$>",@arbit_fee,@format_fmt04)         
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt09 = add_record("<05$$$>",@date_of_letter,@format_fmt09) 
            @format_fmt09 = add_record("<06$$$>",@date_of_letter,@format_fmt09)
            @format_fmt09 = add_last_record("<07$$$>",@date_of_letter,@format_fmt09)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt09 = add_record("<05$$$>",arr_date[0],@format_fmt09) 
            @format_fmt09 = add_record("<06$$$>",arr_date[1],@format_fmt09)
            @format_fmt09 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt09)            
        end   
    end   

    def format_letter_fmt11a
        #拼接字串，初始化
        @format_fmt11a = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt11a = add_record("<01$$$>",@file_code,@format_fmt11a)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt11a = add_record("<02$$$>",@applicant,@format_fmt11a)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt11a = add_record("<03$$$>",@respondent,@format_fmt11a)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt11a = add_record("<04$$$>",@case_code,@format_fmt11a)  
        #首席仲裁员
        @chief_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt11a = add_record("<05$$$>",@chief_arbitrator,@format_fmt11a)
        @format_fmt11a = add_record("<13$$$>",@chief_arbitrator,@format_fmt11a)
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt11a = add_record("<06$$$>",@applicant_arbitrator,@format_fmt11a)
        @format_fmt11a = add_record("<14$$$>",@applicant_arbitrator,@format_fmt11a)
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt11a = add_record("<07$$$>",@respondent_arbitrator,@format_fmt11a)
        @format_fmt11a = add_record("<15$$$>",@respondent_arbitrator,@format_fmt11a)
        #开庭日期
        @sitting_date = TbSitting.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @sitting_date != nil or @sitting_date == ""
            @sitting_date = @sitting_date.sittingdate
        else
            @sitting_date = "no"
        end
        @format_fmt11a = add_record("<08$$$>",@sitting_date,@format_fmt11a)        
        #审限（裁决期限）
        @end_date = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @end_date != nil or @end_date != ""
            @end_date = @end_date.end_date
        else
            @end_date = "no"
        end
        @format_fmt11a = add_record("<09$$$>",@end_date,@format_fmt11a)   
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt11a = add_record("<10$$$>",@date_of_letter,@format_fmt11a) 
            @format_fmt11a = add_record("<11$$$>",@date_of_letter,@format_fmt11a)
            @format_fmt11a = add_last_record("<12$$$>",@date_of_letter,@format_fmt11a)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt11a = add_record("<10$$$>",arr_date[0],@format_fmt11a) 
            @format_fmt11a = add_record("<11$$$>",arr_date[1],@format_fmt11a)
            @format_fmt11a = add_last_record("<12$$$>",arr_date[2].slice(0, 2),@format_fmt11a)            
        end   
    end
    
    def format_letter_fmt14
        #拼接字串，初始化
        @format_fmt14 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt14 = add_record("<01$$$>",@file_code,@format_fmt14)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt14 = add_record("<02$$$>",@applicant,@format_fmt14)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt14 = add_record("<03$$$>",@respondent,@format_fmt14)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt14 = add_record("<04$$$>",@case_code,@format_fmt14)  
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt14 = add_record("<05$$$>",@date_of_letter,@format_fmt14) 
            @format_fmt14 = add_record("<06$$$>",@date_of_letter,@format_fmt14)
            @format_fmt14 = add_last_record("<07$$$>",@date_of_letter,@format_fmt14)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt14 = add_record("<05$$$>",arr_date[0],@format_fmt14) 
            @format_fmt14 = add_record("<06$$$>",arr_date[1],@format_fmt14)
            @format_fmt14 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt14)            
        end   
    end
    
    def format_letter_fmt15
        #拼接字串，初始化
        @format_fmt15 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt15 = add_record("<01$$$>",@file_code,@format_fmt15)
        #首席仲裁员
        @chief_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt15 = add_record("<02$$$>",@chief_arbitrator,@format_fmt15)
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt15 = add_record("<03$$$>",@applicant_arbitrator,@format_fmt15)
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt15 = add_record("<04$$$>",@respondent_arbitrator,@format_fmt15)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt15 = add_record("<05$$$>",@case_code,@format_fmt15)  
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt15 = add_record("<06$$$>",@date_of_letter,@format_fmt15) 
            @format_fmt15 = add_record("<07$$$>",@date_of_letter,@format_fmt15)
            @format_fmt15 = add_last_record("<08$$$>",@date_of_letter,@format_fmt15)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt15 = add_record("<06$$$>",arr_date[0],@format_fmt15) 
            @format_fmt15 = add_record("<07$$$>",arr_date[1],@format_fmt15)
            @format_fmt15 = add_last_record("<08$$$>",arr_date[2].slice(0, 2),@format_fmt15)            
        end   
    end  

    def format_letter_fmt17
        #拼接字串，初始化
        @format_fmt17 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt17 = add_record("<01$$$>",@file_code,@format_fmt17)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt17 = add_record("<02$$$>",@applicant,@format_fmt17)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt17 = add_record("<03$$$>",@respondent,@format_fmt17)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt17 = add_record("<04$$$>",@case_code,@format_fmt17)  
        #独立仲裁员
        @independent_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt17 = add_record("<05$$$>",@independent_arbitrator,@format_fmt17)
        @format_fmt17 = add_record("<07$$$>",@independent_arbitrator,@format_fmt17)
        @format_fmt17 = add_record("<16$$$>",@independent_arbitrator,@format_fmt17)     
        #开庭日期
        @sitting_date = TbSitting.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @sitting_date != nil or @sitting_date == ""
            @sitting_date = @sitting_date.sittingdate
        else
            @sitting_date = "no"
        end
        @format_fmt17 = add_record("<06$$$>",@sitting_date,@format_fmt17)        
        #审限（裁决期限）
        @end_date = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @end_date != nil or @end_date != ""
            @end_date = @end_date.end_date
        else
            @end_date = "no"
        end
        @format_fmt17 = add_record("<08$$$>",@end_date,@format_fmt17)   
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt17 = add_record("<09$$$>",@date_of_letter,@format_fmt17) 
            @format_fmt17 = add_record("<10$$$>",@date_of_letter,@format_fmt17)
            @format_fmt17 = add_record("<11$$$>",@date_of_letter,@format_fmt17)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt17 = add_record("<09$$$>",arr_date[0],@format_fmt17) 
            @format_fmt17 = add_record("<10$$$>",arr_date[1],@format_fmt17)
            @format_fmt17 = add_record("<11$$$>",arr_date[2].slice(0, 2),@format_fmt17)            
        end   
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt17 = add_record("<12$$$>",@case_alerk,@format_fmt17)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt17 = add_record("<13$$$>",@telephone,@format_fmt17)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt17 = add_record("<14$$$>",@fax,@format_fmt17)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt17 = add_last_record("<15$$$>",@email,@format_fmt17)         
    end
        
    def format_letter_fmt18
        #拼接字串，初始化
        @format_fmt18 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt18 = add_record("<01$$$>",@file_code,@format_fmt18)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt18 = add_record("<02$$$>",@case_code,@format_fmt18)          
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt18 = add_record("<03$$$>",@applicant,@format_fmt18)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt18 = add_record("<04$$$>",@respondent,@format_fmt18)
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt18 = add_record("<05$$$>",@date_of_letter,@format_fmt18) 
            @format_fmt18 = add_record("<06$$$>",@date_of_letter,@format_fmt18)
            @format_fmt18 = add_last_record("<07$$$>",@date_of_letter,@format_fmt18)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt18 = add_record("<05$$$>",arr_date[0],@format_fmt18) 
            @format_fmt18 = add_record("<06$$$>",arr_date[1],@format_fmt18)
            @format_fmt18 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt18)            
        end   
    end
    ### 当事人是可选的，地址相应改变 空缺 ###
    def format_letter_fmt19
        #拼接字串，初始化
        @format_fmt19 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt19 = add_record("<01$$$>",@file_code,@format_fmt19)         
        #当事人
        #
        #
        #地址
        #
        #
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt19 = add_record("<04$$$>",@date_of_letter,@format_fmt19) 
            @format_fmt19 = add_record("<05$$$>",@date_of_letter,@format_fmt19)
            @format_fmt19 = add_last_record("<06$$$>",@date_of_letter,@format_fmt19)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt19 = add_record("<04$$$>",arr_date[0],@format_fmt19) 
            @format_fmt19 = add_record("<05$$$>",arr_date[1],@format_fmt19)
            @format_fmt19 = add_last_record("<06$$$>",arr_date[2].slice(0, 2),@format_fmt19)            
        end   
    end
    
    def format_letter_fmt20
        #拼接字串，初始化
        @format_fmt20 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt20 = add_record("<01$$$>",@file_code,@format_fmt20) 
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt20 = add_record("<02$$$>",@case_code,@format_fmt20)          
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt20 = add_record("<03$$$>",@applicant,@format_fmt20)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt20 = add_record("<04$$$>",@respondent,@format_fmt20)
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt20 = add_record("<05$$$>",@date_of_letter,@format_fmt20) 
            @format_fmt20 = add_record("<06$$$>",@date_of_letter,@format_fmt20)
            @format_fmt20 = add_last_record("<07$$$>",@date_of_letter,@format_fmt20)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt20 = add_record("<05$$$>",arr_date[0],@format_fmt20) 
            @format_fmt20 = add_record("<06$$$>",arr_date[1],@format_fmt20)
            @format_fmt20 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt20)            
        end   
    end    
    
    def format_letter_fmt23b
        #拼接字串，初始化
        @format_fmt23b = ""  
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt23b = add_record("<01$$$>",@case_code,@format_fmt23b)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt23b = add_record("<02$$$>",@applicant,@format_fmt23b)
        #申请人代理人(可多名？）
        @applicant_agent = TbAgent.find(@applicants.id)
        if @applicant_agent != nil
            @applicant_agent = @applicant_agent.name
            if @applicant_agent == ""
                @applicant_agent = "no"
            end
        else
            @applicant_agent = "no"
        end
        @format_fmt23b = add_record("<02$$$>",@applicant_agent,@format_fmt23b)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt23b = add_record("<04$$$>",@respondent,@format_fmt23b)
        #被申请人代理人(可多名？）
        @respondent_agent = TbAgent.find(@respondents.id)
        if @respondent_agent != nil
            @respondent_agent = @respondent_agent.name
            if @respondent_agent == ""
                @respondent_agent = "no"
            end
        else
            @respondent_agent = "no"
        end
        @format_fmt23b = add_record("<02$$$>",@respondent_agent,@format_fmt23b)
    end    
      
    def format_letter_fmt23e
        #拼接字串，初始化
        @format_fmt23e = ""  
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt23e = add_record("<01$$$>",@case_code,@format_fmt23e)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt23e = add_record("<02$$$>",@applicant,@format_fmt23e)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt23e = add_record("<03$$$>",@respondent,@format_fmt23e)        
    end    

    def format_letter_fmt24
        #拼接字串，初始化
        @format_fmt24 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt24 = add_record("<01$$$>",@file_code,@format_fmt24)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt24 = add_record("<02$$$>",@case_code,@format_fmt24)          
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt24 = add_record("<03$$$>",@applicant,@format_fmt24) 
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt24 = add_record("<04$$$>",@respondent,@format_fmt24)         
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt24 = add_record("<05$$$>",@applicant_arbitrator,@format_fmt24)        
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt24 = add_record("<06$$$>",@respondent_arbitrator,@format_fmt24)
        #提交限期--目前是15天，最终可能依据程序判断，改成普通程序15天，或者简易程序7天之类的
        @time_limit = "15"
        @format_fmt24 = add_record("<07$$$>",@time_limit,@format_fmt24)
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt24 = add_record("<08$$$>",@date_of_letter,@format_fmt24) 
            @format_fmt24 = add_record("<09$$$>",@date_of_letter,@format_fmt24)
            @format_fmt24 = add_last_record("<10$$$>",@date_of_letter,@format_fmt24)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt24 = add_record("<08$$$>",arr_date[0],@format_fmt24) 
            @format_fmt24 = add_record("<09$$$>",arr_date[1],@format_fmt24)
            @format_fmt24 = add_last_record("<10$$$>",arr_date[2].slice(0, 2),@format_fmt24)            
        end   
    end      
    
    def format_letter_fmt26
        #拼接字串，初始化
        @format_fmt26 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt26 = add_record("<01$$$>",@file_code,@format_fmt26)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt26 = add_record("<02$$$>",@applicant,@format_fmt26)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt26 = add_record("<03$$$>",@respondent,@format_fmt26)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt26 = add_record("<04$$$>",@case_code,@format_fmt26)  
        #首席仲裁员
        @chief_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt26 = add_record("<05$$$>",@chief_arbitrator,@format_fmt26)
        @format_fmt26 = add_record("<13$$$>",@chief_arbitrator,@format_fmt26)
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt26 = add_record("<06$$$>",@applicant_arbitrator,@format_fmt26)
        @format_fmt26 = add_record("<14$$$>",@applicant_arbitrator,@format_fmt26)
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt26 = add_record("<07$$$>",@respondent_arbitrator,@format_fmt26)
        @format_fmt26 = add_record("<15$$$>",@respondent_arbitrator,@format_fmt26)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt26 = add_record("<08$$$>",@date_of_letter,@format_fmt26) 
            @format_fmt26 = add_record("<09$$$>",@date_of_letter,@format_fmt26)
            @format_fmt26 = add_last_record("<10$$$>",@date_of_letter,@format_fmt26)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt26 = add_record("<08$$$>",arr_date[0],@format_fmt26) 
            @format_fmt26 = add_record("<09$$$>",arr_date[1],@format_fmt26)
            @format_fmt26 = add_last_record("<10$$$>",arr_date[2].slice(0, 2),@format_fmt26)            
        end   
    end    
    
    def format_letter_fmt27
        #拼接字串，初始化
        @format_fmt27 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt27 = add_record("<01$$$>",@file_code,@format_fmt27)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt27 = add_record("<02$$$>",@applicant,@format_fmt27)
        #预缴查询费
        #
        #
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt27 = add_record("<04$$$>",@date_of_letter,@format_fmt27) 
            @format_fmt27 = add_record("<05$$$>",@date_of_letter,@format_fmt27)
            @format_fmt27 = add_last_record("<06$$$>",@date_of_letter,@format_fmt27)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt27 = add_record("<04$$$>",arr_date[0],@format_fmt27) 
            @format_fmt27 = add_record("<05$$$>",arr_date[1],@format_fmt27)
            @format_fmt27 = add_last_record("<06$$$>",arr_date[2].slice(0, 2),@format_fmt27)            
        end   
    end    
    
    def format_letter_fmt31
        #拼接字串，初始化
        @format_fmt31 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt31 = add_record("<01$$$>",@file_code,@format_fmt31)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt31 = add_record("<02$$$>",@case_code,@format_fmt31) 
        @format_fmt31 = add_record("<06$$$>",@case_code,@format_fmt31)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end   
        @format_fmt31 = add_record("<03$$$>",@respondent,@format_fmt31)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end       
        @format_fmt31 = add_record("<04$$$>",@applicant,@format_fmt31) 
        #签订的$$$所引起的争议（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_fmt31 = add_record("<05$$$>",@contract_name,@format_fmt31)
        #文件份数
        @copies = num_papers(@applicants.size)
        @format_fmt31 = add_record("<07$$$>",@copies,@format_fmt31) 
        @format_fmt31 = add_record("<08$$$>",@copies,@format_fmt31)
        @format_fmt31 = add_record("<09$$$>",@copies,@format_fmt31) 
        @format_fmt31 = add_record("<10$$$>",@copies,@format_fmt31) 
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt31 = add_record("<11$$$>",@case_alerk,@format_fmt31)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt31 = add_record("<12$$$>",@telephone,@format_fmt31)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt31 = add_record("<13$$$>",@fax,@format_fmt31)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt31 = add_record("<14$$$>",@email,@format_fmt31)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt31 = add_record("<15$$$>",@date_of_letter,@format_fmt31) 
            @format_fmt31 = add_record("<16$$$>",@date_of_letter,@format_fmt31)
            @format_fmt31 = add_last_record("<17$$$>",@date_of_letter,@format_fmt31)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt31 = add_record("<15$$$>",arr_date[0],@format_fmt31) 
            @format_fmt31 = add_record("<16$$$>",arr_date[1],@format_fmt31)
            @format_fmt31 = add_last_record("<17$$$>",arr_date[2].slice(0, 2),@format_fmt31)            
        end          
    end  

    def format_letter_fmt32
        #拼接字串，初始化
        @format_fmt32 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt32 = add_record("<01$$$>",@file_code,@format_fmt32)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt32 = add_record("<02$$$>",@case_code,@format_fmt32)  
        @format_fmt32 = add_record("<08$$$>",@case_code,@format_fmt32)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt32 = add_record("<03$$$>",@applicant,@format_fmt32)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt32 = add_record("<04$$$>",@respondent,@format_fmt32)
        #文件份数
        @copies = num_papers(@respondents.size)
        @format_fmt32 = add_record("<05$$$>",@copies,@format_fmt32)  
        #仲裁费
        @arbit_fee = applicant_arbit_fee(session[:recevice_code]) 
        if @arbit_fee == nil or @arbit_fee == ""
            @arbit_fee = "no"
        end        
        @format_fmt32 = add_record("<06$$$>",@arbit_fee,@format_fmt32)           
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_fmt32 = add_record("<07$$$>",@contract_name,@format_fmt32)
       
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt32 = add_record("<09$$$>",@case_alerk,@format_fmt32)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt32 = add_record("<10$$$>",@telephone,@format_fmt32)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt32 = add_record("<11$$$>",@fax,@format_fmt32)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt32 = add_record("<12$$$>",@email,@format_fmt32)    
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt32 = add_record("<13$$$>",@date_of_letter,@format_fmt32) 
            @format_fmt32 = add_record("<14$$$>",@date_of_letter,@format_fmt32)
            @format_fmt32 = add_last_record("<15$$$>",@date_of_letter,@format_fmt32)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt32 = add_record("<13$$$>",arr_date[0],@format_fmt32) 
            @format_fmt32 = add_record("<14$$$>",arr_date[1],@format_fmt32)
            @format_fmt32 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_fmt32)            
        end   
    end    

    def format_letter_fmt33
        #拼接字串，初始化
        @format_fmt33 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt33 = add_record("<01$$$>",@file_code,@format_fmt33)
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt33 = add_record("<02$$$>",@applicant,@format_fmt33)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt33 = add_record("<03$$$>",@respondent,@format_fmt33)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt33 = add_record("<04$$$>",@case_code,@format_fmt33)          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt33 = add_record("<05$$$>",@date_of_letter,@format_fmt33) 
            @format_fmt33 = add_record("<06$$$>",@date_of_letter,@format_fmt33)
            @format_fmt33 = add_last_record("<07$$$>",@date_of_letter,@format_fmt33)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt33 = add_record("<05$$$>",arr_date[0],@format_fmt33) 
            @format_fmt33 = add_record("<06$$$>",arr_date[1],@format_fmt33)
            @format_fmt33 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt33)            
        end   
    end         
    #函件内容待明确
    def format_letter_fmt34
        
    end
    
    def format_letter_fmt35
        #拼接字串，初始化
        @format_fmt35 = ""  
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt35 = add_record("<01$$$>",@applicant,@format_fmt35)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt35 = add_record("<02$$$>",@respondent,@format_fmt35)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt35 = add_record("<03$$$>",@case_code,@format_fmt35)          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt35 = add_record("<04$$$>",@date_of_letter,@format_fmt35) 
            @format_fmt35 = add_record("<05$$$>",@date_of_letter,@format_fmt35)
            @format_fmt35 = add_last_record("<06$$$>",@date_of_letter,@format_fmt35)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt35 = add_record("<04$$$>",arr_date[0],@format_fmt35) 
            @format_fmt35 = add_record("<05$$$>",arr_date[1],@format_fmt35)
            @format_fmt35 = add_last_record("<06$$$>",arr_date[2].slice(0, 2),@format_fmt35)            
        end   
    end    
    
    def format_letter_fmt36
        #拼接字串，初始化
        @format_fmt36 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt36 = add_record("<01$$$>",@file_code,@format_fmt36)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt36 = add_record("<02$$$>",@case_code,@format_fmt36)          
        #首席仲裁员
        @chief_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt36 = add_record("<03$$$>",@chief_arbitrator,@format_fmt36)
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt36 = add_record("<04$$$>",@applicant_arbitrator,@format_fmt36)
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt36 = add_record("<05$$$>",@respondent_arbitrator,@format_fmt36)
        ###           第n次庭审的日期###
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt36 = add_record("<13$$$>",@date_of_letter,@format_fmt36) 
            @format_fmt36 = add_record("<14$$$>",@date_of_letter,@format_fmt36)
            @format_fmt36 = add_last_record("<15$$$>",@date_of_letter,@format_fmt36)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt36 = add_record("<13$$$>",arr_date[0],@format_fmt36) 
            @format_fmt36 = add_record("<14$$$>",arr_date[1],@format_fmt36)
            @format_fmt36 = add_last_record("<15$$$>",arr_date[2].slice(0, 2),@format_fmt36)            
        end   
    end     

    def format_letter_fmt37
        #拼接字串，初始化
        @format_fmt37 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt37 = add_record("<01$$$>",@file_code,@format_fmt37)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt37 = add_record("<02$$$>",@case_code,@format_fmt37)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt37 = add_record("<03$$$>",@applicant,@format_fmt37)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt37 = add_record("<04$$$>",@respondent,@format_fmt37)         
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt37 = add_record("<05$$$>",@date_of_letter,@format_fmt37) 
            @format_fmt37 = add_record("<06$$$>",@date_of_letter,@format_fmt37)
            @format_fmt37 = add_last_record("<07$$$>",@date_of_letter,@format_fmt37)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt37 = add_record("<05$$$>",arr_date[0],@format_fmt37) 
            @format_fmt37 = add_record("<06$$$>",arr_date[1],@format_fmt37)
            @format_fmt37 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt37)            
        end   
    end    

    def format_letter_fmt38a
        #拼接字串，初始化
        @format_fmt38a = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt38a = add_record("<01$$$>",@file_code,@format_fmt38a)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt38a = add_record("<02$$$>",@case_code,@format_fmt38a)          
        #将要更换的首席仲裁员

        #将要更换的申请人仲裁员

        #将要更换的被申请人仲裁员

        ###      3、4、5、6、7、8、9空缺 ###
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt38a = add_record("<10$$$>",@applicant,@format_fmt38a)
        #申请人代理人(可多名？）
        @applicant_agent = TbAgent.find(@applicants.id)
        if @applicant_agent != nil
            @applicant_agent = @applicant_agent.name
            if @applicant_agent == ""
                @applicant_agent = "no"
            end
        else
            @applicant_agent = "no"
        end
        @format_fmt38a = add_record("<11$$$>",@applicant_agent,@format_fmt38a)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt38a = add_record("<12$$$>",@respondent,@format_fmt38a)
        #被申请人代理人(可多名？）
        @respondent_agent = TbAgent.find(@respondents.id)
        if @respondent_agent != nil
            @respondent_agent = @respondent_agent.name
            if @respondent_agent == ""
                @respondent_agent = "no"
            end
        else
            @respondent_agent = "no"
        end
        @format_fmt38a = add_record("<13$$$>",@respondent_agent,@format_fmt38a) 
        #争议金额（人民币）
        @accounts_rmb = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and currency = '0001'",session[:recevice_code]],:order=>'id')
        @sum_rmb = 0
        for account_rmb in @accounts_rmb
            @sum_rmb = @sum_rmb + account_rmb.rmb_money
        end        
        @format_fmt38a = add_record("<14$$$>",@sum_rmb,@format_fmt38a) 
        #争议金额（港币）
        @accounts_hk = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and currency = '0001'",session[:recevice_code]],:order=>'id')
        @sum_hk = 0
        for account_hk in @accounts_hk
            @sum_hk = @sum_hk + account_hk.f_money
        end        
        @format_fmt38a = add_record("<15$$$>",@sum_hk,@format_fmt38a)    
        #争议金额（美元）
        @accounts_dollar = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and currency = '0003'",session[:recevice_code]],:order=>'id')
        @sum_dollar = 0
        for account_dollar in @accounts_dollar
            @sum_dollar = @sum_dollar + account_dollar.f_money
        end        
        @format_fmt38a = add_record("<16$$$>",@sum_dollar,@format_fmt38a) 
        #争议类型（该案的类型，立案时选定的）--仲裁协议类型
        aribitprotprog_num = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).aribitprotprog_num
        if aribitprotprog_num != nil or aribitprotprog_num != ""
            @case_typ = TbDictionary.find(:first,:conditions=> ["typ_code='0003' and state='Y' and data_val = ?",aribitprotprog_num].data_text)
        end
        @format_fmt38a = add_record("<17$$$>",@case_typ,@format_fmt38a) 
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt38a = add_record("<18$$$>",@case_alerk,@format_fmt38a)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt38a = add_record("<19$$$>",@telephone,@format_fmt38a)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt38a = add_record("<20$$$>",@fax,@format_fmt38a)     
        #电子邮箱
        @email = clerk.email
        if @email == nil or @email == ""
            @email = "no"
        end  
        @format_fmt38a = add_record("<21$$$>",@email,@format_fmt38a)         
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt38a = add_record("<22$$$>",@date_of_letter,@format_fmt38a) 
            @format_fmt38a = add_record("<23$$$>",@date_of_letter,@format_fmt38a)
            @format_fmt38a = add_last_record("<24$$$>",@date_of_letter,@format_fmt38a)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt38a = add_record("<22$$$>",arr_date[0],@format_fmt38a) 
            @format_fmt38a = add_record("<23$$$>",arr_date[1],@format_fmt38a)
            @format_fmt38a = add_last_record("<24$$$>",arr_date[2].slice(0, 2),@format_fmt38a)            
        end   
    end 

    def format_letter_fmt39
        #拼接字串，初始化
        @format_fmt39 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt39 = add_record("<01$$$>",@file_code,@format_fmt39)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt39 = add_record("<02$$$>",@case_code,@format_fmt39)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt39 = add_record("<03$$$>",@applicant,@format_fmt39)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt39 = add_record("<04$$$>",@respondent,@format_fmt39)    
        #开庭日期
        @sitting_date = TbSitting.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @sitting_date != nil or @sitting_date == ""
            @sitting_date = @sitting_date.sittingdate
        else
            @sitting_date = "no"
        end
        @format_fmt39 = add_record("<05$$$>",@sitting_date,@format_fmt39)          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt39 = add_record("<06$$$>",@date_of_letter,@format_fmt39) 
            @format_fmt39 = add_record("<07$$$>",@date_of_letter,@format_fmt39)
            @format_fmt39 = add_last_record("<08$$$>",@date_of_letter,@format_fmt39)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt39 = add_record("<06$$$>",arr_date[0],@format_fmt39) 
            @format_fmt39 = add_record("<07$$$>",arr_date[1],@format_fmt39)
            @format_fmt39 = add_last_record("<08$$$>",arr_date[2].slice(0, 2),@format_fmt39)            
        end   
    end     
    
    def format_letter_fmt40
        #拼接字串，初始化
        @format_fmt40 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt40 = add_record("<01$$$>",@file_code,@format_fmt40)        
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt40 = add_record("<02$$$>",@case_code,@format_fmt40)  
        @format_fmt40 = add_record("<04$$$>",@case_code,@format_fmt40)
        #<03$$$>仲裁员的报告 -- 选定 或者 指定 或者 代指定 等###
        #
        #
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt40 = add_record("<05$$$>",@applicant,@format_fmt40)
        #申请人代理人(可多名？）
        @applicant_agent = TbAgent.find(@applicants.id)
        if @applicant_agent != nil
            @applicant_agent = @applicant_agent.name
            if @applicant_agent == ""
                @applicant_agent = "no"
            end
        else
            @applicant_agent = "no"
        end
        @format_fmt40 = add_record("<06$$$>",@applicant_agent,@format_fmt40)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt40 = add_record("<07$$$>",@respondent,@format_fmt40)
        #被申请人代理人(可多名？）
        @respondent_agent = TbAgent.find(@respondents.id)
        if @respondent_agent != nil
            @respondent_agent = @respondent_agent.name
            if @respondent_agent == ""
                @respondent_agent = "no"
            end
        else
            @respondent_agent = "no"
        end
        @format_fmt40 = add_record("<08$$$>",@respondent_agent,@format_fmt40)
        ### 关于<09$$$>仲裁及<10$$$>程序的有关规定--指国内、涉外、及  简易、普通的意思，从程序内容中取 ###
        #
        #
        #  11-13 是仲裁庭组成的，涉及参数判断等
        #  
        #  
        #  办案秘书--助理
        #助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt40 = add_record("<14$$$>",@case_alerk,@format_fmt40)         
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt40 = add_record("<15$$$>",@date_of_letter,@format_fmt40) 
            @format_fmt40 = add_record("<16$$$>",@date_of_letter,@format_fmt40)
            @format_fmt40 = add_last_record("<17$$$>",@date_of_letter,@format_fmt40)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt40 = add_record("<15$$$>",arr_date[0],@format_fmt40) 
            @format_fmt40 = add_record("<16$$$>",arr_date[1],@format_fmt40)
            @format_fmt40 = add_last_record("<17$$$>",arr_date[2].slice(0, 2),@format_fmt40)            
        end           
    end      
    
    #字段不明确，空缺#
    def format_letter_fmt41
        
    end    
    
    def format_letter_fmt42
        #拼接字串，初始化
        @format_fmt42 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt42 = add_record("<01$$$>",@file_code,@format_fmt42)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt42 = add_record("<02$$$>",@case_code,@format_fmt42)            
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt42 = add_record("<03$$$>",@date_of_letter,@format_fmt42) 
            @format_fmt42 = add_record("<04$$$>",@date_of_letter,@format_fmt42)
            @format_fmt42 = add_record("<05$$$>",@date_of_letter,@format_fmt42)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt42 = add_record("<03$$$>",arr_date[0],@format_fmt42) 
            @format_fmt42 = add_record("<04$$$>",arr_date[1],@format_fmt42)
            @format_fmt42 = add_record("<05$$$>",arr_date[2].slice(0, 2),@format_fmt42)            
        end  
        #联系人--确定是否是助理
        clerk_code = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).clerk
        clerk = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
        @case_alerk = clerk.name + clerk.sex
        if @case_alerk == nil or @case_alerk == ""
            @case_alerk = "no"
        end       
        @format_fmt42 = add_record("<06$$$>",@case_alerk,@format_fmt42)  
        #电话        
        @telephone = clerk.telephone
        if @telephone == nil or @telephone == ""
            @telephone = "no"
        end     
        @format_fmt42 = add_record("<07$$$>",@telephone,@format_fmt42)       
        #传真
        @fax = clerk.fax
        if @fax == nil or @fax == ""
            @fax = "no"
        end    
        @format_fmt42 = add_last_record("<08$$$>",@fax,@format_fmt42)             
    end    
    
    def format_letter_fmt44
        #拼接字串，初始化
        @format_fmt44 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt44 = add_record("<01$$$>",@file_code,@format_fmt44)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt44 = add_record("<02$$$>",@case_code,@format_fmt44)         
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt44 = add_record("<03$$$>",@applicant,@format_fmt44)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt44 = add_record("<04$$$>",@respondent,@format_fmt44)         
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt44 = add_record("<05$$$>",@date_of_letter,@format_fmt44) 
            @format_fmt44 = add_record("<06$$$>",@date_of_letter,@format_fmt44)
            @format_fmt44 = add_last_record("<07$$$>",@date_of_letter,@format_fmt44)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt44 = add_record("<05$$$>",arr_date[0],@format_fmt44) 
            @format_fmt44 = add_record("<06$$$>",arr_date[1],@format_fmt44)
            @format_fmt44 = add_last_record("<07$$$>",arr_date[2].slice(0, 2),@format_fmt44)            
        end   
    end   

    def format_letter_fmt45
        #拼接字串，初始化
        @format_fmt45 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt45 = add_record("<01$$$>",@file_code,@format_fmt45) 
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt45 = add_record("<02$$$>",@date_of_letter,@format_fmt45) 
            @format_fmt45 = add_record("<03$$$>",@date_of_letter,@format_fmt45)
            @format_fmt45 = add_last_record("<04$$$>",@date_of_letter,@format_fmt45)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt45 = add_record("<02$$$>",arr_date[0],@format_fmt45) 
            @format_fmt45 = add_record("<03$$$>",arr_date[1],@format_fmt45)
            @format_fmt45 = add_last_record("<04$$$>",arr_date[2].slice(0, 2),@format_fmt45)            
        end   
    end       

    def format_letter_fmt46
        #拼接字串，初始化
        @format_fmt46 = ""  
        #函号
        @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @file_code == nil or @file_code == ""
            @file_code = "no"
        else
            @file_code = @file_code.file_code
        end
        @format_fmt46 = add_record("<01$$$>",@file_code,@format_fmt46)       
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt46 = add_record("<02$$$>",@applicant,@format_fmt46)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt46 = add_record("<03$$$>",@case_code,@format_fmt46)          
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt46 = add_record("<04$$$>",@date_of_letter,@format_fmt46) 
            @format_fmt46 = add_record("<05$$$>",@date_of_letter,@format_fmt46)
            @format_fmt46 = add_last_record("<06$$$>",@date_of_letter,@format_fmt46)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt46 = add_record("<04$$$>",arr_date[0],@format_fmt46) 
            @format_fmt46 = add_record("<05$$$>",arr_date[1],@format_fmt46)
            @format_fmt46 = add_last_record("<06$$$>",arr_date[2].slice(0, 2),@format_fmt46)            
        end   
    end      

    def format_letter_fmt47
        #拼接字串，初始化
        @format_fmt47 = ""  
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_fmt47 = add_record("<01$$$>",@applicant,@format_fmt47)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_fmt47 = add_record("<02$$$>",@respondent,@format_fmt47)
        #立案号
        @case_code = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]]).case_code
        @format_fmt47 = add_record("<03$$$>",@case_code,@format_fmt47)  
        #首席仲裁员
        @chief_arbitrator = chief_arbitrator(session[:recevice_code])
        @format_fmt47 = add_record("<04$$$>",@chief_arbitrator,@format_fmt47)
        #申请人仲裁员
        @applicant_arbitrator = applicant_arbitrator(session[:recevice_code])
        @format_fmt47 = add_record("<05$$$>",@applicant_arbitrator,@format_fmt47)
        #被申请人仲裁员
        @respondent_arbitrator = respondent_arbitrator(session[:recevice_code])
        @format_fmt47 = add_record("<06$$$>",@respondent_arbitrator,@format_fmt47)
        #日期
        @date_of_letter = Time.now.to_s(:db)
        if @date_of_letter == nil or @date_of_letter == ""
            @date_of_letter = "no"
            @format_fmt47 = add_record("<07$$$>",@date_of_letter,@format_fmt47) 
            @format_fmt47 = add_record("<08$$$>",@date_of_letter,@format_fmt47)
            @format_fmt47 = add_last_record("<09$$$>",@date_of_letter,@format_fmt47)
        else
            arr_date = @date_of_letter.to_s.split("-")
            @format_fmt47 = add_record("<07$$$>",arr_date[0],@format_fmt47) 
            @format_fmt47 = add_record("<08$$$>",arr_date[1],@format_fmt47)
            @format_fmt47 = add_last_record("<09$$$>",arr_date[2].slice(0, 2),@format_fmt47)            
        end   
    end    
    
    def format_letter_for03
        #拼接字串，初始化
        @format_for03 = ""  
        #申请人
        @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @applicants == nil or @applicants == ""
            @applicant = "no"
        else
            @applicant = ""
            @applicants.each do |applicant|
                @applicant = @applicant + applicant.partyname
            end
        end        
        @format_for03 = add_record("<01$$$>",@applicant,@format_for03)
        #被申请人
        @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",session[:recevice_code]], :order => "id")
        if @respondent == nil or @respondent == ""
            @respondent = "no"
        else
            @respondent = ""
            @respondents.each do |resp|
                @respondent = @respondent + resp.partyname
            end
        end       
        @format_for03 = add_record("<02$$$>",@respondent,@format_for03)
        #案由及类别
        @casetype_num = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @casetype_num == nil or @casetype_num == ""
            @casetype_num = "no"
        else
            @casetype = TbDictionary.find_arbit_type("0002",@casetype_num).pactname
        end   
        @format_for03 = add_record("<03$$$>",@casetype,@format_for03)  
        #关于$$$项下争议的仲裁申请文件（合同名称）
        @contract_name = TbContractsign.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",session[:recevice_code]])
        if @contract_name == nil or @contract_name == ""
            @contract_name = "no"
        else
            @contract_name = @contract_name.pactname
        end   
        @format_for03 = add_record("<04$$$>",@contract_name,@format_for03)        
        #明确争议金额（人民币）
        @accounts_rmb = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and currency = '0001'",session[:recevice_code]],:order=>'id')
        @sum_rmb = 0
        for account_rmb in @accounts_rmb
            @sum_rmb = @sum_rmb + account_rmb.rmb_money
        end        
        @format_for03 = add_record("<05$$$>",@sum_rmb,@format_for03) 
        #明确争议金额（港币）
        @accounts_hk = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and currency = '0001'",session[:recevice_code]],:order=>'id')
        @sum_hk = 0
        for account_hk in @accounts_hk
            @sum_hk = @sum_hk + account_hk.f_money
        end        
        @format_for03 = add_record("<06$$$>",@sum_hk,@format_for03)    
        #明确争议金额（美元）
        @accounts_dollar = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and currency = '0003'",session[:recevice_code]],:order=>'id')
        @sum_dollar = 0
        for account_dollar in @accounts_dollar
            @sum_dollar = @sum_dollar + account_dollar.f_money
        end        
        @format_for03 = add_record("<07$$$>",@sum_dollar,@format_for03)      
        #同期港币汇率
        @hk_rate = Money.find(:first,:conditions=>["used='Y' and currency = '0003'"])
        if @hk_rate != nil
            @hk_rate = @hk_rate.rate
        end
        @format_for03 = add_record("<08$$$>",@hk_rate,@format_for03)  
        #同期美元汇率
        @dollar_rate = Money.find(:first,:conditions=>["used='Y' and currency = '0002'"])
        if @dollar_rate != nil
            @dollar_rate = @dollar_rate.rate
        end     
        @format_for03 = add_record("<09$$$>",@dollar_rate,@format_for03) 
        #合计--人民币形式
        @total = @sum_rmb.to_f + @sum_hk.to_f*@hk_rate.to_f + @sum_dollar.to_f*@dollar_rate.to_f 
        @format_for03 = add_record("<10$$$>",@total,@format_for03) 
        #需预缴的费用 空缺 ###
        #
        #立案费
        @arbitration_fee = 10000
        @format_for03 = add_record("<12$$$>",@arbitration_fee,@format_for03)
    end      
    
    ############################################################################
    #私有函数
    ############################################################################
    #添加替换项
    def add_record(str_src,str_des,str_prm)
        str_prm = str_prm + str_src.to_s
        str_prm = str_prm + ","
        str_prm = str_prm + str_des.to_s
        str_prm = str_prm + ";"
        return str_prm
    end
    #最后一个添加项
    def add_last_record(str_src,str_des,str_prm)
        str_prm = str_prm + str_src.to_s
        str_prm = str_prm + ","
        str_prm = str_prm + str_des.to_s
        return str_prm
    end 
    #申请人受理费
    def applicant_litigation_fee(code)
        @applicant_litigation_fee = TbShouldCharge.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and typ = '0001' and payment = '0001'",code])  
        if @applicant_litigation_fee == nil
            return "no"
        end
        return @applicant_litigation_fee.rmb_money
    end
    #被申请人受理费
    def respondent_litigation_fee(code)
        @respondent_litigation_fee = TbShouldCharge.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and typ = '0001' and payment = '0002'",code])  
        if @respondent_litigation_fee == nil
            return "no"
        end        
        return @respondent_litigation_fee.rmb_money
    end
    #申请人处理费、仲裁费
    def applicant_arbit_fee(code)
        @applicant_arbit_fee = TbShouldCharge.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and typ = '0001' and payment = '0001'",code])  
        if @applicant_arbit_fee == nil
            return "no"
        end         
        return @applicant_arbit_fee.rmb_money
    end
    #被申请人处理费、仲裁费
    def respondent_arbit_fee(code)
        @respondent_arbit_fee = TbShouldCharge.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and typ = '0001' and payment = '0002'",code])  
        if @respondent_arbit_fee == nil
            return "no"
        end         
        return @respondent_arbit_fee.rmb_money
    end
    #得到提交文书的份数
    def num_papers(num_people)
        return num_people.to_i + 4
    end
    #获取案件首席仲裁员
    def chief_arbitrator(code)
        @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0002'",code])
        if @case_arbitman != nil
            arbitman_code = @case_arbitman.arbitman
            chief_arbitrator = TbArbitman.find(["used = 'Y' and code = ? ",arbitman_code])
            if chief_arbitrator != nil
                chief_arbitrator = chief_arbitrator.name
            else
                chief_arbitrator = "no"
            end
        else
            chief_arbitrator = "no"
        end
        return chief_arbitrator 
    end
    
    #获取案件申请人仲裁员
    def applicant_arbitrator(code)
        @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0003'",code])
        if @case_arbitman != nil
            arbitman_code = @case_arbitman.arbitman
            applicant_arbitrator = TbArbitman.find(["used = 'Y' and code = ? ",arbitman_code])
            if applicant_arbitrator != nil
                applicant_arbitrator = applicant_arbitrator.name
            else
                applicant_arbitrator = "no"
            end
        else
            applicant_arbitrator = "no"
        end
        return applicant_arbitrator 
    end   
    #获取案件被申请人仲裁员
    def respondent_arbitrator(code)
        @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0004'",code])
        if @case_arbitman != nil
            arbitman_code = @case_arbitman.arbitman
            respondent_arbitrator = TbArbitman.find(["used = 'Y' and code = ? ",arbitman_code])
            if respondent_arbitrator != nil
                respondent_arbitrator = respondent_arbitrator.name
            else
                respondent_arbitrator = "no"
            end
        else
            respondent_arbitrator = "no"
        end
        return respondent_arbitrator 
    end  

    #获取案件独立仲裁员
    def independent_arbitrator(code)
        @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0001'",code])
        if @case_arbitman != nil
            arbitman_code = @case_arbitman.arbitman
            independent_arbitrator = TbArbitman.find(["used = 'Y' and code = ? ",arbitman_code])
            if independent_arbitrator != nil
                independent_arbitrator = independent_arbitrator.name
            else
                independent_arbitrator = "no"
            end
        else
            independent_arbitrator = "no"
        end
        return independent_arbitrator 
    end      
    
end
