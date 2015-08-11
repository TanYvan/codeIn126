# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class ChargeUp
  def up(recevice_code)
    
    c1=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'")
    c2=TbShouldCharge.sum("re_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'")
    c3=TbShouldCharge.sum("redu_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'")
    if c1==nil 
      c1=0
    end
    if c2==nil 
      c2=0
    end
    if c3==nil 
      c3=0
    end
    
    c4=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    c5=TbShouldRefund.sum("redu_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    c6=TbShouldRefund.sum("re_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    if c4==nil 
      c4=0
    end
    if c5==nil 
      c5=0
    end
    if c6==nil 
      c6=0
    end
    
    #申请人应收
    c_a=c1 - (c4 - c5)
    #申请人实收
    c_b=c2 - c6
    #申请人欠缴
    c_c=c_a - c_b - c3
    #########################################################
    c11=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}'")
    c22=TbShouldCharge.sum("re_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004')  and used='Y' and recevice_code='#{recevice_code}'")
    c33=TbShouldCharge.sum("redu_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004')  and used='Y' and recevice_code='#{recevice_code}'")
    if c11==nil 
      c11=0
    end
    if c22==nil 
      c22=0
    end
    if c33==nil 
      c33=0
    end
    
    c44=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    c55=TbShouldRefund.sum("redu_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    c66=TbShouldRefund.sum("re_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{recevice_code}' and state<>3")
    if c44==nil 
      c44=0
    end
    if c55==nil 
      c55=0
    end
    if c66==nil 
      c66=0
    end
    
    #申请人应收
    c_aa=c11 - (c44 - c55)
    #申请人实收
    c_bb=c22 - c66
    #申请人欠缴
    c_cc=c_aa - c_bb - c33
    
    @case_up=TbCase.find_by_recevice_code(recevice_code)
    @case_up.m_rmb_money=c_a
    @case_up.m_re_rmb_money=c_b
    @case_up.m_lack_rmb_money=c_c
    @case_up.m_rmb_money_2=c_aa
    @case_up.m_re_rmb_money_2=c_bb
    @case_up.m_lack_rmb_money_2=c_cc
    @case_up.save
#    puts @case.m_rmb_money
#    @case=TbCase.find_by_recevice_code(recevice_code)
#    puts @case.m_rmb_money
#    puts @case.id
  end
    
end
