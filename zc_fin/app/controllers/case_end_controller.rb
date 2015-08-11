class CaseEndController < ApplicationController
  #检查条件：无立案号、无办案助理、无受理日期不能终审、有欠费不能终审，简易程序无仲裁员不能终审、
  #普通程序没有三个仲裁员不能终审，无结案号、结案方式、结案日期、无裁决书不能终审，
  #撤案结案方式的，如果无仲裁员,可以终审
  #关于日期：立案<=组庭<=开庭<=结案
  #终审检查的时候，对有开庭时间，没有该开庭日期对应的庭审笔录的应卡住
  def list
    r0="" #受理日期
    r3="" #仲裁员
    r1=""#结案信息
    r2=""#交费情况
    r4=""#立案日期不能大于组庭日期
    r5="" #组庭日期不能大于开庭日期
    r6="" #开庭日期不能大于结案日期
    r7="" #代理人所在单位不能为空
    r8="" #庭审笔录
    r9=""  #仲裁员评分
    r10 = "" #某些情况下必须有组庭信息
    #r10="" 对应收款记录
    r11=""  #检查校核信息，若没填写不让终审
    r12 = "" #2010-10-12 niell 存在尚未拆净的金额或者存在尚未对应的明细,要检测不通过
    r13 = "" #2010-10-12 niell 存在尚未对应的明细，进行检测
    r14 = "" #案件合同没有上传
    r15 = "" #必须有新工时汇总信息，否则不能终审。
    r16 = "" # 如果有管辖权异议，那么必须上传管辖权决定，否则不能终审。
    @case = nil#当前办理案件
    if session[:recevice_code]!=nil
      #当前案件
      @case = TbCase.find_by_recevice_code(session[:recevice_code])
      #立案日期或不受理日期
      @nowdate = @case.nowdate
      #组庭信息
      @caseorg = TbCaseorg.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      #开庭信息
      @sitting = TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      #结案信息
      @caseendbook=TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]],:order=>"id desc")

      #判断是否有受理日期
      if @case.accepttime==nil
        r0 = "无受理日期；"
      end

      #判断案件合同是否上传
      file = CaseBook.find(:all,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and typ='0005' and used='Y'")

      if file.empty?
        r14 = "案件合同未上传；"
      else
        for f in file
          if f.book_name.blank?
            r14 = "案件合同未上传；"
          end
        end
      end

      # 判断是否有管辖权异议，有的话必须上传管辖权决定，否则不能终审。
      jurisdiction = TbJurisdiction.find(:all,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      for j in jurisdiction
        jfile = CaseBook.find(:all,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and typ='0006' and used='Y' and p_id='#{j.id}'")
        if jfile.empty? # 没有记录
          r16 = "管辖权决定未上传；"
        else
          for jf in jfile
              r16 = "管辖权决定未上传；"  if jf.book_name.blank? # 有记录记录，但是文件没有上传。
          end
        end
      end


      #判断组庭信息是否正确，包括以下项目：
      #  1 立案日期 <= 组庭日期 <= 开庭日期 <= 结案日期；
      #  2 存在，并且已经上传庭审笔录；
      if @caseorg != nil
        @orgdate = @caseorg.orgdate #组庭日期
        if @nowdate > @orgdate
          r4 = "立案日期不能大于组庭日期；"
        end
        #庭审笔录.如果是多次开庭，验证最后一次庭审笔录
        @casebook = CaseBook.find(:first,:conditions=>["used='Y' and recevice_code = ? and typ = '0001' and book_name<>'' and p_id=?",session[:recevice_code],@case.sitting_id_last])
        if @sitting != nil
          @sittingdate = @sitting.sittingdate
          if @orgdate > @sittingdate and @casebook != nil
            r5 = "组庭日期不能大于开庭日期；无庭审笔录；"
          elsif @orgdate > @sittingdate and @casebook == nil
            r5 = "组庭日期不能大于开庭日期；"
          end

          if @caseendbook != nil
            @decideDate = @caseendbook.decideDate
            if @sittingdate > @decideDate
              r6 = "开庭日期不能大于结案日期；"
            end
          end
          #庭审笔录
          p_id=TbSitting.find(:first,:conditions=>["used='Y' and recevice_code=? and sittingdate=?",session[:recevice_code],@sittingdate],:order=>"id").id
          @doc=CaseBook.find(:first,:conditions=>["used='Y' and p_id=? and typ='0001' and book_name<>''",p_id])
          if @doc==nil
            r8="未上传庭审笔录；"
          end
        end
      end

      #撤案类型案件可以没有仲裁员
      #仲裁员类型 TbEvaluate（仲裁员评价表）
      #arbitman_type  001 独任； 002 首席； 003 申请方； 004 被申请方；
      tb_ev1 = TbEvaluate.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman_type=?",session[:recevice_code],'0001'])
      tb_ev2 = TbEvaluate.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman_type=?",session[:recevice_code],'0002'])
      tb_ev3 = TbEvaluate.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman_type=?",session[:recevice_code],'0003'])
      tb_ev4 = TbEvaluate.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman_type=?",session[:recevice_code],'0004'])

      @ar0 = PubTool.arbitrator(session[:recevice_code],'0001')
      @ar1 = PubTool.arbitrator(session[:recevice_code],'0002')
      @ar2 = PubTool.arbitrator(session[:recevice_code],'0003')
      @ar3 = PubTool.arbitrator(session[:recevice_code],'0004')
      if @caseendbook==nil#没有结案信息
        r1 = "没有结案信息；"
        if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
          if @case.special_convention=="" or @case.special_convention=='0001' or @case.special_convention=='0003' #无特殊约定或约定独任
            if SysArg.new.get_ar(session[:recevice_code])==""
              r3 = "无仲裁员；"
            else
              if @caseorg==nil
                r10 = "没有组庭时间；"
              end
              if tb_ev1==nil
                r9="无仲裁员评价；"
              end
            end
          else # 简易程序约定三人仲裁庭
            if @ar1!="" and @ar2!="" and @ar3!=""
              if @caseorg==nil
                r10 = "没有组庭时间；"
              end
              if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                r9="无仲裁员评价；"
              end
            else
              r3 = "仲裁员不够三个；"
            end
          end
        else#普通案件
          if @case.special_convention=="" or @case.special_convention=='0001' or @case.special_convention=='0002' #无特殊约定或约定三人仲裁庭
            if @ar1!="" and @ar2!="" and @ar3!=""
              if @caseorg==nil
                r10 = "没有组庭时间；"
              end
              if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                r9="无仲裁员评价；"
              end
            else
              r3 = "仲裁员不够三个；"
            end
          else #普通程序约定独任仲裁庭
            if @ar0==""
              r3 = "无仲裁员；"
            else
              if @caseorg==nil
                r10 = "没有组庭时间；"
              end
              if tb_ev1==nil
                r9="无仲裁员评价；"
              end
            end
          end
        end
      else #有结案信息
        @sty = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]]).endStyle
        @book_name1 = CaseBook.find(:all,:conditions=>["used='Y' and recevice_code=? and book_name!='' and book_typ=?",session[:recevice_code],@sty])
        @book_name = PubTool.new.get_first_record(@book_name1)
        if @book_name==nil
          r1 = "没有裁决书；"
        end
        @endStyle = @caseendbook.endStyle
        #撤案结案类型的终审可以没有组庭 ; 撤案案件检查时，有仲裁员的，才检查有无评价；无仲裁员的，不检查评价
        if @endStyle!='0003'
          if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
            if @case.special_convention=="" or @case.special_convention=='0001' or @case.special_convention=='0003' #无特殊约定或约定独任
              if SysArg.new.get_ar(session[:recevice_code])==""
                r3 = "无仲裁员；"
              else
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev1==nil
                  r9="无仲裁员评价；"
                end
              end
            else #  简易程序约定三人仲裁庭
              if @ar1!="" and @ar2!="" and @ar3!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                  r9="无仲裁员评价；"
                end
              else
                r3 = "仲裁员不够三个；"
              end
            end
          else#普通案件
            if @case.special_convention=="" or @case.special_convention=='0001' or @case.special_convention=='0002' #无特殊约定或约定三人仲裁庭
              if @ar1!="" and @ar2!="" and @ar3!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                  r9="无仲裁员评价；"
                end
              else
                r3 = "仲裁员不够三个；"
              end
            else # 普通程序约定独任仲裁庭
              if @ar0==""
                r3 = "无仲裁员；"
              else
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev1==nil
                  r9="无仲裁员评价；"
                end
              end
            end
          end

          # 检查是否录入了新工时汇总信息
          c = "recevice_code='#{@case.recevice_code}' and used='Y'"
          @remun1 = RemunerationAward.find(:all, :conditions => c)
          @remun2 = RemunerationJixiao.find(:all, :conditions => c)

          r15 += "没有录入裁决书制作信息，" if @remun1.length == 0
          r15 += "没有录入绩效评价信息，" if @remun2.length == 0

        else #撤案 ##############################3
          if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
            if @case.special_convention=="" or @case.special_convention=='0001'  or @case.special_convention=='0003' #无特殊约定或约定独任
              if SysArg.new.get_ar(session[:recevice_code])!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev1==nil
                  r9="无仲裁员评价；"
                end
              end
            else #简易程序约定三人仲裁庭
              if @ar1!="" or @ar2!="" or @ar3!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                  r9="无仲裁员评价；"
                end
              end
            end
          else#普通案件
            if @case.special_convention=="" or @case.special_convention=='0001'  or @case.special_convention=='0002' #无特殊约定或约定三人仲裁庭
              if @ar1!="" or @ar2!="" or @ar3!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
                  r9="无仲裁员评价；"
                end
              end
            else # 普通程序约定独任仲裁庭
              if @ar0!=""
                if @caseorg==nil
                  r10 = "没有组庭时间；"
                end
                if tb_ev1==nil
                  r9="无仲裁员评价；"
                end
              end
            end
          end
        end
      end
      #无论结案（不管撤案、还是其他结案方式）、未结：有仲裁员则—评价、组庭信息。

      #有无收款记录
      @ccc=TbShouldCharge.count(:conditions=>"used='Y' and recevice_code='#{session[:recevice_code]}'")
      #应收仲裁费用的和，即应交
      s1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and (typ='0001' or typ='0004')",session[:recevice_code]])
      #减交仲裁费用的和
      s2=TbShouldCharge.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and (typ='0001' or typ='0004')",session[:recevice_code]])
      #已收仲裁费用的和，即实交
      s3=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and (typ='0001' or typ='0004')",session[:recevice_code]])

      if @ccc==nil or @ccc==0
        r2 = "没有交费记录；"
      else
        s=s1.to_i - s2.to_i - s3.to_i
        if s>0
          r2="有欠缴费用未交；"
        else#费用对应明细
          s4=TbShouldCharge.find(:all,:conditions=>["used='Y' and re_rmb_money=0 and recevice_code=? and (typ='0001' or typ='0004')",session[:recevice_code]])
