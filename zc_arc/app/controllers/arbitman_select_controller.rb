class ArbitmanSelectController < ApplicationController
  def p_set
    spell=params[:spell]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    spell="#{cov.iconv(spell)}" 
    if PubTool.new().sql_check_3(spell)!=false
      @tb_arbitmen =TbArbitman.find_by_sql("select * from tb_arbitmen where user='Y' and ((tb_arbitmen.spell like '#{spell}%') or (tb_arbitmen.name like  '#{spell}%'))   order by tb_arbitmen.spell,tb_arbitmen.name")
      render :update do |page| 
        page.remove 'table_1'
        page.replace_html 'pv_set', :partial => 'pv',:object=>@tb_arbitmen
      end
    end
  end
  #tb_arbitmen.code as code ,tb_arbitmen.spell as spell ,tb_arbitmen.name as name ,tb_arbitmen.sex as sex,tb_arbitmen.addr as addr,tb_arbitmen.company as company,tb_arbitmen.telo as telo ,tb_arbitmen.postcode as postcode
  def arbitman_select
    @tb_arbitmen =TbArbitman.find_by_sql("select * from tb_arbitmen where used='Y' order by tb_arbitmen.spell,tb_arbitmen.name limit 100")
  end
  
  
  
  def p_set_2
    spell=params[:spell]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    spell="#{cov.iconv(spell)}"  
    if PubTool.new().sql_check_3(spell)!=false
      @tb_arbitmen =TbArbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.spell as spell ,tb_arbitmen.name as name ,tb_arbitmen.sex as sex,tb_arbitmen.area_code as area_code,tb_arbitmen.company as company,tb_arbitmen.telh as telh ,tb_arbitmen.mobiletel as mobiletel,tb_arbitmen.area_code as area_code,tb_arbitmen.fax as fax from tb_arbitmen where tb_arbitmen.used='Y' and ((tb_arbitmen.spell like '%#{spell}%') or (tb_arbitmen.name like  '%#{spell}%')) order by tb_arbitmen.name desc")
      render :update do |page| 
        page.remove 'table_1'
        page.replace_html 'pv_set', :partial => 'pv_2',:object=>@tb_arbitmen
      end
    end
  end
  def arbitman_select_2
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    sql ="select tb_arbitmen.code as code ,tb_arbitmen.spell as spell ,tb_arbitmen.name as name ,tb_arbitmen.sex as sex,tb_arbitmen.area_code as area_code,tb_arbitmen.company as company,tb_arbitmen.telh as telh ,tb_arbitmen.mobiletel as mobiletel,tb_arbitmen.fax as fax from tb_arbitmen where  tb_arbitmen.used='Y' order by tb_arbitmen.name desc"
    @tb_arbitmen_pages,@tb_arbitmen =paginate_by_sql(TbArbitman,sql,@page_lines.to_i)
  end
  
  
end
