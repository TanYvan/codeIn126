class ReportTotal3Controller < ApplicationController
  
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
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    
    if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
      ReportTotal3.delete_all("user_code='#{session[:user_code]}'")
      ActiveRecord::Base.connection.execute("insert into report_total3s (user_code,typ,typ_name)   select '#{session[:user_code]}',data_val,data_text from tb_dictionaries where typ_code='0004' and state='Y'")
      
      @c=ReportTotal3.find(:all,:conditions=>"user_code='#{session[:user_code]}'")
      for c in @c
        # 1百万以下
        c_a=TbCase.count("used='Y' and  state>=4 and amount<1000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_a==nil
          c_a=0
        end
        c.c_a=c_a
        # 1百万－5百万
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
    
    @case_pages,@case=paginate(:report_total3s,:conditions=>"user_code='#{session[:user_code]}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
  #其它的明细表信息 0005
  def bom
    @case=TbCase.find(:all,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and agent='0005'",params[:d1],params[:d2]])

  end
  def list_1
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
      ReportTotal3.delete_all("user_code='#{session[:user_code]}'")
      ActiveRecord::Base.connection.execute("insert into report_total3s (user_code,typ,typ_name)   select '#{session[:user_code]}',data_val,data_text from tb_dictionaries where typ_code='0004' and state='Y'")

      @c=ReportTotal3.find(:all,:conditions=>"user_code='#{session[:user_code]}'")
      for c in @c
        # 1百万以下
        c_a=TbCase.count("used='Y' and  state>=4 and amount<1000000 and agent='#{c.typ}' and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
        if c_a==nil
          c_a=0
        end
        c.c_a=c_a
        # 1百万－5百万
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
    
    @case_pages,@case=paginate(:report_total3s,:conditions=>"user_code='#{session[:user_code]}'",:order=>@order,:per_page=>@page_lines.to_i)
  end
end