#          tb_should_refund = TbShouldRefund.find_by_sql("")
          #应退 - 减退 如果>0,提醒有退费，不进行；如果没，
#            if
#            r14 = "存在未对应的费用明细【收费明细对应中存在为0】的检测；反之进行检测"
#            end
          if !(s4.empty?)
            r2 = "案件收费明细对应中存在为0的记录；"
          end
          #2010-10-12 niell 存在尚未拆净的金额或者存在尚未对应的明细，进行检测
#          s4 = TbShouldCharge.find(:first,:select=>"sum(rmb_money - re_rmb_money) as ss",:conditions=>["used='Y' and recevice_code=? and (typ='0007' or typ='0008')",session[:recevice_code]]) #未对应的明细费用
          s5 = TbCharge.sum(:rmb_money,:conditions=>["recevice_code=? and used='Y' and typ='b'",session[:recevice_code]]) #被拆分的原始收款总记录
          s6 = TbCharge.sum(:rmb_money,:conditions=>["recevice_code=? and used='Y' and typ='c'",session[:recevice_code]]) #拆分后的收款记录
          s = s5.to_i - s6.to_i
          if s>0
            r12 = "存在尚未拆净的收款费用；"
          end
          s4 = TbCharge.count(:id,:conditions=>["used='Y' and should_id=0 and state=2 and (typ='a' or typ='c') and recevice_code=?",session[:recevice_code]])
          if s4>0
            r13 = "存在未对应的费用明细；"
          end
