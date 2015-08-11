# get_tax函数算个人所得税，当个人所得税算法发生变化的时候要修改改函数。
# To change this template, choose Tools | Templates
# and open the template in the editor.


class Tax
  def initialize

  end

  #劳务所得税
  def get_tax(a)
    #参数a为应发金额
#    税款计算
#    酬金小于800不扣税；
#    酬金大于或等于800和小于等于4000的计算式：(酬金-800)*0.2
#
#    酬金大于4000以上的，先计算 应纳税所得额，即：应纳税所得额=酬金×（1-20%）
#    然后按照所得额计算税款,方法如下：
#    所得额在20000元以下：应纳税额=应纳所得税额×20%；
#    所得额在20000～50000元的：应纳税额=应纳税所得额×30%-2000；
#    所得额在50000元以上的：应纳税额=应纳税所得额×40%-7000。
    r=0
    if a<800
      r=0
    elsif a>=800 and a<=4000
      r=(a-800) * 0.2
    else
      c=a * 0.8
      if c<20000
        r=c * 0.2
      elsif c>20000 and c<50000
        r=c * 0.3 - 2000
      else
        r= c * 0.4 - 7000
      end
    end
    return r
  end

  # 应纳税款（新仲裁员报酬）
  # 按照新的计算方法，如果是本单位人员（仲裁员、助理、校核人员、员工），不需要计算个人所得税、营业税、营业附加税
  # 个人所得税：3.3%；  营业税：5%；  营业税附加：10%  （这里10%的营业附加税为营业税的10%）
  # 参数a：应发金额  typ：是否本单位人员（'Y':是；'N':否）
  def get_tax_1(a,typ)
    re = 0
    if typ == 'N'
      taxtype = TbDictionary.find(:all,:conditions=>"typ_code='9027' and used='Y' and state='Y' ")
       for t in taxtype
         re += SysArg.round2f(a.to_i * t.data_val.to_f).to_f
       end
    end
    return re
  end

  #劳务应纳税所得额
  def get_tax_base(a)
    #参数a为应发金额
#    劳务应纳税所得额计算
#    酬金小于800，应纳税所得额=0；
#    酬金大于或等于800和小于等于4000的计算式：应纳税所得额=(酬金-800)
#
#    酬金大于4000以上的，先计算 应纳税所得额，即：应纳税所得额=酬金×（1-20%）
    r=0
    if a<800
      r=0
    elsif a>=800 and a<=4000
      r=(a-800)
    else
      r=a * 0.8
    end
    return r
  end

  #应纳税所得额 （新仲裁员费用计算新仲裁员费用计算时2013年09月之前）
  def get_tax_base_1(a)
    #参数a为应发金额
    return a
  end

  #应纳税所得额 （新仲裁员费用计算时2013年09月之后）
  def get_tax_base_2(a)
    #参数a为应发金额
    a=a / 1.03
    return SysArg.round_2(a)
  end

  def get_hand_fee(aribitprog_num,a)
    #参数aribitprog_num为仲裁类型(0001:国内普通，0002:国内简易，0003:涉外普通，0004:涉外简易，0005:金融案件),参数a为应发金额
    #《仲裁员和助理办案报酬、稿酬信息表》的仲裁员仲裁费配置。
    #缺省设置为5万元以内800元，
    #每增加1万元增加100元；
    r=0

      if a<=50000
        r=800
      else
        b=(a - 50000) / 10000
        r=800 +  (100 * b).round
      end

    return r
  end


  def get_page_fee(a)
    #参数a为页数
    #《仲裁员和助理办案报酬、稿酬信息表》的阅卷费配置。缺省设置为100页以内800元，
    #每增加100页增加150元，不足100页，按每页1.5元计算。
    r=0
    if a<=100
      r=800
    else
      r=800 + 1.5 * (a - 100)
    end
    return r.round
  end

end
