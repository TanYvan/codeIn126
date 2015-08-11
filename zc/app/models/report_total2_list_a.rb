require "iconv"
class ReportTotal2ListA < ActiveRecord::Base
  set_table_name "report_total2_list_a"

  #调用ReportTotal2ListA.report_list_a(self.recevice_code)
  #TbCase.find_all.each{|c| ReportTotal2ListA.report_list_a(c.recevice_code)}
  def self.report_list_a(recevice_code)
    @report = ReportTotal2ListA.find_by_recevice_code(recevice_code)
    @report = ReportTotal2ListA.new() unless @report
    @report.recevice_code = recevice_code
    #本请求，明确争议金额收费总额
    @report.je1_0001 = Cost.new.get_sum(recevice_code, "1", "0001")
    #是否存在外币明确争议金额（本请求） Y:存在     N:不存在
    if TbCaseAmountDetail.has_amount_fc(recevice_code, '1', '0001')
      @report.je1_f_0001 = 1
    else
      @report.je1_f_0001 = 0
    end
    #本请求，不明确争议金额收费总额
    @report.je2_0001 = Cost.new.get_sum(recevice_code, "1", "0002")
    #是否存在外币不明确争议金额（本请求） Y:存在     N:不存在
    if  TbCaseAmountDetail.has_amount_fc(recevice_code, '1', '0002')
      @report.je2_f_0001 = 1
    else
      @report.je2_f_0001 = 0
    end
      # 无明确争议金额应收费之和
    tb_should_charge = TbShouldCharge.sum("rmb_money",
      :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{recevice_code}'"
    ) || 0

    # 无明确争议金额应退费之和
    tb_should_refund = TbShouldRefund.sum("rmb_money",
      :conditions => "payment='0001' and typ='0004' and used='Y' and recevice_code='#{recevice_code}' and state<>3"
    ) || 0

    #无明确争议金额收费总额（本请求） =  应收费之和 - 应退费之和
    @report.je3_0001 = tb_should_charge - tb_should_refund
    # 应交
    c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 实交
    c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 减交
    c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 应退
    c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3") || 0
    # 实退
    c5 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'  and (state=2 or state = 4)") || 0).to_f
    # 减退
    c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'  and state<>3") || 0
    c1=0 if c1 == nil
    c2=0 if c2 == nil
    c3=0 if c3 == nil
    c4=0 if c4 == nil
    c5=0 if c5 == nil
    c6=0 if c6 == nil

    @report.c_rmb_money_0001      = c1 - (c4 - c6) # （本请求）应收费    = 应交 -（应退 - 减退）
    @report.c_redu_rmb_money_0001 = c3             # （本请求）减交费用
    @report.c_re_rmb_money_0001   = c2 - c5        # （本请求）实收费用 = 实交 - 实退

    # （本请求）欠缴费用 = 应收 - 实收 - 减交
    @report.c_c_0001 = @report.c_rmb_money_0001 - @report.c_re_rmb_money_0001 - @report.c_redu_rmb_money_0001

     # 是否多收了费用  Y:是，N:否
    if @report.c_c_0001 < 0
      @report.c_c_out_0001 = 1
    else
      @report.c_c_out_0001 = 0
    end

    @report.c_c_0001 = 0 if @report.c_c_0001 < 0

    #c.c_sf = c.c_rmb_money - (c4 - c6 ) # 本请求（最终收款）
    #本请求的 if (案件收费（争议金额或无明确争议金额）的应退项>0 and (案件收费（争议金额或无明确争议金额）的应退项－减退－实退>0) then 最终收款＝实交－应退 else 最终收款＝应收
    if (c4 > 0 && ( c4- c6 - c5)>0)
      @report.c_sf_0001 = c2 - c4
    else
      @report.c_sf_0001 = @report.c_re_rmb_money_0001
    end


    #反请求，明确争议金额收费总额
    @report.je1_0002 = Cost.new.get_sum(recevice_code,"2","0001")

    #是否存在非人民币明确争议金额（反请求） Y:存在     N:不存在
    if TbCaseAmountDetail.has_amount_fc(recevice_code, '2', '0001')
      @report.je1_f_0002 = 1
    else
      @report.je1_f_0002 = 0
    end

    #反请求，不明确争议金额收费总额
    @report.je2_0002 = Cost.new.get_sum(recevice_code, "2", "0002")

    #是否存在非人民币不明确争议金额（反请求） Y:存在     N:不存在
    if TbCaseAmountDetail.has_amount_fc(recevice_code, '2', '0002')
      @report.je2_f_0002 = 1
    else
      @report.je2_f_0002 = 0
    end

    # 无明确争议金额应收费之和
    tb_should_charge = TbShouldCharge.sum("rmb_money",
      :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{recevice_code}'"
    ) || 0

    # 无明确争议金额应退费之和
    tb_should_refund = TbShouldRefund.sum("rmb_money",
      :conditions => "payment='0002' and typ='0004' and used='Y' and recevice_code='#{recevice_code}' and state<>3"
    ) || 0

    #无明确争议金额收费总额（反请求） =  应收费之和 - 应退费之和
    @report.je3_0002 = tb_should_charge - tb_should_refund

    # 应交
    c1 = TbShouldCharge.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 实交
    c2 = TbShouldCharge.sum("re_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 减交
    c3 = TbShouldCharge.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'") || 0
    # 应退
    c4 = TbShouldRefund.sum("rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3") || 0
    # 实退
    c5 = (TbShouldRefund.sum("rmb_money - redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'  and (state=2 or state=4)") || 0).to_f
    # 减退
    c6 = TbShouldRefund.sum("redu_rmb_money", :conditions => "payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'  and state<>3") || 0
    c1=0 if c1 == nil
    c2=0 if c2 == nil
    c3=0 if c3 == nil
    c4=0 if c4 == nil
    c5=0 if c5 == nil
    c6=0 if c6 == nil

    @report.c_rmb_money_0002      = c1 - (c4 - c6) # （反请求）应收费    = 应交 -（应退 - 减退）
    @report.c_redu_rmb_money_0002 = c3             # （反请求）减交费用
    @report.c_re_rmb_money_0002   = c2 - c5        # （反请求）实收费用  = 实交 - 实退

    # （反请求）欠缴费用 = 应收 - 实收 - 减交
    @report.c_c_0002 = @report.c_rmb_money_0002 - @report.c_redu_rmb_money_0002 - @report.c_re_rmb_money_0002

    # 是否多收了费用  Y:是，N:否
    if @report.c_c_0002 < 0
      @report.c_c_out_0002 = 1
    else
      @report.c_c_out_0002 = 0
    end

    @report.c_c_0002 = 0 if @report.c_c_0002 < 0

    #c.c_sf_2 = c.c_rmb_money_2 - (c4 -c6) # 反请求（最终收款）
    #反请求的 if (案件收费（争议金额或无明确争议金额）的应退项>0 and (案件收费（争议金额或无明确争议金额）的应退项－减退－实退>0) then 最终收款＝实交－应退 else 最终收款＝应收
    if (c4 > 0 && ( c4- c6 - c5)>0)
      @report.c_sf_0002 = c2 - c4
    else
      @report.c_sf_0002 = @report.c_re_rmb_money_0002
    end

#    @report.casereason = TbCase.find_by_recevice_code(recevice_code).casereason
#    @report.casereason=Iconv.iconv("gbk","utf-8",@report.casereason)
#    @report.party_0001 = ""
#    @report.party_0002 = ""
#    TbParty.find(:all,:conditions=>"used='Y' and partytype=1 and recevice_code='#{recevice_code}'",:order=>"id").each{|tp|
#      @report.party_0001 = @report.party_0001  + "【"+ tp.partyname + "】"
#    }
#    @report.party_0001=Iconv.iconv("gbk","utf-8",@report.party_0001)
#    TbParty.find(:all,:conditions=>"used='Y' and partytype=2 and recevice_code='#{recevice_code}'",:order=>"id").each{|tp|
#      @report.party_0002 = @report.party_0002  + "【"+ tp.partyname + "】"
#    }
#    @report.party_0002=Iconv.iconv("gbk","utf-8",@report.party_0002)
#    @report.arbitman=""
#    @arbitmantype={"0001"=>"独","0002"=>"首","0003"=>"申","0004"=>"被"}
#    @arbit=TbCasearbitman.find_by_sql(["select tb_casearbitmen.arbitmantype as arbitmantype,tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmansign from tb_casearbitmen,tb_arbitmen,tb_dictionaries where tb_dictionaries.typ_code='0015' and tb_casearbitmen.recevice_code=?  and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.arbitmansign=tb_dictionaries.data_val and tb_casearbitmen.used='Y' order by tb_casearbitmen.arbitmantype",recevice_code])
#    if @arbit.empty?
#      @report.arbitman = "未组成"
#    else
#      for arb in @arbit
#        @report.arbitman = @report.arbitman  + @arbitmantype[arb.arbitmantype] + ":" + arb.name+ "(" + arb.arbitmansign + ")<br/>"
#      end
#    end

    @report.save
  end
end
  

