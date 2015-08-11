require "iconv"
require "parseexcel/parser"
class DataImpController < ApplicationController
  
  def index
#    @cnt_processed_1=JUlrich.count("typ=1 and flag<>0")
#    @cnt_total_1=JUlrich.count("typ=1")
#    @cnt_reduplicated_1=JUlrich.count("typ=1 and flag=1")
#    @cnt_doubt_1=JUlrich.count("typ=1 and flag=2")
#    @cnt_non_reduplicated_1=JUlrich.count("typ=1 and flag=3")
  end
  
  def up
    cov1 = Iconv.new('gbk','utf-8')  #Iconv 编码转换
    cov2 = Iconv.new('utf-8','gbk')
    file=params["file"]  # params["file"]与params[:file]作用相同
    #puts cov.iconv(file.original_filename)
    if !file.original_filename.empty?  
      f_name="#{session[:user_code]}#{Time.now().strftime("%Y%m%d%H%M%S")}#{cov1.iconv(file.original_filename)}"
      File.open("#{RAILS_ROOT}/upload/#{f_name}","wb") do |f|
        f.write(file.read) 
      end
      DataOldT.delete_all("1=1")
      error_line=""
      error_line=imp_1("#{RAILS_ROOT}/upload/#{f_name}")
      data_made
      r="#{file.original_filename}   上传完成 ,文件名称【#{cov2.iconv(f_name)}】。 <br />"
      if error_line==""
      else
        r=r+"错误行信息如下<br />"+error_line
      end
      render :text=> r  #   
    end
  end 
  
  
  private
  
  def data_made
    @d=DataOldT.find(:all,:order=>"id")
    for d in @d
      #咨询流水号
      d.recevice_code=d.receivedate.to_s(:db).slice(0,4) + sprintf("%04d",d.recevice_code) 
      #总案号
      d.general_code=sprintf("%010d",d.general_code)
      #助理
      t=User.find_by_name(d.clerk)
      if t!=nil
        d.clerk=t.code
      end
      #仲裁程序类型
      if d.aribitprog_f=="否"
        if d.aribitprog=="普通"
          d.aribitprog_num="0001"
        else
          d.aribitprog_num="0002"
        end
      else
        if d.aribitprog=="普通"
          d.aribitprog_num="0003"
        else
          d.aribitprog_num="0004"
        end
      end
      if d.aribitprotprog_num=="仲裁条款"
        d.aribitprotprog_num="0001"
      else
        d.aribitprotprog_num="0002"
      end
      #审理方式
      if d.trial_typ=="否"
        d.trial_typ="0001"
      else 
        d.trial_typ="0002"       
      end
      #仲裁员及制定方式
      t=TbArbitman.find_by_name(d.arbitman_0001)
      if t!=nil
        d.arbitman_0001=t.code
      end
      t=TbDictionary.find(:first,:conditions=>["typ_code='0015' and data_text=?",d.arbitmansign_0001])
      if t!=nil
        d.arbitmansign_0001=t.data_val
      end
      t=TbArbitman.find_by_name(d.arbitman_0002)
      if t!=nil
        d.arbitman_0002=t.code
      end
      t=TbDictionary.find(:first,:conditions=>["typ_code='0015' and data_text=?",d.arbitmansign_0002])
      if t!=nil
        d.arbitmansign_0002=t.data_val
      end
      t=TbArbitman.find_by_name(d.arbitman_0003)
      if t!=nil
        d.arbitman_0003=t.code
      end
      t=TbDictionary.find(:first,:conditions=>["typ_code='0015' and data_text=?",d.arbitmansign_0003])
      if t!=nil
        d.arbitmansign_0003=t.data_val
      end
      #裁决方式
      case d.end_style
      when "裁决"
        d.end_style="0001"
      when "和裁"
        d.end_style="0002"
      when "撤案"
        d.end_style="0003"
      end
      
      #结案号
      num=d.end_code
      if num!="" and num!=nil
        if (num.slice(0,1)=="D" or num.slice(0,1)=="d") and num.size>=2
          num=num.slice(1,num.size - 1 )
        end
        
        if d.end_style=='0001' or d.end_style=='0002'
          num="awd" + num
          if d.aribitprog_num=="0001" or d.aribitprog_num=="0002" or d.aribitprog_num=="0005" or d.aribitprog_num=="0006"
            num=num + 'd'
          end
          if d.end_style=='0002'
            num=num + 's'
          end
        elsif d.end_style=='0003'
          num="dst" + num
          if d.aribitprog_num=="0001" or d.aribitprog_num=="0002" or d.aribitprog_num=="0005" or d.aribitprog_num=="0006"
            num=num + 'd'
          end
        end  
      end
      
      d.end_code=num
      
      d.save
    end
  end
  
  def imp_1(file_path)#导入乌利希新增数据   
    workbook=Spreadsheet::ParseExcel::Parser.new.parse(file_path)#打开一个EXCEL文件
    worksheet = workbook.worksheet(0)#操作一个工作表
    error_line=""
    r=0#行号
    columns=[]
    worksheet.each {|row|           #遍历工作表
      if r==0
        if row==nil
          return "导入的文件中缺少列名！"
        else
#          column_index=0
#          row.each {|cell|
#            if cell!=nil
#              columns[column_index]=change2(cell)
#              column_index=column_index+1
#            end
#          }
        end
        r=1
        next
      end
      if row!=nil
        begin
          j=DataOldT.new()
          col_n=0
          row.each {|cell|  #读一行中的每个列
            if cell!=nil
              
              col_n=col_n+1
              case col_n
              when 2
                j.recevice_code=ccc(cell).gsub(".0","").gsub(" ","")
              when 4
                if change2(cell)!=""  
                  j.receivedate=cell.date
                end
              when 5
                if change2(cell)!=""
                  j.orgdate=cell.date
                end
              when 7
                j.casereason=cell.to_s("utf-8")
              when 11
                j.clerk=cell.to_s("utf-8").gsub(" ","")
              when 12
                j.case_code=ccc(cell)
              when 14
                j.aribitprog=cell.to_s("utf-8").gsub(" ","")
              when 22
                j.end_code=ccc(cell).gsub(".0","").gsub(" ","")
              when 23
                j.end_style=cell.to_s("utf-8").gsub(" ","")
              when 24
                j.end_date=cell.date
              when 26
                if change2(cell)!=""
                  j.b_should_charge=change2(cell).to_f
                end
              when 28
                if change2(cell)!=""
                  j.b_charge=change2(cell).to_f
                end
              when 31
                j.arbitmansign_0001=cell.to_s("utf-8").gsub(" ","")
              when 33
                j.t_casetype_num=cell.to_s("utf-8").gsub(" ","")
              when 34
                if change2(cell)!=""
                  j.b_amount_rmb=change2(cell).to_f
                end
              when 35
                if change2(cell)!=""
                  j.a_should_charge=change2(cell).to_f
                end
              when 36
                if change2(cell)!=""
                  j.a_charge=change2(cell).to_f
                end
              when 38
                if change2(cell)!=""
                 j.a_amount_rmb=change2(cell).to_f
                end
              when 39
                if change2(cell)!=""
                  j.a_amount_hk=change2(cell).to_f
                end
              when 40
                if change2(cell)!=""
                  j.a_amount_usa=change2(cell).to_f
                end
              when 41
                if change2(cell)!=""
                  j.a_rate_hk=change2(cell).to_f
                end
              when 42
                if change2(cell)!=""
                  j.a_rate_usa=change2(cell).to_f
                end
              when 43
                if change2(cell)!=""
                  j.a_refunds=change2(cell).to_f
                end
              when 45
                if change2(cell)!=""
                  j.a_should_charge_0003=change2(cell).to_f
                end
              when 48
                if change2(cell)!=""
                  j.a_should_charge_0007=change2(cell).to_f
                end
              when 49
                if change2(cell)!=""
                  j.a_should_charge_0002=change2(cell).to_f
                end
              when 50
                if change2(cell)!=""
                  j.a_should_charge_0003=change2(cell).to_f
                end
              when 51
                if change2(cell)!=""
                  j.a_should_qt=change2(cell).to_f
                end
              when 52
                if change2(cell)!=""
                  j.a_should_qt2=change2(cell).to_f
                end
              when 53
                if change2(cell)!=""
                  j.a_amount=change2(cell).to_f
                end
              when 54
                j.aribitprog_f=cell.to_s("utf-8").gsub(" ","")
              when 55
                if change2(cell)!=""
                  j.b_amount_hk=change2(cell).to_f
                end
              when 56
                if change2(cell)!=""
                  j.b_amount_usa=change2(cell).to_f
                end
              when 57
                if change2(cell)!=""
                  j.b_should_charge_0003=change2(cell).to_f
                end
              when 58
                if change2(cell)!=""
                  j.b_should_charge_0002=change2(cell).to_f
                end
              when 59
                if change2(cell)!=""
                  j.b_should_charge_0007=change2(cell).to_f
                end
              when 61
                if change2(cell)!=""
                  j.b_should_charge_0003=change2(cell).to_f
                end
              when 62
                if change2(cell)!=""
                  j.b_should_qt=change2(cell).to_f
                end
              when 63
                if change2(cell)!=""
                  j.b_should_qt2=change2(cell).to_f
                end
              when 64
                if change2(cell)!=""
                  j.b_amount=change2(cell).to_f
                end
              when 65
                if change2(cell)!=""
                  j.b_should_charge_0002=change2(cell).to_f
                end
              when 66
                if change2(cell)!=""
                  j.a_should_charge_0002=change2(cell).to_f
                end
              when 68
                if change2(cell)!=""
                  j.arbitmansign_0002=cell.to_s("utf-8").gsub(" ","")
                end
              when 69
                if change2(cell)!=""
                  j.arbitmansign_0003=cell.to_s("utf-8").gsub(" ","")
                end
              when 70
                if change2(cell)!=""
                  j.b_rate_hk=change2(cell).to_f
                end
              when 71
                if change2(cell)!=""
                  j.b_rate_usa=change2(cell).to_f
                end
              when 72
                if change2(cell)!=""
                  j.aribitprotprog_num=cell.to_s("utf-8").gsub(" ","")
                end
              when 73
                if change2(cell)!=""
                  j.finally_limit_dat=cell.date
                end
              when 74
                if change2(cell)!=""
                  j.nowdate=cell.date
                end
              when 75
                if change2(cell)!=""
                  j.delayDate=cell.date
                end
              when 77
                j.trial_typ=cell.to_s("utf-8").gsub(" ","")
              when 78
                if change2(cell)!=""
                  j.accepttime=cell.date
                end
              when 79
                if change2(cell)!=""
                  j.general_code=ccc(cell).gsub(".0","").gsub(" ","")
                end
              when 80
                if change2(cell)!=""
                  j.a_reduction=change2(cell).to_f
                end
              when 81 
                if change2(cell)!=""
                  j.a_re_rmb=change2(cell).to_f
                end
              when 82
                if change2(cell)!=""
                  j.b_reduction=change2(cell).to_f
                end
              when 83
                if change2(cell)!=""
                  j.b_re_rmb=change2(cell).to_f
                end
              when 86
                if change2(cell)!=""
                  j.b_amount_0002=change2(cell).to_f
                end
              when 87
                if change2(cell)!=""
                  j.a_amount_0002=change2(cell).to_f
                end
              when 88
                if change2(cell)!=""
                  j.a_should_charge_0004=change2(cell).to_f
                end
              when 89
                if change2(cell)!=""
                  j.b_should_charge_0004=change2(cell).to_f
                end
              when 90
                if change2(cell)!=""
                  j.arbitman_0001=cell.to_s("utf-8").gsub(" ","")
                end
              when 91
                if change2(cell)!=""
                  j.arbitman_0002=cell.to_s("utf-8").gsub(" ","")
                end
              when 92
                if change2(cell)!=""
                  j.arbitman_0003=cell.to_s("utf-8").gsub(" ","")
                end
              when 93 
                  j.party=cell.to_s("utf-8")
              when 94
                  j.b_party=cell.to_s("utf-8")
              when 95
                j.agent=cell.to_s("utf-8")
              when 96
                j.b_agent=cell.to_s("utf-8")
              end
            end
          }
          j.save
          puts r+1
        rescue
          print "erro line:"
          puts r+1
          error_line=error_line+"第#{r+1}行数据导入时发生错误，请检查相应源数据<br />"
        end
        r=r+1
        
      else
        print "nil line:"
        puts r+1
      end
    }
    return error_line
  end
  
  
  def change2(cell)
    cov1 = Iconv.new('utf-8','gbk')
    begin
      a=cov1.iconv(cell.to_s)
    rescue
      a=cell.to_s
    end
    a=ccc(a)
    a=a.gsub(/\'/,'')#|‘|’|"|“|”
    return a
  end
  
  def ccc(s)
    s=s.to_s
    a=""
    s.each_byte {|x| 
      if x!=0 
        a=a + x.chr
      end
    }
    return a
  end
  
end
