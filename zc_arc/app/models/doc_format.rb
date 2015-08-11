class Doc_format
  def initialize

  end

  def show(doc_id)
    @doc = TbDoc.find(doc_id)
    @recevice_code = @doc.recevice_code
    @party_type = @doc.obj
    @sub_code = TbDocFormat.find_by_code(@doc.typ_code).sub_code
    @ar_nu = TbDocFormat.find_by_code(@doc.typ_code).aribitprog_num
    if @sub_code == "fmt01"
      r = format_letter_fmt01(@recevice_code)
    elsif @sub_code == "fmt02_1"
      r = format_letter_fmt02_1(@recevice_code)
    elsif @sub_code == "fmt02_2"
      r = format_letter_fmt02_2(@recevice_code)
    elsif @sub_code == "fmt03"
      r = format_letter_fmt03(@recevice_code,doc_id)
    elsif @sub_code == "dfmt04"
      r = format_letter_dfmt04(@recevice_code,doc_id)
    elsif @sub_code == "dfmt05"
      r = format_letter_dfmt05(@recevice_code,doc_id)
    elsif @sub_code == "dfmt06"
      r = format_letter_dfmt06(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt07a"
      r = format_letter_dfmt07ap(@recevice_code,doc_id)
    elsif @sub_code == "fmt07b"
      r = format_letter_fmt07ap(@recevice_code,doc_id)
    elsif @sub_code == "dfmt08"
      r = format_letter_dfmt08(@recevice_code)
    elsif @sub_code == "dfmt09"
      r = format_letter_dfmt09(@recevice_code,doc_id)
    elsif @sub_code == "fmt26"
      r = format_letter_dfmt26(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "dfmt31"
      r = format_letter_dfmt31(@recevice_code,doc_id)
    elsif @sub_code == "dfmt32"
      r = format_letter_dfmt32(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "dfor03"
      r = format_letter_dfor03(@recevice_code)
    elsif @sub_code == "fmt04"
      r = format_letter_fmt04(@recevice_code,doc_id)
    elsif @sub_code == "ft04"
      r = format_letter_ft04(@recevice_code,doc_id)
    elsif @sub_code == "fmt05"
      r = format_letter_fmt05(@recevice_code,doc_id)
    elsif @sub_code == "ft05"
      r = format_letter_ft05(@recevice_code,doc_id)
    elsif @sub_code == "ft05b"
      r = format_letter_bft05(@recevice_code,doc_id)
    elsif @sub_code == "fmt06"
      r = format_letter_fmt06(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "ft06"
      r = format_letter_ft06(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "ft06b"
      r = format_letter_bft06(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt08"
      r = format_letter_fmt08(@recevice_code)
    elsif @sub_code == "fmt09"
      r = format_letter_fmt09(@recevice_code,doc_id)
    elsif @sub_code == "fmt11a"
      r = format_letter_fmt11a(@recevice_code,doc_id)
    elsif @sub_code == "fmt17a"
      r = format_letter_fmt17a(@recevice_code,doc_id)
    elsif @sub_code == "fmt12"
      r = format_letter_fmt12(@recevice_code)
    elsif @sub_code == "fmt14"
      r = format_letter_fmt14(@recevice_code,doc_id)
    elsif @sub_code == "fmt17b"
      r = format_letter_fmt17b(@recevice_code,doc_id)
    elsif @sub_code == "fmt15"
      r = format_letter_fmt15(@recevice_code,doc_id)
    elsif @sub_code == "fmt17"
      r = format_letter_fmt17(@recevice_code,doc_id)
    elsif @sub_code == "fmt18"
      r = format_letter_fmt18(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt19"
      r = format_letter_fmt19(@recevice_code,doc_id)
    elsif @sub_code == "fmt20"
      r = format_letter_fmt20(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt23b"
      r = format_letter_fmt23b(@recevice_code,@party_type,@ar_nu)
    elsif @sub_code == "fmt23m"
      r = format_letter_fmt23m(@recevice_code,@ar_nu)
    elsif @sub_code == "fmt23e"
      r = format_letter_fmt23e(@recevice_code)
    elsif @sub_code == "fmt24"
      r = format_letter_fmt24(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt27"
      r = format_letter_fmt27(@recevice_code,doc_id)
    elsif @sub_code == "fmt31"
      r = format_letter_fmt31(@recevice_code,doc_id)
    elsif @sub_code == "fmt32"
      r = format_letter_fmt32(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt33"
      r = format_letter_fmt33(@recevice_code,doc_id)
    elsif @sub_code == "fmt36"
      r = format_letter_fmt36(@recevice_code,doc_id)
    elsif @sub_code == "fmt37"
      r = format_letter_fmt37(@recevice_code,doc_id)
    elsif @sub_code == "fmt38"
      r = format_letter_fmt38a(@recevice_code,doc_id,@ar_nu)
    elsif @sub_code == "fmt39"
      r = format_letter_fmt39(@recevice_code,doc_id,@ar_nu)
    elsif @sub_code == "fmt40"
      r = format_letter_fmt40(@recevice_code,doc_id)
    elsif @sub_code == "fmt41"
      r = format_letter_fmt41(@recevice_code,@party_type,doc_id)
    elsif @sub_code == "fmt42"
      r = format_letter_fmt42(@recevice_code,doc_id)
    elsif @sub_code == "fmt44"
      r = format_letter_fmt44(@recevice_code,doc_id)
    elsif @sub_code == "fmt45"
      r = format_letter_fmt45(doc_id)
    elsif @sub_code == "fmt46"
      r = format_letter_fmt46(@recevice_code,doc_id)
    elsif @sub_code == "fmt47"
      r = format_letter_fmt47(@recevice_code,@ar_nu)
    elsif @sub_code == "fmt48"
      r = format_letter_fmt48(@recevice_code)
    elsif @sub_code == "fmt49"
      r = format_letter_fmt49(@recevice_code,@party_type)
    elsif @sub_code == "fmt50"
      r = format_letter_fmt50(@recevice_code)
    elsif @sub_code == "dfmt51"
      r = format_letter_fmt51(@recevice_code,@party_type)
    elsif @sub_code == "for03"
      r = format_letter_for03(@recevice_code,doc_id)
    elsif @sub_code == "fr03"
      r = format_letter_fr03(@recevice_code,doc_id)
    elsif @sub_code == "head1"
      r = format_letter_head1(@recevice_code,doc_id)
    elsif @sub_code == "dfmt90"
      r = format_letter_dfmt90(@recevice_code)
    elsif @sub_code == "dfmt91"
      r = format_letter_dfmt91(@recevice_code)
    elsif @sub_code == "dfmt92"
      r = format_letter_dfmt92(@recevice_code)
    elsif @sub_code == "fmt53"
      r = format_letter_fmt53(@recevice_code)
    else
      r = format_letter_head2(@recevice_code)
    end
    return r.delete("\n\r")
  end

  #内部函生成之前的条件检测,符合发文条件的返回空字符串，不符合的则返回提示信息
  def check_sub(recevice_code,format_code)
    r=Array.new
    r[0]=""
    r[1]=""
    @check_sub_code = TbDocFormat.find_by_code(format_code).check_sub_code
    if @check_sub_code!=""
      if @check_sub_code == "fmt07a"#typed='0001' 证据保全 ；0002  财产保全
        @sav2 = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed='0002'",recevice_code],:order=>"id desc")
        if @sav2==nil
          r[0]="text"
          r[1] ="请填写财产保全信息！"
        end
      elsif @check_sub_code == "fmt07b"
        @sav1 = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed='0001'",recevice_code],:order=>"id desc")
        if @sav1==nil
          r[0]="text"
          r[1] ="请填写证据保全信息！"
        end
      elsif @check_sub_code == "fmt11"
        @ccc=TbShouldCharge.count(:conditions=>"used='Y' and recevice_code='#{recevice_code}'")
        @s=TbShouldCharge.find(:first,:select=>"sum(rmb_money-re_rmb_money-redu_rmb_money) as s1",:conditions=>["used = 'Y' and recevice_code=? and (typ='0001' or typ='0004')",recevice_code])
        #案件收费（争议金额）”、“案件收费（无明确争议金额）”，则要检测对应的费用，
        #如果对应的实收为0，则提示“案件收费明细对应中存在为0的记录”，不能终审
        if @s!=nil
          @sss=@s.s1.to_i
        else
          @sss=0
        end
        @sitting=TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=?",recevice_code])
        if @sitting==nil
          contents = "没有开庭时间。"
          r[0]="text"
          r[1] =contents
        else
          if @ccc==nil or @ccc==0
            contents="没有交费记录。"
          end
          if @sss>0
            contents="有欠缴费用未交。"
          end
          r[0]="alert"
          r[1] =contents
        end
      elsif @check_sub_code == "fmt12"
        @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",recevice_code])
        if @award==nil
          r[0]="text"
          r[1]="请填写报校核信息！"
        end
      elsif @check_sub_code == "fmt17"
        @award=TbCaseorg.find(:first,:conditions=>["used='Y' and recevice_code=?",recevice_code])
        if @award==nil
          r[0]="text"
          r[1]="请填写组庭信息！"
        end
      elsif @check_sub_code == "fmt47" #庭审要点、程序报告、开庭签到表，如果没有创建开庭时间，不允许发该函
        @sitting=TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=?",recevice_code])
        if @sitting==nil
          contents = "没有开庭时间。"
          r[0]="text"
          r[1] =contents
        end
      elsif @check_sub_code == "fmt50" #如果没有输入退费信息，则不能生成退费审批表，并提示“请先输入退费信息”
        tb_should_refund = TbShouldRefund.find(:first,:conditions=>["used='Y' and recevice_code=? and parent_id=0 and state<>3",recevice_code],:order=>"id desc")
        if tb_should_refund==nil
          r[0]="text"
          r[1]="请先输入退费信息。"
        end
      end
    end
    return r
  end

  def show_head_1(doc_id)
    @doc = TbDoc.find(doc_id)
    @recevice_code = @doc.recevice_code
    r = format_letter_head1(@recevice_code,doc_id)
    return r
  end
  def format_letter_fmt01(code)
    @format_fmt01 = ""
    @case = TbCase.find_by_recevice_code(code)
    @caseend = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @caseend!=nil
      arr_date = @caseend.decideDate.to_s.split("-")
      rep1 = arr_date[0]
      @endStyle=@caseend.endStyle
      if @endStyle=='0001'
        str2 = "裁"
        str8 = "裁决"
      elsif @endStyle=='0002'
        str2 = "裁"
        str8 = "和解裁决"
      else
        str2 = "撤"
        str8 = "撤案"
      end
      str3 = @caseend.file_arbitBookNum
    else
      rep1="_____"
      str2 = "裁/撤"
      str3 = "_____"
      str8 = "裁决/撤案/和解裁决"
    end
    @general_code = @case.general_code
    if @general_code!=""
      str4 = @general_code.to_i
    else
      str4 = "_____"
    end
    @nowdate = @case.nowdate
    if @nowdate!=nil
      str5 = @nowdate.to_s.split("-")
      rep5 = str5[0]
    else
      rep5 = "_____"
    end
    str6 = @case.case_code
    if str6==nil and str6==""
      str6 = "_____"
    end
    str7 = @case.dispute_type
    if str7==nil or str7==nil
      str7 = "________________"
    end
    @format_fmt01 = add_record("<01$$$>",rep1,@format_fmt01)
    @format_fmt01 = add_record("<02$$$>",str2,@format_fmt01)
    @format_fmt01 = add_record("<03$$$>",str3,@format_fmt01)
    @format_fmt01 = add_record("<04$$$>",str4,@format_fmt01)
    @format_fmt01 = add_record("<05$$$>",rep5,@format_fmt01)
    @format_fmt01 = add_record("<06$$$>",str6,@format_fmt01)
    @format_fmt01 = add_record("<07$$$>",str7,@format_fmt01)
    @format_fmt01 = add_last_record("<08$$$>",str8,@format_fmt01)
  end
  def format_letter_fmt02_1(code)
    @format_fmt02_1 = ""
    @case= TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @r1 = get_contract_nd(code) + "   " + TbCase.find_by_recevice_code(code).dispute_type
    @format_fmt02_1 = add_record("<01$$$>",@r1,@format_fmt02_1)
    @format_fmt02_1 = add_record("<02$$$>",applicant_f(code,1),@format_fmt02_1)
    @format_fmt02_1 = add_record("<03$$$>",applicant_f(code,2),@format_fmt02_1)
    @format_fmt02_1 = add_record("<04$$$>",independent_arbitrator(code),@format_fmt02_1)
    if @case.receivedate!=nil
      @format_fmt02_1 = add_record("<05$$$>",@case.receivedate,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<05$$$>","",@format_fmt02_1)
    end
    if @case.accepttime!=nil
      @format_fmt02_1 = add_record("<06$$$>",@case.accepttime,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<06$$$>","",@format_fmt02_1)
    end
    if @case.nowdate!=nil
      @format_fmt02_1 = add_record("<07$$$>",@case.nowdate,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<07$$$>","",@format_fmt02_1)
    end
    @caseorg = TbCaseorg.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @caseorg!=nil
      @format_fmt02_1 = add_record("<08$$$>",@caseorg.orgdate,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<08$$$>","未组庭",@format_fmt02_1)
    end
    @caseend = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @caseend!=nil
      @format_fmt02_1 = add_record("<09$$$>",@caseend.decideDate,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<09$$$>","",@format_fmt02_1)
    end
    if @case.clerk!=""
      @zl = User.find(:first,:conditions=>["used='Y' and code=?",@case.clerk])
      @format_fmt02_1 = add_record("<10$$$>",@zl.name,@format_fmt02_1)
      @format_fmt02_1 = add_last_record("<11$$$>",@zl.name,@format_fmt02_1)
    else
      @format_fmt02_1 = add_record("<10$$$>","",@format_fmt02_1)
      @format_fmt02_1 = add_last_record("<11$$$>","",@format_fmt02_1)
    end
  end
  #普通程序
  def format_letter_fmt02_2(code)
    @format_fmt02_2 = ""
    @case= TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @r1 = get_contract_nd(code) + "   " + TbCase.find_by_recevice_code(code).dispute_type
    @format_fmt02_2 = add_record("<01$$$>",@r1,@format_fmt02_2)
    @app1 = applicant_f(code,1)
    @format_fmt02_2 = add_record("<02$$$>",@app1,@format_fmt02_2)
    @app2 = applicant_f(code,2)
    @format_fmt02_2 = add_record("<03$$$>",@app2,@format_fmt02_2)
    @format_fmt02_2 = add_record("<04$$$>",chief_arbitrator(code),@format_fmt02_2)
    @format_fmt02_2 = add_record("<13$$$>",applicant_arbitrator(code),@format_fmt02_2)
    @format_fmt02_2 = add_record("<14$$$>",respondent_arbitrator(code),@format_fmt02_2)
    if @case.receivedate!=nil
      @format_fmt02_2 = add_record("<05$$$>",@case.receivedate,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<05$$$>","",@format_fmt02_2)
    end
    if @case.accepttime!=nil
      @format_fmt02_2 = add_record("<06$$$>",@case.accepttime,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<06$$$>","",@format_fmt02_2)
    end
    if @case.nowdate!=nil
      @format_fmt02_2 = add_record("<07$$$>",@case.nowdate,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<07$$$>","",@format_fmt02_2)
    end
    @caseorg = TbCaseorg.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @caseorg!=nil
      @format_fmt02_2 = add_record("<08$$$>",@caseorg.orgdate,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<08$$$>","未组庭",@format_fmt02_2)
    end
    @caseend = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @caseend!=nil
      @format_fmt02_2 = add_record("<09$$$>",@caseend.decideDate,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<09$$$>","",@format_fmt02_2)
    end
    if @case.clerk!=""
      @zl = User.find(:first,:conditions=>["used='Y' and code=?",@case.clerk])
      @format_fmt02_2 = add_record("<10$$$>",@zl.name,@format_fmt02_2)
      @format_fmt02_2 = add_last_record("<11$$$>",@zl.name,@format_fmt02_2)
    else
      @format_fmt02_2 = add_record("<10$$$>","",@format_fmt02_2)
      @format_fmt02_2 = add_last_record("<11$$$>","",@format_fmt02_2)
    end
  end

  #程序报告
  def format_letter_fmt03(code,doc_id)
    format_fmt03 = ""

    current_case = TbCase.find(:first, :conditions => ["used='Y' and recevice_code=?", code])
    case_code = current_case.case_code # 立案号
    aribitprog_num = current_case.aribitprog_num # 仲裁程序编码
    nowdate = current_case.nowdate # 立案日期

    format_fmt03 = add_record("<01$$$>", case_code, format_fmt03)

    if aribitprog_num == '0001' # 国内普通
      format_fmt03 = add_record("<02$$$>", "国内", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "普通", format_fmt03)
    elsif aribitprog_num == '0002'
      format_fmt03 = add_record("<02$$$>", "国内", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "简易", format_fmt03)
    elsif aribitprog_num == '0003'
      format_fmt03 = add_record("<02$$$>", "涉外", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "普通", format_fmt03)
    elsif aribitprog_num == '0004'
      format_fmt03 = add_record("<02$$$>", "涉外", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "简易", format_fmt03)
    elsif aribitprog_num == '0006'
      format_fmt03 = add_record("<02$$$>", "国内", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "金融规则1人", format_fmt03)
    elsif aribitprog_num == '0008'
      format_fmt03 = add_record("<02$$$>", "国内", format_fmt03)
      format_fmt03 = add_record("<03$$$>", "金融规则3人", format_fmt03)
    elsif aribitprog_num == '0007'
      format_fmt03 = add_record("<02$$$>", "涉外",format_fmt03)
      format_fmt03 = add_record("<03$$$>", "金融规则3人",format_fmt03)
    else
      format_fmt03 = add_record("<02$$$>","涉外",format_fmt03)
      format_fmt03 = add_record("<03$$$>","金融规则1人",format_fmt03)
    end

    if nowdate != nil
      arr_date = nowdate.to_s.split("-")
      str6 = arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日"
    else
      str6 = "______年___月___日"
    end

    #仲裁通知日期修改为开庭日期
    format_fmt03 = add_record("<06$$$>",str6,format_fmt03)

    if current_case.accepttime != nil # 受理日期
      arr_date = current_case.accepttime.to_s.split("-")
      accepttime = arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日"
    else
      accepttime = "______年___月___日"
    end

    format_fmt03 = add_record("<04$$$>", accepttime, format_fmt03)

    # 仲裁费用是否已经缴清
    shouldc = TbShouldCharge.count(:conditions => "used='Y' and recevice_code='#{code}'")
    tsc = TbShouldCharge.find(
      :first,
      :select => "sum(rmb_money-re_rmb_money-redu_rmb_money) as s1",
      :conditions => ["used = 'Y' and recevice_code=? and (typ='0001' or typ='0004')", code]
    )
    if tsc != nil
      @sss = tsc.s1.to_i
    else
      @sss = 0
    end

    if shouldc == nil or shouldc == 0
      contents = "未"
    end

    contents = @sss > 0 ? "未" : "已"

    format_fmt03 = add_record("<05$$$>",contents,format_fmt03)

    #财产保全(申请人，被申请人)-----------------------------
    tsave1 = TbSave.find(
      :first,
      :conditions => ["used='Y' and recevice_code=? and request_typ=? and typed=?",code,'0001','0002']
    ) # 申请人 财产保全
    if tsave1 != nil
      send_time1 = tsave1.send_time
      arr_date = send_time1.to_s.split("-")
      send_time1 = "申请人" + tsave1.request_man + "于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出财产保全申请"
    else
      send_time1 = "申请人/被申请人于_____年___月__日提出财产保全申请"
    end
    tsave2 = TbSave.find(
      :first,
      :conditions => ["used='Y' and recevice_code=? and request_typ=? and typed=?",code,'0002','0002']
    ) # 被申请人 财产保全
    if tsave2 != nil
      send_time2 = tsave2.send_time
      arr_date = send_time2.to_s.split("-")
      if send_time1 != ""
        send_time2 = "，被申请人" + tsave2.request_man + "于" +
          arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出财产保全申请"
      else
        send_time2 = "被申请人" + tsave2.request_man + "于" +
          arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出财产保全申请"
      end
    else
      send_time2 = ""
    end
    str7 = send_time1 + send_time2
    format_fmt03 = add_record("<07$$$>",str7,format_fmt03)

    #证据保全(申请人，被申请人)--------------------------------------------
    save1 = TbSave.find(
      :first,
      :conditions => ["used='Y' and recevice_code=? and request_typ=? and typed=?",code,'0001','0001']
    ) # 申请人 证据保全
    if save1 != nil
      s_time1 = save1.send_time
      arr_date = s_time1.to_s.split("-")
      s_time1 = "申请人" + save1.request_man + "于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出证据保全申请"
    else
      s_time1 = "申请人/被申请人于_____年___月__日提出证据保全申请"
    end
    save2 = TbSave.find(
      :first,
      :conditions => ["used='Y' and recevice_code=? and request_typ=? and typed=?",code,'0002','0001']
    ) # 被申请人 证据保全
    if save2 != nil
      s_time2 = save2.send_time
      arr_date = s_time2.to_s.split("-")
      if s_time1 != ""
        s_time2 = "，被申请人" + save2.request_man + "于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出证据保全申请"
      else
        s_time2 = "被申请人"   + save2.request_man + "于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出证据保全申请"
      end
    else
      s_time2 = ""
    end
    str8 = s_time1 + s_time2
    format_fmt03 = add_record("<08$$$>", str8, format_fmt03)

    #被申请人于    年    月    日提出管辖权异议。仲裁委员会于       年     月    日作出决定
    jurisdiction = TbJurisdiction.find(
      :first,
      :conditions => ["used='Y' and recevice_code=? and submitman='0002'",code]
    )
    if jurisdiction != nil
      arr_date = jurisdiction.request_date.to_s.split("-")
      arr_date2 = jurisdiction.decide_date.to_s.split("-")
      str9 = "被申请人" + jurisdiction.request_man + "于" + arr_date[0].to_s + "年" +
        arr_date[1].to_s + "月" + arr_date[2].to_s + "日提出管辖权异议。仲裁委员会于" +
        arr_date2[0].to_s + "年" + arr_date2[1].to_s + "月" + arr_date2[2].to_s + "日作出决定"
    else
      str9 = "被申请人于_____年___月___日提出管辖权异议。仲裁委员会尚未作出决定"
    end
    format_fmt03 = add_record("<09$$$>", str9, format_fmt03)

    #被申请人于    年    月    日提交了答辩，于    年    月   日提出了反请求
    @requ = TbPartyrequest.find(:first,:conditions => ["used='Y' and recevice_code=? and partytype=2", code])
    if @requ != nil
      arr_date = @requ.requestdate.to_s.split("-")
      str101 = '\r    ' + "4．被申请人" + "于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日提交了答辩"
    else
      str101 = ""
    end

    @ans = TbPartyanswer.find(:first, :conditions => ["used='Y' and recevice_code=? and partytype=2",code])
    if @ans != nil
      arr_date2 = @ans.receivedate.to_s.split("-")
      if str101 != ""
        str102 = "，于" + arr_date2[0].to_s + "年" + arr_date2[1].to_s + "月" + arr_date2[2].to_s + "日提交了反请求。"
      else
        str102 = '\r    ' + "4．被申请人于" + arr_date2[0].to_s + "年" + arr_date2[1].to_s + "月" + arr_date2[2].to_s + "日提交了反请求。"
      end
    else
      str102 = ""
    end
    str10 = str101 + str102
    format_fmt03 = add_record("<10$$$>", str10, format_fmt03)

    # 仲裁员
    str19 = ""
    @adjudgebrike = TbAdjudgebrike.find(:all, :conditions => ["used='Y' and recevice_code=?", code])
    if str10 != ""
      format_fmt03 = add_record("<16$$$>", 6, format_fmt03)
      format_fmt03 = add_record("<17$$$>", 7, format_fmt03)
      if @adjudgebrike.first != nil
        for s in @adjudgebrike
          str_19 = TbDictionary.find(
            :first,
            :conditions => ["typ_code='8106' and state='Y' and used='Y' and data_val=?", s.requestman_type]
          ).data_text
          end_date = s.end_date.to_s.split("-")
          end_date10 = end_date[0].to_s + "年"
          end_date1  = end_date[1].to_s + "月"
          end_date2  = end_date[2].to_s + "日"
          change_1 = end_date10 + end_date1 + end_date2
          str19 = str_19 + "要求在" + change_1 + "中止仲裁程序"
          if s.start_date != nil
            end_date = s.start_date.to_s.split("-")
            end_date10 = end_date[0].to_s + "年"
            end_date1  = end_date[1].to_s + "月"
            end_date2  = end_date[2].to_s + "日"
            change_1 = end_date10 + end_date1 + end_date2
            str19=str19 + "，" + change_1 + "恢复仲裁程序"
          end
        end
      end
      if str19 != ""
        format_fmt03 = add_record("<18$$$>", "8．", format_fmt03)
        format_fmt03 = add_record("<20$$$>", "9", format_fmt03)
      else
        format_fmt03 = add_record("<18$$$>", "", format_fmt03)
        format_fmt03 = add_record("<20$$$>", "8", format_fmt03)
      end
    else
      format_fmt03 = add_record("<16$$$>", 5, format_fmt03)
      format_fmt03 = add_record("<17$$$>", 6, format_fmt03)
      if @adjudgebrike.first != nil
        for s in @adjudgebrike
          str_19 = TbDictionary.find(
            :first,
            :conditions => ["typ_code='8106' and state='Y' and used='Y' and data_val=?",s.requestman_type]
          ).data_text # 要求终止仲裁程序的一方 （0001:法院  0002:当事人）
          end_date   = s.end_date.to_s.split("-")
          end_date10 = end_date[0] + "年"
          end_date1  = end_date[1].to_i.to_s + "月"
          end_date2  = end_date[2].to_i.to_s + "日"
          change_1   = end_date10 + end_date1 + end_date2
          str19 = str_19 + "要求在" + change_1 + "中止仲裁程序"
          if s.start_date != nil
            end_date   = s.start_date.to_s.split("-")
            end_date10 = end_date[0] + "年"
            end_date1  = end_date[1].to_i.to_s + "月"
            end_date2  = end_date[2].to_i.to_s + "日"
            change_1   = end_date10 + end_date1 + end_date2
            str19 = str19 + "，" + change_1 + "恢复仲裁程序"
          end
        end
      end
      if str19 != ""
        format_fmt03 = add_record("<18$$$>", "7．", format_fmt03)
        format_fmt03 = add_record("<20$$$>", "8", format_fmt03)
      else
        format_fmt03 = add_record("<18$$$>", "", format_fmt03)
        format_fmt03 = add_record("<20$$$>", "7", format_fmt03)
      end
    end
    format_fmt03 = add_record("<19$$$>",str19,format_fmt03)

    # 仲裁庭组成情况
    if aribitprog_num == '0002' or aribitprog_num == '0004' or aribitprog_num == '0006' or aribitprog_num == '0008'
      str11 = "仲裁庭组成情况：由本会主任指定" + PubTool.arbitrator(code,'0001') + get_arbitman_sex(code,'0001') + "担任独任仲裁员"
    else
      # 申请人的仲裁员
      arbit_man1 = TbCasearbitman.find(:first, :conditions => ["used='Y' and recevice_code=? and arbitmantype=?", code, '0003'])
      if arbit_man1 != nil
        if arbit_man1.arbitmansign != '0005' # 代指定
          stra = "申请人" + TbDictionary.find(:first, :conditions => ["state='Y' and typ_code='0015'",'0003']).data_text + PubTool.arbitrator(code,'0003') + get_arbitman_sex(code,'0003') + "作为本案仲裁员"
        else
          stra = "本会主任代申请人指定" + PubTool.arbitrator(code,'0003') + get_arbitman_sex(code,'0003') + "作为本案仲裁员"
        end
      else
        stra = "申请人选定_____作为本案仲裁员"
      end
      # 被申请人的仲裁员
      arbit_man2 = TbCasearbitman.find(:first, :conditions => ["used='Y' and recevice_code=? and arbitmantype=?", code, '0004'])
      if arbit_man2 != nil
        if arbit_man2.arbitmansign != '0005' # 代指定
          strb = "，被申请人" + TbDictionary.find(:first, :conditions => ["state='Y' and typ_code='0015'",'0004']).data_text+PubTool.arbitrator(code,'0004') + get_arbitman_sex(code,'0004')+"作为本案仲裁员"
        else
          strb = "，本会主任代被申请人指定" + PubTool.arbitrator(code,'0004') + get_arbitman_sex(code,'0004') + "作为本案仲裁员"
        end
      else
        strb = "，被申请人选定_____作为本案仲裁员"
      end
      str11 = "仲裁庭组成情况：" + stra + strb + "，由本会主任指定" + PubTool.arbitrator(code,'0002') + get_arbitman_sex(code,'0002')+"担任首席仲裁员"
    end

    # 仲裁员更换
    change = ""
    tb_change = TbChange.find(:all, :conditions => ["used='Y' and recevice_code=?", code])
    for ch in tb_change
      if ch != nil
        ar1 = TbArbitman.find(:first, :conditions => ["used='Y' and code=?", ch.arbitman_1]) # 更换前的仲裁员
        ar2 = TbArbitman.find(:first, :conditions => ["used='Y' and code=?", ch.arbitman])   # 更换后的仲裁员
        end_date   = ch.changedate.to_s.split("-")
        end_date[0] = end_date[0].to_s + "年"
        end_date[1] = end_date[1].to_s + "月"
        end_date[2] = end_date[2].to_s + "日"
        change_1   = end_date[0] + end_date[1] + end_date[2]
        change_2   = TbDictionary.find(:first, :conditions => ["state='Y' and typ_code='0014' and data_val=?",ch.arbitmantype]).data_text
        if ar1 != nil
          change_3 = ar1.name
        end
        if ar2 != nil
          change_4 = ar2.name
        end
        change = change + "（" + change_1 + "，" + change_2 + "：" + change_3 + "更换为" + change_4 + "）"
      end
    end
    str11 = str11 + change
    format_fmt03 = add_record("<11$$$>",str11,format_fmt03)

    #<12$$$>仲裁庭于   年  月   日组成，定于   年   月    日开庭
    @case_date = TbCaseorg.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code], :order => "id desc")
    if @case_date != nil or @case_date == ""
      end_date    = @case_date.orgdate.to_s.split("-")
      end_date[0] = end_date[0].to_s + "年"
      end_date[1] = end_date[1].to_s + "月"
      end_date[2] = end_date[2].to_s + "日"
      @org_date = "仲裁庭于" + end_date[0] + end_date[1] + end_date[2] + "组成"
    else
      @org_date = "仲裁庭于_____年___月___日组成"
    end
    #-----------------------
    @sittingdate = TbArbitroom.find(:first, :conditions => ["used='Y' and recevice_code=?", code], :order => "id desc")
    if @sittingdate != nil
      @sdate  = @sittingdate.sittingdate
      arr_date = @sdate.to_s.split("-")
      @sdate = "，定于" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日开庭"
    else
      @sdate = "，定于____年__月__日开庭"
    end
    str12 = @org_date + @sdate
    format_fmt03 = add_record("<12$$$>", str12, format_fmt03)

    # 申请人/被申请人于  年 月 日提出仲裁员回避申请。本会主任于  年 月 日作出决定
    @evite = TbEvite.find(:first, :conditions => ["used='Y' and recevice_code=?", code], :order => "id desc")
    if @evite != nil
      if @evite.requestdate != nil
        arr_date = @evite.requestdate.to_s.split("-")
        d1 = arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日"
      else
        d1 = "____年__月__日"
      end
      if @evite.dat3 != nil
        arr_date2 = @evite.dat3.to_s.split("-")
        d2 = "本会主任于" + arr_date2[0].to_s + "年" + arr_date2[1].to_s + "月" + arr_date2[2].to_s + "日作出决定"
      else
        d2 = "本会主任尚未作出决定"
      end
      if @evite.submitman == '0001'
        str13 = "申请人于" + d1 + "提出仲裁员回避申请。" + d2
      else
        str13 = "被申请人于" + d1 + "提出仲裁员回避申请。" + d2
      end
    else
      str13 = "申请人/被申请人于_____年___月___日提出仲裁员回避申请。本会主任于_____年___月___日作出决定"
    end
    format_fmt03 = add_record("<13$$$>", str13, format_fmt03)

    # 审限信息 ………………………………………………………………………………………………………………………………………………
    limit_date = current_case.finally_limit_dat
    if limit_date != nil
      arr_date = limit_date.to_s.split("-")
      str21 = "本案审限为" + arr_date[0].to_s + "年" + arr_date[1].to_s + "月" + arr_date[2].to_s + "日。"
    else
      arr_date = limit_date.to_s.split("-")
      str21 = "本案审限为" + "_____年___月___日。"
    end

    format_fmt03 = add_record("<21$$$>", str21, format_fmt03)

    # 仲裁代理人信息
    applicant_agent = get_agent(code,1)
    respondent_agent = get_agent(code,2)
    format_fmt03 = add_record("<22$$$>", applicant_agent.blank? ? "无" : applicant_agent, format_fmt03)
    format_fmt03 = add_record("<23$$$>", respondent_agent.blank? ? "无" : respondent_agent, format_fmt03)

    # 经办人姓名
    if current_case.clerk != ""
      @zl = User.find(:first,:conditions=>["used='Y' and code=?",current_case.clerk])
      format_fmt03 = add_record("<14$$$>",@zl.name,format_fmt03)
    else
      format_fmt03 = add_record("<14$$$>","",format_fmt03)
    end

    # 时间
    @date_of_letter = TbDoc.find(doc_id)
    if @date_of_letter != nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      arr_date[0] = SysArg.n_to_c(arr_date[0].to_i)
      arr_date[1] = SysArg.n_to_md(arr_date[1].to_i)
      arr_date[2] = SysArg.n_to_md(arr_date[2].to_i)
      str15 = arr_date[0] + "年" + arr_date[1] + "月" + arr_date[2] + "日"
    else
      str15 = "_____年___月___日"
    end
    format_fmt03 = add_last_record("<15$$$>",str15,format_fmt03)
  end

  def format_letter_dfmt04(code,doc_id)
    #拼接字串，初始化
    @format_dfmt04 = ""
    #函号--文件编号
    @file_code = get_code1(doc_id)
    @format_dfmt04 = add_record("<01$$$>",@file_code,@format_dfmt04)
    #申请人
    @applicant=applicant(code,1,4)
    @applicant2=applicant(code,2,3)
    @format_dfmt04 = add_record("<02$$$>",@applicant,@format_dfmt04)
    @format_dfmt04 = add_record("<03$$$>",@applicant2,@format_dfmt04)
    #受理日期
    @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code]).receivedate
    if @date_receive == nil or @date_receive == ""
      @date_receive1 = "_____"
      @date_receive2 = "____"
      @date_receive3 = "____"
      @format_dfmt04 = add_record("<04$$$>",@date_receive1,@format_dfmt04)
      @format_dfmt04 = add_record("<05$$$>",@date_receive2,@format_dfmt04)
      @format_dfmt04 = add_record("<06$$$>",@date_receive3,@format_dfmt04)
    else
      arr_date = @date_receive.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @format_dfmt04 = add_record("<04$$$>",arr_date[0],@format_dfmt04)
      @format_dfmt04 = add_record("<05$$$>",arr_date[1],@format_dfmt04)
      @format_dfmt04 = add_record("<06$$$>",arr_date[2],@format_dfmt04)
    end
    #被申请人
    @respondent=respondent(code,1,4)
    @format_dfmt04 = add_record("<07$$$>",@respondent,@format_dfmt04)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt04 = add_record("<08$$$>",@contract_name,@format_dfmt04)
    #受理费
    @litigation_fee = applicant_litigation_fee(code)
    #处理费
    @processing_fee = applicant_arbit_fee(code)
    #办案费用合计（0002、0003）
    @total_fee = @litigation_fee + @processing_fee
    #金额格式化
    @litigation_fee = SysArg.compart1(@litigation_fee)
    @processing_fee = SysArg.compart1(@processing_fee )
    @total_fee = SysArg.compart1(@total_fee)
    @format_dfmt04 = add_record("<09$$$>",@litigation_fee,@format_dfmt04)
    @format_dfmt04 = add_record("<10$$$>",@processing_fee,@format_dfmt04)
    @format_dfmt04 = add_record("<11$$$>",@total_fee,@format_dfmt04)
    #咨询助理
    @zl_name = get_name2(code)+get_zlsex2(code)
    @telephone = get_tel2(code,1)
    @fax = get_fax22(code,1)
    @email = get_email2(code)
    @fax4=get_fax2(code,1)
    @format_dfmt04 = add_record("<12$$$>",@zl_name,@format_dfmt04)
    @format_dfmt04 = add_record("<13$$$>",@telephone,@format_dfmt04)
    @format_dfmt04 = add_record("<14$$$>",@fax,@format_dfmt04)
    @format_dfmt04 = add_record("<15$$$>",@email,@format_dfmt04)
    @format_dfmt04 = add_record("<19$$$>",@fax4,@format_dfmt04)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt04 = add_record("<16$$$>",@y2,@format_dfmt04)
    @format_dfmt04 = add_record("<17$$$>",@m2,@format_dfmt04)
    @format_dfmt04 = add_record("<18$$$>",@d2,@format_dfmt04)
    @accommodate_remarks=get_accommodate_remarks(code,1)
    @accommodate_remarks2=get_accommodate_remarks2(code,1)
    @format_dfmt04 = add_record("<20$$$>",@accommodate_remarks,@format_dfmt04)
    @format_dfmt04 = add_last_record("<21$$$>",@accommodate_remarks2,@format_dfmt04)
  end

  def format_letter_dfmt05(code,doc_id)
    #拼接字串，初始化
    @format_dfmt05 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt05 = add_record("<01$$$>",@file_code,@format_dfmt05)
    #立案号
    @case_code = casecode(code)
    @format_dfmt05 = add_record("<02$$$>",@case_code,@format_dfmt05)
    @format_dfmt05 = add_record("<06$$$>",@case_code,@format_dfmt05)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_dfmt05 = add_record("<03$$$>",@respondents,@format_dfmt05)
    #申请人
    @applicants = applicant(code,1,4)
    @format_dfmt05 = add_record("<04$$$>",@applicants,@format_dfmt05)
    #签订的$$$所引起的争议（合同编号，名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt05 = add_record("<05$$$>",@contract_name,@format_dfmt05)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0002')
    @format_dfmt05 = add_record("<07$$$>",@copies,@format_dfmt05)
    @copies2 = get_number41(code)#get_number2(code,'0002')
    @format_dfmt05 = add_record("<08$$$>",@copies2,@format_dfmt05)
    @format_dfmt05 = add_record("<09$$$>",@copies,@format_dfmt05)
    @format_dfmt05 = add_record("<23$$$>",@copies,@format_dfmt05)
    #    @format_dfmt05 = add_record("<24$$$>",@copies,@format_dfmt05)
    #助理
    @zl_alerk = get_name(code) + get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_dfmt05 = add_record("<10$$$>",@zl_alerk,@format_dfmt05)
    @format_dfmt05 = add_record("<11$$$>",@telephone,@format_dfmt05)
    @format_dfmt05 = add_record("<12$$$>",@fax,@format_dfmt05)
    @format_dfmt05 = add_record("<13$$$>",@email,@format_dfmt05)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt05 = add_record("<14$$$>",@y2,@format_dfmt05)
    @format_dfmt05 = add_record("<15$$$>",@m2,@format_dfmt05)
    @format_dfmt05 = add_record("<16$$$>",@d2,@format_dfmt05)
    @s1=get_accommodate_remarks(code,2)
    @s2=get_accommodate_remarks2(code,2)
    @format_dfmt05 = add_record("<20$$$>",@s1,@format_dfmt05)
    @format_dfmt05 = add_record("<21$$$>",@s2,@format_dfmt05)
    @arbitab=arbitab(code,2)
    @format_dfmt05 = add_record("<22$$$>",@arbitab,@format_dfmt05)
    @party2 = TbParty.count(:id,:conditions=>["used='Y' and recevice_code=? and partytype=2",code])
    if @party2>1
      @rep26 = "共同选定或共同委托"
      @rep27 = "共同选定或共同委托"
    else
      @rep26 = "选定或委托"
      @rep27 = "选定或委托"
    end
    @format_dfmt05 = add_record("<24$$$>",@rep26,@format_dfmt05)
    @format_dfmt05 = add_record("<25$$$>",@rep27,@format_dfmt05)
    @n_p=get_n_party(code,2)
    @format_dfmt05 = add_record("<26$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<27$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<28$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<29$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<30$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<31$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<32$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<33$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<34$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<35$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<36$$$>",@n_p,@format_dfmt05)
    @format_dfmt05 = add_record("<37$$$>",@n_p,@format_dfmt05)
    s38 = arbitac(code,2)
    @format_dfmt05 = add_last_record("<38$$$>",s38,@format_dfmt05)
  end

  def format_letter_dfmt06(code,p_v,doc_id)
    #拼接字串，初始化
    @format_dfmt06 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt06 = add_record("<01$$$>",@file_code,@format_dfmt06)
    #立案号
    @case_code = casecode(code)
    @format_dfmt06 = add_record("<02$$$>",@case_code,@format_dfmt06)
    @format_dfmt06 = add_record("<08$$$>",@case_code,@format_dfmt06)
    #申请人
    @applicants = applicant(code,2,3)
    @format_dfmt06 = add_record("<03$$$>",@applicants,@format_dfmt06)
    #申请人交材料的日期
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日" #get_recevicedate2(code)
    @format_dfmt06 = add_record("<25$$$>",@recevicedate2,@format_dfmt06)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_dfmt06 = add_record("<04$$$>",@respondents,@format_dfmt06)
    #文件份数  p_v=='0001' 发给申请人
    @copies = get_number1(code,'0001')
    @format_dfmt06 = add_record("<05$$$>",@copies,@format_dfmt06)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @format_dfmt06 = add_record("<06$$$>",@arbit_fee,@format_dfmt06)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt06 = add_record("<07$$$>",@contract_name,@format_dfmt06)
    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_dfmt06 = add_record("<09$$$>",@zl_alerk,@format_dfmt06)
    @format_dfmt06 = add_record("<10$$$>",@telephone,@format_dfmt06)
    @format_dfmt06 = add_record("<11$$$>",@fax,@format_dfmt06)
    @format_dfmt06 = add_record("<12$$$>",@email,@format_dfmt06)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt06 = add_record("<13$$$>",@y2,@format_dfmt06)
    @format_dfmt06 = add_record("<14$$$>",@m2,@format_dfmt06)
    @format_dfmt06 = add_record("<15$$$>",@d2,@format_dfmt06)
    @arbitab=arbitab(code,1)
    @format_dfmt06 = add_record("<19$$$>",@arbitab,@format_dfmt06)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="1、NO. " + t_code + "收据"
      @replace22="2、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO." + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_dfmt06 = add_record("<20$$$>",@replace20,@format_dfmt06)
    @format_dfmt06 = add_record("<21$$$>",@replace21,@format_dfmt06)
    @format_dfmt06 = add_record("<22$$$>",@replace22,@format_dfmt06)
    @format_dfmt06 = add_record("<23$$$>",@replace23,@format_dfmt06)
    @format_dfmt06 = add_record("<24$$$>",@replace24,@format_dfmt06)
    @n_p=get_n_party(code,1)
    @format_dfmt06 = add_record("<26$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<27$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<28$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<29$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<30$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<31$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<32$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<33$$$>",@n_p,@format_dfmt06)
    @format_dfmt06 = add_record("<34$$$>",@n_p,@format_dfmt06)
    s35 = arbitac(code,1)
    @format_dfmt06 = add_last_record("<35$$$>",s35,@format_dfmt06)
  end
  ###########################################################################
  #此函带页面选项，有申请人、被申请人、财产、证据之分
  ############################################################################
  #财产保全
  def format_letter_dfmt07ap(code,doc_id)
    #拼接字串，初始化
    @format_dfmt07 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt07 = add_record("<01$$$>",@file_code,@format_dfmt07)
    #立案号
    @case_code = casecode(code)
    @format_dfmt07 = add_record("<02$$$>",@case_code,@format_dfmt07)
    @format_dfmt07 = add_record("<07$$$>",@case_code,@format_dfmt07)
    @tbsave = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed='0002'",code],:order=>"id desc")

    if @tbsave!=nil
      @request_typ = @tbsave.request_typ
      if @request_typ=='0001'   #申请人
        @str1= get_save_party(code,'0001','0002')
        @applicant2 = "申请人" + @str1
        @court=get_save_place(code,'0001','0002')
        @replace21 = "申请人的仲裁申请书一份"
        @replace22 = "申请人"
        @telephone = get_s_tel(code,'0002','0001')
        @fax = get_s_fax(code,'0002','0001')
      else  @request_typ=='0002'   #被申请人
        @applicant2 = "被申请人" + get_save_party(code,'0002','0002')
        @court=get_save_place(code,'0002','0002')
        @replace21 = "被申请人的答辩书一份"
        @replace22 = "被申请人"
        @telephone = get_s_tel(code,'0002','0002')
        @fax = get_s_fax(code,'0002','0001')
      end

      @case = TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
      if @case.aribitprog_num == '0001' or @case.aribitprog_num == '0002' or @case.aribitprog_num == '0005' or @case.aribitprog_num == '0006' #国内案件
        @clause = "《中华人民共和国仲裁法》第二十八条和《最高人民法院关于实施〈中华人民共和国仲裁法〉几个问题的通知》"
      else
        @clause = "《中华人民共和国仲裁法》第二十八条和《中华人民共和国民事诉讼法》第二百五十六条"
      end

    else
      @applicant2 = "申请人/被申请人"
      @clause = "《中华人民共和国仲裁法》第二十八条和《中华人民共和国民事诉讼法》第二百五十六条"
      @court="_____"
      @replace21 = "_________"
      @replace22 = "_________"
      @telephone = get_s_fax(code,'0002','0003')
      @fax = get_s_fax(code,'0002','0003')
    end
    #当事人
    @applicants1 = applicant(code,1,4)
    @format_dfmt07 = add_record("<04$$$>",@applicants1,@format_dfmt07)
    @format_dfmt07 = add_record("<08$$$>",@applicant2,@format_dfmt07)
    @format_dfmt07 = add_record("<11$$$>",get_save_party(code,@request_typ,'0002'),@format_dfmt07)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_dfmt07 = add_record("<05$$$>",@respondents,@format_dfmt07)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt07 = add_record("<06$$$>",@contract_name,@format_dfmt07)
    @format_dfmt07 = add_record("<09$$$>",@court,@format_dfmt07)
    @format_dfmt07 = add_record("<10$$$>",@clause,@format_dfmt07)
    @format_dfmt07 = add_record("<21$$$>",@replace21,@format_dfmt07)
    @format_dfmt07 = add_record("<22$$$>",@replace22,@format_dfmt07)
    @format_dfmt07 = add_record("<23$$$>",@replace22,@format_dfmt07)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @email = get_email(code)
    @format_dfmt07 = add_record("<14$$$>",@zl_alerk,@format_dfmt07)
    @format_dfmt07 = add_record("<13$$$>",@sex,@format_dfmt07)
    @format_dfmt07 = add_record("<15$$$>",@telephone,@format_dfmt07)
    @format_dfmt07 = add_record("<16$$$>",@fax,@format_dfmt07)
    @format_dfmt07 = add_record("<17$$$>",@email,@format_dfmt07)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt07 = add_record("<18$$$>",@y2,@format_dfmt07)
    @format_dfmt07 = add_record("<19$$$>",@m2,@format_dfmt07)
    @format_dfmt07 = add_last_record("<20$$$>",@d2,@format_dfmt07)
  end

  #证据保全
  def format_letter_fmt07ap(code,doc_id)
    #拼接字串，初始化
    @format_fmt07 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt07 = add_record("<01$$$>",@file_code,@format_fmt07)
    #立案号
    @case_code = casecode(code)
    @format_fmt07 = add_record("<02$$$>",@case_code,@format_fmt07)
    @format_fmt07 = add_record("<07$$$>",@case_code,@format_fmt07)
    #申请人
    @applicants = applicant(code,1,4)
    @format_fmt07 = add_record("<04$$$>",@applicants,@format_fmt07)
    #案件信息
    @case = TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])

    @tbsave = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed='0001'",code],:order=>"id desc")
    if @tbsave != nil
      @request_typ = @tbsave.request_typ
      if @request_typ=='0001'   #申请人
        @applicant2 = "申请人" + get_save_party(code,'0001','0001')
        @court=get_save_place(code,'0001','0001')
        @replace21 = "申请人的仲裁申请书一份"
        @replace22 = "申请人"
        @telephone = get_s_tel(code,'0001','0001')
        @fax = get_s_fax(code,'0001','0001')
      else  @request_typ=='0002'   #被申请人
        @applicant2 = "被申请人" + get_save_party(code,'0002','0001')
        @court=get_save_place(code,'0002','0001')
        @replace21 = "被申请人的答辩书一份"
        @replace22 = "被申请人"
        @telephone = get_s_tel(code,'0001','0002')
        @fax = get_s_fax(code,'0001','0002')
      end

      if @case.aribitprog_num == '0001' or @case.aribitprog_num == '0002' or @case.aribitprog_num == '0005' or @case.aribitprog_num == '0006' #国内案件
        @clause = "根据《中华人民共和国仲裁法》第四十六条"
      else
        @clause = "《中华人民共和国仲裁法》第六十八条"
      end

    else
      @applicant2 = "申请人/被申请人"
      @clause = "《中华人民共和国仲裁法》第二十八条和《中华人民共和国民事诉讼法》第二百五十六条"
      @court="_____"
      @replace21 = "_________"
      @replace22 = "_________"
      @telephone = get_s_tel(code,'0001','0003')
      @fax = get_s_fax(code,'0001','0003')
    end
    @format_fmt07 = add_record("<08$$$>",@applicant2,@format_fmt07)
    @format_fmt07 = add_record("<11$$$>",get_save_party(code,@request_typ,'0001'),@format_fmt07)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_fmt07 = add_record("<05$$$>",@respondents,@format_fmt07)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_fmt07 = add_record("<06$$$>",@contract_name,@format_fmt07)
    #条款
    @format_fmt07 = add_record("<09$$$>",@court,@format_fmt07)
    @format_fmt07 = add_record("<10$$$>",@clause,@format_fmt07)
    @format_fmt07 = add_record("<21$$$>",@replace21,@format_fmt07)
    @format_fmt07 = add_record("<22$$$>",@replace22,@format_fmt07)
    @format_fmt07 = add_record("<23$$$>",@replace22,@format_fmt07)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @email = get_email(code)
    @format_fmt07 = add_record("<14$$$>",@zl_alerk,@format_fmt07)
    @format_dfmt07 = add_record("<13$$$>",@sex,@format_fmt07)
    @format_fmt07 = add_record("<15$$$>",@telephone,@format_fmt07)
    @format_fmt07 = add_record("<16$$$>",@fax,@format_fmt07)
    @format_fmt07 = add_record("<17$$$>",@email,@format_fmt07)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt07 = add_record("<18$$$>",@y2,@format_fmt07)
    @format_fmt07 = add_record("<19$$$>",@m2,@format_fmt07)
    @format_fmt07 = add_last_record("<20$$$>",@d2,@format_fmt07)
  end

  #反请求审批表（国内）
  def format_letter_dfmt08(code)
    @format_dfmt08 = ""
    #被申请人
    @respondents = respondent(code,1,4)
    @format_dfmt08 = add_record("<01$$$>",@respondents,@format_dfmt08)
    #提起时间
    str2=PubTool.get_date(code)
    @format_dfmt08 = add_record("<02$$$>",str2,@format_dfmt08)
    #案件编号
    case_code=TbCase.find_by_recevice_code(code).case_code
    str3=case_code.slice(5,case_code.length)
    @format_dfmt08 = add_record("<03$$$>",str3,@format_dfmt08)
    #提起的依据 合同编号
    contract_name = get_contract_name(code)
    @format_dfmt08 = add_record("<04$$$>",contract_name,@format_dfmt08)
    str5=PubTool.get_dear_money(code)
    @format_dfmt08 = add_record("<05$$$>",str5,@format_dfmt08)
    str6=PubTool.get_indefinite_money(code)
    @format_dfmt08 = add_record("<06$$$>",str6,@format_dfmt08)

    #13，14，15 明确、不明确费用
    @litigation_fee20=PubTool.get_litigation_fee(code)#明确,不明确争议金额的  受理费
    @processing_fee20=PubTool.get_processing_fee(code)#......处理费
    @total_money1=@litigation_fee20+@processing_fee20#合计
    #16，17，18  无明确的案件收费费用
    @litigation_fee30=PubTool.get_litigation_fee2(code)#无明确争议金额的 受理费
    @processing_fee30=PubTool.get_processing_fee2(code)#....处理费
    @total_money30=@litigation_fee30+@processing_fee30#合计
    #6，7，8  受理费、处理费分别的合计
    @litigation_fee=@litigation_fee20+@litigation_fee30
    @processing_fee=@processing_fee20+@processing_fee30
    @total_fee=@litigation_fee + @processing_fee
    #以上结果数字分割
    @litigation_fee=SysArg.compart1(@litigation_fee)
    @processing_fee=SysArg.compart1(@processing_fee)
    @total_fee=SysArg.compart1(@total_fee)

    @litigation_fee2=SysArg.compart1(@litigation_fee20)
    @processing_fee2=SysArg.compart1(@processing_fee20)
    @total_money=SysArg.compart1(@total_money1)
    @litigation_fee3=SysArg.compart1(@litigation_fee30)
    if @litigation_fee3=="_____"
      @litigation_fee3=""
    end
    @processing_fee3=SysArg.compart1(@processing_fee30)
    if @processing_fee3=="_____"
      @processing_fee3=""
    end
    @total_money3=SysArg.compart1(@total_money30)
    if @total_money3=="_____"
      @total_money3=""
    end
    @format_dfmt08 = add_record("<13$$$>",@litigation_fee,@format_dfmt08)
    @format_dfmt08 = add_record("<14$$$>",@processing_fee,@format_dfmt08)
    @format_dfmt08 = add_record("<15$$$>",@total_fee,@format_dfmt08)
    @format_dfmt08 = add_record("<09$$$>",@total_money,@format_dfmt08)
    @format_dfmt08 = add_record("<07$$$>",@litigation_fee2,@format_dfmt08)
    @format_dfmt08 = add_record("<08$$$>",@processing_fee2,@format_dfmt08)
    @format_dfmt08 = add_record("<12$$$>",@total_money3,@format_dfmt08)
    @format_dfmt08 = add_record("<10$$$>",@litigation_fee3,@format_dfmt08)
    @format_dfmt08 = add_last_record("<11$$$>",@processing_fee3,@format_dfmt08)
  end
  #反请求审批表（涉外）
  def format_letter_fmt08(code)
    @format_fmt08 = ""
    #被申请人
    @respondents = respondent(code,1,4)
    @format_fmt08 = add_record("<01$$$>",@respondents,@format_fmt08)
    #提起时间
    str2=PubTool.get_date(code)
    @format_fmt08 = add_record("<02$$$>",str2,@format_fmt08)
    #案件编号
    case_code=TbCase.find_by_recevice_code(code).case_code
    str3=case_code.slice(5,case_code.length)
    @format_fmt08 = add_record("<03$$$>",str3,@format_fmt08)
    #提起的依据 合同编号
    contract_name = get_contract_name(code)
    @format_fmt08 = add_record("<04$$$>",contract_name,@format_fmt08)
    str5=PubTool.get_dear_money(code)
    @format_fmt08 = add_record("<05$$$>",str5,@format_fmt08)
    str6=PubTool.get_indefinite_money(code)
    @format_fmt08 = add_record("<06$$$>",str6,@format_fmt08)

    #08 明确、不明确仲裁费用=应收    09：无明确仲裁费用=应收
    #    @str1 = TbShouldCharge.find(:first,:select=>"sum(rmb_money) as rmb_money",:conditions=>["used='Y' and recevice_code=? and payment='0002' and typ='0001' and parent_id=0",code])
    #    @str2 = TbShouldCharge.find(:first,:select=>"sum(rmb_money) as rmb_money",:conditions=>["used='Y' and recevice_code=? and payment='0002' and typ='0004' and parent_id=0",code])
    @str1 = TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and typ='0001' and parent_id=0",code])
    @str2 = TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and typ='0004' and parent_id=0",code])
    if @str1!=nil
      str8 = SysArg.compart1(@str1)
    else
      str8 = ""
    end
    @format_fmt08 = add_record("<08$$$>",str8,@format_fmt08)
    if @str2!=nil
      str9 = SysArg.compart1(@str2)
    else
      str9 = ""
    end
    @format_fmt08 = add_record("<09$$$>",str9,@format_fmt08)
    if @str1!=nil and @str2!=nil
      str7 = SysArg.compart1(@str1 + @str2)
    elsif @str1!=nil and @str2==nil
      str7 = SysArg.compart1(@str1)
    elsif @str1==nil and @str2!=nil
      str7 = SysArg.compart1(@str2)
    else
      str7 = ""
    end

    @format_fmt08 = add_record("<07$$$>",str7,@format_fmt08)
    @t_detail=TbCaseAmountDetail.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype='2' and currency<>'0001'",code],:select=>"distinct(currency) as currency,rate")
    str10=""
    @t_detail.each do |de|
      str10 = str10 + PubTool.get_sign(de.currency) + de.rate.to_s + "  "
    end
    @format_fmt08 = add_last_record("<10$$$>",str10,@format_fmt08)
  end
  #其它实际费用开支费
  ################################# 空缺 ################################
  def format_letter_dfmt09(code,doc_id)
    #拼接字串，初始化
    @format_dfmt09 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt09 = add_record("<01$$$>",@file_code,@format_dfmt09)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_dfmt09 = add_record("<02$$$>",@respondents,@format_dfmt09)
    #立案号
    @case_code = casecode(code)
    @format_dfmt09 = add_record("<03$$$>",@case_code,@format_dfmt09)
    #被申请人受理费
    @litigation_fee = respondent_litigation_fee(code)
    #被申请人处理费
    @processing_fee = respondent_arbit_fee(code)
    #其它实际费用开支费
    ################################# 空缺 ################################
    #    @other_fee = respondent_other_fee(code)
    #合计
    @total_fee = @litigation_fee+ @processing_fee
    @litigation_fee=SysArg.compart1(@litigation_fee)
    @processing_fee=SysArg.compart1(@processing_fee)
    #    @other_fee=SysArg.compart1(@other_fee)   其他实际费用开支费 去掉
    @total_fee=SysArg.compart1(@total_fee)
    @format_dfmt09 = add_record("<04$$$>",@litigation_fee,@format_dfmt09)
    @format_dfmt09 = add_record("<05$$$>",@processing_fee,@format_dfmt09)
    #    @format_dfmt09 = add_record("<06$$$>",@other_fee,@format_dfmt09)
    @format_dfmt09 = add_record("<07$$$>",@total_fee,@format_dfmt09)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt09 = add_record("<08$$$>",@y2,@format_dfmt09)
    @format_dfmt09 = add_record("<09$$$>",@m2,@format_dfmt09)
    @format_dfmt09 = add_record("<10$$$>",@d2,@format_dfmt09)
    @fax2=get_fax2(code,2)
    @format_dfmt09 = add_last_record("<11$$$>",@fax2,@format_dfmt09)
  end
  #所有案件类型   预缴实际开支费用通知单
  def format_letter_dfmt26(code,p_v,doc_id)
    #拼接字串，初始化
    @format_dfmt26 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt26 = add_record("<01$$$>",@file_code,@format_dfmt26)
    #立案号
    @case_code = casecode(code)
    @format_dfmt26 = add_record("<03$$$>",@case_code,@format_dfmt26)
    #当事人 仲裁员
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'#普通案件
      if p_v=='0001'
        @party1 = applicant(code,2,3)
        if get_style_from(code,'0003')=="代指定"
          @rep9 = "本会主任"
          @independent_arbitrator="代你方指定" + applicant_arbitrator(code) + get_arbitman_sex(code,'0003')
        else
          @rep9 = "你方"
          @independent_arbitrator=get_style_from(code,'0003') + applicant_arbitrator(code) + get_arbitman_sex(code,'0003')
        end
        @replace5 = "仲裁员"
        @arbitman_fee = TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,'0003'])
        if @arbitman_fee!=nil
          @rep11 = "请你方预缴仲裁员实际开支费用" + @arbitman_fee.currency + SysArg.compart1(@arbitman_fee.f_money) + "元"
        else
          @rep11 = "请你方预缴仲裁员实际开支费用人民币_____元"
        end
      elsif p_v=='0002'
        @party1 = respondent(code,2,3)
        if get_style_from(code,'0004')=="代指定"
          @rep9 = "本会主任"
          @independent_arbitrator="代你方指定" + respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
        else
          @rep9 = "你方"
          @independent_arbitrator=get_style_from(code,'0004') + respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
        end
        @replace5 = "仲裁员"
        @arbitman_fee = TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,'0004'])
        if @arbitman_fee!=nil
          @rep11 = "请你方预缴仲裁员实际开支费用" + @arbitman_fee.currency + SysArg.compart1(@arbitman_fee.f_money) + "元"
        else
          @rep11 = "请你方预缴仲裁员实际开支费用人民币_____元"
        end
      else
        @party1 = applicant(code,2,3) + '\r' + respondent(code,2,3)
        if get_style_from(code,'0002')=="代指定"
          @rep9 = "本会主任"
          @independent_arbitrator="代双方指定" + chief_arbitrator(code) + get_arbitman_sex(code,'0002')
        else
          @rep9 = "双方"
          @independent_arbitrator=get_style_from(code,'0002') + chief_arbitrator(code) + get_arbitman_sex(code,'0002')
        end
        @replace5 = "首席仲裁员"
        @arbitman_fee = TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,'0002'])
        if @arbitman_fee!=nil
          @nam = @arbitman_fee.currency
        else
          @nam = "_____"
        end
        if @arbitman_fee!=nil
          @f1 = SysArg.compart1(@arbitman_fee.f_money/2)
        else
          @f1 = "_____"
        end
        if @arbitman_fee!=nil
          @rep11 = "你们双方应各半预缴首席仲裁员实际开支费用" + @nam + @f1 + "元"
        else
          @rep11 = "你们双方应各半预缴首席仲裁员实际开支费用人民币_____元"
        end
      end
    else#简易案件;就一个选项--双方,不需要显示选项
      @party1 = applicant(code,2,3) + '\r' + respondent(code,2,3)
      if get_style_from(code,'0001')=="代指定"
        @rep9 = "本会主任"
        @independent_arbitrator="代双方指定" + independent_arbitrator(code) + get_arbitman_sex(code,'0001')
      else
        @rep9 = "双方"
        @independent_arbitrator=get_style_from(code,'0001') + independent_arbitrator(code) + get_arbitman_sex(code,'0001')
      end
      @replace5 = "独任仲裁员"
      @arbitman_fee = TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,'0001'])
      if @arbitman_fee!=nil
        @rep11 = "你们双方应各半预缴独任仲裁员实际开支费用" + @arbitman_fee.currency + SysArg.compart1(@arbitman_fee.f_money/2) + "元"
      else
        @rep11 = "你们双方应各半预缴独任仲裁员实际开支费用人民币_____元"
      end
    end
    @format_dfmt26 = add_record("<02$$$>",@party1,@format_dfmt26)
    @format_dfmt26 = add_record("<09$$$>",@rep9,@format_dfmt26)
    @format_dfmt26 = add_record("<04$$$>",@independent_arbitrator,@format_dfmt26)
    @format_dfmt26 = add_record("<05$$$>",@replace5,@format_dfmt26)
    @format_dfmt26 = add_record("<11$$$>",@rep11,@format_dfmt26)
    @format_dfmt26 = add_record("<12$$$>",@replace5,@format_dfmt26)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt26 = add_record("<06$$$>",@y2,@format_dfmt26)
    @format_dfmt26 = add_record("<07$$$>",@m2,@format_dfmt26)
    @format_dfmt26 = add_record("<08$$$>",@d2,@format_dfmt26)
    if p_v=='0001'
      @fax2=get_fax2(code,1)
    elsif p_v=='0002'
      @fax2=get_fax2(code,2)
    else  #选择双方时的传真区号
      @fax2=get_fax2(code,3) #显示0755
    end
    @format_dfmt26 = add_last_record("<10$$$>",@fax2,@format_dfmt26)
  end

  def format_letter_dfmt31(code,doc_id)
    #拼接字串，初始化
    @format_dfmt31 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt31 = add_record("<01$$$>",@file_code,@format_dfmt31)
    #立案号
    @case_code = casecode(code)
    @format_dfmt31 = add_record("<02$$$>",@case_code,@format_dfmt31)
    @format_dfmt31 = add_record("<06$$$>",@case_code,@format_dfmt31)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_dfmt31 = add_record("<03$$$>",@respondents,@format_dfmt31)
    #申请人
    @applicants = applicant(code,1,4)
    @format_dfmt31 = add_record("<04$$$>",@applicants,@format_dfmt31)
    #签订的$$$所引起的争议（合同名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt31 = add_record("<05$$$>",@contract_name,@format_dfmt31)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0002')
    @format_dfmt31 = add_record("<07$$$>",@copies,@format_dfmt31)
    @copies2 = get_number41(code)#get_number2(code,'0002')
    @format_dfmt31 = add_record("<08$$$>",@copies2,@format_dfmt31)
    @format_dfmt31 = add_record("<09$$$>",@copies,@format_dfmt31)
    @format_dfmt31 = add_record("<10$$$>",@copies,@format_dfmt31)
    #    @format_dfmt31 = add_record("<23$$$>",@copies,@format_dfmt31)
    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_dfmt31 = add_record("<11$$$>",@zl_alerk,@format_dfmt31)
    @format_dfmt31 = add_record("<12$$$>",@telephone,@format_dfmt31)
    @format_dfmt31 = add_record("<13$$$>",@fax,@format_dfmt31)
    @format_dfmt31 = add_record("<14$$$>",@email,@format_dfmt31)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt31 = add_record("<15$$$>",@y2,@format_dfmt31)
    @format_dfmt31 = add_record("<16$$$>",@m2,@format_dfmt31)
    @format_dfmt31 = add_record("<17$$$>",@d2,@format_dfmt31)
    @code11=get_accommodate_remarks(code,2)
    @code22=get_accommodate_remarks2(code,2)
    @format_dfmt31 = add_record("<18$$$>",@code11,@format_dfmt31)
    @format_dfmt31 = add_record("<19$$$>",@code22,@format_dfmt31)
    @n_p=get_n_party(code,2)
    @format_dfmt31 = add_record("<20$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<21$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<22$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<23$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<24$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<25$$$>",@n_p,@format_dfmt31)
    @format_dfmt31 = add_record("<26$$$>",@n_p,@format_dfmt31)
    s27=arbitac(code,2)
    @format_dfmt31 = add_last_record("<27$$$>",s27,@format_dfmt31)
  end
  #发给申请人
  def format_letter_dfmt32(code,p_v,doc_id)
    #拼接字串，初始化
    @format_dfmt32 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_dfmt32 = add_record("<01$$$>",@file_code,@format_dfmt32)
    #立案号
    @case_code = casecode(code)
    @format_dfmt32 = add_record("<02$$$>",@case_code,@format_dfmt32)
    @format_dfmt32 = add_record("<08$$$>",@case_code,@format_dfmt32)
    #申请人
    @applicants = applicant(code,2,3)
    @format_dfmt32 = add_record("<03$$$>",@applicants,@format_dfmt32)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_dfmt32 = add_record("<04$$$>",@respondents,@format_dfmt32)
    #文件份数
    @copies = get_number1(code,'0001')
    @format_dfmt32 = add_record("<05$$$>",@copies,@format_dfmt32)
    #申请人交材料的日期
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日"
    @format_dfmt32 = add_record("<25$$$>",@recevicedate2,@format_dfmt32)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee = "人民币" + SysArg.compart1(@arbit_fee)
    @format_dfmt32 = add_record("<06$$$>",@arbit_fee,@format_dfmt32)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_dfmt32 = add_record("<07$$$>",@contract_name,@format_dfmt32)

    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_dfmt32 = add_record("<09$$$>",@zl_alerk,@format_dfmt32)
    @format_dfmt32 = add_record("<10$$$>",@telephone,@format_dfmt32)
    @format_dfmt32 = add_record("<11$$$>",@fax,@format_dfmt32)
    @format_dfmt32 = add_record("<12$$$>",@email,@format_dfmt32)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_dfmt32 = add_record("<13$$$>",@y2,@format_dfmt32)
    @format_dfmt32 = add_record("<14$$$>",@m2,@format_dfmt32)
    @format_dfmt32 = add_record("<15$$$>",@d2,@format_dfmt32)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="1、NO. " + t_code + "收据"
      @replace22="2、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_dfmt32 = add_record("<20$$$>",@replace20,@format_dfmt32)
    @format_dfmt32 = add_record("<21$$$>",@replace21,@format_dfmt32)
    @format_dfmt32 = add_record("<22$$$>",@replace22,@format_dfmt32)
    @format_dfmt32 = add_record("<23$$$>",@replace23,@format_dfmt32)
    @format_dfmt32 = add_record("<24$$$>",@replace24,@format_dfmt32)
    s26 = arbitac(code,1)
    @format_dfmt32 = add_last_record("<26$$$>",s26,@format_dfmt32)
  end

  def format_letter_dfor03(code)
    #拼接字串，初始化
    @format_dfor03 = ""
    #申请人
    @applicants = applicant(code,1,4)
    @format_dfor03 = add_record("<01$$$>",@applicants,@format_dfor03)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_dfor03 = add_record("<02$$$>",@respondents,@format_dfor03)
    #案由及类别
    @casetype = get_casetype_num(code)
    @format_dfor03 = add_record("<03$$$>",@casetype,@format_dfor03)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_name(code)
    @format_dfor03 = add_record("<04$$$>",@contract_name,@format_dfor03)
    #明确争议金额
    @sum_1 = get_dear_money(code)
    @format_dfor03 = add_record("<05$$$>",@sum_1,@format_dfor03)
    #不明确争议金额 RMB  USD  HKD
    @sum_2=get_indefinite_money(code)
    @format_dfor03 = add_record("<22$$$>",@sum_2,@format_dfor03)
    ####################
    @casetype_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @num=@casetype_num.aribitprog_num
    if @num=='0001' or  @num=='0003'
      @num1="普通程序"
    elsif @num=='0002' or  @num=='0004'
      @num1="简易程序"
    else
      @num1="金融规则"
    end
    @sdate=get_contract_date(code)
    @format_dfor03 = add_record("<09$$$>",@sdate,@format_dfor03)
    @format_dfor03 = add_record("<10$$$>",@num1,@format_dfor03)
    @casetype2 = get_casetype_num2(code)
    @format_dfor03 = add_record("<12$$$>",@casetype2,@format_dfor03)
    #13，14，15 明确、不明确费用
    @litigation_fee20=get_litigation_fee(code)#明确,不明确争议金额的  受理费
    @processing_fee20=get_processing_fee(code)#......处理费
    @total_money1=@litigation_fee20+@processing_fee20#合计
    #16，17，18  无明确的案件收费费用
    @litigation_fee30=get_litigation_fee2(code)#无明确争议金额的 受理费
    @processing_fee30=get_processing_fee2(code)#....处理费
    @total_money30=@litigation_fee30+@processing_fee30#合计
    #6，7，8  受理费、处理费分别的合计
    @litigation_fee=@litigation_fee20+@litigation_fee30
    @processing_fee=@processing_fee20+@processing_fee30
    @total_fee=@litigation_fee + @processing_fee
    #以上结果数字分割
    @litigation_fee=SysArg.compart1(@litigation_fee)
    @processing_fee=SysArg.compart1(@processing_fee)
    @total_fee=SysArg.compart1(@total_fee)

    @litigation_fee2=SysArg.compart1(@litigation_fee20)
    @processing_fee2=SysArg.compart1(@processing_fee20)
    @total_money=SysArg.compart1(@total_money1)
    @litigation_fee3=SysArg.compart1(@litigation_fee30)
    if @litigation_fee3=="_____"
      @litigation_fee3=""
    end
    @processing_fee3=SysArg.compart1(@processing_fee30)
    if @processing_fee3=="_____"
      @processing_fee3=""
    end
    @total_money3=SysArg.compart1(@total_money30)
    if @total_money3=="_____"
      @total_money3=""
    end
    @format_dfor03 = add_record("<06$$$>",@litigation_fee,@format_dfor03)
    @format_dfor03 = add_record("<07$$$>",@processing_fee,@format_dfor03)
    @format_dfor03 = add_record("<08$$$>",@total_fee,@format_dfor03)
    @format_dfor03 = add_record("<13$$$>",@total_money,@format_dfor03)
    @format_dfor03 = add_record("<14$$$>",@litigation_fee2,@format_dfor03)
    @format_dfor03 = add_record("<15$$$>",@processing_fee2,@format_dfor03)
    @format_dfor03 = add_record("<16$$$>",@total_money3,@format_dfor03)
    @format_dfor03 = add_record("<17$$$>",@litigation_fee3,@format_dfor03)
    @format_dfor03 = add_record("<18$$$>",@processing_fee3,@format_dfor03)
    @con_year3=get_con_year31(code)
    @con_month3=get_con_month31(code)
    @con_day3=get_con_day31(code)
    @format_dfor03 = add_record("<19$$$>",@con_year3,@format_dfor03)
    @format_dfor03 = add_record("<20$$$>",@con_month3,@format_dfor03)
    @format_dfor03 = add_record("<21$$$>",@con_day3,@format_dfor03)
    @sty1 = get_orgstyle(code)
    @format_dfor03 = add_record("<23$$$>",@sty1,@format_dfor03)
    @nu1 = get_number11(code,'0001')
    @format_dfor03 = add_record("<24$$$>",@nu1,@format_dfor03)
    @format_dfor03 = add_record("<25$$$>",@nu1,@format_dfor03)
    @format_dfor03 = add_record("<26$$$>",@nu1,@format_dfor03)
    @format_dfor03 = add_record("<27$$$>",@nu1,@format_dfor03)
    @re = get_remark(code)
    @format_dfor03 = add_last_record("<28$$$>",@re,@format_dfor03)
  end

  ##########################################################################
  #涉外案件
  ##########################################################################
  def format_letter_fmt04(code,doc_id)
    #拼接字串，初始化
    @format_fmt04 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt04 = add_record("<01$$$>",@file_code,@format_fmt04)
    #申请人
    @applicant2 = applicant(code,2,3)
    @applicant3 = applicant(code,1,4)
    @format_fmt04 = add_record("<02$$$>",@applicant3,@format_fmt04)
    @format_fmt04 = add_record("<03$$$>",@applicant2,@format_fmt04)
    #受理日期
    @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code]).receivedate
    if @date_receive == nil or @date_receive == ""
      @date_receive = "_____"
      @format_fmt04 = add_record("<04$$$>",@date_receive,@format_fmt04)
      @format_fmt04 = add_record("<05$$$>",@date_receive,@format_fmt04)
      @format_fmt04 = add_record("<06$$$>",@date_receive,@format_fmt04)
    else
      arr_date = @date_receive.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @format_fmt04 = add_record("<04$$$>",arr_date[0],@format_fmt04)
      @format_fmt04 = add_record("<05$$$>",arr_date[1],@format_fmt04)
      @format_fmt04 = add_record("<06$$$>",arr_date[2],@format_fmt04)
    end

    #被申请人
    @respondents = respondent(code,1,4)
    @format_fmt04 = add_record("<07$$$>",@respondents,@format_fmt04)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @cont_name =  get_contract_nd(code)
    @format_fmt04 = add_record("<08$$$>",@cont_name,@format_fmt04)
    #仲裁费
    @arbit_fee = applicant_arbit_fee(code)
    #立案费
    @litigation_fee = applicant_litigation_fee(code)
    #合计
    @total_fee = @litigation_fee + @arbit_fee
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @litigation_fee=SysArg.compart1(@litigation_fee)
    @total_fee=SysArg.compart1(@total_fee)
    @format_fmt04 = add_record("<09$$$>",@arbit_fee,@format_fmt04)
    @format_fmt04 = add_record("<10$$$>",@litigation_fee,@format_fmt04)
    @format_fmt04 = add_record("<12$$$>",@total_fee,@format_fmt04)
    #助理
    @zl_alerk = get_name2(code)
    @sex = get_zlsex2(code)
    @telephone = get_tel2(code,1)
    @fax = get_fax22(code,1)
    @email = get_email2(code)
    @format_fmt04 = add_record("<13$$$>",@zl_alerk,@format_fmt04)
    @format_fmt04 = add_record("<11$$$>",@sex,@format_fmt04)
    @format_fmt04 = add_record("<14$$$>",@telephone,@format_fmt04)
    @format_fmt04 = add_record("<15$$$>",@fax,@format_fmt04)
    @format_fmt04 = add_record("<16$$$>",@email,@format_fmt04)
    #日期
    @date_of_letter =TbDoc.find(doc_id).ss_t # Time.now.to_s(:db)
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt04 = add_record("<17$$$>",@y2,@format_fmt04)
    @format_fmt04 = add_record("<18$$$>",@m2,@format_fmt04)
    @format_fmt04 = add_record("<19$$$>",@d2,@format_fmt04)
    @fax2=get_fax2(code,1)
    @format_fmt04 = add_record("<20$$$>",@fax2,@format_fmt04)
    @accommodate_remarks=get_accommodate_remarks(code,1)
    @accommodate_remarks2=get_accommodate_remarks2(code,1)
    @format_fmt04 = add_record("<21$$$>",@accommodate_remarks,@format_fmt04)
    @format_fmt04 = add_last_record("<22$$$>",@accommodate_remarks2,@format_fmt04)
  end
  #仲裁申请受理通知书——金融案件
  def format_letter_ft04(code,doc_id)
    #拼接字串，初始化
    @format_ft04 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_ft04 = add_record("<01$$$>",@file_code,@format_ft04)
    #申请人
    @applicant2 = applicant(code,2,3)
    @applicant3 = applicant(code,1,4)
    @format_ft04 = add_record("<02$$$>",@applicant3,@format_ft04)
    @format_ft04 = add_record("<03$$$>",@applicant2,@format_ft04)
    #受理日期
    @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code]).receivedate
    if @date_receive == nil or @date_receive == ""
      @date_receive = "_____"
      @format_ft04 = add_record("<04$$$>",@date_receive,@format_ft04)
      @format_ft04 = add_record("<05$$$>",@date_receive,@format_ft04)
      @format_ft04 = add_record("<06$$$>",@date_receive,@format_ft04)
    else
      arr_date = @date_receive.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @format_ft04 = add_record("<04$$$>",arr_date[0],@format_ft04)
      @format_ft04 = add_record("<05$$$>",arr_date[1],@format_ft04)
      @format_ft04 = add_record("<06$$$>",arr_date[2],@format_ft04)
    end

    #被申请人
    @respondents = respondent(code,1,4)
    @format_ft04 = add_record("<07$$$>",@respondents,@format_ft04)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @cont_name =  get_contract_nd(code)
    @format_ft04 = add_record("<08$$$>",@cont_name,@format_ft04)
    #仲裁费
    @arbit_fee = applicant_arbit_fee(code)
    #立案费
    @litigation_fee = applicant_litigation_fee(code)
    #合计
    @total_fee = @litigation_fee + @arbit_fee
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @litigation_fee=SysArg.compart1(@litigation_fee)
    @total_fee=SysArg.compart1(@total_fee)
    @format_ft04 = add_record("<09$$$>",@arbit_fee,@format_ft04)
    @format_ft04 = add_record("<10$$$>",@litigation_fee,@format_ft04)
    @format_ft04 = add_record("<12$$$>",@total_fee,@format_ft04)
    #助理
    @zl_alerk = get_name2(code)
    @sex = get_zlsex2(code)
    @telephone = get_tel2(code,1)
    @fax = get_fax22(code,1)
    @email = get_email2(code)
    @format_ft04 = add_record("<13$$$>",@zl_alerk,@format_ft04)
    @format_ft04 = add_record("<11$$$>",@sex,@format_ft04)
    @format_ft04 = add_record("<14$$$>",@telephone,@format_ft04)
    @format_ft04 = add_record("<15$$$>",@fax,@format_ft04)
    @format_ft04 = add_record("<16$$$>",@email,@format_ft04)
    #日期
    @date_of_letter =TbDoc.find(doc_id).ss_t # Time.now.to_s(:db)
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_ft04 = add_record("<17$$$>",@y2,@format_ft04)
    @format_ft04 = add_record("<18$$$>",@m2,@format_ft04)
    @format_ft04 = add_record("<19$$$>",@d2,@format_ft04)
    @fax2=get_fax2(code,1)
    @format_ft04 = add_record("<20$$$>",@fax2,@format_ft04)
    @accommodate_remarks=get_accommodate_remarks(code,1)
    @accommodate_remarks2=get_accommodate_remarks2(code,1)
    @format_ft04 = add_record("<21$$$>",@accommodate_remarks,@format_ft04)
    @format_ft04 = add_last_record("<22$$$>",@accommodate_remarks2,@format_ft04)
  end
  #仲裁通知（被申请人） 涉外普通
  def format_letter_fmt05(code,doc_id)
    #拼接字串，初始化
    @format_fmt05 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt05 = add_record("<01$$$>",@file_code,@format_fmt05)
    #立案号
    @case_code = casecode(code)
    @format_fmt05 = add_record("<02$$$>",@case_code,@format_fmt05)
    @format_fmt05 = add_record("<06$$$>",@case_code,@format_fmt05)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt05 = add_record("<03$$$>",@respondents,@format_fmt05)
    #申请人
    @applicants = applicant(code,1,4)
    @format_fmt05 = add_record("<04$$$>",@applicants,@format_fmt05)
    #签订的$$$所引起的争议（合同名称）
    @contract_name = get_contract_nd(code)
    @format_fmt05 = add_record("<05$$$>",@contract_name,@format_fmt05)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0001')
    @format_fmt05 = add_record("<07$$$>",@copies,@format_fmt05)
    @copies2 = get_number41(code)#get_number2(code,'0001')
    @format_fmt05 = add_record("<08$$$>",@copies2,@format_fmt05)
    @format_fmt05 = add_record("<09$$$>",@copies,@format_fmt05)
    @format_fmt05 = add_record("<23$$$>",@copies,@format_fmt05)
    @format_fmt05 = add_record("<28$$$>",@copies,@format_fmt05)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_fmt05 = add_record("<10$$$>",@zl_alerk,@format_fmt05)
    @format_fmt05 = add_record("<25$$$>",@sex,@format_fmt05)
    @format_fmt05 = add_record("<11$$$>",@telephone,@format_fmt05)
    @format_fmt05 = add_record("<12$$$>",@fax,@format_fmt05)
    @format_fmt05 = add_record("<13$$$>",@email,@format_fmt05)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt05 = add_record("<14$$$>",@y2,@format_fmt05)
    @format_fmt05 = add_record("<15$$$>",@m2,@format_fmt05)
    @format_fmt05 = add_record("<16$$$>",@d2,@format_fmt05)
    @s1=get_accommodate_remarks(code,2)
    @s2=get_accommodate_remarks2(code,2)
    @format_fmt05 = add_record("<20$$$>",@s1,@format_fmt05)
    @format_fmt05 = add_record("<21$$$>",@s2,@format_fmt05)
    @arbitab=arbitab(code,2)
    @format_fmt05 = add_record("<22$$$>",@arbitab,@format_fmt05)
    @ac = arbitac(code,2)
    @format_fmt05 = add_record("<24$$$>",@ac,@format_fmt05)
    @party2 = TbParty.count(:id,:conditions=>["used='Y' and recevice_code=? and partytype=2",code])
    if @party2>1
      @rep26 = "共同选定或共同委托"
      @rep27 = "共同选定或共同委托"
    else
      @rep26 = "选定或委托"
      @rep27 = "选定或委托"
    end
    @format_fmt05 = add_record("<26$$$>",@rep26,@format_fmt05)
    @format_fmt05 = add_record("<27$$$>",@rep27,@format_fmt05)
    @n_p=get_n_party(code,2)
    @format_fmt05 = add_record("<29$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<30$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<31$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<32$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<33$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<34$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<35$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<36$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<37$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<38$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_record("<39$$$>",@n_p,@format_fmt05)
    @format_fmt05 = add_last_record("<40$$$>",@n_p,@format_fmt05)
  end
  #仲裁通知（被申请人） 金融规则案件3人
  def format_letter_ft05(code,doc_id)
    #拼接字串，初始化
    @format_ft05 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_ft05 = add_record("<01$$$>",@file_code,@format_ft05)
    #立案号
    @case_code = casecode(code)
    @format_ft05 = add_record("<02$$$>",@case_code,@format_ft05)
    @format_ft05 = add_record("<06$$$>",@case_code,@format_ft05)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_ft05 = add_record("<03$$$>",@respondents,@format_ft05)
    #申请人
    @applicants = applicant(code,1,4)
    @format_ft05 = add_record("<04$$$>",@applicants,@format_ft05)
    #签订的$$$所引起的争议（合同名称）
    @contract_name = get_contract_nd(code)
    @format_ft05 = add_record("<05$$$>",@contract_name,@format_ft05)
    @format_ft05 = add_record("<42$$$>",@contract_name,@format_ft05)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0001')
    @format_ft05 = add_record("<07$$$>",@copies,@format_ft05)
    @copies2 = get_number41(code)#get_number2(code,'0001')
    @format_ft05 = add_record("<08$$$>",@copies2,@format_ft05)
    @format_ft05 = add_record("<09$$$>",@copies,@format_ft05)
    @format_ft05 = add_record("<23$$$>",@copies,@format_ft05)
    @format_ft05 = add_record("<28$$$>",@copies,@format_ft05)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_ft05 = add_record("<10$$$>",@zl_alerk,@format_ft05)
    @format_ft05 = add_record("<25$$$>",@sex,@format_ft05)
    @format_ft05 = add_record("<11$$$>",@telephone,@format_ft05)
    @format_ft05 = add_record("<12$$$>",@fax,@format_ft05)
    @format_ft05 = add_record("<13$$$>",@email,@format_ft05)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_ft05 = add_record("<14$$$>",@y2,@format_ft05)
    @format_ft05 = add_record("<15$$$>",@m2,@format_ft05)
    @format_ft05 = add_record("<16$$$>",@d2,@format_ft05)
    @s1=get_accommodate_remarks(code,2)
    @s2=get_accommodate_remarks2(code,2)
    @format_ft05 = add_record("<20$$$>",@s1,@format_ft05)
    @format_ft05 = add_record("<21$$$>",@s2,@format_ft05)
    @arbitab=arbitab(code,2)
    @format_ft05 = add_record("<22$$$>",@arbitab,@format_ft05)
    @party2 = TbParty.count(:id,:conditions=>["used='Y' and recevice_code=? and partytype=2",code])
    if @party2>1
      @rep26 = "共同选定或共同委托"
      @rep27 = "共同选定或共同委托"
    else
      @rep26 = "选定或委托"
      @rep27 = "选定或委托"
    end
    @format_ft05 = add_record("<26$$$>",@rep26,@format_ft05)
    @n_p=get_n_party(code,2)
    @format_ft05 = add_record("<29$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<30$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<31$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<32$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<33$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<34$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<37$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<39$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<40$$$>",@n_p,@format_ft05)
    @format_ft05 = add_record("<41$$$>",@n_p,@format_ft05)
    #一名/三名； 独任/首席； 替换
    #    @an=TbCase.find_by_recevice_code(code).aribitprog_num
    #    if @an=='0006' or @an=='0008'
    #      str43 = "一名"
    #      str45 = "独任"
    #    else
    str43 = "三名"
    str45 = "首席"
    #    end
    @format_ft05 = add_record("<43$$$>",str43,@format_ft05)
    @format_ft05 = add_record("<44$$$>",str45,@format_ft05)
    @format_ft05 = add_last_record("<27$$$>",str45,@format_ft05)
  end
  #仲裁通知（被申请人） 金融规则案件1人
  def format_letter_bft05(code,doc_id)
    #拼接字串，初始化
    @format_bft05 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_bft05 = add_record("<01$$$>",@file_code,@format_bft05)
    #立案号
    @case_code = casecode(code)
    @format_bft05 = add_record("<02$$$>",@case_code,@format_bft05)
    @format_bft05 = add_record("<06$$$>",@case_code,@format_bft05)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_bft05 = add_record("<03$$$>",@respondents,@format_bft05)
    #申请人
    @applicants = applicant(code,1,4)
    @format_bft05 = add_record("<04$$$>",@applicants,@format_bft05)
    #签订的$$$所引起的争议（合同名称）
    @contract_name = get_contract_nd(code)
    @format_bft05 = add_record("<05$$$>",@contract_name,@format_bft05)
    @format_bft05 = add_record("<42$$$>",@contract_name,@format_bft05)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0001')
    @format_bft05 = add_record("<07$$$>",@copies,@format_bft05)
    @copies2 = get_number41(code)#get_number2(code,'0001')
    @format_bft05 = add_record("<08$$$>",@copies2,@format_bft05)
    @format_bft05 = add_record("<09$$$>",@copies,@format_bft05)
    @format_bft05 = add_record("<23$$$>",@copies,@format_bft05)
    @format_bft05 = add_record("<28$$$>",@copies,@format_bft05)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_bft05 = add_record("<10$$$>",@zl_alerk,@format_bft05)
    @format_bft05 = add_record("<25$$$>",@sex,@format_bft05)
    @format_bft05 = add_record("<11$$$>",@telephone,@format_bft05)
    @format_bft05 = add_record("<12$$$>",@fax,@format_bft05)
    @format_bft05 = add_record("<13$$$>",@email,@format_bft05)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_bft05 = add_record("<14$$$>",@y2,@format_bft05)
    @format_bft05 = add_record("<15$$$>",@m2,@format_bft05)
    @format_bft05 = add_record("<16$$$>",@d2,@format_bft05)
    @s1=get_accommodate_remarks(code,2)
    @s2=get_accommodate_remarks2(code,2)
    @format_bft05 = add_record("<20$$$>",@s1,@format_bft05)
    @format_bft05 = add_record("<21$$$>",@s2,@format_bft05)
    @n_p=get_n_party(code,2)
    @format_bft05 = add_record("<29$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<30$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<31$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<32$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<34$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<39$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<40$$$>",@n_p,@format_bft05)
    @format_bft05 = add_record("<41$$$>",@n_p,@format_bft05)
    #一名/三名； 独任/首席； 替换
    str43 = "一名"
    str45 = "独任"
    @format_bft05 = add_record("<43$$$>",str43,@format_bft05)
    @format_bft05 = add_last_record("<44$$$>",str45,@format_bft05)
  end
  #发给申请人
  def format_letter_fmt06(code,p_v,doc_id)
    #拼接字串，初始化
    @format_fmt06 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt06 = add_record("<01$$$>",@file_code,@format_fmt06)
    #立案号
    @case_code = casecode(code)
    @format_fmt06 = add_record("<02$$$>",@case_code,@format_fmt06)
    @format_fmt06 = add_record("<08$$$>",@case_code,@format_fmt06)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt06 = add_record("<03$$$>",@applicants,@format_fmt06)
    #申请人交材料的日期
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日"  #get_recevicedate2(code)
    @format_fmt06 = add_record("<25$$$>",@recevicedate2,@format_fmt06)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_fmt06 = add_record("<04$$$>",@respondents,@format_fmt06)
    #文件份数
    @copies = get_number1(code,'0001')
    @format_fmt06 = add_record("<05$$$>",@copies,@format_fmt06)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee =SysArg.compart1(@arbit_fee)
    @format_fmt06 = add_record("<06$$$>",@arbit_fee,@format_fmt06)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_fmt06 = add_record("<07$$$>",@contract_name,@format_fmt06)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_fmt06 = add_record("<09$$$>",@zl_alerk,@format_fmt06)
    @format_fmt06 = add_record("<27$$$>",@sex,@format_fmt06)
    @format_fmt06 = add_record("<10$$$>",@telephone,@format_fmt06)
    @format_fmt06 = add_record("<11$$$>",@fax,@format_fmt06)
    @format_fmt06 = add_record("<12$$$>",@email,@format_fmt06)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt06 = add_record("<13$$$>",@y2,@format_fmt06)
    @format_fmt06 = add_record("<14$$$>",@m2,@format_fmt06)
    @format_fmt06 = add_record("<15$$$>",@d2,@format_fmt06)
    @arbitab=arbitab(code,1)
    @format_fmt06 = add_record("<19$$$>",@arbitab,@format_fmt06)
    @ac = arbitac(code,1)
    @format_fmt06 = add_record("<26$$$>",@ac,@format_fmt06)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="1、NO. " + t_code + "收据"
      @replace22="2、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_fmt06 = add_record("<20$$$>",@replace20,@format_fmt06)
    @format_fmt06 = add_record("<21$$$>",@replace21,@format_fmt06)
    @format_fmt06 = add_record("<22$$$>",@replace22,@format_fmt06)
    @format_fmt06 = add_record("<23$$$>",@replace23,@format_fmt06)
    @format_fmt06 = add_record("<24$$$>",@replace24,@format_fmt06)
    @n_p=get_n_party(code,1)
    @format_fmt06 = add_record("<28$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<29$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<30$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<31$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<32$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<33$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<34$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_record("<35$$$>",@n_p,@format_fmt06)
    @format_fmt06 = add_last_record("<36$$$>",@n_p,@format_fmt06)
  end
  #仲裁通知——申请人 金融3人
  def format_letter_ft06(code,p_v,doc_id)
    #拼接字串，初始化
    @format_ft06 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_ft06 = add_record("<01$$$>",@file_code,@format_ft06)
    #立案号
    @case_code = casecode(code)
    @format_ft06 = add_record("<02$$$>",@case_code,@format_ft06)
    @format_ft06 = add_record("<08$$$>",@case_code,@format_ft06)
    #申请人
    @applicants = applicant(code,2,3)
    @format_ft06 = add_record("<03$$$>",@applicants,@format_ft06)
    #申请人交材料的日期
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日"  #get_recevicedate2(code)
    @format_ft06 = add_record("<31$$$>",@recevicedate2,@format_ft06)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_ft06 = add_record("<04$$$>",@respondents,@format_ft06)
    #文件份数
    @copies = get_number1(code,'0001')
    @format_ft06 = add_record("<05$$$>",@copies,@format_ft06)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee =SysArg.compart1(@arbit_fee)
    @format_ft06 = add_record("<06$$$>",@arbit_fee,@format_ft06)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_ft06 = add_record("<07$$$>",@contract_name,@format_ft06)
    @format_ft06 = add_record("<34$$$>",@contract_name,@format_ft06)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_ft06 = add_record("<17$$$>",@zl_alerk,@format_ft06)
    @format_ft06 = add_record("<18$$$>",@sex,@format_ft06)
    @format_ft06 = add_record("<19$$$>",@telephone,@format_ft06)
    @format_ft06 = add_record("<20$$$>",@fax,@format_ft06)
    @format_ft06 = add_record("<21$$$>",@email,@format_ft06)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_ft06 = add_record("<23$$$>",@y2,@format_ft06)
    @format_ft06 = add_record("<24$$$>",@m2,@format_ft06)
    @format_ft06 = add_record("<25$$$>",@d2,@format_ft06)
    @arbitab=arbitab(code,1)
    @format_ft06 = add_record("<12$$$>",@arbitab,@format_ft06)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="2、NO. " + t_code + "收据"
      @replace22="3、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="2、《仲裁规则》"
      @replace22="3、《仲裁员名册》"
      @replace23="4、NO. " + t_code + "收据"
      @replace24="5、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="2、《仲裁规则》"
      @replace22="3、《仲裁员名册》"
      @replace23="4、NO. " + t_code + "收据"
      @replace24="5、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_ft06 = add_record("<22$$$>",@replace20,@format_ft06)
    @format_ft06 = add_record("<26$$$>",@replace21,@format_ft06)
    @format_ft06 = add_record("<27$$$>",@replace22,@format_ft06)
    @format_ft06 = add_record("<28$$$>",@replace23,@format_ft06)
    @format_ft06 = add_record("<29$$$>",@replace24,@format_ft06)
    @n_p=get_n_party(code,1) #你方、你两方........
    @format_ft06 = add_record("<30$$$>",@n_p,@format_ft06)
    @format_ft06 = add_record("<32$$$>",@n_p,@format_ft06)
    @format_ft06 = add_record("<33$$$>",@n_p,@format_ft06)
    @format_ft06 = add_record("<11$$$>",@n_p,@format_ft06)
    @format_ft06 = add_record("<13$$$>",@n_p,@format_ft06)
    #一名/三名； 独任/首席； 替换
    #    @an=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    #    if @an=='0006' or @an=='0008'
    #      str9 = "一名"
    #      str14 = "独任"
    #    else
    str9 = "三名"
    str14 = "首席"
    #    end
    @format_ft06 = add_record("<09$$$>",str9,@format_ft06)
    @format_ft06 = add_record("<10$$$>",str9,@format_ft06)
    @format_ft06 = add_last_record("<14$$$>",str14,@format_ft06)
  end
  #仲裁通知——申请人 金融1人
  def format_letter_bft06(code,p_v,doc_id)
    #拼接字串，初始化
    @format_bft06 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_bft06 = add_record("<01$$$>",@file_code,@format_bft06)
    #立案号
    @case_code = casecode(code)
    @format_bft06 = add_record("<02$$$>",@case_code,@format_bft06)
    @format_bft06 = add_record("<08$$$>",@case_code,@format_bft06)
    #申请人
    @applicants = applicant(code,2,3)
    @format_bft06 = add_record("<03$$$>",@applicants,@format_bft06)
    #申请人交材料的日期
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日"  #get_recevicedate2(code)
    @format_bft06 = add_record("<31$$$>",@recevicedate2,@format_bft06)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_bft06 = add_record("<04$$$>",@respondents,@format_bft06)
    #文件份数
    @copies = get_number1(code,'0001')
    @format_bft06 = add_record("<05$$$>",@copies,@format_bft06)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee =SysArg.compart1(@arbit_fee)
    @format_bft06 = add_record("<06$$$>",@arbit_fee,@format_bft06)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_bft06 = add_record("<07$$$>",@contract_name,@format_bft06)
    @format_bft06 = add_record("<34$$$>",@contract_name,@format_bft06)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_bft06 = add_record("<17$$$>",@zl_alerk,@format_bft06)
    @format_bft06 = add_record("<18$$$>",@sex,@format_bft06)
    @format_bft06 = add_record("<19$$$>",@telephone,@format_bft06)
    @format_bft06 = add_record("<20$$$>",@fax,@format_bft06)
    @format_bft06 = add_record("<21$$$>",@email,@format_bft06)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_bft06 = add_record("<23$$$>",@y2,@format_bft06)
    @format_bft06 = add_record("<24$$$>",@m2,@format_bft06)
    @format_bft06 = add_record("<25$$$>",@d2,@format_bft06)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="2、NO. " + t_code + "收据"
      @replace22="3、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="2、《仲裁规则》"
      @replace22="3、《仲裁员名册》"
      @replace23="4、NO. " + t_code + "收据"
      @replace24="5、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="2、《仲裁规则》"
      @replace22="3、《仲裁员名册》"
      @replace23="4、NO. " + t_code + "收据"
      @replace24="5、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_bft06 = add_record("<22$$$>",@replace20,@format_bft06)
    @format_bft06 = add_record("<26$$$>",@replace21,@format_bft06)
    @format_bft06 = add_record("<27$$$>",@replace22,@format_bft06)
    @format_bft06 = add_record("<28$$$>",@replace23,@format_bft06)
    @format_bft06 = add_record("<29$$$>",@replace24,@format_bft06)
    @n_p=get_n_party(code,1) #你方、你两方........
    @format_bft06 = add_record("<30$$$>",@n_p,@format_bft06)
    @format_bft06 = add_record("<32$$$>",@n_p,@format_bft06)
    @format_bft06 = add_record("<33$$$>",@n_p,@format_bft06)
    @format_bft06 = add_record("<13$$$>",@n_p,@format_bft06)
    #一名/三名； 独任/首席； 替换
    #    @an=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    #    if @an=='0006' or @an=='0008'
    str9 = "一名"
    str14 = "独任"
    #    else
    #      str9 = "三名"
    #      str14 = "首席"
    #    end
    @format_bft06 = add_record("<09$$$>",str9,@format_bft06)
    @format_bft06 = add_record("<10$$$>",str9,@format_bft06)
    @format_bft06 = add_last_record("<14$$$>",str14,@format_bft06)
  end

  ###########################################################################

  def format_letter_fmt09(code,doc_id)
    #拼接字串，初始化
    @format_fmt09 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt09 = add_record("<01$$$>",@file_code,@format_fmt09)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt09 = add_record("<02$$$>",@respondents,@format_fmt09)
    #立案号
    @case_code = casecode(code)
    @format_fmt09 = add_record("<03$$$>",@case_code,@format_fmt09)
    #被申请人仲裁费
    @arbit_fee = respondent_arbit_fee(code) + respondent_litigation_fee(code)
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @format_fmt09 = add_record("<04$$$>",@arbit_fee,@format_fmt09)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt09 = add_record("<05$$$>",@y2,@format_fmt09)
    @format_fmt09 = add_record("<06$$$>",@m2,@format_fmt09)
    @format_fmt09 = add_record("<07$$$>",@d2,@format_fmt09)
    @fax2=get_fax2(code,1)
    @format_fmt09 = add_last_record("<08$$$>",@fax2,@format_fmt09)
  end
  #普通案件——组庭通知当事人
  def format_letter_fmt11a(code,doc_id)
    #拼接字串，初始化
    @format_fmt11a = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt11a = add_record("<01$$$>",@file_code,@format_fmt11a)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt11a = add_record("<02$$$>",@applicants,@format_fmt11a)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt11a = add_record("<03$$$>",@respondents,@format_fmt11a)
    #立案号
    @case_code = casecode(code)
    @format_fmt11a = add_record("<04$$$>",@case_code,@format_fmt11a)
    #将要选用的首席仲裁员#将要选用的申请人仲裁员#将要选用的被申请人仲裁员
    @b=applicant_arbitrator(code)
    @c=respondent_arbitrator(code)
    @style1=get_style_from(code,'0003')#申请人方仲裁员选定方式
    @style2=get_style_from(code,'0004')#被申请人方仲裁员选定方式
    @style3=get_style_from(code,'0002')#首席仲裁员选定方式
    #只用于普通案件
    #首席仲裁员
    @c1 = "首席仲裁员：" + chief_arbitrator(code) + get_arbitman_sex(code,'0002')
    #申请人仲裁员
    @applicant_arbitrator = "仲  裁  员：" + @b+get_arbitman_sex(code,'0003')
    #被申请人仲裁员
    @respondent_arbitrator = "仲  裁  员：" + @c+get_arbitman_sex(code,'0004')
    @format_fmt11a = add_record("<13$$$>",@c1,@format_fmt11a)
    @format_fmt11a = add_record("<14$$$>",@applicant_arbitrator,@format_fmt11a)
    @format_fmt11a = add_record("<15$$$>",@respondent_arbitrator,@format_fmt11a)
    #当事人xxx选定/指定xxx为仲裁员
    @n1=TbParty.count(:id,:conditions=>["used='Y' and partytype=1 and recevice_code=?",code])
    @n2=TbParty.count(:id,:conditions=>["used='Y' and partytype=2 and recevice_code=?",code])
    if @style1=="代指定"
      if @n1>1
        @seven = "因申请人未在规定的期限内共同选定或共同委托本会主任指定仲裁员而由本会主任为申请人指定仲裁员"+@b+get_arbitman_sex(code,'0003')
      else
        @seven = "因申请人未在规定的期限内选定或委托本会主任指定仲裁员而由本会主任为申请人指定仲裁员"+@b+get_arbitman_sex(code,'0003')
      end
    else
      @seven = "申请人"+@style1+@b+get_arbitman_sex(code,'0003')+"作为本案仲裁员"
    end
    if @style2=="代指定"
      if @n2>1
        @eight = "因被申请人未在规定的期限内共同选定或共同委托本会主任指定仲裁员而由本会主任为被申请人指定仲裁员"+@c+get_arbitman_sex(code,'0004')
      else
        @eight = "因被申请人未在规定的期限内选定或委托本会主任指定仲裁员而由本会主任为被申请人指定仲裁员"+@c+get_arbitman_sex(code,'0004')
      end
    else
      @eight = "被申请人"+@style2+@c+get_arbitman_sex(code,'0004')+"作为本案仲裁员"
    end
    if @style3=="代指定"
      @nine = "因双方未在规定的期限内共同选定或共同委托本会主任指定首席仲裁员而由本会主任指定"+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+"作为本案首席仲裁员"
    else
      @nine = "双方"+@style3+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+"作为本案首席仲裁员"
    end
    @format_fmt11a = add_record("<05$$$>",@seven,@format_fmt11a)
    @format_fmt11a = add_record("<06$$$>",@eight,@format_fmt11a)
    @format_fmt11a = add_record("<07$$$>",@nine,@format_fmt11a)
    #组庭日期
    @case_date = TbCaseorg.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code],:order=>"id desc")
    if @case_date != nil or @case_date == ""
      end_date = @case_date.orgdate.to_s.split("-")
      end_date10=end_date[0]+"年"
      end_date1=end_date[1].to_i.to_s+"月"
      end_date2=end_date[2].to_i.to_s+"日"
      @org_date=end_date10+end_date1+end_date2
    else
      @org_date = "_____年___月___日"
    end
    @format_fmt11a = add_record("<08$$$>",@org_date,@format_fmt11a)
    #审限（裁决期限）
    @end_date = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code]).finally_limit_dat
    if @end_date!=nil
      end_date = @end_date.to_s.split("-")
      end_date10=end_date[0]+"年"
      end_date1=end_date[1].to_i.to_s+"月"
      end_date2=end_date[2].to_i.to_s+"日"
      @end_date=end_date10+end_date1+end_date2
    else
      @end_date = "_____年___月___日"
    end
    @format_fmt11a = add_record("<09$$$>",@end_date,@format_fmt11a)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt11a = add_record("<10$$$>",@y2,@format_fmt11a)
    @format_fmt11a = add_record("<11$$$>",@m2,@format_fmt11a)
    @format_fmt11a = add_last_record("<12$$$>",@d2,@format_fmt11a)
  end
  #简易——组庭通知当事人
  def format_letter_fmt17a(code,doc_id)
    #拼接字串，初始化
    @format_fmt17a = ""
    #函号
    file_code = get_code1(doc_id)
    @format_fmt17a = add_record("<01$$$>",file_code,@format_fmt17a)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt17a = add_record("<02$$$>",@applicants,@format_fmt17a)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt17a = add_record("<03$$$>",@respondents,@format_fmt17a)
    #立案号
    @case_code = casecode(code)
    @format_fmt17a = add_record("<04$$$>",@case_code,@format_fmt17a)
    @style3=get_style_from(code,'0001')#独任仲裁员选定方式
    if @style3=="代指定"
      @nine = "因双方未在规定的期限内共同选定或共同委托本会主任指定独任仲裁员而由本会主任指定" + independent_arbitrator(code) + get_arbitman_sex(code,'0001')+"作为本案独任仲裁员"
    else
      @nine = "双方" + @style3 + independent_arbitrator(code) + get_arbitman_sex(code,'0001')+"作为本案独任仲裁员"
    end
    @format_fmt17a = add_record("<05$$$>",@nine,@format_fmt17a)
    #组庭日期
    @case_date = TbCaseorg.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code],:order=>"id desc")
    if @case_date != nil or @case_date == ""
      @org_date=SysArg.get_ymd(@case_date.orgdate)
    else
      @org_date = "_____年___月___日"
    end
    @format_fmt17a = add_record("<06$$$>",@org_date,@format_fmt17a)
    #独任仲裁员
    c1 = independent_arbitrator(code) + get_arbitman_sex(code,'0001')
    @format_fmt17a = add_record("<07$$$>",c1,@format_fmt17a)
    @format_fmt17a = add_record("<16$$$>",c1,@format_fmt17a)
    #审限（裁决期限）
    @end_date = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code]).finally_limit_dat
    if @end_date!=nil
      @end_date=SysArg.get_ymd(@end_date)
    else
      @end_date = "_____年___月___日"
    end
    @format_fmt17a = add_record("<08$$$>",@end_date,@format_fmt17a)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt17a = add_record("<09$$$>",@y2,@format_fmt17a)
    @format_fmt17a = add_record("<10$$$>",@m2,@format_fmt17a)
    @format_fmt17a = add_record("<11$$$>",@d2,@format_fmt17a)
    #办案助理
    @zl_name = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_fmt17a = add_record("<12$$$>",@zl_name,@format_fmt17a)
    @format_fmt17a = add_record("<13$$$>",@telephone,@format_fmt17a)
    @format_fmt17a = add_record("<14$$$>",@fax,@format_fmt17a)
    @format_fmt17a = add_last_record("<15$$$>",@email,@format_fmt17a)
  end
  #校核函
  def format_letter_fmt12(code)
    @format_fmt12 = ""
    @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @award!=nil
      if @award.end_typ=='0001'
        c1='裁决'
        c9="完整裁决书"
        c22="一般裁决"
      elsif @award.end_typ=='0002'
        c1='裁决'
        c9="完整裁决书"
        arbit=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",@award.arbiter])
        if arbit!=nil
          name = arbit.name
        else
          name = ""
        end
        c22="多数/首仲裁决        持少数意见的仲裁员：" + name
      elsif @award.end_typ=='0003'
        c1='裁决'
        c9="完整裁决书"
        c22="和解裁决"
      else
        c1='撤案决定'
        c9="撤案决定书"
        c22="撤案"
      end
      if @award.advice==1
        c23="有意见       具体意见：" + @award.remark
      else
        c23="无意见"
      end
    else
      c1="裁决/撤案决定"
      c9="撤案决定/完整裁决书"
      c22=""
    end
    @format_fmt12 = add_record("<01$$$>",c1,@format_fmt12)
    @format_fmt12 = add_record("<09$$$>",c9,@format_fmt12)
    @format_fmt12 = add_record("<22$$$>",c22,@format_fmt12)
    @format_fmt12 = add_record("<23$$$>",c23,@format_fmt12)
    @case=TbCase.find_by_recevice_code(code)
    case_code=@case.case_code
    @format_fmt12 = add_record("<02$$$>",case_code,@format_fmt12)
    c3=User.find(:first,:conditions=>["used='Y' and code=?",@case.clerk]).name
    @format_fmt12 = add_record("<03$$$>",c3,@format_fmt12)
    if @case.nowdate!=nil
      arr_date = @case.nowdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @sdate=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @sdate=""
    end
    @format_fmt12 = add_record("<04$$$>",@sdate,@format_fmt12)
    @caseorg_date = TbCaseorg.find(:all, :conditions => ["used = 'Y' and recevice_code = ?",code])
    c5=""
    @caseorg_date.each do |t|
      arr_date = t.orgdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @caseorg_date1 = arr_date[0]+"年"+arr_date[1]+"月"+arr_date[2]+"日"+"  "
      c5= c5 + @caseorg_date1
    end
    @format_fmt12 = add_record("<05$$$>",c5,@format_fmt12)
    if @case.finally_limit_dat!=nil
      arr_date = @case.finally_limit_dat.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      c6=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      c6=""
    end
    @format_fmt12 = add_record("<06$$$>",c6,@format_fmt12)
    @ampliation=TbCasedelay.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @ampliation!=nil
      c7="是"
    else
      c7="否"
    end
    @format_fmt12 = add_record("<07$$$>",c7,@format_fmt12)
    @tbend=TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @tbend!=nil
      arr_date = @tbend.decideDate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      c8=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      c8=""
    end
    @format_fmt12 = add_record("<08$$$>",c8,@format_fmt12)
    c11=""
    c12=""
    c13=""
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0001'",code],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code1=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_1=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001' #仲裁员
        if @draftsman_code1!=nil
          c11=c11 + @draftsman_code1.name + " "
        end
      else #助理
        if @draftsman_code_1!=nil
          c11=c11 + @draftsman_code_1.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0002'",code],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code2=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_2=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code1!=nil
          c12=c12 + @draftsman_code2.name + " "
        end
      else
        if @draftsman_code_2!=nil
          c12=c12 + @draftsman_code_2.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and (d.typ='0003' or d.typ='0004')",code],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code3=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_3=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code3!=nil
          c13=c13 + @draftsman_code3.name + " "
        end
      else
        if @draftsman_code_3!=nil
          c13=c13 + @draftsman_code_3.name + " "
        end
      end
    end
    @format_fmt12 = add_record("<11$$$>",c11,@format_fmt12)
    @format_fmt12 = add_record("<12$$$>",c12,@format_fmt12)
    @format_fmt12 = add_record("<13$$$>",c13,@format_fmt12)
    #费用部分
    #申请人  应收=应交- （应退 - 减退 ）
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",code])
    a_f2=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",code])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",code])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",code])
    af = a_f1.to_i - (a_f2.to_i - a_f3.to_i)
    c14=SysArg.compart2(af)
    c17=SysArg.compart2(a_f4)
    @format_fmt12 = add_record("<14$$$>",c14,@format_fmt12)
    @format_fmt12 = add_record("<17$$$>",c17,@format_fmt12)
    #被申请人  应收 、 实收
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",code])
    a_f22=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",code])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",code])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",code])
    af = a_f1.to_i - (a_f22.to_i - a_f3.to_i)
    c15=SysArg.compart2(af)
    c18=SysArg.compart2(a_f4)
    @format_fmt12 = add_record("<15$$$>",c15,@format_fmt12)
    @format_fmt12 = add_record("<18$$$>",c18,@format_fmt12)

    c16=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",code])
    c16 = SysArg.compart2(c16)
    @format_fmt12 = add_record("<16$$$>",c16,@format_fmt12)
    c_19=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",code])
    c19 = SysArg.compart2(c_19)
    @format_fmt12 = add_record("<19$$$>",c19,@format_fmt12)
    #2010-8-16   应退费用----仲裁费，助理输入/系统产生应退、而未确认的费用
    c_20 = TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and (state=1 and state=4) and (typ='0001' or typ='0004') and parent_id=0",code])
    c20=SysArg.compart2(c_20)
    @format_fmt12 = add_record("<20$$$>",c20,@format_fmt12)
    #2010-8-16 仲裁员实际开支应退费用：需要判断，如果助理有输入实际开支的应退费用，以输入的为准进行显示。如果没有输入，以实际开支费用表的结余数字为准。
    c21=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",code])
    if c21.to_i!=0
      c21=SysArg.compart2(c21)
    else
      f12 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",code])
      if c_19==nil
        c_19=0
      end
      c_19 = c_19.to_f - f12.to_f
      @aribitprog_num=@case.aribitprog_num
      if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
        as11=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and arbitman_typ<>'0001'",code])
        as44=TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",code])
        c21=SysArg.compart2(c_19 - (as11.to_f + as44.to_f))
      else#简易案件
        as_3=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and arbitman_typ='0001'",code])
        as_4=TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",code])
        c21=SysArg.compart2(c_19  - (as_3.to_f+as_4.to_f))
      end
    end
    @format_fmt12 = add_record("<21$$$>",c21,@format_fmt12)
    arbitprog_num = TbCase.find_by_recevice_code(code).aribitprog_num
    if arbitprog_num=='0001' or arbitprog_num=='0003' or arbitprog_num=='0005' or arbitprog_num=='0007'
      r24 = "首仲：      申仲：       被仲："
    else
      r24 = "独任："
    end
    @format_fmt12 = add_record("<24$$$>",r24,@format_fmt12)
    @format_fmt12 = add_last_record("<25$$$>",r24,@format_fmt12)
  end
  #开庭通知当事人——普通案件
  def format_letter_fmt14(code,doc_id)
    #拼接字串，初始化
    @format_fmt14 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt14 = add_record("<01$$$>",@file_code,@format_fmt14)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt14 = add_record("<02$$$>",@applicants,@format_fmt14)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt14 = add_record("<03$$$>",@respondents,@format_fmt14)
    #立案号
    @case_code = casecode(code)
    @format_fmt14 = add_record("<04$$$>",@case_code,@format_fmt14)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt14 = add_record("<05$$$>",@y2,@format_fmt14)
    @format_fmt14 = add_record("<06$$$>",@m2,@format_fmt14)
    @format_fmt14 = add_record("<07$$$>",@d2,@format_fmt14)
    @sitting_date = get_sittingdate(code)
    @sitting_date2 = get_sittingdate2(code)
    @format_fmt14 = add_record("<08$$$>",@sitting_date,@format_fmt14)
    @format_fmt14 = add_last_record("<09$$$>",@sitting_date2,@format_fmt14)
  end
  #开庭通知当事人——简易案件
  def format_letter_fmt17b(code,doc_id)
    #拼接字串，初始化
    @format_fmt17b = ""
    #函号
    file_code = get_code1(doc_id)
    @format_fmt17b = add_record("<01$$$>",file_code,@format_fmt17b)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt17b = add_record("<02$$$>",@applicants,@format_fmt17b)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt17b = add_record("<03$$$>",@respondents,@format_fmt17b)
    #立案号
    @case_code = casecode(code)
    @format_fmt17b = add_record("<04$$$>",@case_code,@format_fmt17b)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt17b = add_record("<05$$$>",@y2,@format_fmt17b)
    @format_fmt17b = add_record("<06$$$>",@m2,@format_fmt17b)
    @format_fmt17b = add_record("<07$$$>",@d2,@format_fmt17b)
    arbit = independent_arbitrator(code)
    @format_fmt17b = add_record("<16$$$>",arbit,@format_fmt17b)
    @sitting_date = get_sittingdate(code)
    @sitting_date2 = get_sittingdate2(code)
    @format_fmt17b = add_record("<17$$$>",@sitting_date,@format_fmt17b)
    @format_fmt17b = add_last_record("<18$$$>",@sitting_date2,@format_fmt17b)
  end
  def format_letter_fmt15(code,doc_id)
    #拼接字串，初始化
    @format_fmt15 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt15 = add_record("<01$$$>",@file_code,@format_fmt15)
    #首席仲裁员
    @chief_arbitrator = chief_arbitrator(code) + get_arbitman_sex(code,'0002')
    @format_fmt15 = add_record("<02$$$>",@chief_arbitrator,@format_fmt15)
    #申请人仲裁员
    @applicant_arbitrator = applicant_arbitrator(code) + get_arbitman_sex(code,'0003')
    @format_fmt15 = add_record("<03$$$>",@applicant_arbitrator,@format_fmt15)
    #被申请人仲裁员
    @respondent_arbitrator = respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
    @format_fmt15 = add_record("<04$$$>",@respondent_arbitrator,@format_fmt15)
    #立案号
    @case_code = casecode(code)
    @format_fmt15 = add_record("<05$$$>",@case_code,@format_fmt15)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt15 = add_record("<06$$$>",@y2,@format_fmt15)
    @format_fmt15 = add_record("<07$$$>",@m2,@format_fmt15)
    @format_fmt15 = add_record("<08$$$>",@d2,@format_fmt15)
    @sitting_date = get_sittingdate(code)
    @sitting_date2 = get_sittingdate2(code)
    @format_fmt15 = add_record("<09$$$>",@sitting_date,@format_fmt15)
    @format_fmt15 = add_last_record("<10$$$>",@sitting_date2,@format_fmt15)
  end
  #简易：组庭、开庭通知当事人
  def format_letter_fmt17(code,doc_id)
    #拼接字串，初始化
    @format_fmt17 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt17 = add_record("<01$$$>",@file_code,@format_fmt17)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt17 = add_record("<02$$$>",@applicants,@format_fmt17)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt17 = add_record("<03$$$>",@respondents,@format_fmt17)
    #立案号
    @case_code = casecode(code)
    @format_fmt17 = add_record("<04$$$>",@case_code,@format_fmt17)
    #独立仲裁员
    @style1=get_style_from(code,'0001')
    if @style1=="委托"
      @style1="委托本会主任指定"
    elsif @style1=="共同委托"
      @style1="共同委托本会主任指定"
    end
    @independent_arbitrator = independent_arbitrator(code)+ get_arbitman_sex(code,'0001')
    if @style1=="代指定"
      @independent_arbitrator1="因双方未在规定的期限内共同选定/共同委托指定独任仲裁员，本会主任指定" + @independent_arbitrator +"作为本案独任仲裁员"
    else
      @independent_arbitrator1="双方" + @style1 + @independent_arbitrator+"作为本案独任仲裁员"
    end
    @format_fmt17 = add_record("<05$$$>",@independent_arbitrator1,@format_fmt17)
    @format_fmt17 = add_record("<07$$$>",@independent_arbitrator,@format_fmt17)
    @format_fmt17 = add_record("<16$$$>",@independent_arbitrator,@format_fmt17)
    #组庭日期
    @case_date = TbCaseorg.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code],:order=>"id desc")
    if @case_date != nil or @case_date == ""
      @org_date=SysArg.get_ymd(@case_date.orgdate)
    else
      @org_date = "_____年___月___日"
    end
    @format_fmt17 = add_record("<06$$$>",@org_date,@format_fmt17)
    #审限（裁决期限）
    @end_date = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code])
    if @end_date.finally_limit_dat!= nil && @end_date.finally_limit_dat!= ""
      @end_date=SysArg.get_ymd(@end_date.finally_limit_dat)
    else
      @end_date = "_____年___月___日"
    end
    @format_fmt17 = add_record("<08$$$>",@end_date,@format_fmt17)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt17 = add_record("<09$$$>",@y2,@format_fmt17)
    @format_fmt17 = add_record("<10$$$>",@m2,@format_fmt17)
    @format_fmt17 = add_record("<11$$$>",@d2,@format_fmt17)
    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_fmt17 = add_record("<12$$$>",@zl_alerk,@format_fmt17)
    @format_fmt17 = add_record("<13$$$>",@telephone,@format_fmt17)
    @format_fmt17 = add_record("<14$$$>",@fax,@format_fmt17)
    @format_fmt17 = add_record("<15$$$>",@email,@format_fmt17)
    @replace17 = get_sittingdate(code)
    @format_fmt17 = add_record("<17$$$>",@replace17,@format_fmt17)
    @replace17 = get_sittingdate2(code)
    @format_fmt17 = add_last_record("<18$$$>",@replace18,@format_fmt17)
  end
  #转函---此函公用
  def format_letter_fmt18(code,p_v,doc_id)
    #拼接字串，初始化
    @format_fmt18 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt18 = add_record("<01$$$>",@file_code,@format_fmt18)
    #立案号
    @case_code = casecode(code)
    @format_fmt18 = add_record("<02$$$>",@case_code,@format_fmt18)
    if p_v=='0001'  #申请人
      r4 = get_n_party(code,1)
      @replace16 = "被申请人"
      @applicants = applicant(code,2,3)
      @format_fmt18 = add_record("<03$$$>",@applicants,@format_fmt18)
      #收文:被申请人或者第三方提交的日期、资料
      @recevicedate1=get_recevicedate1(code,"")
      @materialtype1=get_materialtype1(code,"")
      @str8="申请人附去我会秘书处于" + @recevicedate1 + "收到的" + get_third_party(code,"0001") + "提交的" + @materialtype1 + "一式一份"
    elsif p_v=='0002' #被申请人;发给被申请人的
      r4 = get_n_party(code,2)
      @replace16 = "申请人"
      @respondents = respondent(code,2,3)
      @format_fmt18 = add_record("<03$$$>",@respondents,@format_fmt18)
      #收文:申请人提交的日期、资料
      @str8="被申请人附去我会秘书处于"+get_recevicedate2(code,"")+"收到的" + get_third_party(code,"0002") + "提交的"+get_materialtype2(code,"")+"一式一份"
    else      # p_v=='0003'  双方
      r4 = "双方"
      @replace16 = "申请人、被申请人"
      @applicant1 = applicant(code,2,3)
      @respondents = respondent(code,2,3)
      if @applicant1!="_____"
        @applicants = @applicant1 + '\r' + @respondents
      end
      @format_fmt18 = add_record("<03$$$>",@applicants,@format_fmt18)
      #收文:被申请人提交的日期、资料;申请人提交的日期、资料

      @recevicedate11 = get_recevicedate1(code,"two")
      @materialtype11 = get_materialtype1(code,"two")
      @recevicedate12 = get_recevicedate2(code,"two")
      @materialtype12 = get_materialtype2(code,"two")
      puts "==================="
      puts @recevicedate12
      puts @materialtype12
      puts "==================="
      @str8 = "申请人附去我会秘书处于"  + @recevicedate11 + "收到的" + get_third_party(code,"0003") + "提交的" + @materialtype11 + "一式一份" +
      "，向被申请人附去我会秘书处于" + @recevicedate12 + "收到的" + get_third_party(code,"0004") + "提交的" + @materialtype12 + "一式一份"
      @amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? ",code],:order=>"id desc")
      if @amail != nil and !@amail.submitman2.blank?
        @str8 = "双方当事人附去我会秘书处于"  + @recevicedate11 + "收到的" + get_third_party(code,"0003") + "提交的" + @materialtype11 + "各一式一份"
      end

    end
    @format_fmt18 = add_record("<04$$$>",r4,@format_fmt18)
    @format_fmt18 = add_record("<08$$$>",@str8,@format_fmt18)
    #材料数量
    if p_v=='0001'
      p_v='0002'
    elsif p_v=='0002'
      p_v='0001'
    elsif p_v=='0003'#选择双方时，提交资料数量是多少？--按被申请人的
      p_v='0001'
    else
      p_v='0'
    end
    @nn=get_number4(code)#get_number1(code,p_v)
    @format_fmt18 = add_record("<12$$$>",@nn,@format_fmt18)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt18 = add_record("<05$$$>",@y2,@format_fmt18)
    @format_fmt18 = add_record("<06$$$>",@m2,@format_fmt18)
    @format_fmt18 = add_record("<07$$$>",@d2,@format_fmt18)
    #组庭前发文不显示仲裁员，否则显示
    @sittiing=TbCaseorg.find(:first,:conditions=>"used='Y' and recevice_code='#{code}'")
    @ss_t=TbDoc.find(:first,:conditions=>"used='Y' and id=#{doc_id}").ss_t
    if @sittiing!=nil
      @orgdate=@sittiing.orgdate
      if @orgdate<@ss_t
        @arbitman1=""
        #仲裁员
        @an=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
        if @an=='0001' or @an=='0003' or @an=='0005'
          @arbitman1=@arbitman1+"抄送："+"首席仲裁员："+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+'\r'+"      仲  裁  员："+applicant_arbitrator(code) + get_arbitman_sex(code,'0003')+'\r'+"      仲  裁  员："+respondent_arbitrator(code) + get_arbitman_sex(code,'0004')+'\r'+"（附"+@replace16+"材料）"
        else
          @arbitman1=@arbitman1+"抄送："+"独任仲裁员："+independent_arbitrator(code) + get_arbitman_sex(code,'0001')+'\r'+"（附"+@replace16+"材料）"
        end
      else
        @arbitman1=""
      end
    else
      @arbitman1=""
    end
    @format_fmt18 = add_last_record("<13$$$>",@arbitman1,@format_fmt18)
  end
  ### 当事人是可选的，地址相应改变 空缺 ###
  def format_letter_fmt19(code,doc_id)
    #拼接字串，初始化
    @format_fmt19 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt19 = add_record("<01$$$>",@file_code,@format_fmt19)
    #当事人
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype=2 and recevice_code = ?",code], :order => "id")
    if PubTool.new.get_first_record(@applicants) == nil
      @applicant = "_____"
      @addr = "_____"
    else
      @applicant = ""
      @addr = ""
      @applicants.each do |applicant|
        @applicant = @applicant + applicant.partyname + ", "
        if applicant.addr!=nil and applicant.addr!=""
          @addr = @addr + applicant.addr + ", "
        end
      end
      if @applicant!=""
        @applicant = @applicant.slice(0,@applicant.length-2)
      end
      if @addr!=""
        @addr = @addr.slice(0,@addr.length-2)
      end
    end
    @format_fmt19 = add_record("<02$$$>",@applicant,@format_fmt19)
    #地址
    @format_fmt19 = add_record("<03$$$>",@addr,@format_fmt19)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt19 = add_record("<04$$$>",@y2,@format_fmt19)
    @format_fmt19 = add_record("<05$$$>",@m2,@format_fmt19)
    @format_fmt19 = add_last_record("<06$$$>",@d2,@format_fmt19)
  end
  #空白函
  def format_letter_fmt20(code,p_v,doc_id)
    #拼接字串，初始化
    @format_fmt20 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt20 = add_record("<01$$$>",@file_code,@format_fmt20)
    #立案号
    @case_code = casecode(code)
    @format_fmt20 = add_record("<02$$$>",@case_code,@format_fmt20)
    if p_v=='0001'
      @applicants = applicant(code,2,3)
    elsif p_v=='0002'
      @applicants =respondent(code,2,3)
    else  # p_v=='0003'
      @applicants = applicant(code,2,3)+'\r'+respondent(code,2,3)
    end
    @format_fmt20 = add_record("<03$$$>",@applicants,@format_fmt20)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt20 = add_record("<05$$$>",@y2,@format_fmt20)
    @format_fmt20 = add_record("<06$$$>",@m2,@format_fmt20)
    @format_fmt20 = add_record("<07$$$>",@d2,@format_fmt20)
    #组庭前发文不显示仲裁员，否则显示
    @sittiing=TbCaseorg.find(:first,:conditions=>"used='Y' and recevice_code='#{code}'")
    @ss_t=TbDoc.find(:first,:conditions=>"used='Y' and id=#{doc_id}").ss_t
    if @sittiing!=nil
      @orgdate=@sittiing.orgdate
      #if @ss_t<=@orgdate
        @arbitman1=""
        #仲裁员
        @an=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
        if @an=='0001' or @an=='0003' or @an=='0005' or @an=='0007' #添加了0007 2010-2-23 niell
          @arbitman1=@arbitman1+"抄送："+"首席仲裁员："+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+'\r'+"      仲  裁  员："+applicant_arbitrator(code) + get_arbitman_sex(code,'0003')+'\r'+"      仲  裁  员："+respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
        else
          @arbitman1=@arbitman1+"抄送："+"独任仲裁员："+independent_arbitrator(code) + get_arbitman_sex(code,'0001')
        end
      #else
        #@arbitman1=""
      #end
    else
      @arbitman1=""
    end
    @format_fmt20 = add_last_record("<08$$$>",@arbitman1,@format_fmt20)
  end
  #普通案件
  def format_letter_fmt23b(code,p_v,ar_nu)
    #拼接字串，初始化
    @format_fmt23b = ""
    #立案号
    @case_code = casecode(code)
    @format_fmt23b = add_record("<01$$$>",@case_code,@format_fmt23b)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt23b = add_record("<02$$$>",@applicants,@format_fmt23b)
    #申请人代理人(可多名）
    @applicant_agent = get_agent(code,1)
    @format_fmt23b = add_record("<03$$$>",@applicant_agent,@format_fmt23b)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt23b = add_record("<04$$$>",@respondents,@format_fmt23b)
    #被申请人代理人(可多名）
    @respondent_agent = get_agent(code,2)
    @format_fmt23b = add_record("<05$$$>",@respondent_agent,@format_fmt23b)
    @a=get_fix_appoint(code,'0003')
    @b=get_fix_appoint(code,'0004')
    @c=get_fix_appoint(code,'0002')
    if p_v=='0006'
      if @a!="指定"
        @replace6="申请人的" + @a
      else
        @replace6="本会主任的指定"
      end
      @replace7=@a
      @replace8=@a
      @replace9=@a
      @rep10 = "仲裁员"
      @rep11 = "仲裁员"
    elsif p_v=='0007'
      if @b!="指定"
        @replace6="被申请人的" + @b
      else
        @replace6="本会主任的指定"
      end
      @replace7=@b
      @replace8=@b
      @replace9=@b
      @rep10 = "仲裁员"
      @rep11 = "仲裁员"
    else  # p_v=='0008'
      @replace6="本会主任的" + @c
      @replace7=@c
      @replace8=@c
      @replace9=@c
      @rep10 = "首席仲裁员"
      @rep11 = "首席仲裁员"
      #    else
      #      @replace6="申请人的选定/被申请人的选定/本会主任的指定"
      #      @replace7="选定/指定"
      #      @replace8="选定/指定"
      #      @replace9="选定/指定"
      #      @rep10 = "首席仲裁员"
    end
    @format_fmt23b = add_record("<06$$$>",@replace6,@format_fmt23b)
    @format_fmt23b = add_record("<07$$$>",@replace7,@format_fmt23b)
    @format_fmt23b = add_record("<08$$$>",@replace8,@format_fmt23b)
    @format_fmt23b = add_record("<09$$$>",@replace9,@format_fmt23b)
    @format_fmt23b = add_record("<10$$$>",@rep10,@format_fmt23b)
    @format_fmt23b = add_record("<11$$$>",@rep11,@format_fmt23b)
    if ar_nu=='0009'
      str12 = "《中国国际经济贸易仲裁委员会金融争议仲裁规则》、"
      str13 = "金融争议"
    else
      str12 = ""
      str13 = ""
    end
    @format_fmt23b = add_record("<12$$$>",str12,@format_fmt23b)
    @format_fmt23b = add_last_record("<13$$$>",str13,@format_fmt23b)
  end
  #简易案件
  def format_letter_fmt23m(code,ar_nu)
    #拼接字串，初始化
    @format_fmt23b = ""
    #立案号
    @case_code = casecode(code)
    @format_fmt23b = add_record("<01$$$>",@case_code,@format_fmt23b)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt23b = add_record("<02$$$>",@applicants,@format_fmt23b)
    #申请人代理人(可多名？）
    @applicant_agent = get_agent(code,1)
    @format_fmt23b = add_record("<03$$$>",@applicant_agent,@format_fmt23b)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt23b = add_record("<04$$$>",@respondents,@format_fmt23b)
    #被申请人代理人(可多名？）
    @respondent_agent = get_agent(code,2)
    @format_fmt23b = add_record("<05$$$>",@respondent_agent,@format_fmt23b)
    @independent_arbitrator=get_fix_appoint(code,'0001')
    @replace6="本会主任的"+@independent_arbitrator
    @replace7=@independent_arbitrator
    @replace8=@independent_arbitrator
    @replace9=@independent_arbitrator
    @format_fmt23b = add_record("<06$$$>",@replace6,@format_fmt23b)
    @format_fmt23b = add_record("<07$$$>",@replace7,@format_fmt23b)
    @format_fmt23b = add_record("<08$$$>",@replace8,@format_fmt23b)
    @format_fmt23b = add_record("<09$$$>",@replace9,@format_fmt23b)
    @format_fmt23b = add_record("<10$$$>","独任仲裁员",@format_fmt23b)
    @format_fmt23b = add_record("<11$$$>","独任仲裁员",@format_fmt23b)
    if ar_nu=='0010'
      str12 = "《中国国际经济贸易仲裁委员会金融争议仲裁规则》、"
      str13 = "金融争议"
    else
      str12 = ""
      str13 = ""
    end
    @format_fmt23b = add_record("<12$$$>",str12,@format_fmt23b)
    @format_fmt23b = add_last_record("<13$$$>",str13,@format_fmt23b)
  end

  def format_letter_fmt23e(code)
    #拼接字串，初始化
    @format_fmt23e = ""
    #立案号
    @case_code = casecode(code)
    @format_fmt23e = add_record("<01$$$>",@case_code,@format_fmt23e)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt23e = add_record("<02$$$>",@applicants,@format_fmt23e)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt23e = add_record("<03$$$>",@respondents,@format_fmt23e)
    #申请人代理人
    @applicant_agent = get_agent(code,1)
    @format_fmt23e = add_record("<04$$$>",@applicant_agent,@format_fmt23e)
    #被申请人代理人
    @respondent_agent = get_agent(code,2)
    @format_fmt23e = add_last_record("<05$$$>",@respondent_agent,@format_fmt23e)
  end

  def format_letter_fmt24(code,p_v,doc_id)
    #拼接字串，初始化
    @format_fmt24 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt24 = add_record("<01$$$>",@file_code,@format_fmt24)
    #立案号
    @case_code = casecode(code)
    @format_fmt24 = add_record("<02$$$>",@case_code,@format_fmt24)
    #当事人
    if p_v=='0001'
      @applicants = applicant(code,2,3)
      @respondents = ""
    elsif p_v=='0002'
      @applicants = ""
      @respondents = respondent(code,2,3)
    elsif p_v=='0003'
      @applicants = applicant(code,2,3)
      @respondents = respondent(code,2,3)
    else
    end
    @format_fmt24 = add_record("<03$$$>",@applicants,@format_fmt24)
    @format_fmt24 = add_record("<04$$$>",@respondents,@format_fmt24)
    #申请人仲裁员 被申请人仲裁员
    @aribitprog_num1=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @num=@aribitprog_num1.aribitprog_num
    if @num=='0003' or @num=='0001' or @an=='0005' # 普通
      if p_v=='0001'
        @applicant_arbitrator = applicant_arbitrator(code) + get_arbitman_sex(code,'0003')
      elsif p_v=='0002'
        @respondent_arbitrator = respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
      else#p_v=='0003' 双方
        @applicant_arbitrator = chief_arbitrator(code) + get_arbitman_sex(code,'0002')
        @respondent_arbitrator =""
      end
    else
      @applicant_arbitrator = independent_arbitrator(code) + get_arbitman_sex(code,'0001')
      @respondent_arbitrator = ""
    end
    @format_fmt24 = add_record("<05$$$>",@applicant_arbitrator,@format_fmt24)
    @format_fmt24 = add_record("<06$$$>",@respondent_arbitrator,@format_fmt24)
    #先按5天算
    @time_limit = PubTool.new.n_to_md(5)
    @format_fmt24 = add_record("<07$$$>",@time_limit,@format_fmt24)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt24 = add_record("<08$$$>",@y2,@format_fmt24)
    @format_fmt24 = add_record("<09$$$>",@m2,@format_fmt24)
    @format_fmt24 = add_last_record("<10$$$>",@d2,@format_fmt24)
  end
  ####################### 预缴查询费 空缺 #########################
  def format_letter_fmt27(code,doc_id)
    #拼接字串，初始化
    @format_fmt27 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt27 = add_record("<01$$$>",@file_code,@format_fmt27)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt27 = add_record("<02$$$>",@applicants,@format_fmt27)

    # 案号
    @case_code = casecode(code)
    @format_fmt27 = add_record("<03$$$>",@case_code,@format_fmt27)
    #预缴查询费
    #
    #
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt27 = add_record("<04$$$>",@y2,@format_fmt27)
    @format_fmt27 = add_record("<05$$$>",@m2,@format_fmt27)
    @format_fmt27 = add_last_record("<06$$$>",@d2,@format_fmt27)
  end

  def format_letter_fmt31(code,doc_id)
    @format_fmt31 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt31 = add_record("<01$$$>",@file_code,@format_fmt31)
    #立案号
    @case_code = casecode(code)
    @format_fmt31 = add_record("<02$$$>",@case_code,@format_fmt31)
    @format_fmt31 = add_record("<06$$$>",@case_code,@format_fmt31)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt31 = add_record("<03$$$>",@respondents,@format_fmt31)
    #申请人
    @applicants = applicant(code,1,4)
    @format_fmt31 = add_record("<04$$$>",@applicants,@format_fmt31)
    #签订的$$$所引起的争议（合同名称）
    @contract_name = get_contract_nd(code)
    @format_fmt31 = add_record("<05$$$>",@contract_name,@format_fmt31)
    #文件份数
    @copies = get_number4(code)#get_number1(code,'0002')
    @format_fmt31 = add_record("<07$$$>",@copies,@format_fmt31)
    @copies2 = get_number41(code)#get_number2(code,'0002')
    @format_fmt31 = add_record("<08$$$>",@copies2,@format_fmt31)
    @format_fmt31 = add_record("<09$$$>",@copies,@format_fmt31)
    @format_fmt31 = add_record("<10$$$>",@copies,@format_fmt31)
    #    @format_fmt31 = add_record("<23$$$>",@copies,@format_fmt31)
    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,2)
    @fax = get_fax(code,2)
    @email = get_email(code)
    @format_fmt31 = add_record("<11$$$>",@zl_alerk,@format_fmt31)
    @format_fmt31 = add_record("<12$$$>",@telephone,@format_fmt31)
    @format_fmt31 = add_record("<13$$$>",@fax,@format_fmt31)
    @format_fmt31 = add_record("<14$$$>",@email,@format_fmt31)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt31 = add_record("<15$$$>",@y2,@format_fmt31)
    @format_fmt31 = add_record("<16$$$>",@m2,@format_fmt31)
    @format_fmt31 = add_record("<17$$$>",@d2,@format_fmt31)
    @voucher1=get_accommodate_remarks(code,2)
    @voucher2=get_accommodate_remarks2(code,2)
    @format_fmt31 = add_record("<21$$$>",@voucher1,@format_fmt31)
    @format_fmt31 = add_record("<22$$$>",@voucher2,@format_fmt31)
    @n_p=get_n_party(code,2)
    @format_fmt31 = add_record("<23$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<24$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<25$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<26$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<27$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<28$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<29$$$>",@n_p,@format_fmt31)
    @format_fmt31 = add_record("<30$$$>",@n_p,@format_fmt31)
    s31=arbitac(code,2)
    @format_fmt31 = add_last_record("<31$$$>",s31,@format_fmt31)
  end

  def format_letter_fmt32(code,p_v,doc_id)
    #拼接字串，初始化
    @format_fmt32 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt32 = add_record("<01$$$>",@file_code,@format_fmt32)
    #立案号
    @case_code = casecode(code)
    @format_fmt32 = add_record("<02$$$>",@case_code,@format_fmt32)
    @format_fmt32 = add_record("<08$$$>",@case_code,@format_fmt32)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt32 = add_record("<03$$$>",@applicants,@format_fmt32)
    @recevicedate2=get_con_year31(code)+"年"+get_con_month31(code)+"月"+get_con_day31(code)+"日"
    @format_fmt32 = add_record("<28$$$>",@recevicedate2,@format_fmt32)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_fmt32 = add_record("<04$$$>",@respondents,@format_fmt32)
    #文件份数
    @copies =  get_number1(code,'0001')
    @format_fmt32 = add_record("<05$$$>",@copies,@format_fmt32)
    #仲裁费
    @arbit_fee = applicant_arbit_fee22(code,'0001')
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @format_fmt32 = add_record("<06$$$>",@arbit_fee,@format_fmt32)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_nd(code)
    @format_fmt32 = add_record("<07$$$>",@contract_name,@format_fmt32)
    #助理
    @zl_alerk = get_name(code)+get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_fmt32 = add_record("<09$$$>",@zl_alerk,@format_fmt32)
    @format_fmt32 = add_record("<10$$$>",@telephone,@format_fmt32)
    @format_fmt32 = add_record("<11$$$>",@fax,@format_fmt32)
    @format_fmt32 = add_record("<12$$$>",@email,@format_fmt32)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt32 = add_record("<13$$$>",@y2,@format_fmt32)
    @format_fmt32 = add_record("<14$$$>",@m2,@format_fmt32)
    @format_fmt32 = add_record("<15$$$>",@d2,@format_fmt32)
    t_code=get_cn_code(code)
    if p_v=='0004'#送达了《仲裁规则》和《仲裁员名册》
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》已经送交你方。"
      @replace21="1、NO. " + t_code + "收据"
      @replace22="2、选定/委托指定/代指定仲裁员预缴实际开支费用表"
      @replace23=""
      @replace24=""
    elsif p_v=='0005'#未送达《仲裁规则》和《仲裁员名册》
      @replace20=""
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    else
      @replace20="另，本会的《仲裁规则》和《仲裁员名册》是否已经送交你方。"
      @replace21="1、《仲裁规则》"
      @replace22="2、《仲裁员名册》"
      @replace23="3、NO. " + t_code + "收据"
      @replace24="4、选定/委托指定/代指定仲裁员预缴实际开支费用表"
    end
    @format_fmt32 = add_record("<20$$$>",@replace20,@format_fmt32)
    @format_fmt32 = add_record("<21$$$>",@replace21,@format_fmt32)
    @format_fmt32 = add_record("<22$$$>",@replace22,@format_fmt32)
    @format_fmt32 = add_record("<23$$$>",@replace23,@format_fmt32)
    @format_fmt32 = add_record("<24$$$>",@replace24,@format_fmt32)
    s25 = arbitac(code,1)
    @format_fmt32 = add_last_record("<25$$$>",s25,@format_fmt32)
  end

  def format_letter_fmt33(code,doc_id)
    #拼接字串，初始化
    @format_fmt33 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt33 = add_record("<01$$$>",@file_code,@format_fmt33)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt33 = add_record("<02$$$>",@applicants,@format_fmt33)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt33 = add_record("<03$$$>",@respondents,@format_fmt33)
    #立案号
    @case_code = casecode(code)
    @format_fmt33 = add_record("<04$$$>",@case_code,@format_fmt33)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt33 = add_record("<05$$$>",@y2,@format_fmt33)
    @format_fmt33 = add_record("<06$$$>",@m2,@format_fmt33)
    @format_fmt33 = add_last_record("<07$$$>",@d2,@format_fmt33)
  end
  ######################       第n次庭审的日期   空缺 ########################
  def format_letter_fmt36(code,doc_id)
    #拼接字串，初始化
    @format_fmt36 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt36 = add_record("<01$$$>",@file_code,@format_fmt36)
    #立案号
    @case_code = casecode(code)
    @format_fmt36 = add_record("<02$$$>",@case_code,@format_fmt36)
    #首席仲裁员
    @chief_arbitrator = chief_arbitrator(code)
    @format_fmt36 = add_record("<03$$$>",@chief_arbitrator,@format_fmt36)
    @format_fmt36 = add_record("<10$$$>",@chief_arbitrator,@format_fmt36)
    @format_fmt36 = add_record("<11$$$>",@chief_arbitrator,@format_fmt36)
    #申请人仲裁员
    @applicant_arbitrator = applicant_arbitrator(code)
    @format_fmt36 = add_record("<04$$$>",@applicant_arbitrator,@format_fmt36)
    #被申请人仲裁员
    @respondent_arbitrator = respondent_arbitrator(code)
    @format_fmt36 = add_record("<05$$$>",@respondent_arbitrator,@format_fmt36)
    ###           第n次庭审的日期###
    @sittingdate=TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"sittingdate desc",:select=>"sittingdate")
    if @sittingdate!=nil
      @sd=@sittingdate.sittingdate
      if @sd!=nil and @sd!=""
        sd= @sd.to_s.split("-")
        sd[1] = sd[1].to_i.to_s
        sd[2] = sd[2].to_i.to_s
        @format_fmt36 = add_record("<06$$$>",sd[0],@format_fmt36)
        @format_fmt36 = add_record("<07$$$>",sd[1],@format_fmt36)
        @format_fmt36 = add_record("<08$$$>",sd[2],@format_fmt36)
      else
        @sd="_____"
        @format_fmt36 = add_record("<06$$$>",@sd,@format_fmt36)
        @format_fmt36 = add_record("<07$$$>",@sd,@format_fmt36)
        @format_fmt36 = add_record("<08$$$>",@sd,@format_fmt36)
      end
    end
    @sittingdate1=TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:select=>"count(id) as cou")
    @cou=@sittingdate1.cou
    if @cou!=nil
      @cou=SysArg.n_to_c(@cou)
      @format_fmt36 = add_record("<09$$$>",@cou,@format_fmt36)
    else
      @cou="_____"
      @format_fmt36 = add_record("<09$$$>",@cou,@format_fmt36)
    end
    #助理
    @zl_alerk = get_name(code)
    @format_fmt36 = add_record("<12$$$>",@zl_alerk,@format_fmt36)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt36 = add_record("<13$$$>",@y2,@format_fmt36)
    @format_fmt36 = add_record("<14$$$>",@m2,@format_fmt36)
    @format_fmt36 = add_last_record("<15$$$>",@d2,@format_fmt36)
  end

  def format_letter_fmt37(code,doc_id)
    #拼接字串，初始化
    @format_fmt37 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt37 = add_record("<01$$$>",@file_code,@format_fmt37)
    #立案号
    @case_code = casecode(code)
    @format_fmt37 = add_record("<02$$$>",@case_code,@format_fmt37)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt37 = add_record("<03$$$>",@applicants,@format_fmt37)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt37 = add_record("<04$$$>",@respondents,@format_fmt37)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt37 = add_record("<05$$$>",@y2,@format_fmt37)
    @format_fmt37 = add_record("<06$$$>",@m2,@format_fmt37)
    @format_fmt37 = add_record("<07$$$>",@d2,@format_fmt37)
    @endstyle1=get_endstyle(code)
    @format_fmt37 = add_record("<09$$$>",@endstyle1,@format_fmt37)
    @format_fmt37 = add_last_record("<10$$$>",@endstyle1,@format_fmt37)
  end
  #仲裁员是否接受选（指）定的征询函  所有案件
  def format_letter_fmt38a(code,doc_id,ar_nu)
    #拼接字串，初始化
    @format_fmt38a = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt38a = add_record("<01$$$>",@file_code,@format_fmt38a)
    #立案号
    @case_code = casecode(code)
    @format_fmt38a = add_record("<02$$$>",@case_code,@format_fmt38a)
    #将要选用的首席仲裁员#将要选用的申请人仲裁员#将要选用的被申请人仲裁员
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    @a = chief_arbitrator(code)
    @b=applicant_arbitrator(code)
    @c=respondent_arbitrator(code)
    @d=independent_arbitrator(code)
    @style1=get_style_from(code,'0003')#申请人方仲裁员选定方式
    @style2=get_style_from(code,'0004')#被申请人方仲裁员选定方式
    @style3=get_style_from(code,'0002')#首席仲裁员选定方式
    @style4=get_style_from(code,'0001')#独任仲裁员选定方式
    #特殊语句处理
    if @style1=="委托"
      @style1="委托本会主任指定"
    elsif @style1=="共同委托"
      @style1="共同委托本会主任指定"
    end
    if @style2=="委托"
      @style2="委托本会主任指定"
    elsif @style2=="共同委托"
      @style2="共同委托本会主任指定"
    end
    if @style3=="委托"
      @style3="委托本会主任指定"
    elsif @style3=="共同委托"
      @style3="共同委托本会主任指定"
    end
    if @style4=="委托"
      @style4="委托本会主任指定"
    elsif @style4=="共同委托"
      @style4="共同委托本会主任指定"
    end

    if @aribitprog_num=='0001'
      @ari="《仲裁规则》（2005年5月1日起施行）关于国内仲裁和普通程序"
    elsif @aribitprog_num=='0002'
      @ari="《仲裁规则》（2005年5月1日起施行）关于国内仲裁和简易程序"
    elsif @aribitprog_num=='0003'
      @ari="《仲裁规则》（2005年5月1日起施行）关于涉外仲裁和普通程序"
    elsif @aribitprog_num=='0004'
      @ari="《仲裁规则》（2005年5月1日起施行）关于涉外仲裁和简易程序"
    else
      @ari="《金融争议仲裁规则》（2005年5月1日起施行）"
    end
    @format_fmt38a = add_record("<26$$$>",@ari,@format_fmt38a)
    @lan=get_language(code)
    @format_fmt38a = add_record("<27$$$>",@lan,@format_fmt38a)
    @n1=TbParty.count(:id,:conditions=>["used='Y' and partytype=1 and recevice_code=?",code])
    @n2=TbParty.count(:id,:conditions=>["used='Y' and partytype=2 and recevice_code=?",code])
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005'  or @aribitprog_num=='0007'#普通
      #首席仲裁员
      @chief_arbitrator = chief_arbitrator(code) + get_arbitman_sex(code,'0002') + "、" + '\r'
      #申请人仲裁员
      @applicant_arbitrator = "      " + @b + get_arbitman_sex(code,'0003') + "、" + '\r'
      #被申请人仲裁员
      @respondent_arbitrator ="      " + @c + get_arbitman_sex(code,'0004')
      @arbit_man="仲裁员/首席仲裁员"
      #当事人xxx选定/指定xxx为仲裁员   发此函时仲裁员已经选定或指定
      if @style1=="代指定"
        if @n1>1
          @seven = "由于申请人未在规定的期限内共同选定或共同委托本会主任指定仲裁员，本会主任为申请人指定"+@b+get_arbitman_sex(code,'0003')+"担任本案仲裁员"
        else
          @seven = "由于申请人未在规定的期限内选定或委托本会主任指定仲裁员，本会主任为申请人指定"+@b+get_arbitman_sex(code,'0003')+"担任本案仲裁员"
        end
      else
        @seven = "申请人"+@style1+@b+get_arbitman_sex(code,'0003')+"担任本案仲裁员"
      end
      if @style2=="代指定"
        if @n2>1
          @eight = "，由于被申请人未在规定的期限内共同选定或共同委托本会主任指定仲裁员，本会主任为被申请人指定"+@c+get_arbitman_sex(code,'0004')+"担任本案仲裁员"
        else
          @eight = "，由于被申请人未在规定的期限内选定或委托本会主任指定仲裁员，本会主任为被申请人指定"+@c+get_arbitman_sex(code,'0004')+"担任本案仲裁员"
        end
      else
        @eight = "，被申请人"+@style2+@c+get_arbitman_sex(code,'0004')+"担任本案仲裁员"
      end
      if @style3=="代指定"
        @nine = "。由于双方未共同选定或共同委托本会主任指定首席仲裁员，本会主任指定"+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+"担任本案首席仲裁员"
      else
        @nine = "。申请人和被申请人"+@style3+chief_arbitrator(code) + get_arbitman_sex(code,'0002')+"担任本案首席仲裁员"
      end
      if @style1=="代指定" && @style2=="代指定" && @style3=="代指定"
        @replace28 = "指定"
        @rep31 = "指定"
      elsif @style1!="代指定" && @style2!="代指定" && @style3!="代指定"
        @replace28 = "选定"
        @rep31 = "选定"
      else
        @replace28 = "选定或指定"
        @rep31 = "选(指)定"
      end
    else#简易---独任仲裁员
      @chief_arbitrator=@d +  get_arbitman_sex(code,'0001')
      @applicant_arbitrator=""
      @respondent_arbitrator= ""
      @arbit_man="独任仲裁员"
      @seven=""
      @nine=""
      if @style4=="代指定"#未选定独任仲裁员
        @eight="由于双方未共同选定或共同委托本会主任指定独任仲裁员，本会主任指定您担任独任仲裁员"
        @replace28 = "指定"
        @rep31 = "指定"
      else
        @eight="申请人和被申请人" + @style4 + "您担任本案独任仲裁员" #@d + get_arbitman_sex(code,'0001') +
        @replace28 = "选定"
        @rep31 = "选定"
      end
    end
    @format_fmt38a = add_record("<03$$$>",@chief_arbitrator,@format_fmt38a)
    @format_fmt38a = add_record("<04$$$>",@applicant_arbitrator,@format_fmt38a)
    @format_fmt38a = add_record("<05$$$>",@respondent_arbitrator,@format_fmt38a)
    @format_fmt38a = add_record("<25$$$>",@arbit_man,@format_fmt38a)
    @format_fmt38a = add_record("<07$$$>",@seven,@format_fmt38a)
    @format_fmt38a = add_record("<08$$$>",@eight,@format_fmt38a)
    @format_fmt38a = add_record("<09$$$>",@nine,@format_fmt38a)
    @format_fmt38a = add_record("<28$$$>",@replace28,@format_fmt38a)
    @format_fmt38a = add_record("<29$$$>",@replace28,@format_fmt38a)
    @format_fmt38a = add_record("<30$$$>",@replace28,@format_fmt38a)
    @format_fmt38a = add_record("<31$$$>",@rep31,@format_fmt38a)
    @format_fmt38a = add_record("<32$$$>",@replace28,@format_fmt38a)
    @case_code1=casecode(code)
    @format_fmt38a = add_record("<06$$$>",@case_code1,@format_fmt38a)
    #申请人
    @applicantss = applicant2(code,2,3,1)
    @format_fmt38a = add_record("<10$$$>",@applicantss,@format_fmt38a)
    #申请人代理人(可多名？）
    @applicant_agent = get_agent2(code,1)
    @format_fmt38a = add_record("<11$$$>",@applicant_agent,@format_fmt38a)
    #被申请人
    @respondents = applicant2(code,2,3,2)
    @format_fmt38a = add_record("<12$$$>",@respondents,@format_fmt38a)
    #被申请人代理人(可多名？）
    @respondent_agent = get_agent2(code,2)
    @format_fmt38a = add_record("<13$$$>",@respondent_agent,@format_fmt38a)
    #争议金额（人民币）
    @accounts_rmb = TbCaseAmount.find(:all,:conditions=>["recevice_code= ? and used='Y' and currency='0001' and typ='0001'",code],:order=>'id')
    @sum_rmb = 0
    for account_rmb in @accounts_rmb
      @sum_rmb = @sum_rmb  +  account_rmb.rmb_money
    end
    @sum_rmb=SysArg.compart1(@sum_rmb)
    @format_fmt38a = add_record("<14$$$>",@sum_rmb,@format_fmt38a)
    #争议类型（该案的类型，立案时选定的）--仲裁协议类型
    @case_typ=get_casetype_num2(code)
    @format_fmt38a = add_record("<17$$$>",@case_typ,@format_fmt38a)
    #助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @email = get_email(code)
    @format_fmt38a = add_record("<18$$$>",@zl_alerk,@format_fmt38a)
    @format_fmt38a = add_record("<15$$$>",@sex,@format_fmt38a)
    @format_fmt38a = add_record("<19$$$>",@telephone,@format_fmt38a)
    @format_fmt38a = add_record("<20$$$>",@fax,@format_fmt38a)
    @format_fmt38a = add_record("<21$$$>",@email,@format_fmt38a)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt38a = add_record("<22$$$>",@y2,@format_fmt38a)
    @format_fmt38a = add_record("<23$$$>",@m2,@format_fmt38a)
    @format_fmt38a = add_record("<24$$$>",@d2,@format_fmt38a)
    if ar_nu=='0003'
      rep33 = "《金融争议仲裁规则》、"
      rep34 = "金融争议"
      rep35 = "《仲裁法》、《仲裁规则》及《金融争议仲裁规则》"
      rep36 = "《金融争议仲裁规则》第二十六条第二款、"
    else
      rep33 = ""
      rep34 = ""
      rep35 = "《仲裁法》及《仲裁规则》"
      rep36 = ""
    end
    @format_fmt38a = add_record("<33$$$>",rep33,@format_fmt38a)
    @format_fmt38a = add_record("<34$$$>",rep34,@format_fmt38a)
    @format_fmt38a = add_record("<35$$$>",rep35,@format_fmt38a)
    @format_fmt38a = add_last_record("<36$$$>",rep36,@format_fmt38a)
  end
  #案件延期
  def format_letter_fmt39(code,doc_id,ar_nu)
    #拼接字串，初始化
    @format_fmt39 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt39 = add_record("<01$$$>",@file_code,@format_fmt39)
    #立案号
    @case_code = casecode(code)
    @format_fmt39 = add_record("<02$$$>",@case_code,@format_fmt39)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt39 = add_record("<03$$$>",@applicants,@format_fmt39)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt39 = add_record("<04$$$>",@respondents,@format_fmt39)
    #开庭日期,可以是多次的
    @sitting_date2=""
    @sitting_date = TbSitting.find(:all, :conditions => ["used = 'Y' and recevice_code = ?",code])
    if @sitting_date != nil
      i=0
      @sitting_date1 = ""
      @sitting_date.each do |t|
        arr_date = t.sittingdate.to_s.split("-")
        arr_date[1]=arr_date[1].to_i.to_s
        arr_date[2]=arr_date[2].to_i.to_s
        @sitting_date1 = arr_date[0]+"年"+arr_date[1]+"月"+arr_date[2]+"日"+", "
        i+=1
      end
      if @sitting_date1!=""
        @sitting_date2=@sitting_date1.slice(0,@sitting_date1.length-2)
      end
    else
      @sitting_date2 = "_____年___月___日"
      i=1
    end
    if i==1 or  i==0
      @num=""
    else
      @num=PubTool.new.n_to_c(i)+"次"
    end
    @format_fmt39 = add_record("<05$$$>",@sitting_date2,@format_fmt39)
    @format_fmt39 = add_record("<09$$$>",@num,@format_fmt39)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt39 = add_record("<06$$$>",@y2,@format_fmt39)
    @format_fmt39 = add_record("<07$$$>",@m2,@format_fmt39)
    @format_fmt39 = add_record("<08$$$>",@d2,@format_fmt39)
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
      @replace10="首席仲裁员：" + chief_arbitrator(code) + get_arbitman_sex(code,'0002')
      @replace11="仲裁员：" +applicant_arbitrator(code) + get_arbitman_sex(code,'0003') + "、"+ respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
    else
      @replace10="独任仲裁员：" + independent_arbitrator(code) + get_arbitman_sex(code,'0001')
      @replace11=""
    end
    @format_fmt39 = add_record("<10$$$>",@replace10,@format_fmt39)
    @format_fmt39 = add_record("<11$$$>",@replace11,@format_fmt39)
    #第四十二条 对应涉外普通程序/第五十六条 对应（涉外和国内的）简易程序/第六十五  对应国内普通
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if ar_nu=='0001'#国内案件
      if @aribitprog_num=='0001' #国内普通
        @legal_code="六十五"
      else
        @legal_code="五十六"
      end
      rep15 = ""
      rep16 = ""
    elsif ar_nu=='0002'#涉外案件
      if @aribitprog_num=='0003'
        @legal_code="四十二"
      else
        @legal_code="五十六"
      end
      rep15 = ""
      rep16 = ""
    else#金融案件
      @legal_code="二十二条第二款"
      rep15 = "金融争议"
      rep16 = "金融争议"
    end
    @format_fmt39 = add_record("<12$$$>",@legal_code,@format_fmt39)
    @delaydat=get_delaydate(code)
    @format_fmt39 = add_record("<13$$$>",@delaydat,@format_fmt39)
    @format_fmt39 = add_record("<14$$$>",@delaydat,@format_fmt39)
    @format_fmt39 = add_record("<15$$$>",rep15,@format_fmt39)
    @format_fmt39 = add_last_record("<16$$$>",rep16,@format_fmt39)
  end
  # <03$$$>仲裁员的报告 -- 选定 或者 指定 或者 代指定 等###
  def format_letter_fmt40(code,doc_id)
    #拼接字串，初始化
    @format_fmt40 = ""
    #函号
    @file_code =get_code1(doc_id)
    @format_fmt40 = add_record("<01$$$>",@file_code,@format_fmt40)
    #立案号
    @case_code = casecode(code)
    @format_fmt40 = add_record("<02$$$>",@case_code,@format_fmt40)
    @case_code1=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    #根据案件类型，提醒代指定的仲裁员类型##########################################
    @style1 = get_style(code,'0003')#申请人方
    @style2 = get_style(code,'0004')#被申请人方
    @style3 = get_style(code,'0002')#首席
    @style4 = get_style(code,'0001')#独任
    @chief_arbitrator1=chief_arbitrator(code)#首席仲裁员
    @applicant_arbitrator1=applicant_arbitrator(code)#申请人仲裁员
    @respondent_arbitrator1=respondent_arbitrator(code)#被申请人仲裁员
    @chief_arbitrator2=independent_arbitrator(code)#独任仲裁员
    @n1=TbParty.count(:id,:conditions=>["used='Y' and partytype=1 and recevice_code=?",code])
    @n2=TbParty.count(:id,:conditions=>["used='Y' and partytype=2 and recevice_code=?",code])
    if @case_code1=='0001' or @case_code1=='0003' or @case_code1=='0005' #普通
      if @style1!="f" && @style2!="f" && @style3=="f" #首席未选定
        @arbitrator19 = "鉴于申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        @arbitrator20 = "首席仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为双方指定_____先生/女士为本案首席仲裁员。"
      elsif @style1=="f" && @style2!="f" && @style3!="f" #申请人未选定
        if @n1>1
          @arbitrator19 = "鉴于申请人未能按期共同选定或共同委托本会主任指定仲裁员"
        else
          @arbitrator19 = "鉴于申请人未能按期选定或委托本会主任指定仲裁员"
        end
        @arbitrator20 = "仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为申请人指定_____先生/女士为本案仲裁员。"
      elsif @style1!="f" && @style2=="f" && @style3!="f" #被申请人未选定
        if @n2>1
          @arbitrator19 = "鉴于被申请人未能按期共同选定或共同委托本会主任指定仲裁员"
        else
          @arbitrator19 = "鉴于被申请人未能按期选定或委托本会主任指定仲裁员"
        end
        @arbitrator20 = "仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为被申请人指定_____先生/女士为本案仲裁员。"
      elsif  @style1=="f" && @style2=="f" && @style3!="f" #申请人和被申请人未选定仲裁员
        if @n1>1
          @arbitratora = "鉴于申请人未能按期共同选定或共同委托本会主任指定仲裁员,"
        else
          @arbitratora = "鉴于申请人未能按期选定或委托本会主任指定仲裁员,"
        end
        if @n2>1
          @arbitratorb = "被申请人未能按期共同选定或共同委托本会主任指定仲裁员"
        else
          @arbitratorb = "被申请人未能按期选定或委托本会主任指定仲裁员"
        end
        @arbitrator19 = @arbitratora + @arbitratorb
        @arbitrator20 = "仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为申请人指定_____先生/女士为本案仲裁员,为被申请人指定_____先生/女士为本案仲裁员。"
      elsif @style1=="f" && @style2!="f" && @style3=="f" #申请人、双方未选定
        if @n1>1
          @arbitrator19 = "鉴于申请人未能按期共同选定或共同委托本会主任指定仲裁员,申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        else
          @arbitrator19 = "鉴于申请人未能按期选定或委托本会主任指定仲裁员,申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        end
        @arbitrator20 = "仲裁员/首席仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为申请人指定_____先生/女士为本案仲裁员,为双方指定_____先生/女士为本案首席仲裁员。"
      elsif @style1!="f" && @style2=="f" && @style3=="f" #被申请人、双方未选定
        if @n2>1
          @arbitrator19 = "鉴于被申请人未能按期共同选定或共同委托本会主任指定仲裁员,申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        else
          @arbitrator19 = "鉴于被申请人未能按期选定或委托本会主任指定仲裁员,申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        end
        @arbitrator20 = "仲裁员/首席仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为被申请人指定_____先生/女士为本案仲裁员,为双方指定_____先生/女士为本案首席仲裁员。"
      elsif @style1=="f" && @style2=="f" && @style3=="f" #当事人方、首席都未选定
        if @n1>1
          @arbitratora = "鉴于申请人未能按期共同选定或共同委托本会主任指定仲裁员，"
        else
          @arbitratora = "鉴于申请人未能按期选定或委托本会主任指定仲裁员，"
        end
        if @n2>1
          @arbitratorb = "被申请人未能按期共同选定或共同委托本会主任指定仲裁员，"
        else
          @arbitratorb = "被申请人未能按期选定或委托本会主任指定仲裁员，"
        end
        @arbitrator19 = @arbitratora + @arbitratorb + "申请人和被申请人未能按期共同选定或共同委托本会主任指定首席仲裁员"
        @arbitrator20 = "仲裁员/首席仲裁员"
        @replace22 = "基于上述情况，本会秘书处拟请本会主任为申请人指定_____先生/女士为本案仲裁员,为被申请人指定_____先生/女士为本案仲裁员,为双方指定_____先生/女士为本案首席仲裁员。"
      else #都选定了
        if @style1!="代指定"
          @seven="申请人" + @style1 + applicant_arbitrator(code) + get_arbitman_sex(code,'0003') + "担任本案仲裁员"
        else
          @seven="本会主任为申请人指定" + applicant_arbitrator(code) + get_arbitman_sex(code,'0003') + "担任本案仲裁员"
        end
        if @style2!="代指定"
          @eight="，被申请人" + @style2 + respondent_arbitrator(code) + get_arbitman_sex(code,'0004') + "担任本案仲裁员"
        else
          @seven="，本会主任为被申请人指定" + respondent_arbitrator(code) + get_arbitman_sex(code,'0003') + "担任本案仲裁员"
        end
        if @style3!="代指定"
          @nine="，双方" + @style3 + chief_arbitrator(code) + get_arbitman_sex(code,'0002') + "担任本案首席仲裁员"
        else
          @nine="，本会主任为双方指定" + @style3 + chief_arbitrator(code) + get_arbitman_sex(code,'0002') + "担任本案首席仲裁员"
        end
        @arbitrator19=@seven + @eight + @nine
        @arbitrator20 ="仲裁员/首席仲裁员"
        @replace22 = ""
      end
    else  #简易案件
      if @style4=="f"#未选定独任仲裁员
        @arbitrator19="鉴于双方未能按期共同选定或共同委托本会主任指定独任仲裁员"
        @replace22="基于上述情况，本会秘书处拟请本会主任为双方指定_____先生/女士为本案独任仲裁员。"
      else
        @arbitrator19="申请人和被申请人" + @style4 + independent_arbitrator(code) + get_arbitman_sex(code,'0001') + "担任本案独任仲裁员"
        @replace22=""
      end
      @arbitrator20="独任仲裁员"
    end
    @format_fmt40 = add_record("<19$$$>",@arbitrator19,@format_fmt40)
    @format_fmt40 = add_record("<20$$$>",@arbitrator20,@format_fmt40)
    @format_fmt40 = add_record("<22$$$>",@replace22,@format_fmt40)
    #################################################################################
    @format_fmt40 = add_record("<04$$$>",@case_code,@format_fmt40)
    #申请人
    @applicants = applicant2_fmt40(code,1)
    @format_fmt40 = add_record("<05$$$>",@applicants,@format_fmt40)
    #申请人代理人(可多名？）
    @applicant_agent =get_agent2_fmt40(code,1)
    @format_fmt40 = add_record("<06$$$>",@applicant_agent,@format_fmt40)
    #被申请人
    @respondents = applicant2_fmt40(code,2)
    @format_fmt40 = add_record("<07$$$>",@respondents,@format_fmt40)
    #被申请人代理人(可多名？）
    @respondent_agent =get_agent2_fmt40(code,2)
    @format_fmt40 = add_record("<08$$$>",@respondent_agent,@format_fmt40)
    ### 关于<09$$$>仲裁及<10$$$>程序的有关规定--指国内、涉外；简易、普通的意思，从程序内容中取 ###
    @typ=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @typ1=@typ.aribitprog_num
    if @typ1=='0001'
      @a1="国内"
      @a2="普通"
      @r="三人仲裁庭"
    elsif @typ1=='0002'
      @a1="国内"
      @a2="简易"
      @r="独任仲裁庭"
    elsif @typ1=='0003'
      @a1="涉外"
      @a2="普通"
      @r="三人仲裁庭"
    elsif @typ1=='0004'
      @a1="涉外"
      @a2="简易"
      @r="独任仲裁庭"
    elsif @typ1=='0005'
      @a1="国内"
      @a2="金融规则3人"
      @r="三人仲裁庭"
    elsif @typ1=='0006'
      @a1="国内"
      @a2="金融规则1人"
      @r="独任仲裁庭"
    elsif @typ1=='0007'
      @a1="涉外"
      @a2="金融规则3人"
      @r="三人仲裁庭"
    else
      @a1="涉外"
      @a2="金融规则1人"
      @r="独任仲裁庭"
    end
    @format_fmt40 = add_record("<09$$$>",@a1,@format_fmt40)
    @format_fmt40 = add_record("<10$$$>",@a2,@format_fmt40)
    #  11 是仲裁庭组成的，简易 独任仲裁庭；普通  三人仲裁庭
    @format_fmt40 = add_record("<11$$$>",@r,@format_fmt40)
    #申请人仲裁员
    if @applicant_arbitrator1=="_____"
      @applicant_arbitrator1="无"
    end
    @format_fmt40 = add_record("<12$$$>",@applicant_arbitrator1,@format_fmt40)
    #被申请人仲裁员
    if @respondent_arbitrator1=="_____"
      @respondent_arbitrator1="无"
    end
    @format_fmt40 = add_record("<13$$$>",@respondent_arbitrator1,@format_fmt40)
    #办案秘书--助理
    #助理
    @zl_alerk = get_name(code)
    @format_fmt40 = add_record("<14$$$>",@zl_alerk,@format_fmt40)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt40 = add_record("<15$$$>",@y2,@format_fmt40)
    @format_fmt40 = add_record("<16$$$>",@m2,@format_fmt40)
    @format_fmt40 = add_record("<17$$$>",@d2,@format_fmt40)
    @casetype_num2=get_casetype_num2(code)
    @format_fmt40 = add_record("<18$$$>",@casetype_num2,@format_fmt40)
    @lan=get_language(code)
    @format_fmt40 = add_record("<23$$$>",@lan,@format_fmt40)

    # 争议金额
    # 币种全部转成人民币也可以
    # 增加、减少，本函不考虑
    # 在本函只写明立案时候的争议金额即可

    @format_fmt40 = add_record("<25$$$>",get_amount_detail(code),@format_fmt40)

    @dispute_type = TbJurisdiction.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @dispute_type!=nil
      @format_fmt40 = add_last_record("<24$$$>","有",@format_fmt40)
    else
      @format_fmt40 = add_last_record("<24$$$>","无",@format_fmt40)
    end

  end
  #补缴仲裁费用通知单
  def format_letter_fmt41(code,p_t,doc_id)
    #拼接字串，初始化
    @format_fmt41 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt41 = add_record("<01$$$>",@file_code,@format_fmt41)
    #判断申请人或者被申请人
    if p_t == '0001'
      #申请人
      @applicants = applicant(code,2,3)
    else# p_t == '0002'
      #被申请人
      @applicants = respondent(code,2,3)
    end
    @format_fmt41 = add_record("<02$$$>",@applicants,@format_fmt41)
    #“就$$$争议” （合同名称）
    @contract_name =  get_contract_name(code)
    @format_fmt41 = add_record("<03$$$>",@contract_name,@format_fmt41)
    #提出变更请求的日期，“于  年 月  日”，空缺
    @caseamount = TbCaseAmount.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,p_t.to_i],:order=>"id desc")
    if @caseamount!=nil
      if @caseamount.dt!=nil
        arr_date = @caseamount.dt.to_s.split("-")
        @replace4=SysArg.n_to_c(arr_date[0].to_i) + "年" + SysArg.n_to_md(arr_date[1].to_i) + "月" + SysArg.n_to_md(arr_date[2].to_i) + "日"
      else
        @replace4="_____年__月__日"
      end
    else
      @replace4="_____年__月__日"
    end
    @format_fmt41 = add_record("<04$$$>",@replace4,@format_fmt41)
    @replace5=get_fax2(code,p_t) #传真号
    @format_fmt41 = add_record("<05$$$>",@replace5,@format_fmt41)
    #补缴仲裁费<07$$$>
    if p_t == '0001' #申请人
      @arbit_fee=applicant_arbit_fee3(code,'0001')
    elsif p_t == '0002'#被申请人
      @arbit_fee=applicant_arbit_fee3(code,'0002')
    else
      @arbit_fee=0
    end
    @arbit_fee=SysArg.compart1(@arbit_fee)
    @format_fmt41 = add_record("<07$$$>",@arbit_fee,@format_fmt41)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt41 = add_record("<08$$$>",@y2,@format_fmt41)
    @format_fmt41 = add_record("<09$$$>",@m2,@format_fmt41)
    @format_fmt41 = add_last_record("<10$$$>",@d2,@format_fmt41)
  end

  def format_letter_fmt42(code,doc_id)
    #拼接字串，初始化
    @format_fmt42 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt42 = add_record("<01$$$>",@file_code,@format_fmt42)
    #立案号
    @case_code = casecode(code)
    @format_fmt42 = add_record("<02$$$>",@case_code,@format_fmt42)
    #日期
    @date_of_letter =TbDoc.find(doc_id).ss_t # Time.now.to_s(:db)
    if @date_of_letter == nil or @date_of_letter == ""
      @date_of_letter = "_____"
      @format_fmt42 = add_record("<03$$$>",@date_of_letter,@format_fmt42)
      @format_fmt42 = add_record("<04$$$>",@date_of_letter,@format_fmt42)
      @format_fmt42 = add_record("<05$$$>",@date_of_letter,@format_fmt42)
    else
      arr_date = @date_of_letter.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @format_fmt42 = add_record("<03$$$>",arr_date[0],@format_fmt42)
      @format_fmt42 = add_record("<04$$$>",arr_date[1],@format_fmt42)
      @format_fmt42 = add_record("<05$$$>",arr_date[2],@format_fmt42)
    end
    #联系人--确定是否是助理
    @zl_alerk = get_name(code)
    @sex = get_zlsex(code)
    @telephone = get_tel(code,1)
    @fax = get_fax(code,1)
    @format_fmt42 = add_record("<06$$$>",@zl_alerk,@format_fmt42)
    @format_fmt42 = add_record("<09$$$>",@sex,@format_fmt42)
    @format_fmt42 = add_record("<07$$$>",@telephone,@format_fmt42)
    @format_fmt42 = add_last_record("<08$$$>",@fax,@format_fmt42)
  end

  def format_letter_fmt44(code,doc_id)
    #拼接字串，初始化
    @format_fmt44 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt44 = add_record("<01$$$>",@file_code,@format_fmt44)
    #立案号
    @case_code = casecode(code)
    @format_fmt44 = add_record("<02$$$>",@case_code,@format_fmt44)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt44 = add_record("<03$$$>",@applicants,@format_fmt44)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt44 = add_record("<04$$$>",@respondents,@format_fmt44)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt44 = add_record("<05$$$>",@y2,@format_fmt44)
    @format_fmt44 = add_record("<06$$$>",@m2,@format_fmt44)
    @format_fmt44 = add_last_record("<07$$$>",@d2,@format_fmt44)
  end

  def format_letter_fmt45(doc_id)
    #拼接字串，初始化
    @format_fmt45 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt45 = add_record("<01$$$>",@file_code,@format_fmt45)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt45 = add_record("<02$$$>",@y2,@format_fmt45)
    @format_fmt45 = add_record("<03$$$>",@m2,@format_fmt45)
    @format_fmt45 = add_last_record("<04$$$>",@d2,@format_fmt45)
  end

  def format_letter_fmt46(code,doc_id)
    #拼接字串，初始化
    @format_fmt46 = ""
    #函号
    @file_code = get_code1(doc_id)
    @format_fmt46 = add_record("<01$$$>",@file_code,@format_fmt46)
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt46 = add_record("<02$$$>",@applicants,@format_fmt46)
    #立案号
    @case_code = casecode(code)
    @format_fmt46 = add_record("<03$$$>",@case_code,@format_fmt46)
    #日期
    @y2 = get_con_year2(doc_id)
    @m2 = get_con_month2(doc_id)
    @d2 = get_con_day2(doc_id)
    @format_fmt46 = add_record("<04$$$>",@y2,@format_fmt46)
    @format_fmt46 = add_record("<05$$$>",@m2,@format_fmt46)
    @format_fmt46 = add_record("<06$$$>",@d2,@format_fmt46)
    #收 反请求及证据 的时间
    amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    str8 = "反请求申请书/答辩书（被申请人在答辩书中提出了反请求）"
    if amail!=nil
      recevicedate = amail.recevicedate
      str7=SysArg.get_ymd(recevicedate)
      if amail.submitman=='0002' #被申请人
        if amail.materialtype!=nil
          if amail.materialtype=='0001'
            str8 = "答辩书及证据（被申请人在答辩书中提出了反请求）"
          else
            str8 = TbDictionary.find(:first,:conditions=>["typ_code='8138' and state='Y' and used='Y' and data_val=?",amail.materialtype]).data_text
          end
        else
          str8 = amail.material_other
        end
      end
    else
      str7 = "______年____月____日"
    end
    @format_fmt46 = add_record("<07$$$>",str7,@format_fmt46)
    @format_fmt46 = add_last_record("<08$$$>",str8,@format_fmt46)
  end

  def format_letter_fmt47(code,ar_nu)
    #拼接字串，初始化
    @format_fmt47 = ""
    #申请人
    @applicants = applicant(code,2,3)
    @format_fmt47 = add_record("<01$$$>",@applicants,@format_fmt47)
    #被申请人
    @respondents = respondent(code,2,3)
    @format_fmt47 = add_record("<02$$$>",@respondents,@format_fmt47)
    #立案号
    @case_code = casecode(code)
    @format_fmt47 = add_record("<03$$$>",@case_code,@format_fmt47)
    #首席仲裁员  申请人仲裁员  被申请人仲裁员
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'#普通
      @chief_arbitrator = "首席仲裁员" + chief_arbitrator(code) + get_arbitman_sex(code,'0002') + "以及"
      @applicant_arbitrator ="仲裁员" + applicant_arbitrator(code) + get_arbitman_sex(code,'0003')+"和"
      @respondent_arbitrator = respondent_arbitrator(code) + get_arbitman_sex(code,'0004')
    else
      @chief_arbitrator = "独任仲裁员" + independent_arbitrator(code) + get_arbitman_sex(code,'0001')
      @applicant_arbitrator = ""
      @respondent_arbitrator = ""
    end
    @format_fmt47 = add_record("<04$$$>",@chief_arbitrator,@format_fmt47)
    @format_fmt47 = add_record("<05$$$>",@applicant_arbitrator,@format_fmt47)
    @format_fmt47 = add_record("<06$$$>",@respondent_arbitrator,@format_fmt47)
    #开庭日期
    @sittingdate=TbArbitroom.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @sittingdate!=nil
      @sdate=@sittingdate.sittingdate
      arr_date = @sdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @sdate=SysArg.n_to_c(arr_date[0].to_i.to_s)+"年"+SysArg.n_to_md(arr_date[1])+"月"+SysArg.n_to_md(arr_date[2])+"日"
    else
      @sdate="____年__月__日"
    end
    @format_fmt47 = add_record("<07$$$>",@sdate,@format_fmt47)
    if ar_nu=='0003'
      rep8 = "2005年5月1日"
      rep9 = "金融争议"
    else
      rep8 = "2005年5月1日"
      rep9 = ""
    end
    @format_fmt47 = add_record("<08$$$>",rep8,@format_fmt47)
    @format_fmt47 = add_record("<09$$$>",rep9,@format_fmt47)
    @format_fmt47 = add_last_record("<10$$$>",@sdate,@format_fmt47)
  end
  #开庭签到表
  def format_letter_fmt48(code)
    #拼接字串，初始化
    @format_fmt48 = ""
    @case_code = casecode(code)
    @format_fmt48 = add_record("<01$$$>",@case_code,@format_fmt48)
    @sitting_date=get_sittingdate2(code)
    @format_fmt48 = add_record("<02$$$>",@sitting_date,@format_fmt48)
    #仲裁员
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'#普通
      @str3 = "首席"
      @chief_arbitrator = chief_arbitrator(code) + "（签名） __________" + '\r' + "        仲  裁  员：" + applicant_arbitrator(code) + "（签名） __________" +'\r' + "        仲  裁  员："+ respondent_arbitrator(code) + "（签名） __________"
    else
      @str3 = "独任"
      @chief_arbitrator = independent_arbitrator(code) + "（签名） __________"
    end
    @zl = get_name(code) + "（签名） __________"
    @format_fmt48 = add_record("<03$$$>",@str3,@format_fmt48)
    @format_fmt48 = add_record("<04$$$>",@chief_arbitrator,@format_fmt48)
    @format_fmt48 = add_record("<05$$$>",@zl,@format_fmt48)
    #申请人
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",code], :order => "id")
    if @applicants == nil
      @applicant1 = "____________"
    else
      @applicant1 = ""
      @n1 = @applicants.length
      if @n1==1
        @applicant1 = @applicant1 + "申 请 人（名称）：" + PubTool.new.get_first_record(@applicants).partyname + '\r'
        @tp=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=1 and commissary!='' and partyname=?",code,PubTool.new.get_first_record(@applicants).partyname])
        @tp1 = PubTool.new.get_first_record(@tp)
        if @tp1!=nil
          i=1
          @tp.each do |agents|
            if i>1
              @applicant1=@applicant1 + "                     " + agents.commissary + "（签名） __________"  + '\r'
            else
              @applicant1=@applicant1 + "          法定代表人：" + agents.commissary  + "（签名） __________" + '\r'
            end
            i+=1
          end
        end
        #申请人的代理人
        @agents1 = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=1 and party_id=?",code,PubTool.new.get_first_record(@applicants).id])
        @ag1 =  PubTool.new.get_first_record(@agents1)
        if @ag1!=nil
          i2=1
          @agents1.each do |agentss|
            if i2>1
              @applicant1=@applicant1 + "                 " + agentss.name + "（签名） __________"  + '\r'
            else
              @applicant1=@applicant1 + "          代理人：" + agentss.name + "（签名） __________"  + '\r'
            end
            i2+=1
          end
        end
      else#多个申请人时按次序显示
        i3 = 1
        @applicants.each do |applicant|
          @applicant1=@applicant1 + "第" +SysArg.n_to_c(i3)+ "申请人（名称）："+applicant.partyname + '\r'
          #法定代表人
          @tp3=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=1 and commissary!='' and partyname=?",code,applicant.partyname])
          @tp = PubTool.new.get_first_record(@tp3)
          if @tp!=nil
            @n3 = @tp3.length
            if @n3==1
              @applicant1=@applicant1 + "          法定代表人：" + @tp.commissary  + "（签名） __________" + '\r'
            else
              i5 = 1
              @tp3.each do |tp3|
                if i5>1
                  @applicant1=@applicant1 + "                     " + tp3.commissary  + "（签名） __________" + '\r'
                else
                  @applicant1=@applicant1 + "          法定代表人：" + tp3.commissary  + "（签名） __________" + '\r'
                end
                i5+=1
              end
            end
          end
          #代理人
          @agents2 = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=1 and party_id=?",code,applicant.id])
          @agents1 = PubTool.new.get_first_record(@agents2)
          if @agents1!=nil
            i6 = 1
            @agents2.each do |a|
              if i6>1
                @applicant1=@applicant1 + "                  " + a.name + "（签名） __________"  + '\r'
              else
                @applicant1=@applicant1 + "          代理人：" + a.name + "（签名） __________"  + '\r'
              end
              i6+=1
            end
          end
          i3+=1
        end
      end#  去掉最后的\r
    end
    @applicant1=@applicant1.slice(0,@applicant1.length-2)
    @format_fmt48 = add_record("<06$$$>",@applicant1,@format_fmt48)
    #被申请人
    @applicants2 = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",code], :order => "id")
    if @applicants == nil
      @applicant2 = "____________"
    else
      @n2 = @applicants2.length
      @applicant2 = ""
      if @n2==1
        @applicant2 =@applicant2 + "被申请人（名称）：" + PubTool.new.get_first_record(@applicants2).partyname + '\r'
        @tp=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=2 and commissary!='' and partyname=?",code,PubTool.new.get_first_record(@applicants2).partyname])
        @tp1 = PubTool.new.get_first_record(@tp)
        if @tp1!=nil
          i=1
          @tp.each do |agents|
            if i>1
              @applicant2=@applicant2 + "                     " + agents.commissary + "（签名） __________"  + '\r'
            else
              @applicant2=@applicant2 + "          法定代表人：" + agents.commissary  + "（签名） __________" + '\r'
            end
            i+=1
          end
        end
        #被申请人的代理人
        @agents1 = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=2 and party_id=?",code,PubTool.new.get_first_record(@applicants2).id])
        @ag1 =  PubTool.new.get_first_record(@agents1)
        if @ag1!=nil && @ag1!=""
          i=1
          @agents1.each do |agentss|
            if i>1
              @applicant2=@applicant2 + "                 " + agentss.name + "（签名） __________"  + '\r'
            else
              @applicant2=@applicant2 + "          代理人：" + agentss.name + "（签名） __________"  + '\r'
            end
            i+=1
          end
        end
      else#多个被申请人
        i=1
        @applicants2.each do |applicant2|
          @applicant2=@applicant2 +"第" +SysArg.n_to_c(i)+ "被申请人（名称）："+ applicant2.partyname + '\r'
          #法定代表人
          @tp4=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=2 and commissary!='' and partyname=?",code,applicant2.partyname])
          @tp = PubTool.new.get_first_record(@tp4)
          if @tp!=nil
            i7 = 1
            @tp4.each do |tp4|
              if i7>1
                @applicant2=@applicant2 + "                     " + tp4.commissary  + "（签名） __________" + '\r'
              else
                @applicant2=@applicant2 + "          法定代表人：" + tp4.commissary  + "（签名） __________" + '\r'
              end
              i7+=1
            end
          end
          #代理人
          @agents10 = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=2 and party_id=?",code,applicant2.id])
          @agents1 = PubTool.new.get_first_record(@agents10)
          if @agents1!=nil
            i8 = 1
            @agents10.each do |agents1|
              if i8>1
                @applicant2=@applicant2 + "                 " + agents1.name + "（签名） __________"  + '\r'
              else
                @applicant2=@applicant2 + "          代理人：" + agents1.name + "（签名） __________"  + '\r'
              end
              i8+=1
            end
          end
          i+=1
        end      #  去掉最后的\r
      end
    end
    @applicant2=@applicant2.slice(0,@applicant2.length-2)
    @format_fmt48 = add_last_record("<07$$$>",@applicant2,@format_fmt48)
  end
  #变 更 仲 裁 费 用 审 批 表（涉外案件）；增加/减少争议金额
  def format_letter_fmt49(code,p_v)
    @format_fmt49 = ""
    rep11 = ""
    rep2 = "____年__月__日"
    rep10 = "____年__月__日"
    rep3 = ""
    rep4 = ""
    rep5 = ""
    rep6 = ""
    rep7 = ""
    rep8 = ""
    rep9 = ""
    rep13 = ""
    if p_v=='0001'#提出人是申请人
      rep1 = applicant(code,1,4)
      @a=1
    else#被申请人
      rep1 = respondent(code,1,4)
      @a=2
    end
    aribitprog_num = TbCase.find_by_recevice_code(code).aribitprog_num
    if aribitprog_num=='0001' or aribitprog_num=='0002' or aribitprog_num=='0005' or aribitprog_num=='0006'
      rep12 = "国内"
    else
      rep12 = "涉外"
    end
    @format_fmt49 = add_record("<12$$$>",rep12,@format_fmt49)
    @format_fmt49 = add_record("<01$$$>",rep1,@format_fmt49)
    #立案号
    case_code = casecode(code)
    @format_fmt49 = add_record("<03$$$>",case_code,@format_fmt49)
    #typ=='0002' （增加）；'0003' （减少）
    @caseamount = TbCaseAmount.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=? and typ<>'0001'",code,@a],:order=>"id desc")
    if @caseamount!=nil
      rep2 = SysArg.get_ymd(@caseamount.dt)
      rep10 = rep2
      rep9 = @caseamount.remark
      if @caseamount.typ=='0002'
        rep11 = "（增加）"
        rep13 = "增加"
        #增加的明确的争议金额
        rep4 =SysArg.get_d_money(code,'0002',@caseamount.id,@a)
        #增加的不明确但可以确定的争议金额
        rep5 = SysArg.get_i_money(code,'0002',@caseamount.id,@a)
        #明确的或不明确但可以确定的争议金额的仲裁费用
        @sum1 = TbShouldCharge.find_by_sql("select s.rmb_money as sm from tb_should_charges as s,tb_case_amounts as a
     where s.used='Y' and a.used='Y' and s.recevice_code=a.recevice_code and s.recevice_code='#{code}' and s.case_amount_id=#{@caseamount.id} and s.parent_id=0 and a.typ='0002' and a.partytype=#{@a} order by a.id desc")
        @s1=PubTool.new.get_first_record(@sum1)
        if @s1!=nil
          @rep7 = @s1.sm
          rep7 = SysArg.compart1(@rep7.to_f)
        else
          @rep7 = 0
        end
        #不明确且无法确定金额的请求事项的仲裁费用
        @sum2= TbShouldCharge.find(:first,:conditions=>"used='Y' and recevice_code='#{code}' and parent_id=0 and payment='#{p_v}' and typ='0009'",:select=>"sum(rmb_money) as sm2",:order=>"id desc")
        if @sum2!=nil
          @rep8 = @sum2.sm2
          if @rep8!=nil
            rep8 = SysArg.compart1(@rep8.to_f)
          end
        else
          @rep8 = 0
          rep8 = ""
        end
        @rep6 = @rep7.to_i + @rep8.to_i
        rep6 = SysArg.compart2(@rep6)
      elsif @caseamount.typ=='0003'
        rep11 = "（减少）"
        rep13 = "减少"
        #减少的明确的争议金额
        rep4 = SysArg.get_d_money(code,'0003',@caseamount.id,@a)
        #减少的不明确但可以确定的争议金额
        rep5 = SysArg.get_i_money(code,'0003',@caseamount.id,@a)
        #明确的或不明确但可以确定的争议金额的仲裁费用
        @sum1 = TbShouldRefund.sum(:rmb_money,:conditions=>["recevice_code=? and used='Y' and payment=? and case_amount_id=? and typ='0001'",code,p_v,@caseamount.id])
        if @sum1!=nil
          @rep7 = @sum1.to_f
          rep7 = SysArg.compart1(@rep7.to_f)
        else
          @rep7 = 0
        end
        #不明确且无法确定金额的请求事项的仲裁费用
        @sum2= TbShouldRefund.sum(:rmb_money,:conditions=>["recevice_code=? and used='Y' and payment=? and case_amount_id=? and typ='0004'",code,p_v,@caseamount.id])
        if @sum2!=nil
          @rep8 = @sum2.to_f
          rep8 = SysArg.compart1(@rep8.to_f)
        else
          @rep8 = 0
        end
        @rep6 = @rep7 + @rep8
        rep6 = SysArg.compart2(@rep6)
      end
    end
    @format_fmt49 = add_record("<11$$$>",rep11,@format_fmt49)
    @format_fmt49 = add_record("<02$$$>",rep2,@format_fmt49)
    @format_fmt49 = add_record("<10$$$>",rep10,@format_fmt49)
    @format_fmt49 = add_record("<03$$$>",rep3,@format_fmt49)
    @format_fmt49 = add_record("<04$$$>",rep4,@format_fmt49)
    @format_fmt49 = add_record("<05$$$>",rep5,@format_fmt49)
    @format_fmt49 = add_record("<06$$$>",rep6,@format_fmt49)
    @format_fmt49 = add_record("<07$$$>",rep7,@format_fmt49)
    @format_fmt49 = add_record("<08$$$>",rep8,@format_fmt49)
    @format_fmt49 = add_record("<09$$$>",rep9,@format_fmt49)
    @format_fmt49 = add_record("<13$$$>",rep13,@format_fmt49)
    @format_fmt49 = add_last_record("<14$$$>",rep13,@format_fmt49)
  end
  #退 费 审 批 表 ---- 所有案件
  def format_letter_fmt50(code)
    @format_fmt50 = ""
    rep1 = casecode(code)
    @format_fmt50 = add_record("<01$$$>",rep1,@format_fmt50)
    tb_caseendbook = TbCaseendbook.find_by_used_and_recevice_code('Y',code)
    end_num = (tb_caseendbook!=nil) ? tb_caseendbook.arbitBookNum : ""
    @format_fmt50 = add_record("<02$$$>",end_num,@format_fmt50)
    zl = get_name(code)
    @format_fmt50 = add_record("<03$$$>",zl,@format_fmt50)
    rep4 = applicant(code,1,4)
    @format_fmt50 = add_record("<04$$$>",rep4,@format_fmt50)
    rep5 = respondent(code,1,4)
    @format_fmt50 = add_record("<05$$$>",rep5,@format_fmt50)
    tb_should_refund = TbShouldRefund.find(:first,:conditions=>["used=? and recevice_code=? and parent_id=0 and state<>3",'Y',code],:order=>"id desc")
    if tb_should_refund!=nil
      rep6 = tb_should_refund.payment=='0001' ? rep4 : rep5
      if tb_should_refund.refund_date!=nil
        arr_date = tb_should_refund.refund_date.to_s.split("-")
        rep7 = arr_date[0].to_i.to_s + "年" +arr_date[1].to_i.to_s + "月"+ arr_date[2].to_i.to_s+"日"
      else
        rep7 = "_____年__月__日"
      end
      rep8 = tb_should_refund.refund_case
      rep9 = tb_should_refund.payment=='0001' ? SysArg.compart2(TbCase.find_by_recevice_code(code).m_re_rmb_money) : SysArg.compart2(TbCase.find_by_recevice_code(code).m_re_rmb_money_2)
      m_typ = PubTool.get_sign(tb_should_refund.currency)
      rep10 = m_typ + SysArg.compart2(tb_should_refund.f_money)
    else
      rep6 = ""
      rep7 = "_____年__月__日"
      rep8 = ""
      rep9 = ""
      rep10 = ""
    end
    @format_fmt50 = add_record("<06$$$>",rep6,@format_fmt50)
    @format_fmt50 = add_record("<07$$$>",rep7,@format_fmt50)
    @format_fmt50 = add_record("<08$$$>",rep8,@format_fmt50)
    @format_fmt50 = add_record("<09$$$>",rep9,@format_fmt50)
    @format_fmt50 = add_record("<10$$$>",rep10,@format_fmt50)
    arr_date = Date.today().to_s.split("-")
    rep11 = arr_date[0].to_i.to_s + "年" +arr_date[1].to_i.to_s + "月"+ arr_date[2].to_i.to_s+"日"
    @format_fmt50 = add_last_record("<11$$$>",rep11,@format_fmt50)
  end
  # 送达回证格式函
  def format_letter_fmt51(code, p_v)
    @format_fmt51 = ""

    # 当事人
    @dangshiren = ""
    if p_v == '0001'  #申请人
      @dangshiren = applicant(code,1,4)
    elsif p_v=='0002' #被申请人
      @dangshiren = respondent(code,1,4)
    else              #双方
      @applicant1  = applicant(code,1,4)
      @respondents = respondent(code,1,4)
      @dangshiren = @applicant1 + '\r' + @respondents
    end
    @format_fmt51 = add_record("<01$$$>",@dangshiren,@format_fmt51)

    # 案由
    @casereason = ""
    tbcase = TbCase.find_by_recevice_code(code)
    if !tbcase.blank?
      @casereason = tbcase.casereason
    end
    @format_fmt51 = add_record("<02$$$>",@casereason,@format_fmt51)

    # 送达人（助理姓名）
    @format_fmt51 = add_last_record("<03$$$>",get_name(code),@format_fmt51)

  end
  #需预缴的费用 空缺 --- 在案件费用的界面里面，对应 “无明确争议金额收费”
  def format_letter_for03(code,doc_id)
    #拼接字串，初始化
    @format_for03 = ""
    #申请人
    @applicants = applicant(code,1,4)
    @format_for03 = add_record("<01$$$>",@applicants,@format_for03)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_for03 = add_record("<02$$$>",@respondents,@format_for03)
    #案由及类别
    @casetype = get_casetype_num(code)
    @format_for03 = add_record("<03$$$>",@casetype,@format_for03)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_name(code)
    @format_for03 = add_record("<04$$$>",@contract_name,@format_for03)
    #明确争议金额（人民币）；不明确争议金额
    @sum_1=get_dear_money(code)
    @sum_2=get_indefinite_money(code)
    @format_for03 = add_record("<05$$$>",@sum_1,@format_for03)
    @format_for03 = add_record("<18$$$>",@sum_2,@format_for03)
    #同期港币汇率
    @hk_rate = TbCaseAmountDetail.find(:first,:conditions=>["used='Y' and currency='0003' and recevice_code=?",code])
    if @hk_rate != nil
      @hk_rate = @hk_rate.rate
      @hk_rate1=@hk_rate*100
    else
      @hk_rate1=" "
    end
    @format_for03 = add_record("<08$$$>",@hk_rate1,@format_for03)
    #同期美元汇率
    @dollar_rate =TbCaseAmountDetail.find(:first,:conditions=>["used='Y' and currency='0002' and recevice_code=?",code])
    if @dollar_rate != nil
      @dollar_rate = @dollar_rate.rate
      @dollar_rate1=@dollar_rate*100
    else
      @dollar_rate1=" "
    end
    @format_for03 = add_record("<09$$$>",@dollar_rate1,@format_for03)
    #立案费:
    #申请人立案费
    @party1=applicant_litigation_fee(code)
    #被申请人立案费
    @party2=respondent_litigation_fee(code)
    @amount=0
    @amount=@party1 + @party2
    #明确的或不明确但可以确定的争议金额的请求事项需预缴的费用
    @amount1=get_processing_fee(code)#明确、不明确金额的  仲裁费
    @amount11=get_processing_fee2(code)#无明确的仲裁费
    #合计--人民币形式
    @tota = @amount1+@amount+@amount11
    if @tota==0
      @total=""
    else
      @total=SysArg.compart1(@tota)
    end
    @format_for03 = add_record("<10$$$>",@total,@format_for03)
    if @amount1==0
      @amount10=""
    else
      @amount10=SysArg.compart1(@amount1)
    end
    @format_for03 = add_record("<11$$$>",@amount10,@format_for03)
    if @amount==0
      @amount2=""
    else
      @amount2=SysArg.compart1(@amount)
    end
    @format_for03 = add_record("<12$$$>",@amount2,@format_for03)
    if @amount11==0
      @amount11=""
    else
      @amount11=SysArg.compart1(@amount11)
    end
    @format_for03 = add_record("<17$$$>",@amount11,@format_for03)
    @num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @num=='0001' or  @num=='0003' or  @num=='0005' or  @num=='0007'
      @num1="普通程序"
    else
      @num1="简易程序"
    end
    @format_for03 = add_record("<13$$$>",@num1,@format_for03)
    @sdate=get_contract_date(code)
    @format_for03 = add_record("<15$$$>",@sdate,@format_for03)
    @casetype2 = get_casetype_num2(code)
    @format_for03 = add_record("<16$$$>",@casetype2,@format_for03)
    #收文时间
    @year3=get_con_year3(doc_id)
    @month3=get_con_month3(doc_id)
    @day3=get_con_day3(doc_id)
    @format_for03 = add_record("<19$$$>",@year3,@format_for03)
    @format_for03 = add_record("<20$$$>",@month3,@format_for03)
    @format_for03 = add_record("<21$$$>",@day3,@format_for03)
    #是否和解特别程序
    @compromise = TbCase.find(:first,:conditions=>"used='Y' and recevice_code='#{code}'").compromise
    if @compromise=="是"
      @comn = "和解特别程序"
    else
      @comn = ""
    end
    @format_for03 = add_record("<14$$$>",@comn,@format_for03)
    @sty1 = get_orgstyle(code)
    @format_for03 = add_record("<22$$$>",@sty1,@format_for03)
    @nu1 = get_number11(code,'0001')
    @format_for03 = add_record("<23$$$>",@nu1,@format_for03)
    @format_for03 = add_record("<24$$$>",@nu1,@format_for03)
    @format_for03 = add_record("<25$$$>",@nu1,@format_for03)
    @format_for03 = add_record("<26$$$>",@nu1,@format_for03)
    @re = get_remark(code)
    @format_for03 = add_last_record("<27$$$>",@re,@format_for03)
  end
  #审批格式函————金融规则案件
  def format_letter_fr03(code,doc_id)
    #拼接字串，初始化
    @format_fr03 = ""
    #申请人
    @applicants = applicant(code,1,4)
    @format_fr03 = add_record("<01$$$>",@applicants,@format_fr03)
    #被申请人
    @respondents = respondent(code,1,4)
    @format_fr03 = add_record("<02$$$>",@respondents,@format_fr03)
    #案由及类别
    @casetype = get_casetype_num(code)
    @format_fr03 = add_record("<03$$$>",@casetype,@format_fr03)
    #关于$$$项下争议的仲裁申请文件（合同名称）
    @contract_name = get_contract_name(code)
    @format_fr03 = add_record("<04$$$>",@contract_name,@format_fr03)
    #明确争议金额（人民币）；不明确争议金额
    @sum_1=get_dear_money(code)
    @sum_2=get_indefinite_money(code)
    @format_fr03 = add_record("<05$$$>",@sum_1,@format_fr03)
    @format_fr03 = add_record("<18$$$>",@sum_2,@format_fr03)
    #立案费：<06$$$> 仲裁费：<07$$$>
    @amount=TbShouldCharge.find(:first,:select=>"sum(s.rmb_money) as aa",:conditions=>["s.used='Y' and s.recevice_code=? and s.typ='0002'",code],:joins=>"as s inner join tb_case_amounts as a on a.used='Y' and s.recevice_code=a.recevice_code and s.case_amount_id=a.id and a.typ='0001'")
    if @amount!=nil
      f1 = @amount.aa.to_f  #立案费
    else
      f1 = 0
    end
    @amount_2=TbShouldCharge.find(:first,:select=>"sum(s.rmb_money) as aa",:conditions=>["s.used='Y' and s.recevice_code=? and s.typ='0003'",code],:joins=>"as s inner join tb_case_amounts as a on a.used='Y' and s.recevice_code=a.recevice_code and s.case_amount_id=a.id and a.typ='0001'")
    if @amount_2!=nil
      f2 = @amount_2.aa.to_f  #仲裁费
    else
      f2 = 0
    end
    #无明确金金额预交的仲裁费用 <09$$$>
    f3 =get_processing_fee2(code)
    str6 = SysArg.compart1(f1)
    str7 = SysArg.compart1(f2)
    str8 = SysArg.compart1(f1 + f2)
    str9 = SysArg.compart1(f3)
    str12 = SysArg.compart1(f2 + f3)
    str13 = SysArg.compart1(f1 + f2 + f3)
    @format_fr03 = add_record("<06$$$>",str6,@format_fr03)
    @format_fr03 = add_record("<07$$$>",str7,@format_fr03)
    @format_fr03 = add_record("<08$$$>",str8,@format_fr03)
    @format_fr03 = add_record("<11$$$>",str6,@format_fr03)
    @format_fr03 = add_record("<09$$$>",str9,@format_fr03)
    @format_fr03 = add_record("<10$$$>",str9,@format_fr03)
    @format_fr03 = add_record("<12$$$>",str12,@format_fr03)
    @format_fr03 = add_record("<25$$$>",str13,@format_fr03)

    @format_fr03 = add_record("<17$$$>",@amount11,@format_fr03)
    @num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @num=='0005' or  @num=='0007'
      @num1="金融规则3人"
    else
      @num1="金融规则1人"
    end
    @format_fr03 = add_record("<13$$$>",@num1,@format_fr03)
    @sdate=get_contract_date(code)
    @format_fr03 = add_record("<16$$$>",@sdate,@format_fr03)
    @casetype2 = get_casetype_num2(code)
    @format_fr03 = add_record("<17$$$>",@casetype2,@format_fr03)
    #收文时间
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_y = arr_date[0].to_i.to_s + "年" + arr_date[1].to_i.to_s + "月" + arr_date[2].to_i.to_s + "日"
    else
      @con_y = "_____年___月___日"
    end
    @format_fr03 = add_record("<23$$$>",@con_y,@format_fr03)
    @sty1 = get_orgstyle(code)
    @format_fr03 = add_record("<15$$$>",@sty1,@format_fr03)
    @nu1 = get_number11(code,'0001')
    @format_fr03 = add_record("<19$$$>",@nu1,@format_fr03)
    @format_fr03 = add_record("<20$$$>",@nu1,@format_fr03)
    @format_fr03 = add_record("<21$$$>",@nu1,@format_fr03)
    @format_fr03 = add_record("<22$$$>",@nu1,@format_fr03)
    #是否和解特别程序
    @compromise = TbCase.find(:first,:conditions=>"used='Y' and recevice_code='#{code}'").compromise
    if @compromise=="是"
      @comn = "和解特别程序"
    else
      @comn = ""
    end
    @format_fr03 = add_record("<14$$$>",@comn,@format_fr03)
    @re = get_remark(code)
    @format_fr03 = add_last_record("<24$$$>",@re,@format_fr03)
  end
  def format_letter_head1(code,doc_id)
    #初始化
    @format_head1 = ""
    #函号
    @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and id=?",doc_id])
    if @file_code == nil
      @file_code3 = "无发文函号"
    else
      @file_code=@file_code.send_code
      if @file_code==nil or @file_code==""
        @file_code3="无发文函号"
      else
        @file_code3 ="发文" + @file_code
      end
    end
    @format_head1 = add_record("<$$$head01>",@file_code3,@format_head1)
    #签发$$$,目前要求替换成横线
    #@obj_doc = "_____________"
    @obj_doc = ""
    @format_head1 = add_record("<$$$head02>",@obj_doc,@format_head1)
    #经办人$$$,$$$,即助理和时间 立案前的是咨询助理；立案后的是办案助理
    @stat = TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).state
    if @stat==1
      @zl_alerk = get_name2(code)
    else
      @zl_alerk = get_name(code)
    end
    @format_head1 = add_record("<$$$head03>",@zl_alerk,@format_head1)
    #此处日期是否处理当天时间有待确证
    @y2 = get_con_year3(doc_id)
    @m2 = get_con_month3(doc_id)
    @d2 = get_con_day3(doc_id)
    @date_of_letter = @y2 + "年" + @m2 +"月"+@d2+"日"
    @format_head1 = add_last_record("<$$$head04>",@date_of_letter,@format_head1)
  end
  #目前没有可替换字段
  def format_letter_head2(code)
    #初始化
    @format_head2 = ""

  end

  # 开庭笔录（独任）
  def format_letter_dfmt90(code)
    @format_dfmt90 = ""

    @case_code = casecode(code) #立案号
    @format_dfmt90 =  add_record("<01$$$>",@case_code,@format_dfmt90)

    @sitting_date  = get_sittingdate2(code) # 开庭日期
    @format_dfmt90 =  add_record("<02$$$>",@sitting_date,@format_dfmt90)

    @sitting_time  = get_sitting_time(code) # 开庭时间
    @format_dfmt90 =  add_record("<03$$$>",@sitting_time,@format_dfmt90)

    @applicant     = applicant(code,1,4) # 申请人
    @format_dfmt90 = add_record("<04$$$>",@applicant,@format_dfmt90)

    @respondent    = respondent(code,1,4) # 被申请人
    @format_dfmt90 = add_record("<05$$$>",@respondent,@format_dfmt90)

    @independent_arbitrator = independent_arbitrator(code) + get_arbitman_sex(code,"0001") #独任仲裁员
    @format_dfmt90 = add_record("<06$$$>",@independent_arbitrator,@format_dfmt90)

    @aclerk = get_name(code) #助理
    @format_dfmt90 = add_record("<07$$$>",@aclerk,@format_dfmt90)

    @agent1 = get_agent3(code,1) # 申请方代理人
    @format_dfmt90 = add_record("<08$$$>",@agent1,@format_dfmt90)

    @agent2 = get_agent3(code,2) # 被申请方代理人
    @format_dfmt90 = add_last_record("<09$$$>",@agent2,@format_dfmt90)
  end

  # 开庭笔录（非独任）
  def format_letter_dfmt91(code)
    @format_dfmt91 = ""

    @case_code = casecode(code) #立案号
    @format_dfmt91 =  add_record("<01$$$>",@case_code,@format_dfmt91)

    @sitting_date  = get_sittingdate2(code) # 开庭日期
    @format_dfmt91 =  add_record("<02$$$>",@sitting_date,@format_dfmt91)

    @sitting_time  = get_sitting_time(code) # 开庭时间
    @format_dfmt91 =  add_record("<03$$$>",@sitting_time,@format_dfmt91)

    @applicant     = applicant(code,1,4) # 申请人
    @format_dfmt91 = add_record("<04$$$>",@applicant,@format_dfmt91)

    @respondent    = respondent(code,1,4) # 被申请人
    @format_dfmt91 = add_record("<05$$$>",@respondent,@format_dfmt91)

    @chief_arbitrator = chief_arbitrator(code) + get_arbitman_sex(code,"0002")#首席仲裁员
    @format_dfmt91 = add_record("<06$$$>",@chief_arbitrator,@format_dfmt91)

    @applicant_arbitrator = applicant_arbitrator(code) + get_arbitman_sex(code,"0003")#申请人仲裁员
    @format_dfmt91 = add_record("<07$$$>",@applicant_arbitrator,@format_dfmt91)

    @respondent_arbitrator = respondent_arbitrator(code) + get_arbitman_sex(code,"0004") #被申请人仲裁员
    @format_dfmt91 = add_record("<08$$$>",@respondent_arbitrator,@format_dfmt91)

    @aclerk = get_name(code) #助理
    @format_dfmt91 = add_record("<09$$$>",@aclerk,@format_dfmt91)

    @agent1 = get_agent3(code,1) # 申请方代理人
    @format_dfmt91 = add_record("<10$$$>",@agent1,@format_dfmt91)

    @agent2 = get_agent3(code,2) # 被申请方代理人
    @format_dfmt91 = add_last_record("<11$$$>",@agent2,@format_dfmt91)

  end

  # 合议笔录
  def format_letter_dfmt92(code)
    @format_dfmt92 = ""

    @case_code = casecode(code) # 立案号
    @format_dfmt92 =  add_record("<01$$$>",@case_code,@format_dfmt92)

