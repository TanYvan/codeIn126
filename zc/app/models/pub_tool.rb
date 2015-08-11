require 'digest/sha1'
# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
class PubTool
  
  #返回被a覆盖后的b
  def put_to(a,b)
    r = {}
    h = a.attributes
    b.attribute_names.each{|f|
      v = h[f]
      if f!="id" && v
        r.merge!({f => v})
      end
    }
    b.attributes = r
    return b
  end
  
  def p_en(s)
    s=Digest::SHA1.hexdigest(s)
    a="aeb5660fc2140aec3585"
    b=Digest::SHA1.hexdigest(Time.now().to_s(:long))
    c="b04c54574d18c28d46e6"
    rrr=s + a + b + c
    return rrr
  end
  
  def n_to_c(v)
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
  def n_to_md(v)
    @nc={"1"=>"一","2"=>"二","3"=>"三","4"=>"四","5"=>"五","6"=>"六","7"=>"七","8"=>"八","9"=>"九","10"=>"十",
      "11"=>"十一","12"=>"十二","13"=>"十三","14"=>"十四","15"=>"十五","16"=>"十六","17"=>"十七","18"=>"十八","19"=>"十九","20"=>"二十",
      "21"=>"二十一","22"=>"二十二","23"=>"二十三","24"=>"二十四","25"=>"二十五","26"=>"二十六","27"=>"二十七","28"=>"二十八","29"=>"二十九","30"=>"三十","31"=>"三十一"}
    v=v.to_s
    rrr=@nc[v]
    return rrr
  end
  #当事人个数
  def self.n_to_p(v)
    @nc={"2"=>"两","3"=>"三","4"=>"四","5"=>"五","6"=>"六","7"=>"七","8"=>"八","9"=>"九","10"=>"十",
      "11"=>"十一","12"=>"十二","13"=>"十三","14"=>"十四","15"=>"十五","16"=>"十六","17"=>"十七","18"=>"十八","19"=>"十九","20"=>"二十",
      "21"=>"二十一","22"=>"二十二","23"=>"二十三","24"=>"二十四","25"=>"二十五","26"=>"二十六","27"=>"二十七","28"=>"二十八","29"=>"二十九","30"=>"三十","31"=>"三十一"}
    v=v.to_s
    rrr=@nc[v]
    return rrr
  end
  def round_0(v)
    rrr=v
    return rrr.round
  end
  def round_2(v)
    rrr=(v * 100).round
    rrr=rrr / 100.00
    return rrr
  end
  def round_3(v)
    rrr=(v * 1000).round
    rrr=rrr / 1000.00
    return rrr
  end
  def get_first_record(obj)
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
  def get_last_record(obj)
    if obj.empty?
      rrr=nil
    else
      for ob in obj
        rrr=ob
      end
    end
    return rrr
  end
  def sql_check(sq)
    if sq!=nil
      sq=sq.to_s
      sq=sq.downcase
      ss=["not","and","or","exec","insert","select","delete","update","count","*","%","chr","mid","master","truncate","char","declare"]
      for s in ss
        if sq.index(s) != nil
          return false
        end
      end  
    end
  end
  
  def sql_check_2(sq)
    if sq!=nil
      sq=sq.to_s
      sq=sq.downcase
      ss=["exec","insert","select","delete","update","count","*","%","chr","mid","master","truncate","char","declare"]
      for s in ss
        if sq.index(s) != nil
          return false
        end
      end 
    end    
  end
  
  def sql_check_3(sq)
    if sq!=nil
      sq=sq.to_s
      sq=sq.downcase
      ss=["exec","insert","delete","update","master","truncate","declare"]
      for s in ss
        if sq.index(s) != nil
          return false
        end
      end
    end
  end

  #当事人
  def self.get_parties(code,p1)
    @party=TbParty.find(:all,:conditions=>"used='Y' and partytype=#{p1} and recevice_code='#{code}'",:order=>"id")
    stra = ""
    if @party.empty?
    else
      stra = ""
      k = 1
      @party.each do |pa|
        if k==1
          if p1==1
            stra = stra+" <br> 申请人:#{pa.partyname}" + "、"
          else
            stra = stra+" <br> 被申请人:#{pa.partyname}" + "、"
          end
        else
          stra = stra+"#{pa.partyname}" + "、"
        end
        k+=1
      end
      stra = stra.slice(0,stra.length-3)
    end
    return stra
  end
  #仲裁员
  def self.arbitrator(code,n)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = ?",code,n])
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
  #仲裁员选定方式
  def self.get_arbitstyle(code,v1)
    @arbitmenA=TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,v1])
    if @arbitmenA!=nil
      @arbitmansign=@arbitmenA.arbitmansign
      if @arbitmansign!=nil
        @ab=TbDictionary.find(:first,:conditions=>"typ_code='0015' and state='Y' and data_val='#{@arbitmansign}'")
        @abc=@ab.data_text
      else
        @abc=""
      end
    else
      @abc=""
    end
    return @abc
  end
  #案件时间差显示不同颜色
  def self.getd(code)
    @d1=Date.today     #延期审限的日期 - 当天日期
    c = TbCase.find_by_recevice_code(code)
    if c.finally_limit_dat != nil #审限日期
      return c.finally_limit_dat - @d1
    else
      return ""
    end
  end
  #    @casedely=TbCasedelay.find(:first,:conditions=>["recevice_code=?",code],:order=>"id desc")
  #    if @casedely!=nil
  #      return @casedely.delayDate - @d1
  #    else
  #      if c.finally_limit_dat!=nil  #初始审限日期 - 当天日期
  #        return c.finally_limit_dat - @d1
  #      else
  #        return ""
  #      end
  #    end
  #取档次
  def get_grade(grade)
    r=''
    if grade==nil or grade==''
      r='&nbsp;'
      return r
    else
      r=''
      g=grade.split(" ")
      i=0
      g.each{|gr|
        if i<g.length - 1
          r=r+ ' ' + gr
        end
        i=i+1
      }
      return r
    end
  end
  #结案时间
  def self.get_end_day(code,nowdate)
    cend=TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if cend!=nil
      return cend.decideDate - nowdate.to_date
    end
  end
  #反请求审批表
  def self.get_date(code)
    @resp=TbCaseAmount.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype='2'",code],:order=>"id")
    str6=""
    if @resp!=nil
      arr_date = @resp.dt.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      str6=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      str6="______年___月___日"
    end
    return str6
  end
  #反请求
  def self.get_dear_money(code)
    @account2 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and typ= '0001' and partytype='2'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
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
  #不明确争议金额
  def self.get_indefinite_money(code)
    @account4 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0002' and typ= '0001' and partytype='2'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
    if PubTool.new.get_first_record(@account4)!=nil
      @d_m2=""
      @account4.each do |ac|
        @d_m2 = @d_m2 + get_sign(ac.currency)+ SysArg.compart1(ac.f_money.to_f) + "  "
      end
      if @d_m2!=""
        @d_m2 =@d_m2.slice(0,@d_m2.length-2)
      end
    else
      @d_m2=""
    end
    return @d_m2
  end
  #立案费/受理费 0002
  def self.get_litigation_fee(code)
    @litigation=TbShouldCharge.find_by_sql("select sum(s.rmb_money) as aa from tb_case_amounts as a,tb_should_charges as s where s.used='Y' and a.used='Y'
      and a.recevice_code='#{code}' and a.recevice_code=s.recevice_code and a.id=s.case_amount_id and
      s.typ='0002' and  a.typ='0001' and a.partytype='2'")
    @litigation=PubTool.new.get_first_record(@litigation)
    if @litigation!=nil
      @litigation=@litigation.aa
      if @litigation!=nil
        @litigation=@litigation.to_f
        @mm=@litigation
      else
        @mm=0
      end
    else
      @mm=0
    end
    return @mm
  end
  #仲裁费/处理费
  def self.get_processing_fee(code)
    @processing=TbShouldCharge.find_by_sql("select sum(s.rmb_money) as cc from tb_case_amounts as a,tb_should_charges as s where s.used='Y' and a.used='Y'
      and a.recevice_code='#{code}' and a.recevice_code=s.recevice_code and a.id=s.case_amount_id and
      s.typ='0003' and  a.typ='0001' and a.partytype='2'")
    @processing=PubTool.new.get_first_record(@processing)
    if @processing!=nil
      @processing=@processing.cc
      if @processing!=nil
        @processing=@processing.to_f
        @mmm=@processing
      else
        @mmm=0
      end
    else
      @mmm=0
    end
    return @mmm
  end
  #无明确争议金额：
  #立案费/受理费
  def self.get_litigation_fee2(code)
    @litigation2=TbShouldCharge.find_by_sql("select sum(rmb_money) as aa2 from tb_should_charges where used='Y'
      and recevice_code='#{code}' and typ='0005' and payment='0002'")
    @litigation2=PubTool.new.get_first_record(@litigation2).aa2
    if @litigation2!=nil
      @litigation2=@litigation2.to_f
      if @litigation2==0
        return 0
      else
        return @litigation2
      end
    else
      return 0
    end
  end
  #无明确金额的 处理费/仲裁费
  def self.get_processing_fee2(code)
    @processing2=TbShouldCharge.find_by_sql("select sum(rmb_money) as cc2 from tb_should_charges where used='Y'
      and recevice_code='#{code}' and typ='0006' and payment='0002'")
    @processing2=PubTool.new.get_first_record(@processing2).cc2
    if @processing2!=nil
      @processing2=@processing2.to_f
      if @processing2==0
        return 0
      else
        return @processing2
      end
    else
      return 0
    end
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
end
