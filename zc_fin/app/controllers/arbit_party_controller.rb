#2009-8-4  niell  仲裁员当事人查询
class ArbitPartyController < ApplicationController
  def list
    @name = params[:name]
    @name1 = params[:name1]
    @party1 = params[:party1]
    @agent1 = params[:agent1]
    @case = TbCasearbitman.find_by_sql("select c.recevice_code as recevice_code,c.arbitmantype as arbitmantype,c.arbitman as arbitman,c.arbitmansign as arbitmansign 
       from tb_casearbitmen as c,tb_parties as p,
      tb_agents as a where c.recevice_code=p.recevice_code and c.recevice_code=a.recevice_code and
      c.used='Y' and p.used='Y' and a.used='Y' and 
      p.partyname='#{@party1}' and a.name='#{@agent1}'")
    
  end
end
