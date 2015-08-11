class CasetypeEndtypeCountController < ApplicationController
  
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
    @aribitprog=TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @end_type=TbDictionary.find(:all,:conditions=>"typ_code='8117' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    if @datestyle=='0001'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='Y' and users.used='Y')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='N' or users.used='N')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' order by clerks.name")
    elsif @datestyle=='0002'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='Y' and users.used='Y')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_caseendbooks.decideDate>='#{@date1}' and tb_caseendbooks.decideDate<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='N' or users.used='N')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_caseendbooks.decideDate>='#{@date1}' and tb_caseendbooks.decideDate<='#{@date2}' order by clerks.name")
    elsif @datestyle=='0003'
      @clerks_1=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='Y' and users.used='Y')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and  tb_caseendbooks.decideDate>='#{@date1}' and tb_caseendbooks.decideDate<='#{@date2}' order by clerks.name")
      @clerks_2=TbCase.find_by_sql("select distinct clerks.name as name,clerks.code as code from tb_cases,tb_caseendbooks,(select distinct users.name,users.code from users where (users.states='N' and users.used='N')  ) as clerks where tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.clerk=clerks.code and  tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and  tb_caseendbooks.decideDate>='#{@date1}' and tb_caseendbooks.decideDate<='#{@date2}' order by clerks.name")
    end
  end
  
end
