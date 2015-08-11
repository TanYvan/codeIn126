class ReportTotal3Controller < ApplicationController

  # 受理案件仲裁条款及争议金额分析
  # 按照设定的时间区间和仲裁机构：
  # 1 分别统计本请求或者反请求的一下数据以及合计
  #    明确争议金额收费、不明确争议金额收费、无明确争议金额收费、实收
  # 2 按照金额区间统计案件数量
  #    百万以下  1百万至5百万  5百万至1千万  1千万至5千万  5千万至1亿  1亿以上
  def list
    
    @order = params[:order] || "typ"
    @page_lines = params[:page_lines] || 2000000

    @d1 = params[:d1] || Time.now.at_beginning_of_year.to_date
    @d2 = params[:d2] || Time.now.to_date

    p = PubTool.new()
    return unless p.sql_check_3(@d1) and p.sql_check_3(@d2)
    
    ReportTotal3.delete_all("user_code='#{session[:user_code]}'")

    #查询所有的 仲裁机构  并插入到 report_total3s
    ActiveRecord::Base.connection.execute(
      " insert into report_total3s (user_code,typ,typ_name)
        select '#{session[:user_code]}',data_val,data_text
        from tb_dictionaries
        where typ_code='0004' and state='Y' "
    )
      
    report_total3 = ReportTotal3.find(:all,:conditions=>"user_code='#{session[:user_code]}'")

    for c in report_total3
      # 1百万以下
      c.c_a = TbCase.count(
        " used='Y' and  state>=4 and amount<1000000 and
          agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      # 1百万－5百万
      c.c_b = TbCase.count(
        " used='Y' and  state>=4 and amount>=1000000 and
          amount<5000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      # 5百万－1千万
      c.c_c = TbCase.count(
        " used='Y' and  state>=4 and amount>=5000000 and
          amount<10000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      # 1千万－5千万
      c.c_d = TbCase.count(
        " used='Y' and  state>=4 and amount>=10000000 and
          amount<50000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      # 5千万－1亿
      c.c_e = TbCase.count(
        " used='Y' and  state>=4 and amount>=50000000 and
          amount<100000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      #1亿以上
      c.c_f = TbCase.count(
        " used='Y' and  state>=4 and amount>=100000000 and
          agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'"
      ) || 0

      # 合计
      c.h = c.c_a + c.c_b + c.c_c + c.c_d + c.c_e + c.c_f
      
      #本诉明确争议金额
      b_amount_0001_all = TbCase.find_by_sql(
        "select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END) as n
         from tb_cases,tb_case_amounts
         where tb_cases.used='Y' and tb_case_amounts.used='Y'  and 
               tb_cases.recevice_code=tb_case_amounts.recevice_code  and
               tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
               tb_case_amounts.partytype='1' and tb_case_amounts.amount_typ='0001'  and
               tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      c.b_amount_0001 = b_amount_0001_all.first.n || 0
      
      # 本诉不明确争议金额
      b_amount_0002_all = TbCase.find_by_sql(
        "select sum( CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END ) as n
         from tb_cases,tb_case_amounts
         where tb_cases.used='Y' and tb_case_amounts.used='Y'  and
               tb_cases.recevice_code=tb_case_amounts.recevice_code  and
               tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
               tb_case_amounts.partytype='1' and tb_case_amounts.amount_typ='0002' and
               tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      c.b_amount_0002 = b_amount_0002_all.first.n || 0
      
      # 本诉争议金额合计
      c.b_amount_h = c.b_amount_0001 + c.b_amount_0002
      
      # 反诉明确争议金额
      f_amount_0001_all = TbCase.find_by_sql(
        " select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END) as n
          from tb_cases,tb_case_amounts
          where tb_cases.used='Y' and tb_case_amounts.used='Y'  and
                tb_cases.recevice_code=tb_case_amounts.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and 
                tb_case_amounts.partytype='2' and tb_case_amounts.amount_typ='0001' and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'"
      )
      c.f_amount_0001 = f_amount_0001_all.first.n || 0
      
      # 反诉不明确争议金额
      f_amount_0002_all = TbCase.find_by_sql(
        " select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END)  as n
          from tb_cases,tb_case_amounts
          where tb_cases.used='Y' and tb_case_amounts.used='Y' and
                tb_cases.recevice_code=tb_case_amounts.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_case_amounts.partytype='2' and tb_case_amounts.amount_typ='0002' and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      c.f_amount_0002 = f_amount_0002_all.first.n || 0

      # 反诉争议金额合计
      c.f_amount_h = c.f_amount_0001 + c.f_amount_0002

      # 争议金额总计
      c.amount_h=c.b_amount_h + c.f_amount_h
      
      # 本诉无明确争议金额 收费
      b_charge_0004_all_a = TbCase.find_by_sql(
        " select sum(tb_should_charges.rmb_money)  as n
          from tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_should_charges.used='Y'  and
                tb_cases.recevice_code=tb_should_charges.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_charges.payment='0001' and tb_should_charges.typ='0004' and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      
      # 本诉无明确争议金额 退费
      b_charge_0004_all_b = TbCase.find_by_sql(
        " select sum(tb_should_refunds.rmb_money)  as n
          from tb_cases,tb_should_refunds
          where tb_cases.used='Y' and tb_should_refunds.used='Y'  and
                tb_cases.recevice_code=tb_should_refunds.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_refunds.payment='0001' and tb_should_refunds.typ='0004' and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and
                tb_should_refunds.state<>3 "
      )

      b_charge_0004_a = b_charge_0004_all_a.first.n || 0
      b_charge_0004_b = b_charge_0004_all_b.first.n || 0

      #无明确争议金额 总收费
      c.b_charge_0004 = b_charge_0004_a.to_f - b_charge_0004_b.to_f

      # 本诉仲裁费(实交)
      b_charge_all_a = TbCase.find_by_sql(
        " select sum(tb_should_charges.re_rmb_money) as n
          from tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_should_charges.used='Y'  and
                tb_cases.recevice_code=tb_should_charges.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_charges.payment='0001' and
                (tb_should_charges.typ='0001' or tb_should_charges.typ='0004') and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      # 本诉仲裁费(实退)
      b_charge_all_b = TbCase.find_by_sql(
        " select sum(tb_should_refunds.re_rmb_money) as n
          from tb_cases,tb_should_refunds
          where tb_cases.used='Y' and tb_should_refunds.used='Y'  and
                tb_cases.recevice_code = tb_should_refunds.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_refunds.payment='0001' and
                (tb_should_refunds.typ='0001' or tb_should_refunds.typ='0004') and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state=2 "
      )

      b_charge_a = b_charge_all_a.first.n || 0
      b_charge_b = b_charge_all_b.first.n || 0
      
      # （本请求）实收费用 = 实交 - 实退
      c.b_charge = b_charge_a.to_f - b_charge_b.to_f

      # 反诉无明确争议金额 收费之和
      f_charge_0004_all_a = TbCase.find_by_sql(
        " select sum(tb_should_charges.rmb_money)  as n
          from tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_should_charges.used='Y'  and
                tb_cases.recevice_code=tb_should_charges.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_charges.payment='0002' and tb_should_charges.typ='0004' and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      # 反诉无明确争议金额 退费之和
      f_charge_0004_all_b = TbCase.find_by_sql(
        " select sum(tb_should_refunds.rmb_money)  as n
          from tb_cases,tb_should_refunds
          where tb_cases.used='Y' and tb_should_refunds.used='Y'  and
                tb_cases.recevice_code=tb_should_refunds.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_refunds.payment='0002' and 
                tb_should_refunds.typ='0004' and tb_cases.nowdate>='#{@d1}' and
                tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state<>3 "
      )
      
      f_charge_0004_a = f_charge_0004_all_a.first.n || 0
      f_charge_0004_b = f_charge_0004_all_b.first.n || 0

      #反诉 无明确争议金额 总收费
      c.f_charge_0004 = f_charge_0004_a.to_f - f_charge_0004_b.to_f

      # 反诉仲裁费(实交)
      f_charge_all_a = TbCase.find_by_sql(
        " select sum(tb_should_charges.re_rmb_money)  as n
          from tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_should_charges.used='Y'  and
                tb_cases.recevice_code=tb_should_charges.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_charges.payment='0002' and
                (tb_should_charges.typ='0001' or tb_should_charges.typ='0004') and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' "
      )
      # 反诉仲裁费(实退)
      f_charge_all_b = TbCase.find_by_sql(
        " select sum(tb_should_refunds.re_rmb_money)  as n
          from tb_cases,tb_should_refunds
          where tb_cases.used='Y' and tb_should_refunds.used='Y'  and
                tb_cases.recevice_code=tb_should_refunds.recevice_code  and
                tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and
                tb_should_refunds.payment='0002' and
                (tb_should_refunds.typ='0001' or tb_should_refunds.typ='0004') and
                tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state=2"
      )

      f_charge_a = f_charge_all_a.first.n || 0
      f_charge_b = f_charge_all_b.first.n || 0
      # 实收 = 实交 - 实退
      c.f_charge = f_charge_a.to_f - f_charge_b.to_f

      # 仲裁费总计 = （本请求）无明确争议金额总收费 + （本请求）实收费用 + （反请求）无明确争议金额 总收费 + （反请求）实收费用
      c.charge_h = c.b_charge_0004 + c.b_charge + c.f_charge_0004 + c.f_charge

      c.save
    end
    
    @case_pages,@case = paginate(
      :report_total3s,
      :conditions => "user_code='#{session[:user_code]}'",
      :order      => @order,
      :per_page   => @page_lines.to_i
    )
  end

  #明细表信息
  def bom
    @case = TbCase.find(:all,
      :conditions => ["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and agent=?", params[:d1], params[:d2], params[:agent]],
      :order      => "right(case_code,7) desc"
    )
  end

  #仲裁条款分析--处长使用
  def list4
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

    if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
      ReportTotal4.delete_all("user_code='#{session[:user_code]}'")
      ActiveRecord::Base.connection.execute("insert into report_total4s (user_code,typ,typ_name)   select '#{session[:user_code]}',data_val,data_text from tb_dictionaries where typ_code='0004' and state='Y'")

      @c=ReportTotal4.find(:all,:conditions=>"user_code='#{session[:user_code]}'")
      for c in @c
        # 1百万以下
        c_a=TbCase.count("used='Y' and  state>=4 and amount<1000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_a==nil
          c_a=0
        end
        c.c_a=c_a
        #1百万－5百万
        c_b=TbCase.count("used='Y' and  state>=4 and amount>=1000000 and amount<5000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_b==nil
          c_b=0
        end
        c.c_b=c_b
        # 5百万－1千万
        c_c=TbCase.count("used='Y' and  state>=4 and amount>=5000000 and amount<10000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_c==nil
          c_c=0
        end
        c.c_c=c_c
        # 1千万－5千万
        c_d=TbCase.count("used='Y' and  state>=4 and amount>=10000000 and amount<50000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_d==nil
          c_d=0
        end
        c.c_d=c_d
        # 5千万－1亿
        c_e=TbCase.count("used='Y' and  state>=4 and amount>=50000000 and amount<100000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_e==nil
          c_e=0
        end
        c.c_e=c_e
        #1亿以上
        c_f=TbCase.count("used='Y' and  state>=4 and amount>=100000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_f==nil
          c_f=0
        end
        c.c_f=c_f
        # 合计
        c.h=c_a + c_b + c_c + c_d + c_e + c_f
        #本诉明确争议金额
        b_amount_0001_all=TbCase.find_by_sql("select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END)  as n    from tb_cases,tb_case_amounts where tb_cases.used='Y' and tb_case_amounts.used='Y'  and tb_cases.recevice_code=tb_case_amounts.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_case_amounts.partytype='1' and tb_case_amounts.amount_typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        b_amount_0001_all=p.get_first_record(b_amount_0001_all)
        if b_amount_0001_all==nil
          b_amount_0001=0
        else
          b_amount_0001=b_amount_0001_all.n
        end
        if b_amount_0001==nil
          b_amount_0001=0
        end
        c.b_amount_0001=b_amount_0001
        # 本诉不明确争议金额
        b_amount_0002_all=TbCase.find_by_sql("select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END)  as n    from tb_cases,tb_case_amounts where tb_cases.used='Y' and tb_case_amounts.used='Y'  and tb_cases.recevice_code=tb_case_amounts.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_case_amounts.partytype='1' and tb_case_amounts.amount_typ='0002' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        b_amount_0002_all=p.get_first_record(b_amount_0002_all)
        if b_amount_0002_all==nil
          b_amount_0002=0
        else
          b_amount_0002=b_amount_0002_all.n
        end
        if b_amount_0002==nil
          b_amount_0002=0
        end
        c.b_amount_0002=b_amount_0002
        # 本诉争议金额合计
        c.b_amount_h=c.b_amount_0001 + c.b_amount_0002
        # 反诉明确争议金额
        f_amount_0001_all=TbCase.find_by_sql("select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END)  as n    from tb_cases,tb_case_amounts where tb_cases.used='Y' and tb_case_amounts.used='Y'  and tb_cases.recevice_code=tb_case_amounts.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_case_amounts.partytype='2' and tb_case_amounts.amount_typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        f_amount_0001_all=p.get_first_record(f_amount_0001_all)
        if f_amount_0001_all==nil
          f_amount_0001=0
        else
          f_amount_0001=f_amount_0001_all.n
        end
        if f_amount_0001==nil
          f_amount_0001=0
        end
        c.f_amount_0001=f_amount_0001
        # 反诉不明确争议金额
        f_amount_0002_all=TbCase.find_by_sql("select sum(CASE tb_case_amounts.typ WHEN '0003' THEN  -1 * tb_case_amounts.rmb_money ELSE tb_case_amounts.rmb_money END)  as n    from tb_cases,tb_case_amounts where tb_cases.used='Y' and tb_case_amounts.used='Y'  and tb_cases.recevice_code=tb_case_amounts.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_case_amounts.partytype='2' and tb_case_amounts.amount_typ='0002' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        f_amount_0002_all=p.get_first_record(f_amount_0002_all)
        if f_amount_0002_all==nil
          f_amount_0002=0
        else
          f_amount_0002=f_amount_0002_all.n
        end
        if f_amount_0002==nil
          f_amount_0002=0
        end
        c.f_amount_0002=f_amount_0002
        # 反诉争议金额合计
        c.f_amount_h=c.f_amount_0001 + c.f_amount_0002
        # 争议金额总计
        c.amount_h=c.b_amount_h + c.f_amount_h
        # 本诉无明确争议金额收费
        b_charge_0004_all_a=TbCase.find_by_sql("select sum(tb_should_charges.rmb_money)  as n    from tb_cases,tb_should_charges where tb_cases.used='Y' and tb_should_charges.used='Y'  and tb_cases.recevice_code=tb_should_charges.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_charges.payment='0001' and tb_should_charges.typ='0004' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        b_charge_0004_all_b=TbCase.find_by_sql("select sum(tb_should_refunds.rmb_money)  as n    from tb_cases,tb_should_refunds where tb_cases.used='Y' and tb_should_refunds.used='Y'  and tb_cases.recevice_code=tb_should_refunds.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_refunds.payment='0001' and tb_should_refunds.typ='0004' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state<>3")

        b_charge_0004_all_a=p.get_first_record(b_charge_0004_all_a)
        if b_charge_0004_all_a==nil
          b_charge_0004_a=0
        else
          b_charge_0004_a=b_charge_0004_all_a.n
        end
        if b_charge_0004_a==nil
          b_charge_0004_a=0
        end

        b_charge_0004_all_b=p.get_first_record(b_charge_0004_all_b)
        if b_charge_0004_all_b==nil
          b_charge_0004_b=0
        else
          b_charge_0004_b=b_charge_0004_all_b.n
        end
        if b_charge_0004_b==nil
          b_charge_0004_b=0
        end

        c.b_charge_0004=b_charge_0004_a.to_f - b_charge_0004_b.to_f
        # 本诉仲裁费(实收)
        b_charge_all_a=TbCase.find_by_sql("select sum(tb_should_charges.rmb_money)  as n    from tb_cases,tb_should_charges where tb_cases.used='Y' and tb_should_charges.used='Y'  and tb_cases.recevice_code=tb_should_charges.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_charges.payment='0001' and tb_should_charges.typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        b_charge_all_b=TbCase.find_by_sql("select sum(tb_should_refunds.rmb_money)  as n    from tb_cases,tb_should_refunds where tb_cases.used='Y' and tb_should_refunds.used='Y'  and tb_cases.recevice_code=tb_should_refunds.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_refunds.payment='0001' and tb_should_refunds.typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state<>3")

        b_charge_all_a=p.get_first_record(b_charge_all_a)
        if b_charge_all_a==nil
          b_charge_a=0
        else
          b_charge_a=b_charge_all_a.n
        end
        if b_charge_a==nil
          b_charge_a=0
        end

        b_charge_all_b=p.get_first_record(b_charge_all_b)
        if b_charge_all_b==nil
          b_charge_b=0
        else
          b_charge_b=b_charge_all_b.n
        end
        if b_charge_b==nil
          b_charge_b=0
        end

        c.b_charge=b_charge_a.to_f - b_charge_b.to_f
        # 反诉无明确争议金额收费
        f_charge_0004_all_a=TbCase.find_by_sql("select sum(tb_should_charges.rmb_money)  as n    from tb_cases,tb_should_charges where tb_cases.used='Y' and tb_should_charges.used='Y'  and tb_cases.recevice_code=tb_should_charges.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_charges.payment='0002' and tb_should_charges.typ='0004' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        f_charge_0004_all_b=TbCase.find_by_sql("select sum(tb_should_refunds.rmb_money)  as n    from tb_cases,tb_should_refunds where tb_cases.used='Y' and tb_should_refunds.used='Y'  and tb_cases.recevice_code=tb_should_refunds.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_refunds.payment='0002' and tb_should_refunds.typ='0004' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state<>3")

        f_charge_0004_all_a=p.get_first_record(f_charge_0004_all_a)
        if f_charge_0004_all_a==nil
          f_charge_0004_a=0
        else
          f_charge_0004_a=f_charge_0004_all_a.n
        end
        if f_charge_0004_a==nil
          f_charge_0004_a=0
        end

        f_charge_0004_all_b=p.get_first_record(f_charge_0004_all_b)
        if f_charge_0004_all_b==nil
          f_charge_0004_b=0
        else
          f_charge_0004_b=f_charge_0004_all_b.n
        end
        if f_charge_0004_b==nil
          f_charge_0004_b=0
        end

        c.f_charge_0004=f_charge_0004_a.to_f - f_charge_0004_b.to_f
        # 反诉仲裁费(实收)
        f_charge_all_a=TbCase.find_by_sql("select sum(tb_should_charges.rmb_money)  as n    from tb_cases,tb_should_charges where tb_cases.used='Y' and tb_should_charges.used='Y'  and tb_cases.recevice_code=tb_should_charges.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_charges.payment='0002' and tb_should_charges.typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}'")
        f_charge_all_b=TbCase.find_by_sql("select sum(tb_should_refunds.rmb_money)  as n    from tb_cases,tb_should_refunds where tb_cases.used='Y' and tb_should_refunds.used='Y'  and tb_cases.recevice_code=tb_should_refunds.recevice_code  and  tb_cases.state>=4 and  tb_cases.agent='#{c.typ}' and tb_should_refunds.payment='0002' and tb_should_refunds.typ='0001' and tb_cases.nowdate>='#{@d1}' and tb_cases.nowdate<='#{@d2}' and tb_should_refunds.state<>3")

        f_charge_all_a=p.get_first_record(f_charge_all_a)
        if b_charge_all_a==nil
          f_charge_a=0
        else
          f_charge_a=f_charge_all_a.n
        end
        if f_charge_a==nil
          f_charge_a=0
        end

        f_charge_all_b=p.get_first_record(f_charge_all_b)
        if f_charge_all_b==nil
          f_charge_b=0
        else
          f_charge_b=f_charge_all_b.n
        end
        if f_charge_b==nil
          f_charge_b=0
        end

        c.f_charge=f_charge_a.to_f - f_charge_b.to_f
        # 仲裁费总计
        c.charge_h=c.b_charge_0004 + c.b_charge + c.f_charge_0004 + c.f_charge


        c.save
      end
    end
    @case_pages,@case=paginate(:report_total4s,:conditions=>"user_code='#{session[:user_code]}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  
  def bom_2
    @case = TbCase.find(
      :all,
      :conditions => ["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and agent=?",params[:d1],params[:d2],params[:agent]],
      :order      => "right(case_code,7)"
    )
  end
end
