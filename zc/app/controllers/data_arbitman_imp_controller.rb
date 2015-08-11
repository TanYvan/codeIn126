require "iconv"
require "parseexcel/parser"
class DataArbitmanImpController < ApplicationController

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
      DataArbitmanImp.delete_all("1=1")
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
    
    @d=DataArbitmanImp.find(:all,:order=>"id")
    for d in @d
      ar = TbArbitman.find_by_name_and_used(d.name,'Y')
      if ar != nil
        d.code=ar.code
        d.save
      end
    end
    
  end

  def imp_1(file_path)#导入
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
          j=DataArbitmanImp.new()
          col_n=0
          row.each {|cell|  #读一行中的每个列
            if cell!=nil
              col_n=col_n+1
              case col_n
              when 1
                j.name=cell.to_s("utf-8")
              when 2
                j.spell=ccc(cell)
              when 3
                j.sex=cell.to_s("utf-8")
              when 4
                j.jg=cell.to_s("utf-8")
              when 5
                j.addr_1=cell.to_s("utf-8")
              when 6
                j.workp=cell.to_s("utf-8")
              when 7
                j.zw=cell.to_s("utf-8")
              when 8
                j.tel=ccc(cell).gsub(".0","")#.to_s("utf-8")
              when 9
                j.email=cell.to_s("utf-8")
              when 10
                j.phone=ccc(cell).gsub(".0","")#cell.to_s("utf-8")
              when 11
                j.send_code=ccc(cell).gsub(".0","")#cell.to_s("utf-8")
              when 12
                j.addr_2=cell.to_s("utf-8")
              when 13
                j.roles=cell.to_s("utf-8")
              when 14
                j.yearbe=ccc(cell).gsub(".0","")
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
