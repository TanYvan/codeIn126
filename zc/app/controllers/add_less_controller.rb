#2010-10-8 niell  仲裁员评价加减分统计
class AddLessController < ApplicationController
  #案件仲裁员评价加减分统计
  def list
    
    @page_lines = params[:page_lines] || session[:lines]
    
    @spell = params[:spell]
    if @spell.blank?      
      @add_less1_pages,@add_less1 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and e.score>0 order by e.id desc",@page_lines.to_i)
      @add_less2_pages,@add_less2 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and e.score<0 order by e.id desc",@page_lines.to_i)
    else
      arbitman = TbArbitman.find_by_used_and_spell('Y',params[:spell])
      @name = arbitman.name if arbitman!=nil
      @add_less1_pages,@add_less1 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and a.spell='#{@spell}' and e.score>0 order by e.id desc",@page_lines.to_i)
      @add_less2_pages,@add_less2 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and a.spell='#{@spell}' and e.score<0 order by e.id desc",@page_lines.to_i)
    end
    
  end
end
