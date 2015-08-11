class SysArg < ActiveRecord::Base

  def before_create
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end

  def before_save
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end

  def before_update
    suppress(ActiveRecord::StatementInvalid) do
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end

  #计算从上次运行提醒服务到现在的秒数，并返回。登录页面使用。
  def self.remind_runtime_from_now
    find(:first,
      :select => "unix_timestamp(now())-unix_timestamp(val) as n",
      :conditions => "code='2001'"
    ).n.to_i
  end

  #获取默认每页显示记录的条数
  def self.lines_per_page
    record = find_by_code('9003')
    (record.nil?) ? 20 : record.val
  end

  def self.n_to_c(v)
    @nc={"0"=>"○","1"=>"一","2"=>"二","3"=>"三","4"=>"四","5"=>"五","6"=>"六","7"=>"七","8"=>"八","9"=>"九",}
    v=v.to_s
    rrr=""
    h=v.size
    hh=0
    while (hh<h)
      rrr=rrr+@nc[v.slice(hh,1)]
      hh=hh + 1
    end
    return rrr
  end
  #将阿拉伯数字转换成汉字
  def self.n_to_md(v)
    @nc={"1"=>"一","2"=>"二","3"=>"三","4"=>"四","5"=>"五","6"=>"六","7"=>"七","8"=>"八","9"=>"九","10"=>"十",
      "11"=>"十一","12"=>"十二","13"=>"十三","14"=>"十四","15"=>"十五","16"=>"十六","17"=>"十七","18"=>"十八","19"=>"十九","20"=>"二十",
      "21"=>"二十一","22"=>"二十二","23"=>"二十三","24"=>"二十四","25"=>"二十五","26"=>"二十六","27"=>"二十七","28"=>"二十八","29"=>"二十九","30"=>"三十","31"=>"三十一"}
    v=v.to_s
    rrr=@nc[v]
    return rrr
  end
  def self.round_0(v)
    rrr=v
    return rrr.round
  end
  def self.round_2(v)
    rrr=(v * 100).round
    rrr=rrr / 100
    return v
  end
  def self.round_3(v)
    rrr=(v * 1000).round
    rrr=rrr / 1000
    return rrr
  end
  #金额数字分割################### 如果为0则返回下划线

  def self.compart1(v)
    v1=round_2(v)
    str1=v1.to_s
    arr=str1.split(".")
    if arr[0]!=nil and arr[0]!=""
      @arr1=commify1(arr[0].to_i).to_s
    else
    end

    if arr[1]!=nil and arr[1]!=""
      @arr2=arr[1]
    else
    end

    if @arr1!=nil and @arr2!=nil
      if @arr2=='00' or @arr2=='0'
        rr=@arr1
        if rr=='0'
          rr="_____"
        end
      elsif @arr2!='00' or @arr2!='0' #  if arr[1].slice(arr[1].length-1)=='0'
        if @arr2.length>=2
          rr=@arr1+'.'+@arr2
        else
          rr=@arr1+'.'+@arr2 + '0'
        end
      end
    elsif @arr1!=nil and @arr2==nil
      rr=@arr1
      rr=@arr1
      if rr=='0'
        rr="_____"
      end
    else
      rr="_____"
    end
    return rr
  end
  def self.commify1(money1)
    #    return price.to_s.gsub(/(￥d)(?=￥d{3}+$)/, '￥￥1,') #(日本使用方法)
    return money1.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,') #(中国区使用方法)
  end
  #界面中分割 后 如果是0的返回为空
  def self.compart2(v)
    #    v1=round_2(v)
    str1=v.to_s
    arr=str1.split(".")
    @arr1=commify1(arr[0].to_i).to_s
    @arr2=arr[1]

    if @arr1!=nil and @arr2!=nil
      if @arr2=='00' or @arr2=='0'
        rr=@arr1
        if rr=='0'
          rr=""
        end
      elsif @arr2!='00' or @arr2!='0'
        if @arr2.length>=2
          rr=@arr1+'.'+@arr2
        else #小数点后只有1位数时，加 0 保留2位。
          rr=@arr1+'.'+@arr2 + '0'
        end
      end
    elsif @arr1!=nil and @arr2==nil
      rr=@arr1
      rr=@arr1
      if rr=='0'
        rr=""
      end
    else
      rr=""
    end
    return rr
  end
  
  #界面中分割 后 如果是0的返回为0
  def self.compart3(v)
    #    v1=round_2(v)
    str1=v.to_s
    arr=str1.split(".")
    @arr1=commify1(arr[0].to_i).to_s
    @arr2=arr[1]

    if @arr1!=nil and @arr2!=nil
      if @arr2=='00' or @arr2=='0'
        rr=@arr1
      elsif @arr2!='00' or @arr2!='0'
        if @arr2.length>=2
          rr=@arr1+'.'+@arr2
        else #小数点后只有1位数时，加 0 保留2位。
          rr=@arr1+'.'+@arr2 + '0'
        end
      end
    elsif @arr1!=nil and @arr2==nil
      rr=@arr1
    else
      rr=""
    end
    return rr
  end

  #--------------------
  def self.compart8(v)
    v1=v
    str1=v1.to_s
    arr=str1.split(".")
    if arr[0]!=nil and arr[0]!=""
      @arr1=commify1(arr[0].to_i).to_s
    else
    end

    if arr[1]!=nil and arr[1]!=""
      @arr2=arr[1]
    else
    end

    if @arr2!=nil
      rr=@arr1+'.'+@arr2
    elsif @arr2==nil
      rr=@arr1
      if rr=='0'
        rr=""
      end
    end
    return rr
  end
  ################
  def self.get_first_record(obj)
    if obj.empty?
      rrr=nil
    else
      for ob in obj
        rrr=ob
        break;
      end
    end
    return rrr
  end
  def self.get_last_record(obj)
    if obj.empty?
      rrr=nil
    else
      for ob in obj
        rrr=ob
      end
    end
    return rrr
  end

  #咨询流水号
  def self.add_0001
    r=""
    s=self.find(:first,:conditions=>"code='0001'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,s.val.size - 4 )
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"0001"
    else
      if old_c.to_i >= 9999
        r=old_year + (old_c.to_i + 1).to_s
      else
        r=old_year+sprintf("%04d",old_c.to_i+1)
      end
    end
    s.val=r
    s.save
    return r
  end

  #案件号，即立案号
  def self.add_0002
    r=""
    s=self.find(:first,:conditions=>"code='0002'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,s.val.size - 4)
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"001"
    else
      if old_c.to_i >= 999
        r=old_year + (old_c.to_i + 1).to_s
      else
        r=old_year+sprintf("%03d",old_c.to_i+1)
      end
    end
    s.val=r
    s.save
    return r
  end

  #总案号
  def self.add_0003
    r=""
    s=self.find(:first,:conditions=>"code='0003'")
    r=sprintf("%010d",s.val.to_i + 1)
    #r=s.val.to_i + 1
    s.val=r.to_s
    s.save
    return r
  end

  #收款号--出纳
  def self.get_0004
    r=""
    s=self.find(:first,:conditions=>"code='0004'")
    r=s.val.to_i + 1
    return r
  end

  def self.set_0004(v)
    s=self.find(:first,:conditions=>"code='0004'")
    s.val=v
    s.save
  end
  #  def self.add_0004
  #    r=""
  #    s=self.find(:first,:conditions=>"code='0004'")
  #    old_year=s.val.slice(0,4)
  #    old_c=s.val.slice(5,4)
  #    n=Date.today.to_s.slice(0,4)
  #    if n>old_year
  #      r=n+"0001"
  #    else
  #      r=old_year+sprintf("%04d",old_c.to_i+1)
  #    end
  #    s.val=r
  #    s.save
  #    return r
  #  end

  #报酬待发编号
  def self.add_0005
    r=""
    s=self.find(:first,:conditions=>"code='0005'")
    r=sprintf("%08d",s.val.to_i + 1)
    s.val=r
    s.save
    return r
  end

  #报酬发放编号
  def self.add_0006
    r=""
    s=self.find(:first,:conditions=>"code='0006'")
    old_ym=s.val.slice(0,6)
    old_c=s.val.slice(6,3)
    n=Date.today.to_s.slice(0,4)+Date.today.to_s.slice(5,2)
    if n>old_ym
      r=n+"001"
    else
      r=old_ym+sprintf("%03d",old_c.to_i+1)
    end
    s.val=r
    s.save
    return r
  end

  #报酬发放编号
  def self.add_0006_next
    r=""
    s=self.find(:first,:conditions=>"code='0006'")
    old_ym=s.val.slice(0,6)
    old_c=s.val.slice(6,3)
    n=Date.today.to_s.slice(0,4)+Date.today.to_s.slice(5,2)
    if n>old_ym
      r=n+"001"
    else
      r=old_ym+sprintf("%03d",old_c.to_i+1)
    end
    s.val=r
    #s.save
    return r
  end

  #报酬发放编号下降
  def self.reduce_0006
    r=""
    s=self.find_by_code("0006")
    extend_code=TbTExtendCode.find(:first,:conditions=>"used='Y'",:order=>"t_extend_code desc")
    if extend_code
      s.val=extend_code.t_extend_code
      s.save
    end
  end
  
  #文件内部流水号（发文中文件的内部流水号,与文件名称关联）
  def self.add_0007
    r=""
    s=self.find(:first,:conditions=>"code='0007'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,6)
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"000001"
    else
      r=old_year+sprintf("%06d",old_c.to_i+1)
    end
    s.val=r
    s.save
    return r
  end

  #仲裁员编码
  def self.add_0008
    r=""
    s=self.find(:first,:conditions=>"code='0008'")
    r=sprintf("%08d",s.val.to_i + 1)
    s.val=r
    s.save
    return r
  end

  #发文编号（发文中只有向外发的函才有的发文编号）
  def self.add_0009
    r=""
    s=self.find(:first,:conditions=>"code='0009'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,6)
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"000001"
    else
      r=old_year+sprintf("%06d",old_c.to_i+1)
    end
    s.val=r
    s.save
    return r
  end
  #专家编码
  def self.add_0010
    r=""
    s=self.find(:first,:conditions=>"code='0010'")
    r=sprintf("%08d",s.val.to_i + 1)
    s.val=r
    s.save
    return r
  end
  #机构编码
  def self.add_0011
    r=""
    s=self.find(:first,:conditions=>"code='0011'")
    r=sprintf("%08d",s.val.to_i + 1)
    s.val=r
    s.save
    return r
  end
  #结案号（裁决、和裁）
  def self.add_0021
    r=""
    s=self.find(:first,:conditions=>"code='0021'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,s.val.size - 4)
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"001"
    else
      if old_c.to_i >= 999
        r=old_year + (old_c.to_i + 1).to_s
      else
        r=old_year+sprintf("%03d",old_c.to_i+1)
      end
    end
    s.val=r
    s.save
    return r
  end

  #结案号（撤案）
  def self.add_0022
    r=""
    s=self.find(:first,:conditions=>"code='0022'")
    old_year=s.val.slice(0,4)
    old_c=s.val.slice(4,s.val.size - 4)
    n=Date.today.to_s.slice(0,4)
    if n>old_year
      r=n+"001"
    else
      if old_c.to_i >= 999
        r=old_year + (old_c.to_i + 1).to_s
      else
        r=old_year+sprintf("%03d",old_c.to_i+1)
      end
    end
    s.val=r
    s.save
    return r
  end

  #裁决书编号
  def self.add_0031
    r=""
    s=self.find(:first,:conditions=>"code='0031'")
    #r=sprintf("%010d",s.val.to_i + 1)
    r=s.val.to_i + 1
    s.val=r.to_s
    s.save
    return r
  end
  #本、反请求争议金额和，不同币种
  def self.get_fm(code,v)
    @account2 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and typ<>'0003' and partytype=? and currency<>''",code,v],:select=>"currency,sum(f_money) as f_money",:group=>"currency")
    if PubTool.new.get_first_record(@account2)!=nil
      r1=""
      @account2.each do |acc|
        f1=acc.f_money.to_f
        @account21 = TbCaseAmountDetail.sum(:f_money,:conditions=>["recevice_code=? and used='Y' and typ='0003' and partytype=? and currency=?",code,v,acc.currency])
        if @account21!=nil
          f2=@account21.to_f
        else
          f2=0
        end
        f = f1 - f2
        if v==1
          r1 =r1+get_sign(acc.currency) + compart1(f) + "  "
        else
          r1 =r1+get_sign(acc.currency) + compart1(f) + "  "
        end
      end
      if r1!=""
        r1=r1.slice(0,r1.length-2)
      end
    end
    return r1
  end
  #代理人显示，以顿号隔开
  def self.get_agent(code,v)
    @agents = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    @agent1=""
    @agents.each do |agents|
      if agents!=nil
        @agent1=@agent1 + agents.name + "  " + agents.company + "、"
      end
    end
    if @agent1!=""
      @agent1=@agent1.slice(0,@agent1.length-3)
    end
    return @agent1
  end
  def self.applicant(code,v1,v3)
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",code], :order => "id")
    if @applicants == nil
      @applicant1 = ""
    else
      @applicant1 = ""
      i=1
      @last1 = @applicants.length
      @applicants.each do |applicant|
        if @applicants.length>1
          if v1==1
            if i==@last1
              @applicant1=@applicant1+applicant.partyname + "  "
            else
              @applicant1=@applicant1+applicant.partyname+"、"
            end
          elsif v1==2
            @applicant1 =@applicant1+"第"+SysArg.n_to_c(i)+"申请人："+ applicant.partyname + '\r'
          end
        else
          if v3==3
            @applicant1="申请人："+applicant.partyname + "  "
          elsif v3==4
            @applicant1=applicant.partyname + "  "
          end
        end
        i+=1
      end      #  去掉最后的逗号 ,\r
      if @applicant1!=""
        @applicant1=@applicant1.slice(0,@applicant1.length-2)
      end
    end
    return @applicant1
  end
  def self.respondent(code,v1,v3)
    @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",code], :order => "id")
    if @respondents == nil
      @respondent1 = ""
    else
      @respondent1 = ""
      i = 1
      @last3 = @respondents.length
      @respondents.each do |applicant|
        if @respondents.length>1
          if v1==1
            if i==@last3
              @respondent1=@respondent1+applicant.partyname+"  "
            else
              @respondent1=@respondent1+applicant.partyname+"、"
            end
          elsif v1==2
            @respondent1 = @respondent1 +"第"+SysArg.n_to_c(i)+"被申请人："+ applicant.partyname + '\r'
          end
        else
          if v3==3
            @respondent1="被申请人："+applicant.partyname + "  "
          elsif v3==4
            @respondent1=applicant.partyname + "  "
          end
        end
        i+=1
      end    #  去掉最后的逗号 和 换行号
      if @respondent1!=""
        @respondent1=@respondent1.slice(0,@respondent1.length-2)
      end
    end
    return @respondent1
  end
  #获取案件首席仲裁员
  def chief_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0002'",code])
    if @case_arbitman != nil
      @chief_a= TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",@case_arbitman.arbitman])
      if @chief_a != nil
        @c_arbit = @chief_a.name
      else
        @c_arbit = ""
      end
    else
      @c_arbit = ""
    end
    return @c_arbit
  end

  #获取案件申请人仲裁员
  def applicant_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0003'",code])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      applicant_arbitrator = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if applicant_arbitrator != nil
        applicant_arbitrator3 = applicant_arbitrator.name
      else
        applicant_arbitrator3 = ""
      end
    else
      applicant_arbitrator3 = ""
    end
    return applicant_arbitrator3
  end
  #获取案件被申请人仲裁员
  def respondent_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0004'",code])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      @respondent_arbitrator = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if @respondent_arbitrator != nil
        respondent_arbitrator1 = @respondent_arbitrator.name
      else
        respondent_arbitrator1 = ""
      end
    else
      respondent_arbitrator1 = ""
    end
    return respondent_arbitrator1
  end
  #1人仲裁庭变3人仲裁庭，3人变1人；则查明是否有仲裁员
  def get_ar(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code])
    if @case_arbitman != nil
      ar = "有仲裁员" #随意显示的字符串，用于判断
    else
      ar = ""
    end
    return ar
  end
  #获取案件独立仲裁员
  def independent_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0001'",code])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      independent_arbitrator = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if independent_arbitrator != nil
        independent_arbitrator1 = independent_arbitrator.name
      else
        independent_arbitrator1 = ""
      end
    else
      independent_arbitrator1 = ""
    end
    return independent_arbitrator1
  end
  #金额符号
  def self.get_sign(n1)
    if n1=='0001'
      m = "￥"
    elsif n1=='0002'
      m = "USD"
    elsif n1=='0003'
      m = "HKD"
    elsif n1=='0005'
      m = "EUR"
    else
      m = Money.find(:first,:conditions=>["used='Y' and code=?",n1]).name
    end
    return m
  end
  #当事人地区信息分析
  def self.get_pn_by_recevice_code(recevice_code)
    @pr = PartyRegion.find_by_recevice_code(recevice_code)
    unless @pr
      @pr = PartyRegion.new()
      @pr.recevice_code = recevice_code
    end
    @case = TbCase.find_by_recevice_code(recevice_code)
    @pr.state = @case.state
    @pr.nowdate = @case.nowdate
    @pr.agent = @case.agent
    #至少一方为深圳市
    if TbParty.count(["used='Y' and recevice_code=? and area='001001001'",recevice_code]) > 0
      @pr.r1=1
    else
      @pr.r1=0
    end
    #至少一方为广东其他地区（除深圳市以外）
    if TbParty.count(["used='Y' and recevice_code=? and area<>'001001001' and left(area,6)='001001'",recevice_code]) > 0
      @pr.r2=1
    else
      @pr.r2=0
    end
    #至少一方为香港地区
    if TbParty.count(["used='Y' and recevice_code=? and area='002'",recevice_code]) > 0
      @pr.r3=1
    else
      @pr.r3=0
    end
    #双方都是广东以外地区
    if TbParty.count(["used='Y' and recevice_code=? and left(area,6)='001001'",recevice_code]) == 0
      @pr.r4=1
    else
      @pr.r4=0
    end
    #双方都是外国
    if TbParty.count(["used='Y' and recevice_code=? and left(area,3)='001'",recevice_code]) == 0
      @pr.r5=1
    else
      @pr.r5=0
    end
    #一方为外地，另一方为外国
    if (TbParty.count(["used='Y' and recevice_code=? and partytype=1 and left(area,3)='001' and area <> '001001001'",recevice_code]) != 0 && TbParty.count(["used='Y' and recevice_code=? and partytype=2 and left(area,3)<>'001'",recevice_code]) != 0) || (TbParty.count(["used='Y' and recevice_code=? and partytype=2 and left(area,3)='001' and area <> '001001001'",recevice_code]) != 0 && TbParty.count(["used='Y' and recevice_code=? and partytype=1 and left(area,3)<>'001'",recevice_code]) != 0)
      @pr.r6=1
    else
      @pr.r6=0
    end
    @pr.save
  end
  #当事人所在地区数量
  def self.get_pn1(d1,d2,agent)
    @p1 = 0 #至少一方为深圳市
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2,agent])
        @v_list2.each do |v|
          if v!=nil
            if v.tb_parties_area!=nil
              if v.tb_parties_area=='001001001'
                @p1 = @p1 + 1
              end
            end
          end
        end
      end
    end
    return @p1
  end
  def self.get_pn2(d1,d2,agent)
    @p2 = 0 #至少一方为广东其他地区（除深圳市以外）
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = TbCase.find_by_sql("select p.area as tb_parties_area from tb_cases as c,tb_parties as p where c.recevice_code='#{vv.tb_cases_recevice_code}' and c.nowdate>='#{d1}' and c.nowdate<='#{d2}' and c.agent='#{agent}' and c.recevice_code=p.recevice_code and p.area<>''")
        @v_list2.each do |v|
          if v!=nil
            if v.tb_parties_area!=nil
              if v.tb_parties_area!='001001001' and v.tb_parties_area.slice(0,6)=="001001"
                @p2 = @p2 + 1
              end
            end
          end
        end

      end
    end
    return @p2
  end
  def self.get_pn3(d1,d2,agent)
    @p3 = 0 #至少一方为香港地区
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = VCaseQuery1List1.find(:first,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>'' and tb_parties_area='002'",vv.tb_cases_recevice_code,d1,d2,agent])
        if @v_list2!=nil
          @p3 = @p3 + 1
        end
      end
    end
    return @p3
  end
  def self.get_pn4(d1,d2,agent)
    @p4 = 0 #双方都是广东以外地区
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      #      if vv!=nil
      pa1=0
      #        pa2=0
      p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2,agent])
      #        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_partytype=2",vv.tb_cases_recevice_code,d1,d2,agent])
      #        p_12=p1.length+p2.length
      #申请人 被申请人
      p1.each do |p_1|
        if p_1!=nil
          if p_1.tb_parties_area!=nil
            if p_1.tb_parties_area.slice(0,6)!="001001"
              pa1=pa1+1
            end
          end
        end
      end
      #被申请人
      #        p2.each do |p_2|
      #          if p_2!=nil
      #            if p_2.tb_parties_area!=nil
      #              if p_2.tb_parties_area.slice(0,6)!="001001"
      #                pa2=pa2+1
      #              end
      #            end
      #          end
      #        end
      if pa1==p1.length
        @p4=@p4+1
      end
      #      end
    end
    return @p4
  end
  def self.get_pn5(d1,d2,agent)
    @p5 = 0 #双方都是外国
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        pa1=0
        #        pa2=0
        p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2,agent])
        #        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_partytype=2",vv.tb_cases_recevice_code,d1,d2,agent])
        #        p_12=p1.length+p2.length
        #申请人是国外的
        p1.each do |p_1|
          if p_1!=nil
            if p_1.tb_parties_area!=nil
              if p_1.tb_parties_area.slice(0,3)!="001"
                pa1=pa1+1
              end
            end
          end
        end
        #被申请人是国外的
        #        p2.each do |p_2|
        #          if p_2!=nil
        #            if p_2.tb_parties_area!=nil
        #              if p_2.tb_parties_area.slice(0,3)!="001"
        #                pa2=pa2+1
        #              end
        #            end
        #          end
        #        end
        if pa1==p1.length
          @p5=@p5+1
        end
      end
    end
    return @p5
  end
  def self.get_pn6(d1,d2,agent)
    @p6 = 0 #一方为广东以外地区，另一方为外国
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",d1,d2,agent],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        pa1=0
        pa2=0
        pa3=0
        pa4=0
        p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_partytype=1 and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2,agent])
        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_partytype=2 and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2,agent])
        p_12=p1.length+p2.length
        if p1!=nil#申请人是国内广东省以外的
          p1.each do |p_1|
            if p_1.tb_parties_area!=nil
              if p_1.tb_parties_area.slice(0,3)=="001" and  p_1.tb_parties_area.slice(0,6)!="001001"
                pa1=pa1+1
              end
              #申请人是国外的
              if p_1.tb_parties_area.slice(0,3)!="001"
                pa3=pa3+1
              end
            end
          end
        end
        if p2!=nil#被申请人是国外的
          p2.each do |p_2|
            if p_2.tb_parties_area!=nil
              if p_2.tb_parties_area.slice(0,3)!="001"
                pa2=pa2+1
              end
              #被申请人是国内广东省以外的
              if p_2.tb_parties_area.slice(0,3)=="001" and  p_2.tb_parties_area.slice(0,6)!="001001"
                pa4=pa4+1
              end
            end
          end
        end
        if (pa1+pa2)==p_12 or (pa3+pa4)==p_12
          @p6=@p6+1
        end
      end
    end
    return @p6
  end
  #不分仲裁机构，统计每列所有的 -------------------------------------------
  def self.get_pn_1(d1,d2)
    @p1 = 0 #至少一方为深圳市
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        @v_list2.each do |v|
          if v!=nil
            if v.tb_parties_area!=nil
              if v.tb_parties_area=='001001001'
                @p1 = @p1 + 1
              end
            end
          end
        end
      end
    end
    return @p1
  end
  def self.get_pn_2(d1,d2)
    @p2 = 0 #至少一方为广东其他地区（除深圳市以外）
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        @v_list2.each do |v|
          if v!=nil
            if v.tb_parties_area!=nil
              if v.tb_parties_area!='001001001' and v.tb_parties_area.slice(0,6)=="001001"
                @p2 = @p2 + 1
              end
            end
          end
        end
      end
    end
    return @p2
  end
  def self.get_pn_3(d1,d2)
    @p3 = 0 #至少一方为香港地区
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        @v_list2 = VCaseQuery1List1.find(:first,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''  and tb_parties_area='002'",vv.tb_cases_recevice_code,d1,d2])
        if @v_list2!=nil
          @p3 = @p3 + 1
        end
      end
    end
  end
  def self.get_pn_4(d1,d2)
    @p4 = 0 #双方都是广东以外地区
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        pa1=0
        #        pa2=0
        p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_agent=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        #        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_agent=? and tb_parties_partytype=2",vv.tb_cases_recevice_code,d1,d2])
        #        p_12=p1.length+p2.length
        #申请人
        p1.each do |p_1|
          if p_1!=nil
            if p_1.tb_parties_area!=nil
              if p_1.tb_parties_area.slice(0,6)!="001001"
                pa1=pa1+1
              end
            end
          end
        end
        #被申请人
        #        p2.each do |p_2|
        #          if p_2!=nil
        #            if p_2.tb_parties_area!=nil
        #              if p_2.tb_parties_area.slice(0,6)!="001001"
        #                pa2=pa2+1
        #              end
        #            end
        #          end
        #        end
        if pa1==p1.length
          @p4=@p4+1
        end
      end
    end
    return @p4
  end
  def self.get_pn_5(d1,d2)
    @p5 = 0 #双方都是外国
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        pa1=0
        #        pa2=0
        p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        #        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_partytype=2",vv.tb_cases_recevice_code,d1,d2])
        #        p_12=p1.length+p2.length
        #申请人是国外的
        p1.each do |p_1|
          if p_1!=nil
            if p_1.tb_parties_area!=nil
              if p_1.tb_parties_area.slice(0,3)!="001"
                pa1=pa1+1
              end
            end
          end
        end
        #被申请人是国外的
        #        p2.each do |p_2|
        #          if p_2!=nil
        #            if p_2.tb_parties_area!=nil
        #              if p_2.tb_parties_area.slice(0,3)!="001"
        #                pa2=pa2+1
        #              end
        #            end
        #          end
        #        end
        if pa1==p1.length
          @p5=@p5+1
        end
      end
    end
    return @p5
  end
  def self.get_pn_6(d1,d2)
    @p6 = 0 #一方为外地，另一方为外国
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_area<>''",d1,d2],:group=>"tb_cases_recevice_code")
    @v_list.each do |vv|
      if vv!=nil
        pa1=0
        pa2=0
        pa3=0
        pa4=0
        p1 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_partytype=1 and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        p2 = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_recevice_code=? and tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_parties_partytype=2 and tb_parties_area<>''",vv.tb_cases_recevice_code,d1,d2])
        p_12=p1.length+p2.length
        if p1!=nil#申请人是国内的
          p1.each do |p_1|
            if p_1.tb_parties_area!=nil
              if p_1.tb_parties_area.slice(0,3)=="001"
                pa1=pa1+1
              else#申请人是国外的
                pa3=pa3+1
              end
            end
          end
        end
        if p2!=nil#被申请人是国外的
          p2.each do |p_2|
            if p_2.tb_parties_area!=nil
              if p_2.tb_parties_area.slice(0,3)!="001"
                pa2=pa2+1
              else#被申请人是国内的
                pa4=pa4+1
              end
            end
          end
        end
        if (pa1+pa2)==p_12 or (pa3+pa4)==p_12
          @p6=@p6+1
        end
      end
    end
    return @p6
  end
  #起草案情 还是 仲裁庭意见，案件基本情况界面——3处共用
  def self.get_draft(code,v)
    a = ""
    @award=TbAwardDetail.find_by_sql("select a.draftsman_typ as draftsman_typ,a.draftsman as draftsman from tb_award_details as a,tb_awards as aw where a.used='Y' and a.recevice_code='#{code}' and a.typ='#{v}' and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id")
    for award in @award
      if award!=nil
        if award.draftsman_typ=='0001'
          a=a + TbArbitman.find(:first,:conditions=>["used='Y' and code=?",award.draftsman]).name + " "
        else
          u=User.find(:first,:conditions=>["used='Y' and code=?",award.draftsman])
          if u!=nil
            a=a + u.name + " "
          end
        end
      end
    end
    return a
  end
  #起草裁决书
  def self.get_casebook(code)
    casebook=""
    a = ""
    aa=""
    @award=TbAwardDetail.find_by_sql("select a.draftsman_typ as draftsman_typ,a.draftsman as draftsman,a.typ as typ from tb_award_details as a,tb_awards as aw where a.used='Y' and a.recevice_code='#{code}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id")
    for award in @award
      if award!=nil
        if award.draftsman_typ=='0001'#仲裁员
          arbman = TbArbitman.find(:first,:conditions=>["code=?",award.draftsman])
          if arbman
            a=a + TbArbitman.find(:first,:conditions=>["code=?",award.draftsman]).name + " "
          else
            a=a + award.draftsman + " "
          end
        else #助理
          u=User.find(:first,:conditions=>["used='Y' and code=?",award.draftsman])
          if u!=nil
            a=a+ u.name + " "
          end
        end
      end
      aa = TbDictionary.find(:first,:conditions=>["typ_code='0059' and used='Y' and state='Y' and data_val=?",award.typ]).data_text
    end
    if aa!=""
      casebook = aa + "：" + a
    else
      casebook = ""
    end
    return casebook
  end
  #裁决书评分
  def self.get_judge(code)
    @judge=TbAwardJudge.find(:first,:select=>"sum(score) as sc,count(id) as sd",:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @judge!=nil && @judge.sd.to_i!=0
      a = @judge.sc.to_f/@judge.sd.to_i
    else
      a = ""
    end
    return a
  end
  #年 月 日
  def self.get_ymd(date1)
    arr_date = date1.to_s.split("-")
    arr_date[1]=arr_date[1].to_i.to_s
    arr_date[2]=arr_date[2].to_i.to_s
    ymd=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    return ymd
  end
  #开庭时间
  def self.get_stime(time1)
    open_time={"08:00"=>"上午八时","08:30"=>"上午八时三十分","09:00"=>"上午九时","09:30"=>"上午九时三十分","10:00"=>"上午十时","10:30"=>"上午十时三十分","11:00"=>"上午十一时","11:30"=>"上午十一时三十分","12:00"=>"中午十二时",
      "12:30"=>"下午十二时三十分","13:00"=>"下午十三时","13:30"=>"下午十三时三十分","14:00"=>"下午十四时","14:30"=>"下午十四时三十分","15:00"=>"下午十五时","15:30"=>"下午十五时三十分",
      "16:00"=>"下午十六时","16:30"=>"下午十六时三十分","17:00"=>"下午十七时","17:30"=>"下午十七时三十分","18:00"=>"下午十八时","18:30"=>"下午十八时三十分",
      "19:00"=>"下午十九时","19:30"=>"下午十九时三十分","20:00"=>"下午二十时"}
    return open_time[time1]
  end
  #变 更 仲 裁 费 用 审 批 表：明确金额；不明确金额
  def self.get_d_money(code,typ,p_id,pv)
    @account2 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and typ= ? and parent_id=? and partytype=?",code,typ,p_id,pv],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
    if PubTool.new.get_first_record(@account2)!=nil
      @d_m=""
      @account2.each do |ac|
        @d_m = @d_m + get_sign(ac.currency) + SysArg.compart1(ac.f_money.to_f) + "  "
      end
      if @d_m!=""
        @d_m =@d_m.slice(0,@d_m.length-2)
      end
    else
      @d_m=""
    end
    return @d_m
  end
  def self.get_i_money(code,typ,p_id,pv)
    @account4 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0002' and typ=? and parent_id=? and partytype=?",code,typ,p_id,pv],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
    if PubTool.new.get_first_record(@account4)!=nil
      @d_m2=""
      @account4.each do |ac|
        @d_m2 = @d_m2 + get_sign(ac.currency) + SysArg.compart1(ac.f_money.to_f) + "  "
      end
      if @d_m2!=""
        @d_m2 =@d_m2.slice(0,@d_m2.length-2)
      end
    else
      @d_m2=""
    end
    return @d_m2
  end

  # 用于金额计算，四舍五入并保留两位小数
  def self.round2f(flo)
    flo = flo.to_f
    return sprintf("%.2f",(flo*100).round/100.00)
  end

  def self.num2chinese(num)
    chinese_numa_arr = ['零','壹','贰','叁','肆','伍','陆','柒','捌','玖']
    chinese_pos_arr = ['万','仟','佰','拾','亿','仟','佰','拾','万','仟','佰','拾','元','角','分']
    chinese_num = ''
    chinese_pos = ''
    str_chinese = ''
    nzero = 0
    str_num = (num*100).to_i.to_s
    i=0
    length=str_num.length
    pos_value = 0
    pos=chinese_pos_arr.length-length
    while i<length
      pos_value=str_num[i].chr.to_i

      if(i!=(length-3) && i!=(length-7) && i!=(length-11) && i!=(length-15))
        if(pos_value==0)
          chinese_num=''
          chinese_pos=''
          nzero+=1
        else
          if(nzero!=0)
            chinese_num=chinese_numa_arr[0]+chinese_numa_arr[pos_value]
            chinese_pos=chinese_pos_arr[pos+i]
            nzero=0
          else
            chinese_num=chinese_numa_arr[pos_value]
            chinese_pos=chinese_pos_arr[pos+i]
            nzero=0
          end
        end
      else
        if(pos_value!=0 && nzero!=0)
          chinese_num=chinese_numa_arr[0]+chinese_numa_arr[pos_value]
          chinese_pos=chinese_pos_arr[pos+i]
          nzero=0
        else
          if(pos_value!=0 && nzero==0)
            chinese_num=chinese_numa_arr[pos_value]
            chinese_pos=chinese_pos_arr[pos+i]
            nzero=0
          else
            if(length>=11)
              chinese_num=''
              nzero+=1
            else
              chinese_num=''
              chinese_pos=chinese_pos_arr[pos+i]
              nzero+=1
            end
          end
        end
      end
      if(i==(length-11) || i==(length-3))
        chinese_pos=chinese_pos_arr[pos+i]
      end
      str_chinese=str_chinese+chinese_num+chinese_pos
      if(i==(length-1) && pos_value==0)
        str_chinese=str_chinese+'整'
      end
      i+=1
    end

    str_chinese
  end

  #仲裁员最低金额控制
  def self.get_reward_safe(recevice_code,arbitman)
    @case=TbCase.find_by_recevice_code(recevice_code)
    #所有的简易程序
    jy = ["0002","0004","0006","0008"]
    #涉外普通
    swpt = ["0003","0007"]
    #国内普通
    gnpt = ["0001","0005"]
    @arbitman = TbCasearbitman.find_by_recevice_code_and_arbitman_and_used(recevice_code,arbitman,"Y")
    if jy.include?(@case.aribitprog_num)
      if @arbitman.arbitmantype=="0001"
        return "6000"
      else
        return nil
      end
    elsif swpt.include?(@case.aribitprog_num)
      if @arbitman.arbitmantype=="0002"
        return 11500
      else
        return 5500
      end
    elsif gnpt.include?(@case.aribitprog_num)
      if @arbitman.arbitmantype=="0002"
        return 10000
      else
        return 5000
      end  
    end
  end


end
