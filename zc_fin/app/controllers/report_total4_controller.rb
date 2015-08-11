class ReportTotal4Controller < ApplicationController
  def list
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false
        if @typ=='1'
          @zl=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 , count(clerk) as c  from v_case_time_query_lists,users,user_duties where v_case_time_query_lists.endStyle<>'0003' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' group by v_case_time_query_lists.clerk order by users.ord,users.name")
        else
          @zl=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 , count(clerk) as c  from v_case_time_query_lists,users,user_duties where v_case_time_query_lists.endStyle<>'0003' and nowdate>='#{@d1}' and nowdate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' group by v_case_time_query_lists.clerk order by users.ord,users.name")
        end
      end
    end
  end

  def list_detail
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    @d1=params[:d1]
    @d2=params[:d2]
    @zl=params[:zl]
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false and p.sql_check_3(@zl)!=false
        if @typ=='1'
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5  from v_case_time_query_lists where v_case_time_query_lists.clerk='#{params[:zl]}' and v_case_time_query_lists.endStyle<>'0003' and decideDate>='#{@d1}' and decideDate<='#{@d2}'  order by right(case_code,7)")
        else
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5  from v_case_time_query_lists where v_case_time_query_lists.clerk='#{params[:zl]}' and v_case_time_query_lists.endStyle<>'0003' and nowdate>='#{@d1}' and nowdate<='#{@d2}' order by right(case_code,7)")
        end
      end
    end
  end

  def list_2
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false
        if @typ=='1'
          @zl=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 , count(clerk) as c  from v_case_time_query_lists,users,user_duties where v_case_time_query_lists.endStyle='0003' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' group by v_case_time_query_lists.clerk order by users.ord,users.name")
        else
          @zl=VCaseTimeQueryList.find_by_sql("select users.code as code,users.name as name,sum(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,sum(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,sum(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,sum(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,sum(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5 , count(clerk) as c  from v_case_time_query_lists,users,user_duties where v_case_time_query_lists.endStyle='0003' and nowdate>='#{@d1}' and nowdate<='#{@d2}' and v_case_time_query_lists.clerk=users.code and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' group by v_case_time_query_lists.clerk order by users.ord,users.name")
        end
      end
    end
  end

  def list_2_detail
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    @d1=params[:d1]
    @d2=params[:d2]
    @zl=params[:zl]
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false and p.sql_check_3(@zl)!=false
        if @typ=='1'
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5  from v_case_time_query_lists where v_case_time_query_lists.clerk='#{params[:zl]}' and v_case_time_query_lists.endStyle='0003'  and decideDate>='#{@d1}' and decideDate<='#{@d2}'  order by right(case_code,7)")
        else
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5  from v_case_time_query_lists where v_case_time_query_lists.clerk='#{params[:zl]}' and v_case_time_query_lists.endStyle='0003'  and nowdate>='#{@d1}' and nowdate<='#{@d2}'  order by right(case_code,7)")
        end
      end
    end
  end

  def list_3
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
    #    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @typ=params[:typ]
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
    @op=TbDictionary.find(:all,:conditions=>["typ_code='0001' and used='Y' and state='Y'"],:order=>"data_val")
  end

  def list_3_detail
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    @d1=params[:d1]
    @d2=params[:d2]
    @zl=params[:zl]
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false
        if @typ=='1'
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5    from v_case_time_query_lists where end_code<>'' and endStyle<>'0003' and v_case_time_query_lists.clerk='#{params[:zl]}' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and aribitprog_num='#{params[:aribitprog_num]}'  order by decideDate,end_code")
        else
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5    from v_case_time_query_lists where end_code<>'' and endStyle<>'0003' and v_case_time_query_lists.clerk='#{params[:zl]}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'  and aribitprog_num='#{params[:aribitprog_num]}' order by decideDate,end_code")
        end
      end
    end
  end
  def list_3b_detail
    @typ_t={"1"=>"结案时间","2"=>"立案时间"}
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
    @d1=params[:d1]
    @d2=params[:d2]
    @zl=params[:zl]
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@typ)!=false
        if @typ=='1'
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5    from v_case_time_query_lists where end_code<>'' and endStyle='0003' and v_case_time_query_lists.clerk='#{params[:zl]}' and decideDate>='#{@d1}' and decideDate<='#{@d2}' and aribitprog_num='#{params[:aribitprog_num]}'  order by decideDate,end_code")
        else
          @case=VCaseTimeQueryList.find_by_sql("select v_case_time_query_lists.recevice_code,v_case_time_query_lists.general_code,v_case_time_query_lists.case_code,v_case_time_query_lists.end_code,nowdate,orgdate,sittingdate,decideDate,(CASE WHEN (nowdate is  null or orgdate is  null) THEN 0 ELSE DATEDIFF(orgdate,nowdate)  END) as d1,(CASE WHEN (orgdate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(sittingdate,orgdate)  END) as d2,(CASE WHEN (decideDate is  null or sittingdate is  null) THEN 0 ELSE DATEDIFF(decideDate,sittingdate)  END) as d3,(CASE WHEN (orgdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,orgdate)  END) as d4 ,(CASE WHEN (nowdate is  null or decideDate is  null) THEN 0 ELSE DATEDIFF(decideDate,nowdate)  END) as d5    from v_case_time_query_lists where end_code<>'' and endStyle='0003' and v_case_time_query_lists.clerk='#{params[:zl]}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'  and aribitprog_num='#{params[:aribitprog_num]}' order by decideDate,end_code")
        end
      end
    end
  end
end