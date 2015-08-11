=begin
   用于“案件费用统计”和“仲裁员费用情况”的控制器
=end
class ReportTotal2Controller < ApplicationController

  #  案件费用统计
  #  用于统计某一个时间段内 立案案件的 以下信息：
  #                 本请求：   明确争议金额、不明确争议金额、无明确争议金额、应收、减交、实收、欠缴
  #                 反请求：   明确争议金额、不明确争议金额、无明确争议金额、应收、减交、实收、欠缴
  #   以上各项的合计：
  #   此外显示每一个案件的 通知日期、总案号、立案号、经办人、案由、申请人、被申请人、仲裁员、结案号、结案时间、结案方式
  def list
    @order = params[:order] || "right(ca_cc,7) asc"
    @page_lines = params[:page_lines] || 2000000
    @d1 = params[:d1] || Time.now.at_beginning_of_year.to_date
    @d2 = params[:d2] || Time.now.to_date

    p = PubTool.new()
    return if !p.sql_check_3(@d1) or !p.sql_check_3(@d2)

    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")

    ActiveRecord::Base.connection.execute(
      "insert into report_total2s (user_code,ca_clerk_name,ca_id,ca_rc,ca_gc,ca_cc,ca_ec,ca_nowdate,ca_clerk)
       select '#{session[:user_code]}',b.name,c.id,c.recevice_code,c.general_code,c.case_code,c.end_code,c.nowdate,c.clerk
       from tb_cases as c, users as b
       where c.clerk=b.code and c.used='Y' and c.state>=4 and c.nowdate>='#{@d1}' and c.nowdate<='#{@d2}'"
    )

    report_total2 = ReportTotal2.find(:all, :conditions => "user_code='#{session[:user_code]}'")
    for c in report_total2
      endbook = TbCaseendbook.find(:first, :conditions => ["used='Y' and recevice_code=?", c.ca_rc], :order => "id desc")
      if endbook != nil
        c.ca_en = endbook.arbitBookNum #结案号
        c.ca_ed = endbook.decideDate   #结案时间
        c.ca_es = endbook.endStyle     #结案方式
      end

      #---------------------------- 本请求----------------------------

      #本请求，明确争议金额收费总额
      c.je1 = Cost.new.get_sum(c.ca_rc, "1", "0001")

      #是否存在外币明确争议金额（本请求） Y:存在     N:不存在
      c.je1_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '1', '0001') ? "Y" : "N"

      #本请求，不明确争议金额收费总额
      c.je2 = Cost.new.get_sum(c.ca_rc, "1", "0002")

      #是否存在外币不明确争议金额（本请求） Y:存在     N:不存在
      c.je2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '1', '0002') ? "Y" : "N"

      # 无明确争议金额应收费之和
      tb_should_charge = TbShouldCharge.sum("rmb_money",
        :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'"
      ) || 0

      # 无明确争议金额应退费之和
      tb_should_refund = TbShouldRefund.sum("rmb_money",
        :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}' and state<>3"
      ) || 0

      #无明确争议金额收费总额（本请求） =  应收费之和 - 应退费之和
      c.je3 = tb_should_charge - tb_should_refund

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 减交
      c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and (state=2 or state = 4)") || 0).to_f
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0
      c1=0 if c1 == nil
      c2=0 if c2 == nil
      c3=0 if c3 == nil
      c4=0 if c4 == nil
      c5=0 if c5 == nil
      c6=0 if c6 == nil 

      c.c_rmb_money      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）
      c.c_redu_rmb_money = c3             # （本请求）减交费用
      c.c_re_rmb_money   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

      # （本请求）欠缴费用 = 应收 - 实收 - 减交
      c.c_c = c.c_rmb_money - c.c_re_rmb_money - c.c_redu_rmb_money

      c.c_c_out = c.c_c < 0 ? 'Y' : 'N' # 是否多收了费用  Y:是，N:否
      c.c_c = 0 if c.c_c < 0

      #c.c_sf = c.c_rmb_money - (c4 - c6 ) # 本请求（最终收款）
      #本请求的 if (案件收费（争议金额或无明确争议金额）的应退项>0 and (案件收费（争议金额或无明确争议金额）的应退项－减退－实退>0) then 最终收款＝实交－应退 else 最终收款＝应收
      if (c4 > 0 && ( c4- c6 - c5)>0)
        c.c_sf = c2 - c4
      else
        c.c_sf = c.c_re_rmb_money
      end
      #----------------------------  反请求----------------------------

      #反请求，明确争议金额收费总额
      c.je1_2 = Cost.new.get_sum(c.ca_rc,"2","0001")

      #是否存在非人民币明确争议金额（反请求） Y:存在     N:不存在
      c.je1_2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '2', '0001') ? 'Y' : 'N'

      #反请求，不明确争议金额收费总额
      c.je2_2 = Cost.new.get_sum(c.ca_rc, "2", "0002")

      #是否存在非人民币不明确争议金额（反请求） Y:存在     N:不存在
      c.je2_2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '2', '0002') ? "Y" : "N"

      # 无明确争议金额应收费之和
      tb_should_charge = TbShouldCharge.sum("rmb_money",
        :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'"
      ) || 0

      # 无明确争议金额应退费之和
      tb_should_refund = TbShouldRefund.sum("rmb_money",
        :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}' and state<>3"
      ) || 0

      #无明确争议金额收费总额（反请求） =  应收费之和 - 应退费之和
      c.je3_2 = tb_should_charge - tb_should_refund

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 减交
      c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and (state=2 or state=4)") || 0).to_f
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0
      c1=0 if c1 == nil
      c2=0 if c2 == nil
      c3=0 if c3 == nil
      c4=0 if c4 == nil
      c5=0 if c5 == nil
      c6=0 if c6 == nil 

      c.c_rmb_money_2      = c1 - (c4 - c6) # （反请求）应收费    = 应交 -（应退 - 减退）
      c.c_redu_rmb_money_2 = c3             # （反请求）减交费用
      c.c_re_rmb_money_2   = c2 - c5        # （反请求）实收费用  = 实交 - 实退

      # （反请求）欠缴费用 = 应收 - 实收 - 减交
      c.c_c_2 = c.c_rmb_money_2 - c.c_redu_rmb_money_2 - c.c_re_rmb_money_2

      c.c_c_2_out = c.c_c_2 < 0 ? 'Y' : 'N' # 是否多收了费用  Y:是，N:否
      c.c_c_2 = 0 if c.c_c_2 < 0

      #c.c_sf_2 = c.c_rmb_money_2 - (c4 -c6) # 反请求（最终收款）
      #反请求的 if (案件收费（争议金额或无明确争议金额）的应退项>0 and (案件收费（争议金额或无明确争议金额）的应退项－减退－实退>0) then 最终收款＝实交－应退 else 最终收款＝应收
      if (c4 > 0 && ( c4- c6 - c5)>0)
        c.c_sf_2 = c2 - c4
      else
        c.c_sf_2 = c.c_re_rmb_money_2
      end

      c.save
    end

    @count = ReportTotal2.count("user_code='#{session[:user_code]}'")
    @case_pages,@case = paginate(:report_total2s,
      :conditions => "user_code='#{session[:user_code]}'",
      :order      => @order,
      :per_page   => @page_lines.to_i
    )
    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")
  end


  # 在办案件统计表
  # 用于统计所有在办案件的以下信息
  # 立案号	通知日期	组庭日期	助理	申请人	代理人（申）	被申请人	代理人（被）	审限日期	延期日期	仲裁庭组成	应收（申）	实收（申）	应收（被）	实收（被）
  def list_0
    @order = params[:order] || "right(ca_cc,7) asc"
    @page_lines = params[:page_lines] || 2000000

    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")

    ActiveRecord::Base.connection.execute(
      "insert into report_total2s (user_code,ca_clerk_name,ca_id,ca_rc,ca_gc,ca_cc,ca_ec,ca_nowdate,ca_clerk)
       select '#{session[:user_code]}',b.name,c.id,c.recevice_code,c.general_code,c.case_code,c.end_code,c.nowdate,c.clerk
       from tb_cases as c, users as b
       where c.clerk=b.code and c.used='Y' and c.state>=4 and c.state<100  and caseendbook_id_first is NULL "
    )

    report_total2 = ReportTotal2.find(:all, :conditions => "user_code='#{session[:user_code]}'")
    for c in report_total2

      #---------------------------- 本请求----------------------------

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = TbShouldRefund.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state=2") || 0
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0

      c.c_rmb_money      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）

      c.c_re_rmb_money   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

      #----------------------------  反请求----------------------------

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0

      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = TbShouldRefund.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state=2") || 0
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0

      c.c_rmb_money_2      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）

      c.c_re_rmb_money_2   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

      c.save
    end

    @count = ReportTotal2.count("user_code='#{session[:user_code]}'")
    @case_pages,@case = paginate(:report_total2s,
      :conditions => "user_code='#{session[:user_code]}'",
      :order      => @order,
      :per_page   => @page_lines.to_i
    )
    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")

  end

  def list_1
    @page_lines=params[:page_lines]
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @d1=Time.now.at_beginning_of_year.to_date
    @d2=Time.now.to_date
    #仲裁员姓名、立案号、结案号、立案时间、组庭时间、开庭时间
    @hant_search_1_page_name="list_1"
    @hant_search_1=[['date','decideDate','结案日期','text',[],@d1],
      ['date','decideDate ','结案日期','text',[],@d2],
      ['date','orgdate','组庭时间','text',[],@d1],
      ['date','orgdate ','组庭时间','text',[],@d2],
      ['date','sittingdate','开庭时间','text',[],@d1],
      ['date','sittingdate ','开庭时间','text',[],@d2],
      ['char','name','仲裁员姓名','text',[]],
      ['char','case_code','立案号','text',[]],
      ['char','arbitBookNum','结案号','text',[]]
    ]
    @hant_search_1_list=["case_code","name"]
    @order = params[:order]
    if @order==nil or @order==""
      @order = "decideDate"
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    c="1=1 "
    if hant_search_1_word == nil or hant_search_1_word ==""
      #      c = " decideDate>='#{@d1}' and decideDate<='#{@d2}'"
    else
      @search_condit= " and " + hant_search_1_word
    end
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    sql="select distinct recevice_code,arbitman from v_arbit_fees where #{c} order by #{@order}"
    @casearbitman_pages,@casearbitman =paginate_by_sql(VArbitFee,sql,@page_lines.to_i)
    @n_l=VArbitFee.find_by_sql("select distinct recevice_code,arbitman from v_arbit_fees where #{c}")
    #    @casearbitman_pages,@casearbitman =paginate(:v_arbit_fees,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end

  # 案件综合信息查询
  # 用于统计某一个时间段内 立案案件的 以下信息：
  #                本请求：   明确争议金额、不明确争议金额、无明确争议金额、应收、减交、实收、欠缴
  #                反请求：   明确争议金额、不明确争议金额、无明确争议金额、应收、减交、实收、欠缴
  # 以上各项的合计：
  # 此外显示每一个案件的如下信息：
  # 通知日期、总案号、立案号、经办人、案由、申请人、被申请人、仲裁员、结案号、结案时间、结案方式、
  # 合同类型、申请人行业、被申请人行业、申请人地区、被申请人地区、申请人代理人、申请人代理人律所、
  # 被申请人代理人、被申请人代理人律所、选定的仲裁机构、适用规则项目、依据仲裁协议类型、仲裁程序、
  # 仲裁语言、主体类型、和解特别程序、总会案件分类、案件类型大分类、案件类型小分类、争议类型、仲裁协议备注、
  # 仲裁条款达成日期、仲裁协议类型、仲裁条款起草方
  def list_2
    @order = params[:order] || "right(ca_cc,7) asc"
    @d1 = params[:d1] || Time.now.at_beginning_of_year.to_date
    @d2 = params[:d2] || Time.now.to_date

    p = PubTool.new()
    return if !p.sql_check_3(@d1) or !p.sql_check_3(@d2)

    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")

    ActiveRecord::Base.connection.execute(
      "insert into report_total2s (user_code,ca_clerk_name,ca_id,ca_rc,ca_gc,ca_cc,ca_ec,ca_nowdate,ca_clerk)
       select '#{session[:user_code]}',b.name,c.id,c.recevice_code,c.general_code,c.case_code,c.end_code,c.nowdate,c.clerk
       from tb_cases as c, users as b
       where c.clerk=b.code and c.used='Y' and c.state>=4 and c.nowdate>='#{@d1}' and c.nowdate<='#{@d2}'"
    )

    report_total2 = ReportTotal2.find(:all, :conditions => "user_code='#{session[:user_code]}'")
    for c in report_total2
      endbook = TbCaseendbook.find(:first, :conditions => ["used='Y' and recevice_code=?", c.ca_rc], :order => "id desc")
      if endbook != nil
        c.ca_en = endbook.arbitBookNum #结案号
        c.ca_ed = endbook.decideDate   #结案时间
        c.ca_es = endbook.endStyle     #结案方式
      end

      #---------------------------- 本请求----------------------------

      #本请求，明确争议金额收费总额
      c.je1 = Cost.new.get_sum(c.ca_rc, "1", "0001")

      #是否存在外币明确争议金额（本请求） Y:存在     N:不存在
      c.je1_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '1', '0001') ? "Y" : "N"

      #本请求，不明确争议金额收费总额
      c.je2 = Cost.new.get_sum(c.ca_rc, "1", "0002")

      #是否存在外币不明确争议金额（本请求） Y:存在     N:不存在
      c.je2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '1', '0002') ? "Y" : "N"

      # 无明确争议金额应收费之和
      tb_should_charge = TbShouldCharge.sum("rmb_money",
        :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'"
      ) || 0

      # 无明确争议金额应退费之和
      tb_should_refund = TbShouldRefund.sum("rmb_money",
        :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}' and state<>3"
      ) || 0

      #无明确争议金额收费总额（本请求） =  应收费之和 - 应退费之和
      c.je3 = tb_should_charge - tb_should_refund

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 减交
      c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = TbShouldRefund.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state=2") || 0
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0

      c.c_rmb_money      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）
      c.c_redu_rmb_money = c3             # （本请求）减交费用
      c.c_re_rmb_money   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

      # （本请求）欠缴费用 = 应收 - 实收 - 减交
      c.c_c = c.c_rmb_money - c.c_re_rmb_money - c.c_redu_rmb_money

      c.c_c_out = c.c_c < 0 ? 'Y' : 'N' # 是否多收了费用  Y:是，N:否
      c.c_c = 0 if c.c_c < 0

      #----------------------------  反请求----------------------------

      #反请求，明确争议金额收费总额
      c.je1_2 = Cost.new.get_sum(c.ca_rc,"2","0001")

      #是否存在非人民币明确争议金额（反请求） Y:存在     N:不存在
      c.je1_2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '2', '0001') ? 'Y' : 'N'

      #反请求，不明确争议金额收费总额
      c.je2_2 = Cost.new.get_sum(c.ca_rc, "2", "0002")

      #是否存在非人民币不明确争议金额（反请求） Y:存在     N:不存在
      c.je2_2_f = TbCaseAmountDetail.has_amount_fc(c.ca_rc, '2', '0002') ? "Y" : "N"

      # 无明确争议金额应收费之和
      tb_should_charge = TbShouldCharge.sum("rmb_money",
        :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'"
      ) || 0

      # 无明确争议金额应退费之和
      tb_should_refund = TbShouldRefund.sum("rmb_money",
        :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}' and state<>3"
      ) || 0

      #无明确争议金额收费总额（本请求） =  应收费之和 - 应退费之和
      c.je3_2 = tb_should_charge - tb_should_refund

      # 应交
      c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 实交
      c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 减交
      c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'") || 0
      # 应退
      c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3") || 0
      # 实退
      c5 = TbShouldRefund.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state=2") || 0
      # 减退
      c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3") || 0

      c.c_rmb_money_2      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）
      c.c_redu_rmb_money_2 = c3             # （本请求）减交费用
      c.c_re_rmb_money_2   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

      # （本请求）欠缴费用 = 应收 - 实收 - 减交
      c.c_c_2 = c.c_rmb_money_2 - c.c_redu_rmb_money_2 - c.c_re_rmb_money_2

      c.c_c_2_out = c.c_c_2 < 0 ? 'Y' : 'N' # 是否多收了费用  Y:是，N:否
      c.c_c_2 = 0 if c.c_c_2 < 0

      c.save
    end

    @count = ReportTotal2.count("user_code='#{session[:user_code]}'")
    @case = ReportTotal2.find(
      :all,
      :conditions => "user_code='#{session[:user_code]}'",
      :order      => @order
    )

    @agent = TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y' and used='Y' ").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @app_rules = TbDictionary.find(:all,:conditions=>"typ_code='8143' and state='Y' and used='Y' ").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @aribitprotprog_num = TbDictionary.find(:all,:conditions=>"typ_code='0003' and state='Y' and used='Y' ").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @aribitprog_num = TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @language = TbDictionary.find(:all,:conditions=>"typ_code='0044' and state='Y' and used='Y' ").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @case_type1 = TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @t_casetype_num = TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @casetype_num = TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @casetype_num2 = TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @aribittype = TbDictionary.find(:all,:conditions=>"typ_code='0006' and state='Y' and used='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @ca_es = TbDictionary.find(:all,:conditions=>"typ_code='8117' and used='Y' and state='Y'").inject({}){|f,e| f[e.data_val]=e.data_text;f}
    @region = Region.find(:all,:select=>"code,name").inject({}){|f,e| f[e.code]=e.name;f}
    ReportTotal2.delete_all("user_code='#{session[:user_code]}'")
  end

end
