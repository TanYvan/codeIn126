class TbCaseAmountDetail < ActiveRecord::Base

  # 本请求（或者反请求）是否存在外币明确(或者不明确)争议金额
  #
  # 参数：
  # partytype:   1-本请求     2-反请求 ； amount_type: 0001-明确争议金额   0002-不明确争议金额
  #
  # 返回值 true:存在；     false:不存在
  def self.has_amount_fc(rc,partytype,amount_typ)
    TbCaseAmountDetail.count(:all,
        :conditions => "used='Y' and recevice_code='#{rc}'
                        and partytype='#{partytype}' and amount_typ='#{amount_typ}'
                        and currency<>'0001' and f_money<>0"
    ) > 0
  end
end
