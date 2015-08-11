class ReportTotal5Controller < ApplicationController
  def list
    @typ_t={"1"=>"结案时间","2"=>"立案时间","3"=>"立案结案时间"}
    @case_typ_t={"0"=>"全部","1"=>"涉外","2"=>"国内"} 
    @prog_typ_t={"0"=>"全部","1"=>"普通","2"=>"简易"}
    @end_typ_t={"0"=>"全部","1"=>"裁决","2"=>"和解","3"=>"撤案"}
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @typ=params[:typ]
    @case_typ=params[:case_typ]
    @prog_typ=params[:prog_typ]
    @end_typ=params[:end_typ]
    @d1=params[:d1]
    @d2=params[:d2]
    if @typ==nil
      @typ='1'
    end
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    s=""
    if @case_typ=='1'
      s=s + " and (aribitprog_num='0003' or 'aribitprog_num='0004' or aribitprog_num='0007' and aribitprog_num='0008') "
    elsif @case_typ=='2'
      s=s + " and (aribitprog_num='0001' or 'aribitprog_num='0002' or aribitprog_num='0005' and aribitprog_num='0006') "
    end
    if @prog_typ=='1'
      s=s + " and (aribitprog_num='0001' or 'aribitprog_num='0003' or aribitprog_num='0005' and aribitprog_num='0007') "
    elsif @prog_typ=='2'
      s=s + " and (aribitprog_num='0002' or 'aribitprog_num='0004' or aribitprog_num='0006' and aribitprog_num='0008') "
    end
    if @end_typ=='1'
      s=s + " and endStyle='0001' "
    elsif @end_typ=='2'
      s=s + " and endStyle='0002' "
    elsif @end_typ=='3'
      s=s + " and endStyle='0003' "
    end
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false and p.sql_check_3(s)!=false
        if @typ=='1'
          @zl_total=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,org as org,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 ,count(clerk) as c     from v_case_time_query_lists,users,user_duties where decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' #{s} group by v_case_time_query_lists.clerk,v_case_time_query_lists.org order by users.ord,users.name,v_case_time_query_lists.org desc ")
          @zl_2=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5  from v_case_time_query_lists,users,user_duties where decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=1 #{s} order by users.ord,users.name ")
          @zl_3=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5  from v_case_time_query_lists,users,user_duties where decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=0 #{s} order by users.ord,users.name ")
        elsif @typ=='2'
          @zl_total=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,org as org,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 ,count(clerk) as c   from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003'  #{s} group by v_case_time_query_lists.clerk,v_case_time_query_lists.org  order by users.ord,users.name,v_case_time_query_lists.org ")
          @zl_2=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5  from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=1 #{s} order by users.ord,users.name ")
          @zl_3=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5  from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=0 #{s} order by users.ord,users.name ")
        else
          @zl_total=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,org as org,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 ,count(clerk) as c    from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003'  #{s} group by v_case_time_query_lists.clerk,v_case_time_query_lists.org  order by users.ord,users.name,v_case_time_query_lists.org ")
          @zl_2=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5   from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=1  #{s} order by users.ord,users.name")
          @zl_3=VCaseTimeQueryList.find_by_sql("select users.name,v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END as d1,CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END as d2,CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END as d3,CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END as d4 ,CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END as d5   from v_case_time_query_lists,users,user_duties where nowdate>='#{@d1}' and nowdate<='#{@d2}' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' and v_case_time_query_lists.org=0  #{s} order by users.ord,users.name")
        end
      end
    end
  end
end
