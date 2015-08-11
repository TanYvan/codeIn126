# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class Cost
  def initialize
    
  end
  #国内案件受理费
  def get_01_01(ccc)
    if ccc<0
      rrr=0
    elsif ccc>=0 && ccc<1000
      rrr=100
    elsif ccc>=1000 && ccc<50000
      rrr=100+(ccc-1000)*0.05

    elsif ccc>=50000 && ccc<100000
      rrr=2550+(ccc-50000)*0.04

    elsif ccc>=100000 && ccc<200000
      rrr=4550+(ccc-100000)*0.03

    elsif ccc>=200000 && ccc<500000
      rrr=7550+(ccc-200000)*0.02

    elsif ccc>=500000 && ccc<1000000
      rrr=13550+(ccc-500000)*0.01

    elsif ccc>=1000000
      rrr=18550+(ccc-1000000)*0.005
    end  
    
    return PubTool.new.round_0(rrr)
  end
  #国内案件处理费
  def get_01_02(ccc)
    if ccc<0
      rrr=0
    elsif ccc>=0 && ccc<50000
      rrr=1250
    elsif ccc>=50000 && ccc<200000
      rrr=1250+(ccc-50000)*0.025
    elsif ccc>=200000 && ccc<500000
      rrr=5000+(ccc-200000)*0.02
    elsif ccc>=500000 && ccc<1000000
      rrr=11000+(ccc-500000)*0.015
    elsif ccc>=1000000 && ccc<3000000
      rrr=18500+(ccc-1000000)*0.005
    elsif ccc>=3000000 && ccc<6000000
      rrr=28500+(ccc-3000000)*0.0045
    elsif ccc>=6000000 && ccc<10000000
      rrr=42000+(ccc-6000000)*0.004
    elsif ccc>=10000000 && ccc<20000000
      rrr=58000+(ccc-10000000)*0.003
    elsif ccc>=20000000 && ccc<40000000
      rrr=88000+(ccc-20000000)*0.002
    elsif ccc>=40000000
      rrr=128000+(ccc-40000000)*0.0015
    end
    return PubTool.new.round_0(rrr)
  end
  #涉外案件立案费
  def get_02_01(ccc)
    rrr=10000
    return PubTool.new.round_0(rrr)
  end
  #涉外案件仲裁费
  def get_02_02(ccc)
    if ccc<0
      rrr=0
    elsif  ccc>=0 && ccc<1000000
      rrr=ccc*0.035
      if rrr<10000
        rrr=10000
      end
    elsif ccc>=1000000 && ccc<5000000
      rrr=(ccc-1000000)*0.025+35000
    elsif ccc>=5000000 && ccc<10000000
      rrr=(ccc-5000000)*0.015+135000
    elsif ccc>=10000000 && ccc<50000000
      rrr=(ccc-10000000)*0.01+210000
    elsif ccc>=50000000
      rrr=(ccc-50000000)*0.005+610000
    end
    return PubTool.new.round_0(rrr)
  end
  #金融案件立案费
  def get_03_01(ccc)
    rrr=10000
    return PubTool.new.round_0(rrr)
  end
  #金融案件仲裁费
  def get_03_02(ccc)
    if ccc<0
      rrr=0
    elsif ccc>=0 && ccc<1000000
      rrr=ccc*0.01
      if rrr<5000
        rrr=5000
      end
    elsif ccc>=1000000 && ccc<5000000
      rrr=(ccc-1000000)*0.008+10000
    elsif ccc>=5000000 && ccc<50000000
      rrr=(ccc-5000000)*0.006+42000
    elsif ccc>=50000000
      rrr=(ccc-50000000)*0.005+312000
    end
    return PubTool.new.round_0(rrr)
  end
  
  
  #申请人、被申请人的明确争议金额、不明确争议金额以及未明确争议金额收费总额计算
  def get_sum(recevice_code,pt,at)
    if pt == "0" and at == "0000"
      @accounts = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y'",recevice_code],:order=>'id')
    elsif pt != "0" and at != "0000"
      @accounts = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and partytype=? and amount_typ=?",recevice_code,pt,at],:order=>'id')
    elsif pt != "0" and at == "0000"
      @accounts = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and partytype=?",recevice_code,pt],:order=>'id')
    elsif pt == "0" and at != "0000"
      @accounts = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ=?",recevice_code,at],:order=>'id')
    end
    @sum=0
    for account in @accounts
      if account.typ=="0003"
        @sum = @sum - account.rmb_money
      else
        @sum = @sum + account.rmb_money
      end
    end
    return @sum
  end
  
  
  def get_fee(typ1,typ2,recevice_code)
    registration_fee=0 #受理费、立案费
    arbitration_fee=0 #仲裁费、处理费
    #申请人明确争议金额
    @applicant_definites = get_sum(recevice_code,"1","0001")
    #被申请人明确争议金额
    @respondent_definites = get_sum(recevice_code,"2","0001")
    #申请人不明确争议金额
    @applicant_undefinites = get_sum(recevice_code,"1","0002")
    #被申请人不明确争议金额
    @respondent_undefinites = get_sum(recevice_code,"2","0002")
    #申请人费用汇总
    applicant_all = @applicant_definites+@applicant_undefinites
    #被申请人费用汇总
    respondent_all = @respondent_definites+@respondent_undefinites
    @case = TbCase.find_by_recevice_code(recevice_code)
    #金融案件仲裁费/立案费
    if @case!=nil
      if @case.aribitprog_num == "0005" or @case.aribitprog_num == "0006"  or @case.aribitprog_num == "0007" or @case.aribitprog_num == "0008" 
        if typ1=='1'
          if applicant_all != 0
            arbitration_fee = Cost.new.get_03_02(applicant_all)   #仲裁费
            registration_fee = Cost.new.get_03_01(applicant_all)  #立案费
          else
            arbitration_fee = 0
            registration_fee = 0
          end
        else
          if respondent_all != 0
            arbitration_fee = Cost.new.get_03_02(respondent_all)
            registration_fee = Cost.new.get_03_01(respondent_all)
          else
            arbitration_fee = 0
            registration_fee = 0
          end
        end
        #涉外案件仲裁费/立案费

      elsif @case.aribitprog_num == "0003" or @case.aribitprog_num == "0004"
        if typ1=='1'
          if applicant_all != 0
            arbitration_fee = Cost.new.get_02_02(applicant_all)   #仲裁费
            registration_fee = Cost.new.get_02_01(applicant_all)  #立案费
          else
            arbitration_fee = 0
            registration_fee = 0
          end
        else
          if respondent_all != 0
            arbitration_fee = Cost.new.get_02_02(respondent_all)
            registration_fee = 0 # Cost.new.get_02_01(respondent_all)
          else
            arbitration_fee = 0
            registration_fee = 0
          end
        end 
        #国内案件受理费/处理费计算
      elsif @case.aribitprog_num == "0001" or @case.aribitprog_num == "0002"

        if typ1=='1'
          #puts applicant_all 
          if applicant_all != 0
            registration_fee = Cost.new.get_01_01(applicant_all)
            arbitration_fee = Cost.new.get_01_02(applicant_all)
          else
            registration_fee = 0
            arbitration_fee = 0
          end
        else
          if respondent_all != 0
            registration_fee = Cost.new.get_01_01(respondent_all)
            arbitration_fee = Cost.new.get_01_02(respondent_all)
          else
            registration_fee = 0
            arbitration_fee = 0
          end
        end
      end
      #typ1==1 是申请人   typ==2 是被申请人
      #typ2==1 是立案费、受理费   typ==2 是仲裁费、处理费
      if typ2==1
        return registration_fee.round
      else
        return arbitration_fee.round
      end
    end
  end
end