#          if s4!=nil && s4.ss.to_i>0
#            r13 = "存在未对应的费用明细；"
#          end
        end
      end
      @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      if @award==nil
        r11="请填写裁决书报校核信息；"
      end
      #收款记录对应
      @homologous=TbCharge.find(:first,:conditions=>["used='Y' and recevice_code=? and (typ='a' or typ='c') and should_id=0",session[:recevice_code]])
      #代理人所在单位
      agent=TbAgent.count(:id,:conditions=>["used='Y' and recevice_code=? and company=''",session[:recevice_code]])
      if agent>0
        r7="代理人所在单位不能为空；"
      end
      @r_mes = r0 + r14 + r3 + r10 + r1 + r2 + r4 + r5 + r6 + r7 + r8 + r9 + r11 + r12 + r13 + r15 + r16



      # -----------------------------以下各项检查仅作为提示，如果检查不通过也可以终审--------------------------------------

      #仲裁员实际开支费用 :当事人预缴仲裁员开支费用 - (助理录入)仲裁员实际开支、抹零数据
      m_1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",session[:recevice_code]])
      @shoud1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",session[:recevice_code]])
      @should2= TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",session[:recevice_code]])
      #出纳录入的仲裁员开支费用
      #      @arbitspend=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      #助理录入的仲裁庭支出费用
      #      @sroom = TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
      @aribitprog_num=@case.aribitprog_num
      if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
        as11=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and arbitman_typ<>'0001'",session[:recevice_code]])
        as44=TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
        as=as11.to_i + as44.to_i
      else
        as11=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and arbitman_typ='0001'",session[:recevice_code]])
        as44=TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
        as=as11.to_i + as44.to_i
      end
      fe1 = @shoud1.to_i - @should2.to_i - as

      if fe1!=0
        s1="仲裁员实际费用平衡表 结余不为0；"
      else
        s1=""
      end
      if m_1.to_i!=0
        if @shoud1.to_i==0
          s2 = "仲裁员实际开支费用没有交纳；"
        else
          s2=""
        end
      else
        s2=""
      end
      #当事人地区，如果存在“中国内地”输入项目，提示，不作为终审卡住条件
      tb_party=TbParty.count(:id,:conditions=>["used='Y' and recevice_code=? and area='001'",session[:recevice_code]])
      if tb_party>0
        s3="当事人地区为中国内地，请明确其所在省份；"
      else
        s3=""
      end
      @m_fee=s1 + s2 + s3
    end
  end

  def final_do
    if TbCaseFlow.check(session[:recevice_code],'0007')
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      f=TbCaseFlow.add_flow(session[:recevice_code],'0007')
      if f!=0
        @case.state=f
      end
      recevice_code=session[:recevice_code]
      @case.end_date=params[:dat]
      @case.end_u=session[:user_code]
      @case.end_t=Time.now

      if @case.save
        session[:recevice_code]=nil
        session[:case_code]=nil
        session[:general_code]=nil
        a_p="final_tex"
      else
        flash[:notice]="终审操作失败！"
        a_p="list"
      end
      redirect_to :action=>a_p,:r_code=>recevice_code
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end