#    @comment_date  = get_commentdate(code) # 合议日期
#    @format_dfmt92 = add_record("<02$$$>",@comment_date,@format_dfmt92)

    @comment_date  = get_sittingdate2(code) # 合议日期
    @format_dfmt92 = add_record("<02$$$>",@comment_date,@format_dfmt92)

    @applicant     = applicant(code,1,4) # 申请人
    @format_dfmt92 = add_record("<04$$$>",@applicant,@format_dfmt92)

    @respondent    = respondent(code,1,4) # 被申请人
    @format_dfmt92 = add_record("<05$$$>",@respondent,@format_dfmt92)

    @arbitrator = "____"
    aribitprog_num = TbCase.find(:first, :conditions => "used='Y' and recevice_code='#{code}'").aribitprog_num
    if aribitprog_num == "0001" or aribitprog_num == "0003" or aribitprog_num == "0005" or  aribitprog_num == "0007"
      @chief_arbitrator = chief_arbitrator(code) #首席仲裁员
      @applicant_arbitrator = applicant_arbitrator(code) #申请人仲裁员
      @respondent_arbitrator = respondent_arbitrator(code) #被申请人仲裁员
      @arbitrator = @chief_arbitrator + "、" + @applicant_arbitrator + "、" + @respondent_arbitrator
    else
      @arbitrator = independent_arbitrator(code) #独任仲裁员
    end

    chief_arbitrator(code) #仲裁庭
    @format_dfmt92 = add_record("<06$$$>",@arbitrator,@format_dfmt92)

    @aclerk = get_name(code) #助理
    @format_dfmt92 = add_last_record("<07$$$>",@aclerk,@format_dfmt92)
  end

  # 减免费用审批表
  def format_letter_fmt53(code)
    @format_fmt53 = ""
    @case = TbCase.find_by_recevice_code(code)
    unless @case
      return ""
    end
    if @case.state == 1
      @format_fmt53 =  add_record("<01$$$>",get_name2(code),@format_fmt53)
    elsif @case.state >= 4
      @format_fmt53 =  add_record("<01$$$>",get_name(code),@format_fmt53)
    end

    # 申请人
    @format_fmt53 = add_record("<02$$$>",applicant(code,1,4),@format_fmt53)

    # 被申请人
    @format_fmt53 =  add_record("<03$$$>",respondent(code,1,4),@format_fmt53)
    @redu = TbReduction.find(:first, :conditions => ["recevice_code=?",code], :order => "id desc")
    if @redu
      if @redu.consultant == "0001"
        @format_fmt53 =  add_record("<04$$$>",applicant(code,1,4),@format_fmt53)
      elsif  @redu.consultant == "0002"
        @format_fmt53 =  add_record("<04$$$>",respondent(code,1,4),@format_fmt53)
      end
      @format_fmt53 =  add_record("<05$$$>",@redu.remark,@format_fmt53)
      @format_fmt53 =  add_record("<06$$$>",SysArg.get_ymd(@redu.apply_date),@format_fmt53)
      @format_fmt53 =  add_record("<07$$$>",TbShouldCharge.find(@redu.should_charge_id).rmb_money,@format_fmt53)
      @format_fmt53 =  add_record("<08$$$>",@redu.rmb_money,@format_fmt53)
      @format_fmt53 =  add_last_record("<09$$$>",SysArg.get_ymd( Date.today.to_s(:db)),@format_fmt53)
    end
    return @format_fmt53
  end
  ############################################################################
  #私有函数
  ############################################################################
  #函号
  def get_code1(doc_id)
    @file_code = TbDoc.find(:first,:conditions => ["used = 'Y' and id=?",doc_id])
    if @file_code == nil
      @file_code3 = "无发文函号"
    else
      @file_code=@file_code.send_code
      if @file_code==nil or @file_code==""
        @file_code3="无发文函号"
      else
        @file_code3 =  @file_code
      end
    end
    return @file_code3
  end
  #添加替换项
  def add_record(str_src,str_des,str_prm)
    str_prm = str_prm + str_src.to_s
    str_prm = str_prm + ",,,"
    str_prm = str_prm + str_des.to_s
    str_prm = str_prm + ";;;"
    return str_prm
  end
  #最后一个添加项
  def add_last_record(str_src,str_des,str_prm)
    str_prm = str_prm + str_src.to_s
    str_prm = str_prm + ",,,"
    str_prm = str_prm + str_des.to_s
    return str_prm
  end
  #修改  2009-8-10 聂灵灵   明确不明确争议金额部分的,以及无明确争议金额费用部分的
  #申请人受理费、立案费
  def applicant_litigation_fee(code)
    @s_id=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and typ in ('0002','0005') and payment='0001'",code],:select=>"sum(rmb_money) as rmb")
    if @s_id!=nil
      @p_id=@s_id.rmb
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #被申请人受理费、立案费
  def respondent_litigation_fee(code)
    @s_id2=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and typ in ('0002','0005') and payment='0002'",code],:select=>"sum(rmb_money) as rmb2")
    if @s_id2!=nil
      @p_id=@s_id2.rmb2
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #申请人处理费、仲裁费
  def applicant_arbit_fee(code)
    @s_id=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and typ in ('0003','0006') and payment='0001'",code],:select=>"sum(rmb_money) as rmb")
    if @s_id!=nil
      @p_id=@s_id.rmb
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #被申请人处理费、仲裁费
  def respondent_arbit_fee(code)
    @s_id=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and typ in ('0003','0006') and payment='0002'",code],:select=>"sum(rmb_money) as rmb")
    if @s_id!=nil
      @p_id=@s_id.rmb
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #补缴仲裁费用 = 应收 - 已收 - 减交 ;p:0001,0002 当事人
  def applicant_arbit_fee3(code,p)
    @s=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and payment=? and (typ='0001' or typ='0004')",code,p],:select=>"sum(rmb_money-re_rmb_money-redu_rmb_money) as s1")
    if @s!=nil
      return @s.s1.to_f
    else
      return 0
    end
  end
  #已收---申请人'0001'(处理费、仲裁费;立案费、受理费）  应收费用 -----typ='0001' ，被申请人0002--p
  def applicant_arbit_fee22(code,p)
    @s_id=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and payment=?",code,p],:select=>"sum(re_rmb_money) as rmb")
    if @s_id!=nil
      @p_id=@s_id.rmb
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #被申请人其他费用
  def respondent_other_fee(code)
    @s_id=TbShouldCharge.find(:first,:conditions=>["used = 'Y' and recevice_code=? and (typ='0007' or typ='0008') and payment='0002'",code],:select=>"sum(rmb_money) as rmb")
    if @s_id!=nil
      @p_id=@s_id.rmb
      if @p_id!=nil
        return @p_id.to_f
      else
        return 0
      end
    else
      return 0
    end
  end
  #得到提交文书的份数
  def num_papers(code,v)
    @num=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v],:order=>"id")
    if @num!=nil
      @num_people=@num.length + 4
    else
      @num_people="_____"
    end
    return @num_people
  end
  #获取案件首席仲裁员
  def chief_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0002'",code])
    if @case_arbitman != nil
      @chief_a= TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",@case_arbitman.arbitman])
      if @chief_a != nil
        @c_arbit = @chief_a.name
      else
        @c_arbit = "_____"
      end
    else
      @c_arbit = "_____"
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
        applicant_arbitrator = applicant_arbitrator.name
      else
        applicant_arbitrator = "_____"
      end
    else
      applicant_arbitrator = "_____"
    end
    return applicant_arbitrator
  end
  #获取案件被申请人仲裁员
  def respondent_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0004'",code])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      respondent_arbitrator = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if respondent_arbitrator != nil
        respondent_arbitrator = respondent_arbitrator.name
      else
        respondent_arbitrator = "_____"
      end
    else
      respondent_arbitrator = "_____"
    end
    return respondent_arbitrator
  end
  #获取案件独立仲裁员
  def independent_arbitrator(code)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype = '0001'",code])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      independent_arbitrator = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if independent_arbitrator != nil
        independent_arbitrator = independent_arbitrator.name
      else
        independent_arbitrator = "_____"
      end
    else
      independent_arbitrator = "_____"
    end
    return independent_arbitrator
  end
  #仲裁员性别
  def get_arbitman_sex(code,v)
    @case_arbitman = TbCasearbitman.find(:first, :conditions => ["used = 'Y' and recevice_code = ? and arbitmantype=?",code,v])
    if @case_arbitman != nil
      arbitman_code = @case_arbitman.arbitman
      sex1 = TbArbitman.find(:first, :conditions =>["used = 'Y' and code = ? ",arbitman_code])
      if sex1 != nil
        s = sex1.sex
        if s=='男'
          s="先生"
        else
          s="女士"
        end
      else
        s="先生/女士"
      end
    else
      s="先生/女士"
    end
    return s
  end
  #仲裁员选定方式
  def get_style(code,v1) #v1:哪类仲裁员
    @arbitmenA=TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,v1])
    @aribitprog_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).aribitprog_num
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'#普通案件
      @a = "首席仲裁员"
    else  #简易案件
      @a = "独任仲裁员"
    end
    if @arbitmenA!=nil
      @arbitmansign=@arbitmenA.arbitmansign
      if @arbitmansign!=nil
        if @arbitmansign=='0005' #代指定
          if @aribitprog_num=='0002' or @aribitprog_num=='0004' or @aribitprog_num=='0006' or @aribitprog_num=='0008'#简易
            @aaa="由于双方未共同选定或共同委托本会主任指定" + @a + "，本会主任指定"
          else
            @aaa="指定"
          end
        else
          @ab=TbDictionary.find(:first,:conditions=>"typ_code='0015' and state='Y' and data_val='#{@arbitmansign}'")
          @aaa=@ab.data_text
        end
      else
        @aaa="f"
      end
    else
      @aaa="f"
    end
    return @aaa
  end
  #仲裁员选定方式---从字典表中查询得来的：
  def get_style_from(code,v1) #v1:哪类仲裁员
    @arbitmenA=TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,v1])
    if @arbitmenA!=nil
      @arbitmansign=@arbitmenA.arbitmansign
      if @arbitmansign!=nil
        @ab=TbDictionary.find(:first,:conditions=>"typ_code='0015' and state='Y' and data_val='#{@arbitmansign}'")
        @abc=@ab.data_text
      else
        @abc="_____"
      end
    else
      @abc="_____"
    end
    return @abc
  end
  #根据仲裁员选定方式的编码替换函中文字。 0001,0002:选定  ;   0005:指定   函中显示仲裁委选定/指定仲裁员方式
  def get_fix_appoint(code,v1) #v1:哪类仲裁员
    @arbitmenA=TbCasearbitman.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitmantype=?",code,v1])
    if @arbitmenA!=nil
      @arbitmansign=@arbitmenA.arbitmansign
      if @arbitmansign!=nil
        if @arbitmansign=='0001' or @arbitmansign=='0002'
          @c = "选定"
        else #@arbitmansign=='0005' 或其他的
          @c = "指定"
        end
      else
        @c = "指定"
      end
    else
      @c = "指定"
    end
    return @c
  end
  #根据性别 显示：先生、女士
  def get_sex(sex)
    if sex == nil
      return ""
    elsif sex == "男"
      return "先生"
    else
      return "女士"
    end
  end
  #助理信息：姓名
  def get_name(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @case_alerk = @clerk1.name
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  #性别
  def get_zlsex(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @sex = @clerk1.sex
        if  @sex == "男"
          @case_alerk="先生"
        else
          @case_alerk="女士"
        end
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  #电话
  def get_tel(code,v)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code=?",clerk_code])
      if @clerk1!=nil
        @party=TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
        if @party!=nil
          area1 = @party.area
          if area1!=nil && area1!=""
            if area1!='002' && area1!='003' && area1!='004' && area1.slice(0,3)=="001" #国内的
              @case_alerk2 = "0755-" + @clerk1.telephone
            else  #香港、国外的
              @case_alerk2 = "(86-755)" + @clerk1.telephone
            end
          else
            @case_alerk2 ="0755-" + @clerk1.telephone
          end
        else
          @case_alerk2 ="0755-" + @clerk1.telephone
        end
      else
        @case_alerk2 ="0755-" + @clerk1.telephone
      end
    else
      @case_alerk2 ="0755-"
    end
    return @case_alerk2
  end
  #传真
  def get_fax(code,v)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil
        @party=TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
        if @party!=nil
          area1 = @party.area
          if area1!=nil && area1!=""
            if area1!='002' && area1!='003' && area1!='004' && area1.slice(0,3)=="001" #国内的
              @case_alerk3 = "0755-" + @clerk1.fax
            else  #香港、国外的
              @case_alerk3 = "(86-755)" + @clerk1.fax
            end
          else
            @case_alerk3 = "0755-" + @clerk1.fax
          end
        else
          @case_alerk3 = "0755-" + @clerk1.fax
        end
      else
        @case_alerk3 ="0755-" + @clerk1.fax
      end
    else
      @case_alerk3 = "0755-" + @clerk1.fax
    end
    return @case_alerk3
  end
  #根据法院地区是港澳台、国内外替换电话 ------发保全函
  def  get_s_tel(code,typ,pv)
    @yard_area = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed=? and request_typ=?",code,typ,pv])
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if @yard_area!=nil
      if @yard_area.yard_area!='0011' && @yard_area.yard_area=='0012' && @yard_area.yard_area=='0013' && @yard_area.yard_area.slice(0,3)!='001'
        if clerk_code!=nil and clerk_code!=""
          @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
          return "(86-755)" + @clerk1.telephone
        else
          return "(86-755)"
        end
      else
        if clerk_code!=nil and clerk_code!=""
          @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
          return "(0755)" + @clerk1.telephone
        else
          return "(0755)"
        end
      end
    else
      return "(0755)"
    end
  end
  ##根据法院地区是港澳台、国内外替换传真区号---发保全函
  def get_s_fax(code,typ,pv)
    @yard_area = TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and typed=? and request_typ=?",code,typ,pv])
    @case=TbCase.find(:first,:conditions =>["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if @yard_area!=nil
      if @yard_area.yard_area!='0011' && @yard_area.yard_area=='0012' && @yard_area.yard_area=='0013' && @yard_area.yard_area.slice(0,3)!='001'
        if clerk_code!=nil and clerk_code!=""
          @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
          return "(86-755)" + @clerk1.fax
        else
          return "(86-755)"
        end
      else
        if clerk_code!=nil and clerk_code!=""
          @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
          return "(0755)" + @clerk1.fax
        else
          return "(0755)"
        end
      end
    else
      return "(0755)"
    end
  end
  #根据当事人是国内、港和国外 来设定传真开头区号
  def get_fax2(code,v)
    party=TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    if party!=nil
      area1 = party.area
      if area1!=nil && area1!=""
        if area1!='002' && area1!='003' && area1!='004' && area1.slice(0,3)=="001" #国内的
          @code5 = "0755"
        else  #香港、国外的
          @code5 = "86-755"
        end
      else
        @code5 = "0755"
      end
    else
      @code5 = "0755"
    end
    return @code5
  end
  #电子邮箱
  def get_email(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @case_alerk = @clerk1.email
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  #合同签订年、月、日
  def get_con_year(code)
    @contractdate=TbContractsign.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @contractdate!=nil
      arr_date = @contractdate.contractdate.to_s.split("-")
      @con_y = arr_date[0]
      return @con_y
    else
      return "_____"
    end
  end
  def get_con_month(code)
    @contractdate=TbContractsign.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @contractdate!=nil
      arr_date = @contractdate.contractdate.to_s.split("-")
      @con_m = arr_date[1].to_i.to_s
      return @con_m
    else
      return "_____"
    end
  end
  def get_con_day(code)
    @contractdate=TbContractsign.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @contractdate!=nil
      arr_date = @contractdate.contractdate.to_s.split("-")
      @con_d = arr_date[2].to_i.to_s
      return @con_d
    else
      return "_____"
    end
  end
  #发文编号---年、月、日
  def get_con_year2(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_y = SysArg.n_to_c(arr_date[0].to_i)
      return @con_y
    else
      return "_____"
    end
  end
  def get_con_month2(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_m = SysArg.n_to_md(arr_date[1].to_i)
      return @con_m
    else
      return "_____"
    end
  end
  def get_con_day2(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_d = SysArg.n_to_md(arr_date[2].to_i)
      return @con_d
    else
      return "_____"
    end
  end
  #发文年、月、日====收文日期     一般是当天的年、月、日
  def get_con_year3(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_y = arr_date[0].to_i.to_s
      return @con_y
    else
      return "_____"
    end
  end
  def get_con_month3(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_m = arr_date[1].to_i.to_s
      return @con_m
    else
      return "_____"
    end
  end
  def get_con_day3(doc_id)
    @date_of_letter =TbDoc.find(doc_id)
    if @date_of_letter!=nil
      arr_date = @date_of_letter.ss_t.to_s.split("-")
      @con_d = arr_date[2].to_i.to_s
      return @con_d
    else
      return "_____"
    end
  end
  #部分收文日期按 立案日期算
  def get_con_year31(code)
    @date_of_letter =TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @date_of_letter!=nil
      arr_date = @date_of_letter.receivedate.to_s.split("-")
      @con_y = arr_date[0].to_i.to_s
      return @con_y
    else
      return "_____"
    end
  end
  def get_con_month31(code)
    @date_of_letter =TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @date_of_letter!=nil
      arr_date = @date_of_letter.receivedate.to_s.split("-")
      @con_m = arr_date[1].to_i.to_s
      return @con_m
    else
      return "_____"
    end
  end
  def get_con_day31(code)
    @date_of_letter =TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @date_of_letter!=nil
      arr_date = @date_of_letter.receivedate.to_s.split("-")
      @con_d = arr_date[2].to_i.to_s
      return @con_d
    else
      return "_____"
    end
  end
  #适用于卷宗 :如果多个当事人，显示第几，并换行；否则直接显示
  def applicant_f(code,v)
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype =? and recevice_code = ?",v,code], :order => "id")
    if PubTool.new.get_first_record(@applicants) == nil
      @applicant1 = "_____"
    else
      @applicant1 = ""
      i=1
      @last1 = @applicants.length
      if @applicants.length==1
        @applicant1 = PubTool.new.get_first_record(@applicants).partyname
      else
        @applicants.each do |applicant|
          if v==1
            @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
          else
            @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
          end
          i+=1
        end      #  去掉最后的逗号 ,\r
        if @applicant1!=""
          @applicant1=@applicant1.slice(0,@applicant1.length-2)
        end
      end
    end
    return @applicant1
  end

  #申请人   v1-1:以分号隔开,在函中；2：要标明第几个当事人。v3:3:要冒号 4：不要冒号
  def applicant(code,v1,v3)
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 1 and recevice_code = ?",code], :order => "id")
    if @applicants == nil
      @applicant1 = "_____"
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
            @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
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
      else
        @applicant1="申请人：__________"
      end
    end
    return @applicant1
  end

  #换行、对齐的列出多个当事人：v1：申请人还是被申请人1，2    fmt38a
  def applicant2(code,v1,v3,p)#p 1申请人   2被申请人
    @applicants = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = ? and recevice_code = ?",p,code], :order => "id")
    if @applicants == nil
      @applicant1 = "_____"
    else
      @applicant1 = ""
      i=1
      @last2 = @applicants.length
      @applicants.each do |applicant|
        if @applicants.length>1
          if v1==1
            if i==@last2
              @applicant1=@applicant1+applicant.partyname + "  "
            else
              @applicant1=@applicant1+applicant.partyname + "、"
            end
          elsif v1==2
            if p==1
              if i>1
                @applicant1 =@applicant1+"   "+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
              else
                @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
              end
            else
              if i>1
                @applicant1 =@applicant1+"   "+"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
              else
                @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
              end
            end
            i+=1
          end
        else
          if v3==3 && p==1
            @applicant1="申请人：" + applicant.partyname + "  "
          elsif v3==3 && p==2
            @applicant1="被申请人：" + applicant.partyname + "  "
          elsif v3==4
            @applicant1=applicant.partyname
          end
        end
      end      #  去掉最后的逗号 ,\r
      @applicant1=@applicant1.slice(0,@applicant1.length-2)
    end
    return @applicant1
  end

  #换行、对齐的列出多个当事人：v1：申请人还是被申请人1，2    fmt40
  def applicant2_fmt40(code,v1)
    @applicants = TbParty.find(:all,:conditions =>["used = 'Y' and recevice_code='#{code}' and partytype=?",v1],:order => "id")
    if @applicants == nil
      @applicant1 = "_____"
    else
      @applicant1 = ""
      i=1
      @applicants.each do |applicant|
        if @applicants.length>1
          if v1==1
            if i>1
              @applicant1 =@applicant1+"    "+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
            else
              @applicant1 =@applicant1+"第"+SysArg.n_to_md(i)+"申请人："+ applicant.partyname + '\r'
            end
          elsif v1==2
            if i>1
              @applicant1=@applicant1+"    "+"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
            else
              @applicant1=@applicant1+"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
            end
          end
          i+=1
        else
          if v1==1
            @applicant1="申请人："+applicant.partyname + "  "
          elsif v1==2
            @applicant1="被申请人："+applicant.partyname + "  "
          end
        end
      end
      #  去掉最后的换行号
      @applicant1=@applicant1.slice(0,@applicant1.length-2)
    end
    return @applicant1
  end

  #被申请人
  def respondent(code,v1,v3)
    @respondents = TbParty.find(:all,:conditions => ["used = 'Y' and partytype = 2 and recevice_code = ?",code], :order => "id")
    if @respondents == nil
      @respondent1 = "_____"
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
            @respondent1 = @respondent1 +"第"+SysArg.n_to_md(i)+"被申请人："+ applicant.partyname + '\r'
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
  #当事人代理人(可多名）
  def  get_agent(code,v)
    @agents = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    if @agents!=nil
      @agent1=""
      i=1
      @last4 = @agents.length
      @agents.each do |agents|
        #代理人职务  2010-9-2 修改;2010-9-7 修改—添加空格
        if agents.duty!=""
          statu=agents.duty
        else
          statu=TbDictionary.find(:first,:conditions=>["typ_code='0007' and state='Y' and used='Y' and data_val=?",agents.status]).data_text
        end

        if i==@last4
          @agent1=@agent1+agents.name+"  "+agents.company+statu+"  "
        else
          @agent1=@agent1+agents.name+"  "+agents.company+statu+"、"
        end
        i+=1
      end
      if @agent1!=""
        @agent1=@agent1.slice(0,@agent1.length-2)
      end
    else
      @agent1="无"
    end
    return @agent1
  end
  #换行、对齐的列出代理人，若有单位：姓名+单位+职务；如没：当事人+代理人职务  [如果没有职务，填写身份信息]
  def get_agent2(code,v)
    @agents = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    if v==1
      app1 = "申请人"
    else
      app1 = "被申请人"
    end
    if @agents!=nil
      @agent1=""
      i=1
      @agents.each do |agents|
        if agents.duty!=""
          statu=agents.duty
        else
          statu=TbDictionary.find(:first,:conditions=>["typ_code='0007' and state='Y' and used='Y' and data_val=?",agents.status]).data_text
        end

        if agents.company!=nil && agents.company!=""
          if i>1
            @agent1=@agent1+"               "+agents.name+" "+agents.company+statu + '\r'
          else
            @agent1=@agent1+agents.name+" "+agents.company+statu + '\r'
          end
        else
          if i>1
            @agent1=@agent1 + "               " + agents.name+" " + app1 +statu+ '\r'
          else
            @agent1=@agent1 + agents.name+" " + app1 +statu + '\r'
          end
        end
        i+=1
      end
      @agent1=@agent1.slice(0,@agent1.length-2)
    else
      @agent1="无"
    end
    return @agent1
  end
  #换行、对齐的列出代理人  fmt40 若有单位：姓名+单位+职务；如没：当事人+代理人职务
  def get_agent2_fmt40(code,v)
    @agents = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    if v==1
      app2 = "申请人"
    else
      app2 = "被申请人"
    end
    if @agents!=nil
      @agent1=""
      i=1
      @agents.each do |agents|
        if agents.company!=nil && agents.company!=""
          if i>1
            @agent1=@agent1+"            "+agents.name+" "+agents.company+agents.duty + '\r'
          else
            @agent1=@agent1+agents.name+" "+agents.company+agents.duty + '\r'
          end
        else
          if i>1
            @agent1=@agent1 + "            " + agents.name + " " + app2 + agents.duty + '\r'
          else
            @agent1=@agent1 + agents.name + " " + app2 + agents.duty+ '\r'
          end
        end
        i+=1
      end
      @agent1=@agent1.slice(0,@agent1.length-2)
    else
      @agent1="无"
    end
    return @agent1
  end

  # dfmt 91
  def get_agent3(code,v)
    @agents = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
    if @agents != nil
      @agent1 = ""
      i = 1
      @last4 = @agents.length
      @agents.each do |agents|
        if agents.duty!=""
          statu = agents.duty
        else
          statu = TbDictionary.find(:first,:conditions=>["typ_code='0007' and state='Y' and used='Y' and data_val=?",agents.status]).data_text
        end
        if i == @last4
          @agent1 = @agent1 + agents.company + agents.name + statu + "  "
        else
          @agent1 = @agent1 + agents.company + agents.name + statu + "、"
        end
        i+=1
      end
      if @agent1!=""
        @agent1=@agent1.slice(0,@agent1.length-2)
      end
    else
      @agent1="无"
    end
    return @agent1
  end
  #仲裁申请受理通知书,发送给申请人的：1=》是 2=》否。  19：注册登记/身份证明... 20：法定代表人证明书及/或授权委托书...

  #第二次重新修改 2009-11-15  niell

  #第三次修改  2010-8-9 niell
  #个人：国内外的都是身份证明文件复印件一式$$$份
  #公司：外国公司：公司注册和商业登记证明文件复印件一式$$$份
  #     国内公司：营业执照文件复印件一式$$$份
  def get_accommodate_remarks(code,v1)
    @party=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v1],:order=>"id")
    @aa = TbParty.find(:first,:conditions=>["used='Y' and LEFT(area ,3)='001' and recevice_code=? and partytype=?",code,v1])
    @bb = TbParty.find(:first,:conditions=>["used='Y' and LEFT(area ,3)<>'001' and recevice_code=? and partytype=?",code,v1])
    @isperson = TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=? and isperson=1",code,v1])
    if PubTool.new.get_first_record(@party)!=nil
      @len1 = @party.length
      if @isperson!=nil#个人
        if @len1==1
          str1="身份证明"
        else #多个申请人
          if @aa!=nil and @bb!=nil
            str1="营业执照/公司注册和商业登记证明"
          elsif @aa!=nil and @bb==nil #国内的
            str1="身份证明/营业执照"
          else#港澳与国外的
            str1="公司注册和商业登记证明"
          end
        end
      else#公司
        #        if @len1==1
        #          str1="营业执照"
        #else 多个申请人
        if @aa!=nil and @bb!=nil
          str1="营业执照/公司注册和商业登记证明"
        elsif @aa!=nil and @bb==nil #国内的
          str1="营业执照"
        else#港澳与国外的
          str1="公司注册和商业登记证明"
        end
        #        end
      end
    else
      str1="身份证明/营业执照/公司注册和商业登记证明"
    end
    return str1
  end
  #2010-7-7 "法定代表人证明文件及/或授权委托书"——去掉【/或】

  #第三次修改  2010-8-9 niell
  #个人：国内外的都是授权委托书（如你方委托代理人参与仲裁）
  #公司：外国公司：法定代表人证明文件/授权代表证明文件及/或授权委托书（如你方委托代理人参与仲裁）
  #     国内公司：法定代表人证明文件及/或授权委托书（如你方委托代理人参与仲裁）
  def get_accommodate_remarks2(code,v1)
    @party3=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v1],:order=>"id")
    @aa = TbParty.find(:first,:conditions=>["used='Y' and LEFT(area ,3)='001' and recevice_code=? and partytype=?",code,v1])
    @bb = TbParty.find(:first,:conditions=>["used='Y' and LEFT(area ,3)<>'001' and recevice_code=? and partytype=?",code,v1])
    @isperson = TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=? and isperson=1",code,v1])
    if PubTool.new.get_first_record(@party3)!=nil
      @len1 = @party.length
      if @isperson!=nil#个人
        if @len1==1
          str2="授权委托书"
        else #多个申请人
          if @aa!=nil and @bb!=nil
            str2="法定代表人证明文件/授权代表证明文件及授权委托书"
          elsif @aa!=nil and @bb==nil #国内的
            str2="法定代表人证明文件及授权委托书"
          else#港澳、国外的
            str2="法定代表人证明文件/授权代表证明文件及授权委托书"
          end
        end
      else#公司
        #        if @len1==1
        #          str2="法定代表人证明文件及授权委托书"
        # else 多个申请人
        if @aa!=nil and @bb!=nil
          str2="法定代表人证明文件/授权代表证明文件及授权委托书"
        elsif @aa!=nil and @bb==nil #国内的
          str2="法定代表人证明文件及授权委托书"
        else#港澳与国外的
          str2="法定代表人证明文件/授权代表证明文件及授权委托书"
        end
        #        end
      end
    else
      str2="法定代表人证明文件/授权代表证明文件及授权委托书"
    end
    return str2
  end
  #根据当事人数量选择仲裁员方式：选定/共同选定或委托/共同委托  v--当事人
  def arbitab(code,v)
    @party3=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v],:order=>"id")
    if @party3!=nil
      if @party3.length>1
        str3="共同选定或共同委托"
      elsif @party3.length==1
        str3="选定或委托"
      end
    else
      str3="选定/共同选定或委托/共同委托"
    end
    return str3
  end
  #推荐还是共同推荐
  def arbitac(code,v)
    @party4=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v],:order=>"id")
    if @party4!=nil
      if @party4.length>1
        str8="共同推荐"
      elsif @party4.length==1
        str8="推荐"
      end
    else
      str8="推荐/共同推荐"
    end
    return str8
  end
  def casecode(code)
    @casecode = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code]).case_code
    if @casecode!=nil && @casecode!=""
      @casecode1=@casecode
    else
      @casecode1="_____"
    end
    return @casecode1
  end
  #合同编号及名称
  def get_contract_name(code)
    @contract_name = TbContractsign.find(:all,:conditions => ["used = 'Y' and recevice_code = ?",code])
    if PubTool.new.get_first_record(@contract_name)!=nil
      @contract_name1=""
      if @contract_name.length==1
        @contract_name=PubTool.new.get_first_record(@contract_name)
        @n1 = @contract_name.pactname.index('《')
        if @n1!=nil
          @contract_name1 = @contract_name.pactname
        else
          @contract_name1 ="《" + @contract_name.pactname + "》"
        end
      else
        @contract_name.each do |c|
          arr_date = c.contractdate.to_s.split("-")
          arr_date[1]=arr_date[1].to_i.to_s
          arr_date[2]=arr_date[2].to_i.to_s
          @n1 = c.pactname.index('《')
          if @n1!=nil
            @contract_name1 =@contract_name1 +  c.pactname+"、"
          else
            @contract_name1 =@contract_name1 + "《" + c.pactname + "》"+"、"
          end
        end
        @contract_name1=@contract_name1.slice(0,@contract_name1.length-3)
      end
    else
      @contract_name1 = "_____"
    end
    return @contract_name1
  end
  #合同签订时间
  def get_contract_date(code)
    @contract_name = TbContractsign.find(:all,:conditions => ["used = 'Y' and recevice_code = ?",code])
    if PubTool.new.get_first_record(@contract_name)!=nil
      @contract_name1=""
      if @contract_name.length==1
        @contract_name=PubTool.new.get_first_record(@contract_name)
        arr_date = @contract_name.contractdate.to_s.split("-")
        arr_date[1]=arr_date[1].to_i.to_s
        arr_date[2]=arr_date[2].to_i.to_s
        @contract_name1 =arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
      else
        @contract_name.each do |c|
          arr_date = c.contractdate.to_s.split("-")
          arr_date[1]=arr_date[1].to_i.to_s
          arr_date[2]=arr_date[2].to_i.to_s
          @contract_name1 =@contract_name1 +arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"+"、"
        end
        @contract_name1=@contract_name1.slice(0,@contract_name1.length-3)
      end
    else
      @contract_name1 = "_____"
    end
    return @contract_name1
  end
  #显示多个合同名称、时间，在一起显示，暂时未用
  def get_contract_nd(code)
    @contract_name = TbContractsign.find(:all,:conditions => ["used = 'Y' and recevice_code = ?",code])
    if PubTool.new.get_first_record(@contract_name)!=nil
      @contract_name1=""
      if @contract_name.length==1
        @contract_name=PubTool.new.get_first_record(@contract_name)
        @n1 = @contract_name.pactname.index('《')
        arr_date = @contract_name.contractdate.to_s.split("-")
        arr_date[1]=arr_date[1].to_i.to_s
        arr_date[2]=arr_date[2].to_i.to_s
        if @n1!=nil
          @contract_name1 =arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日签订的"+ @contract_name.pactname
        else
          @contract_name1 =arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日签订的"+"《" + @contract_name.pactname + "》"
        end
      else
        @contract_name.each do |c|
          arr_date = c.contractdate.to_s.split("-")
          arr_date[1]=arr_date[1].to_i.to_s
          arr_date[2]=arr_date[2].to_i.to_s
          @n1 = c.pactname.index('《')
          if @n1!=nil
            @contract_name1 =@contract_name1 +arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日签订的"+  c.pactname+"、"
          else
            @contract_name1 =@contract_name1 +arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日签订的"+  "《" + c.pactname + "》"+"、"
          end
        end
        @contract_name1=@contract_name1.slice(0,@contract_name1.length-3)
      end
    else
      @contract_name1 = "_____"
    end
    return @contract_name1
  end
  #受理日期
  def get_recevicedate(code)
    @date_receive = TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code]).receivedate
    if @date_receive == nil or @date_receive == ""
      @date_receive = "_____"
    else
      arr_date = @date_receive.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @date_receive=arr_date[0]+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    end
    return @date_receive
  end
  #案件大分类---目前按字母类别显示
  def get_casetype_num(code)
    #    @case = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code])
    #    @casetype = TbDictionary.find(:first,:conditions=>["used='Y' and typ_code='0002' and state='Y' and data_parent='' and data_val='#{@case.casetype_num}'"])
    #    return @casetype.data_text
    @case = TbCase.find(:first, :conditions => ["used = 'Y' and recevice_code = ?",code])
    @aribitprog_num = @case.aribitprog_num
    @casetype=@case.t_casetype_num
    if @casetype==nil or @casetype==""
      return "_____"
    else
      if @aribitprog_num=='0001' or @aribitprog_num=='0002' or @aribitprog_num=='0005' or @aribitprog_num=='0006'
        return "D" + @casetype
      else
        return @casetype
      end
    end
  end
  #案件小分类----总会案件分类
  def get_casetype_num2(code)
    @dispute_type=TbCase.find_by_recevice_code(code).dispute_type
    if @dispute_type==nil or @dispute_type==""
      return "_____"
    else
      return @dispute_type
    end
  end
  #1.明确的或不明确但可以确定的争议金额的费用合计;2.对应的受理费、处理费
  def get_total_money(code)
    @rmb_money=TbCaseAmount.find(:first,:conditions=>"used='Y' and recevice_code='#{code}' and typ='0001'",:select=>"sum(rmb_money) as a")
    if @rmb_money!=nil
      @rmb_money=@rmb_money.a
      if @rmb_money!=nil
        @rmb_money=@rmb_money.to_f
        @m=SysArg.compart1(@rmb_money)
      else
        @m="_____"
      end
    else
      @m="_____"
    end
    return  @m
  end
  #立案费/受理费 0002
  def get_litigation_fee(code)
    @litigation=TbShouldCharge.find_by_sql("select sum(s.rmb_money) as aa from tb_case_amounts as a,tb_should_charges as s where s.used='Y' and a.used='Y'
      and a.recevice_code='#{code}' and a.recevice_code=s.recevice_code and a.id=s.case_amount_id and
      s.typ='0002' and  a.typ='0001'")
    #    @litigation=TbShouldCharge.find_by_sql("select sum(rmb_money) as aa from tb_should_charges  where used='Y'
    #      and recevice_code='#{code}'  and typ='0002'")
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
  def get_processing_fee(code)
    @processing=TbShouldCharge.find_by_sql("select sum(s.rmb_money) as cc from tb_case_amounts as a,tb_should_charges as s where s.used='Y' and a.used='Y'
      and a.recevice_code='#{code}' and a.recevice_code=s.recevice_code and a.id=s.case_amount_id and
      s.typ='0003' and  a.typ='0001'")
    #    @processing=TbShouldCharge.find_by_sql("select sum(rmb_money) as cc from tb_should_charges where used='Y'
    #      and recevice_code='#{code}' and typ='0003'")
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
  def get_litigation_fee2(code)
    @litigation2=TbShouldCharge.find_by_sql("select sum(rmb_money) as aa2 from tb_should_charges where used='Y'
      and recevice_code='#{code}' and typ='0005'")
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
  #无明确金额的 处理费/仲裁费 ======涉外、金融的无明确金融收费 = 仲裁费 （个性化约定），所以typ='0004'或0006都可
  def get_processing_fee2(code)
    @processing2=TbShouldCharge.find_by_sql("select sum(rmb_money) as cc2 from tb_should_charges where used='Y'
      and recevice_code='#{code}' and typ='0006'")
    @processing2=PubTool.new.get_first_record(@processing2)
    if @processing2!=nil
      if @processing2.cc2!=nil
        @processing3=@processing2.cc2.to_f
        return @processing3
      else
        return 0
      end
    else
      return 0
    end
  end
  #列出争议金额所有币种、金额信息
  def get_dear_money(code)
    @account2 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and typ= '0001'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
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

  # 获取争议金额
  def get_amount_detail(code)
    # 本请求争议金额
    @amount1 = TbCaseAmount.find(:all, :conditions => "recevice_code='#{code}' and used='Y' and partytype=1 and currency='0001' and typ='0001'", :order => 'id')
    # 反请求争议金额
    @amount2 = TbCaseAmount.find(:all, :conditions => "recevice_code='#{code}' and used='Y' and partytype=2 and currency='0001' and typ='0001'", :order => 'id')
    #争议金额（人民币）

    @sum_rmb1 = 0
    @sum_rmb2 = 0
    for a1 in @amount1
      @sum_rmb1 = @sum_rmb1  +  a1.rmb_money
    end
    for a2 in @amount2
      @sum_rmb2 = @sum_rmb2  +  a2.rmb_money
    end
    re = "人民币" + SysArg.compart1(@sum_rmb1.to_f) + "元"
    re+= "；反请求争议金额：人民币" + SysArg.compart1(@sum_rmb2.to_f) +"元"  if @sum_rmb2 != 0
    return re
  end

  #不明确争议金额
  def get_indefinite_money(code)
    @account4 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0002' and typ= '0001'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
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
  #变 更 仲 裁 费 用 审 批 表：明确金额；不明确金额
  def get_d_money(code)
    @account2 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0001' and typ= '0002'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
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
  def get_i_money(code)
    @account4 = TbCaseAmountDetail.find(:all,:conditions=>["recevice_code= ? and used='Y' and amount_typ= '0002' and typ= '0002'",code],:select=>"sum(f_money) as f_money,currency",:group=>"currency")
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
  #开庭日期
  def get_sittingdate(code)
    @sittingdate=TbArbitroom.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @sittingdate!=nil
      @sdate=@sittingdate.sittingdate
      @weekn=Workday.find(:first,:conditions=>["date=?",@sdate])
      if @weekn!=nil
        @n = @weekn.weekday
        @week0 = @n=="0" ? "日" : SysArg.n_to_md(@n)
      else
        @week0 = "___"
      end
      @sdate=SysArg.get_ymd(@sdate) + "（星期" + @week0 +"）" + SysArg.get_stime(@sittingdate.open_t)
    else
      @sdate="____年__月__日（星期___）上午/下午___时___分"
    end
    return @sdate
  end
  #开庭日期，不带星期几
  def get_sittingdate2(code)
    @sittingdate=TbArbitroom.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @sittingdate!=nil
      @sdate=@sittingdate.sittingdate
      @sdate=SysArg.get_ymd(@sdate)
    else
      @sdate="____年__月__日"
    end
    return @sdate
  end

  # 开庭时间
  def get_sitting_time(code)
    @sittingtime = TbArbitroom.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @sittingtime != nil
      @stime = @sittingdate.open_t + " - " + @sittingdate.close_t
    else
      @stime="__:__ - __:__"
    end
    return @stime
  end

  # 评议时间
  def get_commentdate(code)
    comment = TbCasecomment.find(:first, :conditions => "recevice_code='#{code}' and used = 'Y' ",:order=>'id')
    @re = "____年__月__日"
    unless comment.blank?
      @re = SysArg.get_ymd(comment.comment_date)
    end
  end

  #案件延期日期
  def get_delaydate(code)
    @sittingdate=TbCasedelay.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
    if @sittingdate!=nil
      @sdate=@sittingdate.delayDate
      arr_date = @sdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @sdate=arr_date[0].to_i.to_s + "年" + arr_date[1] + "月" + arr_date[2] + "日"
    else
      @sdate="_____年__月__日"
    end
    return @sdate
  end
  # 转函----1.接收人为申请人:日期、收文材料
  def get_recevicedate1(code,subman)
    @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?  and ifnull(submitman,'')<>'0001'",code],:order=>"id desc")
    if subman == "two"
      @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?  and submitman='0002'",code],:order=>"id desc")
    end
    if @amail!=nil
      @recevicedate1=@amail.recevicedate
      arr_date = @recevicedate1.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @recevicedate=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @recevicedate="____年__月__日"
    end
    return @recevicedate
  end
  def get_materialtype1(code,subman)
    @amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and ifnull(submitman,'')<>'0001'",code],:order=>"id desc")
    if subman == "two"
      @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?  and submitman='0002'",code],:order=>"id desc")
    end
    if @amail != nil
      @materialtype = @amail.materialtype
      if @materialtype != nil
        @a2 = TbDictionary.find(:first,:conditions=>["typ_code='8138' and state='Y' and data_val=?",@materialtype])
        if @a2 != nil
          return @a2.data_text
        end
      else
        return @amail.material_other
      end
    else
      return "_____"
    end
  end
  # 转函----2.接收人为被申请人:日期、收文材料
  def get_recevicedate2(code,subman)
    @amail2=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and ifnull(submitman,'')<>'0002'",code],:order=>"id desc")
    if subman == "two"
      @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?  and submitman='0001'",code],:order=>"id desc")
    end
    if @amail2!=nil
      @recevicedate1=@amail2.recevicedate
      arr_date = @recevicedate1.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @recevicedate=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @recevicedate="____年__月__日"
    end
    return @recevicedate
  end
  def get_materialtype2(code,subman)
    @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and ifnull(submitman,'')<>'0002'",code],:order=>"id desc")
    if subman == "two"
      @amail=TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=?  and submitman='0001'",code],:order=>"id desc")
    end
    if @amail!=nil
      @materialtype1=@amail.materialtype
      if @materialtype1!=nil
        @a2=TbDictionary.find(:first,:conditions=>["typ_code='8138' and state='Y' and data_val=?",@materialtype1])
        if @a2!=nil
          return @a2.data_text
        end
      else
        return @amail.material_other
      end
    else
      return "_____"
    end
  end
  #提交人：当事人 或第三方
  def get_third_party(code,typ)
    @amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and ifnull(submitman,'')<>?",code,typ],:order=>"id desc")
    if typ == "0003"
      @amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and submitman= '0002' ",code],:order=>"id desc")
    end
    if typ == "0004"
      @amail = TbAmail.find(:first,:conditions=>["used='Y' and recevice_code=? and submitman= '0001' ",code],:order=>"id desc")
    end
    if @amail != nil
      if !@amail.submitman2.blank?
        return @amail.submitman2
      elsif @amail.submitman == '0001'
        return "申请人" + @amail.arbitman
      elsif @amail.submitman == '0002'
        return "被申请人" + @amail.arbitman
      end
    else
      return "_____"
    end
  end
  #对方申请人数量＋仲裁员数量＋1＝所需数量
  def get_number1(code,p_v)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @aribitprog_num=@case.aribitprog_num
      if p_v=='0001' #发给申请人
        @n2=TbParty.find_by_sql("select count(id) as i1 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=2")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i1.to_i + 3 + 1
        else
          @n=@n2.i1.to_i + 1 + 1
        end
        @n=SysArg.n_to_md(@n)
      elsif p_v=='0002'#发给被申请人
        @n2=TbParty.find_by_sql("select count(id) as i3 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005'  or @aribitprog_num=='0007'
          @n=@n2.i3.to_i + 3 + 1
        else
          @n=@n2.i3.to_i + 1 + 1
        end
        @n=SysArg.n_to_md(@n)
      elsif p_v=='0003'#发送给双方 和被申请人的一样
        @n2=TbParty.find_by_sql("select count(id) as i from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i.to_i + 3 + 1
        else
          @n=@n2.i.to_i + 1 + 1
        end
        @n=SysArg.n_to_md(@n)
      end
    else
      @n="___"
    end
    return @n
  end
  #和以上方法相同，是以阿拉伯数字形式显示
  def get_number11(code,p_v)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @aribitprog_num=@case.aribitprog_num
      if p_v=='0001' #发给申请人
        @n2=TbParty.find_by_sql("select count(id) as i1 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=2")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i1.to_i + 3 + 1
        else
          @n=@n2.i1.to_i + 1 + 1
        end
      elsif p_v=='0002'#发给被申请人
        @n2=TbParty.find_by_sql("select count(id) as i3 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i3.to_i + 3 + 1
        else
          @n=@n2.i3.to_i + 1 + 1
        end
      elsif p_v=='0003'#发送给双方 和被申请人的一样
        @n2=TbParty.find_by_sql("select count(id) as i from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i.to_i + 3 + 1
        else
          @n=@n2.i.to_i + 1 + 1
        end
      end
    else
      @n="___"
    end
    return @n
  end
  ##仲裁通知（被申请人函），材料份数：对方申请人数量＋（己方申请人的数量－1）＋仲裁员数量＋1存档＝所需数量
  def get_number4(code)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @aribitprog_num=@case.aribitprog_num#发给被申请人
      @n2=TbParty.find_by_sql("select count(id) as i3 from tb_parties where used='Y' and recevice_code='#{code}'")
      @n2=PubTool.new.get_first_record(@n2)
      if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
        @n=SysArg.n_to_md(@n2.i3.to_i + 3)
      else
        @n=SysArg.n_to_md(@n2.i3.to_i + 1)
      end
    else
      @n="___"
    end
    return @n
  end
  ##仲裁通知（XXXXX函）,有当事人原件时减交一份
  def get_number41(code)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @aribitprog_num=@case.aribitprog_num#发给被申请人
      @n2=TbParty.find_by_sql("select count(id) as i3 from tb_parties where used='Y' and recevice_code='#{code}'")
      @n2=PubTool.new.get_first_record(@n2)
      if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
        @n=SysArg.n_to_md(@n2.i3.to_i + 2)
      else
        @n=SysArg.n_to_md(@n2.i3.to_i)
      end
    else
      @n="___"
    end
    return @n
  end
  #如果有原件，复印件数量不用加1
  def get_number2(code,p_v)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @aribitprog_num=@case.aribitprog_num
      if p_v=='0001' #发给申请人
        @n2=TbParty.find_by_sql("select count(id) as i1 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=2")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i1.to_i + 3
        else
          @n=@n2.i1.to_i + 1
        end
        @n=SysArg.n_to_md(@n)
      elsif p_v=='0002'#发给被申请人
        @n2=TbParty.find_by_sql("select count(id) as i3 from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i3.to_i + 3
        else
          @n=@n2.i3.to_i + 1
        end
        @n=SysArg.n_to_md(@n)
      elsif p_v=='0003'#发送给双方 和被申请人的一样
        @n2=TbParty.find_by_sql("select count(id) as i from tb_parties where used='Y' and recevice_code='#{code}' and partytype=1")
        @n2=PubTool.new.get_first_record(@n2)
        if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
          @n=@n2.i.to_i + 3
        else
          @n=@n2.i.to_i + 1
        end
        @n=SysArg.n_to_md(@n)
      end
    else
      @n="___"
    end
    return @n
  end
  #转函 --当事人
  def get_partytype(p_v)
    if p_v=='0001'
      return "申请人"
    elsif p_v=='0002'
      return "被申请人"
    else
      return "_____"
    end
  end
  #案件类型：字母分类
  def get_t_casetype_num(code)
    @t_casetype_num=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code]).t_casetype_num
    if @t_casetype_num!=nil
      @t=@t_casetype_num
    else
      @t="_____"
    end
    return @t
  end
  #证据/财产保全申请时间
  def get_save_time(code,request_typ,typed)#后2参数为申请保全人类型，保全类型
    @save1=TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and request_typ=? and typed=?",code,request_typ,typed])
    if @save1!=nil
      @send_time1=@save1.send_time
      arr_date = @send_time1.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @send_time=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @send_time="_____年__月__日"
    end
    return @send_time
  end
  #证据/财产保全的法院/地区
  def get_save_place(code,request_typ,typed)
    @save1=TbSave.find(:first,:conditions=>["used='Y' and recevice_code=? and request_typ=? and typed=?",code,request_typ,typed])
    if @save1!=nil
      @save_yard=@save1.save_yard
      if @save_yard==""
        @save_yard="_____人民法院/中级人民法院"
      end
    else
      @save_yard="_____人民法院/中级人民法院"
    end
    return @save_yard
  end
  #仲裁语言
  def get_language(code)
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @case!=nil
      @langu=@case.language
      if @langu!=nil and @langu!=""
        @lan=TbDictionary.find(:first,:conditions=>["typ_code='0044' and state='Y' and data_val=?",@langu])
        if @lan!=nil
          @lan=@lan.data_text
        else
          @lan="中文"
        end
      else
        @lan="中文"
      end
    else
      @lan="中文"
    end
    return @lan
  end
  #结案方式  此方法只用于“函寄裁决书”函（fmt37）
  def get_endstyle(code)
    @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    if @award!=nil
      if @award.end_typ!='0004'
        @a = "裁决书"
      else
        @a="撤案决定书"
      end
    else
      @case=TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",code],:order=>"id desc")
      if @case!=nil
        @endStyle=@case.endStyle
        if @endStyle=='0001' or @endStyle=='0002'
          @a = "裁决书"
        else
          @a="撤案决定书"
        end
      else
        @a="裁决书/撤案决定书"
      end
    end
    return @a
  end
  #咨询时当事人提交材料方式
  def get_orgstyle(code)
    @case = TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",code])
    @orgstyle = @case.orgstyle
    @orgname = TbDictionary.find(:first,:conditions=>"typ_code='0005' and state='Y' and data_val='#{@orgstyle}'")
    if @orgname!=nil
      @orgname=@orgname.data_text
    else
      @orgname="_____"
    end
    return @orgname
  end
  #本请求、反请求争议金额的备注，出现在审批格式函中
  def get_remark(code)
    @rema = TbCaseAmount.find(:first,:conditions=>["used='Y' and recevice_code=? and typ='0001'",code],:order=>"id desc")
    @special = TbCase.find_by_recevice_code(code).special
    if @rema!=nil && @special!=nil
      @rem = @rema.remark + '\r' + "  " + @special
    elsif @rema==nil && @special!=nil
      @rem =@special
    elsif @rema!=nil && @special==nil
      @rem = @rema.remark
    else
      @rem = ""
    end
    return @rem
  end
  #咨询助理的相关信息###################################################
  #助理信息：姓名
  def get_name2(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk_2
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @case_alerk = @clerk1.name
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  #性别
  def get_zlsex2(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk_2
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @sex = @clerk1.sex
        if  @sex == "男"
          @case_alerk="先生"
        else
          @case_alerk="女士"
        end
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  #电话
  def get_tel2(code,v)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk_2
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code=?",clerk_code])
      if @clerk1!=nil
        @party=TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
        if @party!=nil
          area1 = @party.area
          if area1!=nil && area1!=""
            if area1!='002' && area1!='003' && area1!='004' && area1.slice(0,3)=="001" #国内的
              @case_alerk2 = "0755-" + @clerk1.telephone
            else  #香港、国外的
              @case_alerk2 = "(86-755)" + @clerk1.telephone
            end
          else
            @case_alerk2 ="0755-" + @clerk1.telephone
          end
        else
          @case_alerk2 ="0755-" + @clerk1.telephone
        end
      else
        @case_alerk2 ="0755-" + @clerk1.telephone
      end
    else
      @case_alerk2 ="0755-"
    end
    return @case_alerk2
  end
  #传真
  def get_fax22(code,v)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk_2
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil
        @party=TbParty.find(:first,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,v])
        if @party!=nil
          area1 = @party.area
          if area1!=nil && area1!=""
            if area1!='002' && area1!='003' && area1!='004' && area1.slice(0,3)=="001" #国内的
              @case_alerk3 = "0755-" + @clerk1.fax
            else  #香港、国外的
              @case_alerk3 = "(86-755)" + @clerk1.fax
            end
          else
            @case_alerk3 = "0755-" + @clerk1.fax
          end
        else
          @case_alerk3 = "0755-" + @clerk1.fax
        end
      else
        @case_alerk3 ="0755-" + @clerk1.fax
      end
    else
      @case_alerk3 = "0755-"
    end
    return @case_alerk3
  end
  #电子邮箱
  def get_email2(code)
    @case=TbCase.find(:first,:conditions => ["used = 'Y' and recevice_code = ?",code])
    clerk_code = @case.clerk_2
    if clerk_code!=nil and clerk_code!=""
      @clerk1 = User.find(:first,:conditions => ["used = 'Y' and code = ?",clerk_code])
      if @clerk1!=nil and @clerk1!=""
        @case_alerk = @clerk1.email
      else
        @case_alerk = "_____"
      end
    else
      @case_alerk = "_____"
    end
    return @case_alerk
  end
  ##############################################
  #你方；你两....方：显示当事人个数。三方及三方以上的修改为 “上述申请人”p:1,申请人；2，被申请人
  def get_n_party(code,p)
    @partyall=TbParty.find(:all,:conditions=>["used='Y' and recevice_code=? and partytype=?",code,p])
    if PubTool.new.get_first_record(@partyall)!=nil
      @p1 = @partyall.length
      if @p1==1
        return "你方"
      elsif @p1==2
        return "你两方"
      else
        if p==1
          return "上述申请人"
        else
          return "上述被申请人"
        end
      end
    else
      return ""
    end
  end
  #保全管理：显示多个当事人名称
  def get_save_party(code,p_v,typ)
    @part=TbParty.find_by_sql("select s.request_man as partyname,s.send_time as send_time from tb_saves as s where
 s.used='Y' and s.typed='#{typ}' and s.recevice_code='#{code}' and s.request_typ='#{p_v}' order by s.id")
    if PubTool.new.get_first_record(@part)==nil
      @save_p = ""
    else
      @save_p = ""
      i = 1
      @part.each do |sp|
        arr_date = sp.send_time.to_s.split("-")
        arr_date[1]=arr_date[1].to_i.to_s
        arr_date[2]=arr_date[2].to_i.to_s
        @send_time=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
        if @part.length==1
          @save_p = @save_p + sp.partyname + "在" + @send_time + "  "
        else
          if i==@part.length
            @save_p = @save_p + sp.partyname+ "在" + @send_time + "  "
          else
            @save_p = @save_p + sp.partyname+ "在" + @send_time + "、"
          end
        end
        i+=1
      end
      if @save_p!=""
        @save_p = @save_p.slice(0,@save_p.length-2)
      end
    end
    return @save_p
  end
  #金额符号
  def get_sign(n1)
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
  #收据
  def  get_cn_code(code)
    @tbcharge=TbCharge.find(:all,:conditions=>["used='Y' and recevice_code=? and (typ='a' or typ='b') and state=2",code])
    tcode=""
    if PubTool.new.get_first_record(@tbcharge)!=nil
      @tbcharge.each do |tc|
        tcode= tcode + tc.code + "、"
      end
      if tcode!=""
        tcode=tcode.slice(0,tcode.length-3)
      end
    end
    tcode="____" if tcode==""
    return tcode
  end
end
