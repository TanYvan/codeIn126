class ArbitmannowSelectController < ApplicationController
  def p_set
    spell=params[:spell]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    spell="#{cov.iconv(spell)}"  
    if PubTool.new().sql_check_3(spell)!=false
      @tb_arbitmen =TbArbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.spell as spell ,tb_arbitmen.name as name ,tb_arbitmen.sex as sex,tb_arbitmen.addr as addr,tb_arbitmen.company as company,tb_arbitmen.telo as telo ,tb_arbitmen.postcode as postcode,tb_arbitmen.area_code as area_code from tb_arbitmen ,tb_arbitmannows where tb_arbitmen.used='Y' and tb_arbitmannows.used='Y' and ((tb_arbitmen.spell like '%#{spell}%') or (tb_arbitmen.name like  '%#{spell}%')) and tb_arbitmen.code=tb_arbitmannows.arbitman_num order by tb_arbitmen.spell,tb_arbitmen.name")
      render :update do |page| 
        page.remove 'table_1'
        page.replace_html 'pv_set', :partial => 'pv',:object=>@tb_arbitmen
      end
    end
  end
  def arbitman_select
    @tb_arbitmen =TbArbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.spell as spell ,tb_arbitmen.name as name ,tb_arbitmen.sex as sex,tb_arbitmen.addr as addr,tb_arbitmen.company as company,tb_arbitmen.telo as telo ,tb_arbitmen.postcode as postcode,tb_arbitmen.area_code as area_code from tb_arbitmen ,tb_arbitmannows where tb_arbitmen.code=tb_arbitmannows.arbitman_num and tb_arbitmen.used='Y' and tb_arbitmannows.used='Y' order by tb_arbitmen.spell,tb_arbitmen.name limit 100")
  end
  
end