end
#      @sss=TbShouldCharge.count(:conditions=>"used='Y' and (typ='0001' or typ='0004') and recevice_code='#{session[:recevice_code]}' and (rmb_money - redu_rmb_money - re_rmb_money)>=0")
#      if ((@ccc==nil or @ccc==0) or (@sss!=nil and @sss!=0))
#        if (@ccc==nil or @ccc==0)
#          r2 = "没有交费记录；"
#        elsif @sss!=nil and @sss!=0
#          r2 = "有欠缴费用未交；"
#        end
#      else
#        r2 = ""
#      end

#if SysArg.new.get_ar(session[:recevice_code])==""#无仲裁员
#            r3 = "无仲裁员；"
#            r9="无仲裁员评价；"
#          else#有仲裁员
#            if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
#              if SysArg.new.independent_arbitrator(session[:recevice_code])==""
#                r3 = "无仲裁员；"
#              end
#              if tb_ev1==nil
#                r9="无仲裁员评价；"
#              end
#            else#普通案件
#              if @ar1!=nil or @ar2!=nil or @ar3!=nil
#                r3 = "仲裁员不够三个；"
#              end
#              if tb_ev2==nil or tb_ev3==nil or tb_ev4==nil
#                r9="无仲裁员评价；"
#              end
#            end
#          end