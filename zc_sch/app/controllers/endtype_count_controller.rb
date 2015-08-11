class EndtypeCountController < ApplicationController
  
  def list
    @datestyle_state={"0001"=>"立案时间段","0002"=>"结案时间段","0003"=>"立案结案时间段"}
    j=params[:j]
    @date1=params[:date1]
    if @date1==nil
      @date1=Time.now.at_beginning_of_year.to_date
    end
    @date2=params[:date2]
    if @date2==nil
      @date2=Date.today
    end
    @endcase=params[:endcase]
    if params[:j]!=nil
      @datestyle=params[:j][:datestyle]
    end
    @end_type=TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y'",:order=>'data_val',:select=>"data_val,data_text")
    if @datestyle=='0001'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='Y' and users.used='Y') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='N' or users.used='N') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' order by clerks.name")
    elsif @datestyle=='0002'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='Y' and users.used='Y') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.end_date>='#{@date1}' and tb_cases.end_date<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='N' or users.used='N') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.end_date>='#{@date1}' and tb_cases.end_date<='#{@date2}' order by clerks.name")
    elsif @datestyle=='0003'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='Y' and users.used='Y') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and  tb_cases.end_date>='#{@date1}' and tb_cases.end_date<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,(select distinct users.name,users.code from users,user_duties where (users.states='N' or users.used='N') and users.code=user_duties.user_code and user_duties.duty_code='0003') as clerks where tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and  tb_cases.end_date>='#{@date1}' and tb_cases.end_date<='#{@date2}' order by clerks.name")
    end
  end
  
end
