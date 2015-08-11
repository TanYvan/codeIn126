#2009-8-4  聂灵灵
class ArbitCaseController < ApplicationController
  def list
    @name = params[:name]
    @case = TbCasearbitman.find_by_sql("select c.recevice_code as recevice_code,c.arbitmansign as arbitmansign,
a.code as code from tb_arbitmen as a,tb_casearbitmen as c where a.name='#{@name}' and a.used='Y'
and c.used='Y' and a.code=c.arbitman")
  end
end
