class EvaluateSumController < ApplicationController

    def list
        @year=params[:year]
        @evaluate_t = EvaluateSum.find(:first)
        @train_t = TrainSum.find(:first)
        unless @year.blank?
          sql="select code ,name, round(party_to_arbitman_1_sum,2) as party_to_arbitman_1_sum,round(party_to_arbitman_2_sum,2) as party_to_arbitman_2_sum,round(arbitman_to_arbitman_sum,2) as arbitman_to_arbitman_sum,round(assistant_to_arbitman_sum,2) as assistant_to_arbitman_sum,round(train,2) as train  from (select  tb_arbitmen.code as code,tb_arbitmen.name as name,
          sum(case evaluate_sum.category when 'party_to_arbitman_1' then evaluate_sum.score_sum else 0 end ) /sum(case evaluate_sum.category when 'party_to_arbitman_1' then 1 else 0 end )  as party_to_arbitman_1_sum
          ,sum(case evaluate_sum.category when 'party_to_arbitman_2' then evaluate_sum.score_sum else 0 end ) /sum(case evaluate_sum.category when 'party_to_arbitman_2' then 1 else 0 end )  as party_to_arbitman_2_sum
          ,sum(case evaluate_sum.category when 'arbitman_to_arbitman' then evaluate_sum.score_sum else 0 end ) /sum(case evaluate_sum.category when 'arbitman_to_arbitman' then 1 else 0 end )  as arbitman_to_arbitman_sum
          ,sum(case evaluate_sum.category when 'assistant_to_arbitman' then evaluate_sum.score_sum else 0 end ) /sum(case evaluate_sum.category when 'assistant_to_arbitman' then 1 else 0 end )  as assistant_to_arbitman_sum
          ,(select avg(score_sum) from train_sum where train_sum.user_type='arbitman' and train_sum.user=tb_arbitmen.code and do_year='#{@year}')as train
          from evaluate_sum,tb_arbitmen,tb_cases,tb_casearbitmen where YEAR(tb_cases.nowdate)='#{@year}' and tb_cases.state>=4 and tb_cases.used='Y' and tb_casearbitmen.recevice_code=tb_cases.recevice_code and  tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.recevice_code=evaluate_sum.recevice_code and evaluate_sum.user_code= tb_casearbitmen.arbitman and tb_casearbitmen.used='Y' and tb_arbitmen.used='Y' group by tb_arbitmen.code) as evaluate"
      
          @evaluate=TbCase.find_by_sql(sql)
      end
  end

end
