class RegionTotalController < ApplicationController
  #当事人国别统计
  def list
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
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
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='0' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end


  # -------------------------------------------  ↓↓↓前一月数据统计↓↓↓  ----------------------------------------------
  #前一月数据统计 立案数据按立案时间查询,结案数据按结案时间查询,裁决更正 补充裁决 以上传日期为准
  #
  #管辖权异议、仲裁员回避、延期案件数量 时间以提出时间判断，
  #专家咨询会以开会时间判断；   含涉外仲裁员的以组庭时间判断(案件数)； 仲裁员语言及规则的以立案时间判断
  #检测、审计、鉴定 以提出时间判断
  #发文量是统计时间段内含发文函号的发文数量 发文时间
  def list_1
    @clerk = User.find_by_sql("select u.code as code,u.name as name from users as u,user_duties as d where d.duty_code='0003' and d.user_code=u.code and u.used='Y' and u.used_used='Y' order by u.ord")
    @d1 = params[:d1]
    if @d1==nil
      @d1 = Time.now.months_ago(1).at_beginning_of_month.to_date
      #  Time.now.at_beginning_of_year.to_date
    end
    @d2 = params[:d2]
    if @d2==nil
      @d2 = Time.now.at_beginning_of_month.ago(86400).to_date
    end
  end
  #咨询接待案件
  def list1
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbCase.find(:all,:select=>"recevice_code,receivedate,amount",:conditions=>["clerk_2=? and used='Y' and receivedate>=? and receivedate<=? and state<>-2",params[:code],params[:d1],params[:d2]])
  end
  #新立案件
  def list2
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    if params[:k]=="2"
      @case = TbCase.find(:all,:select=>"recevice_code,case_code,receivedate,amount,nowdate",:conditions=>["clerk=? and used='Y' and nowdate>=? and nowdate<=? and state>=4 and (aribitprog_num='0002' or aribitprog_num='0004')",params[:code],params[:d1],params[:d2]])
    elsif params[:k]=="3"
      @case = TbCase.find(:all,:select=>"recevice_code,case_code,receivedate,amount,nowdate",:conditions=>["clerk=? and used='Y' and nowdate>=? and nowdate<=? and state>=4 and (aribitprog_num='0001' or aribitprog_num='0003')",params[:code],params[:d1],params[:d2]])
    elsif params[:k]=="4"
      @case = TbCase.find(:all,:select=>"recevice_code,case_code,receivedate,amount,nowdate",:conditions=>["clerk=? and used='Y' and nowdate>=? and nowdate<=? and state>=4 and (aribitprog_num='0005' or aribitprog_num='0006' or aribitprog_num='0007' or aribitprog_num='0008')",params[:code],params[:d1],params[:d2]])
    else
      @case = TbCase.find(:all,:select=>"recevice_code,case_code,receivedate,amount,nowdate",:conditions=>["clerk=? and used='Y' and nowdate>=? and nowdate<=? and state>=4",params[:code],params[:d1],params[:d2]])
    end
  end
  #结案案件
  def list3
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    if params[:k]=="2"
      @case = TbCase.find(:all,:select=>"c.recevice_code as recevice_code,c.case_code as case_code,c.receivedate as receivedate,c.amount as amount,c.nowdate as nowdate,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum",:conditions=>["c.clerk=? and c.used='Y' and (c.aribitprog_num='0002' or c.aribitprog_num='0004') and e.used='Y' and e.endStyle<>'0003' and e.decideDate>=? and e.decideDate<=?",params[:code],params[:d1],params[:d2]],:joins=>"as c inner join tb_caseendbooks as e on c.recevice_code=e.recevice_code")
    elsif params[:k]=="3"
      @case = TbCase.find(:all,:select=>"c.recevice_code as recevice_code,c.case_code as case_code,c.receivedate as receivedate,c.amount as amount,c.nowdate as nowdate,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum",:conditions=>["c.clerk=? and c.used='Y' and (c.aribitprog_num='0001' or c.aribitprog_num='0003') and e.used='Y' and e.endStyle<>'0003' and e.decideDate>=? and e.decideDate<=?",params[:code],params[:d1],params[:d2]],:joins=>"as c inner join tb_caseendbooks as e on c.recevice_code=e.recevice_code")
    elsif params[:k]=="4"
      @case = TbCase.find(:all,:select=>"c.recevice_code as recevice_code,c.case_code as case_code,c.receivedate as receivedate,c.amount as amount,c.nowdate as nowdate,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum",:conditions=>["c.clerk=? and c.used='Y' and (c.aribitprog_num='0005' or c.aribitprog_num='0006' or c.aribitprog_num='0007' or c.aribitprog_num='0008') and e.used='Y' and e.endStyle<>'0003' and e.decideDate>=? and e.decideDate<=?",params[:code],params[:d1],params[:d2]],:joins=>"as c inner join tb_caseendbooks as e on c.recevice_code=e.recevice_code")
    elsif params[:k]=="5"
      @case = TbCase.find(:all,:select=>"c.recevice_code as recevice_code,c.case_code as case_code,c.receivedate as receivedate,c.amount as amount,c.nowdate as nowdate,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum",:conditions=>["c.clerk=? and c.used='Y' and e.used='Y' and e.endStyle='0003' and e.decideDate>=? and e.decideDate<=?",params[:code],params[:d1],params[:d2]],:joins=>"as c inner join tb_caseendbooks as e on c.recevice_code=e.recevice_code")
    else
      @case = TbCase.find(:all,:select=>"c.recevice_code as recevice_code,c.case_code as case_code,c.receivedate as receivedate,c.amount as amount,c.nowdate as nowdate,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum",:conditions=>["c.clerk=? and c.used='Y' and e.used='Y' and e.decideDate>=? and e.decideDate<=?",params[:code],params[:d1],params[:d2]],:joins=>"as c inner join tb_caseendbooks as e on c.recevice_code=e.recevice_code")
    end
  end
  #裁决更正、补充裁决
  def list4
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    if params[:k]=="1"
      @case = TbCase.find_by_sql("select distinct(c.recevice_code) as recevice_code from tb_cases as c,tb_caseendbooks as e,case_books as b where c.clerk='#{params[:code]}' and c.used='Y' and c.recevice_code=b.recevice_code and c.caseendbook_id_last=b.p_id and b.used='Y' and b.book_dat>='#{params[:d1]}' and b.book_dat<='#{params[:d2]}' and b.typ='0002' and b.book_typ='0004'")
    else
      @case = TbCase.find_by_sql("select distinct(c.recevice_code) as recevice_code from tb_cases as c,tb_caseendbooks as e,case_books as b where c.clerk='#{params[:code]}' and c.used='Y' and c.recevice_code=b.recevice_code and c.caseendbook_id_last=b.p_id and b.used='Y' and b.book_dat>='#{params[:d1]}' and b.book_dat<='#{params[:d2]}' and b.typ='0002' and b.book_typ='0005'")
    end
  end
  #管辖权异议、 时间以提出时间判断
  def list11
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbJurisdiction.find(:all,:select=>"distinct(recevice_code) as recevice_code",:conditions=>["request_date>=? and request_date<=? and u=? and used='Y'",params[:d1],params[:d2],params[:code]])
  end
  #仲裁员回避
  def list12
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbEvite.find(:all,:select=>"distinct(recevice_code) as recevice_code",:conditions=>["requestdate>=? and requestdate<=? and u=? and used='Y'",params[:d1],params[:d2],params[:code]])
  end
  #延期案件数量
  def list13
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbCasedelay.find(:all,:select=>"distinct(recevice_code) as recevice_code",:conditions=>["requestdate>=? and requestdate<=? and u=? and used='Y'",params[:d1],params[:d2],params[:code]])
  end
  #专家咨询
  def list14
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbExpert.find(:all,:select=>"distinct(recevice_code) as recevice_code",:conditions=>["convoke_date>=? and convoke_date<=? and u=? and used='Y'",params[:d1],params[:d2],params[:code]])
  end
  #含涉外仲裁员的
  def list15
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbCaseorg.find_by_sql("select distinct(o.recevice_code) as recevice_code from tb_caseorgs as o,tb_casearbitmen as m,tb_arbitmen as a where o.u='#{params[:code]}' and o.orgdate>='#{params[:d1]}' and o.orgdate<='#{params[:d2]}' and o.used='Y' and o.recevice_code=m.recevice_code and m.used='Y' and m.arbitman=a.code and a.used='Y' and a.area_code>'004'")
  end

  def list16
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    if params[:k]=="6"
      @case = TbCase.find(:all,:conditions=>["nowdate>=? and nowdate<=? and clerk=? and used='Y' and language='0002'",params[:d1],params[:d2],params[:code]])
    else
      @case = TbCase.find(:all,:conditions=>["nowdate>=? and nowdate<=? and clerk=? and used='Y' and app_rules<>'0001' and app_rules<>'0002'",params[:d1],params[:d2],params[:code]])
    end
  end
  #有检测、审计、鉴定事宜的
  def list17
    @name = User.find(:first,:conditions=>["code=? and used='Y' ",params[:code]]).name
    @case = TbDetection.find(:all,:select=>"distinct(recevice_code) as recevice_code",:conditions=>["make_date>=? and make_date<=? and u=? and used='Y'",params[:d1],params[:d2],params[:code]])
  end
  # -------------------------------------------  ↑↑↑前一月数据统计↑↑↑  ----------------------------------------------

  
  #查看具体国别的当事人案件信息
  def list_a
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    @case_pages,@re=paginate_by_sql(TbCase,["select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like ? and nowdate>=? and nowdate<=?  group by tb_cases.recevice_code order by right(tb_cases.case_code,7)",params[:code]+'%',params[:d1],params[:d2]],@page_lines.to_i)
    @re1=TbCase.find_by_sql(["select tb_cases.recevice_code as recevice_code from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like ? and nowdate>=? and nowdate<=?  group by tb_cases.recevice_code order by tb_cases.general_code",params[:code]+'%',params[:d1],params[:d2]])
  end
  #某地区当事人数量统计
  def list_2
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @area=params[:area]
    if @d1!=nil and @d2!=nil and @area!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@area)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(tb_cases.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(tb_cases.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area = regions.code and regions.code='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
      end
    end
  end
  #查看某地区当事人数量统计明细
  def list_2a
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases.case_code,7)"
    end
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    if params[:k]=='1'
      sql="select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like '#{params[:code]}%' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by #{@order}"
      @case_pages,@re=paginate_by_sql(TbCase,sql,@page_lines.to_i)
      @re1=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like '#{params[:code]}%' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code")
    else
      sql="select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by #{@order}"
      @case_pages,@re=paginate_by_sql(TbCase,sql,@page_lines.to_i)
      @re1=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code")
    end
  end
  #查看中国内地当事人数量统计明细
  def list_2b
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    ("select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by #{@order}")
  end
  #广东省各市当事人统计
  def list_3
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
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
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='001001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='001001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end
  #查看广东省各市当事人统计 明细
  def list_3a
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    sql="select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by right(tb_cases.case_code,7)"
    @case_pages,@re=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    @re1=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by tb_cases.general_code")
  end
  #国内各省当事人统计
  def list_4
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
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
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end
  #查看国内各省 当事人统计 明细
  def list_4a
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    sql="select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like '#{params[:code]}%' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by right(tb_cases.case_code,7)"
    @case_pages,@re=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    @re1=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like '#{params[:code]}%' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by tb_cases.general_code")
  end
  #某地区案件数量统计
  def list_5
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @area=params[:area]
    if @d1!=nil and @d2!=nil and @area!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@area)!=false
        #@re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(distinct CONCAT(tb_parties.area ,tb_parties.recevice_code)) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(distinct tb_parties.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(distinct tb_parties.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
      end
    end
  end
  #地区案件数量统计
  def list_5a
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    parent_code=Region.find_by_code(params[:code]).parent
    if parent_code=="0" or parent_code=="001"
      @re=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area like '#{params[:code]}%' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by right(tb_cases.case_code,7)")
    else
      @re=TbCase.find_by_sql("select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area='#{params[:code]}' and nowdate>='#{params[:d1]}' and nowdate<='#{params[:d2]}' group by tb_cases.recevice_code order by right(tb_cases.case_code,7)")
    end
  end
  #查看本地区的（不包括子地区）
  def list_self
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @state={4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请",200=>"存档接收",220=>"存档"}
    @case_pages,@re=paginate_by_sql(TbCase,["select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=? and nowdate>=?  and nowdate<=?  group by tb_cases.recevice_code order by right(tb_cases.case_code,7)",params[:code],params[:d1],params[:d2]],@page_lines.to_i)
    @re1=TbCase.find_by_sql(["select tb_cases.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.amount as amount from tb_cases,tb_parties where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=? and nowdate>=?  and nowdate<=?  group by tb_cases.recevice_code order by tb_cases.general_code",params[:code],params[:d1],params[:d2]])
  end
end
