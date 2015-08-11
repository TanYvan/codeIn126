#
# To change this template, choose Tools | Templates
# and open the template in the editor.


class Task_a

  def t_a
    t_b
  end

#  def t_b
#    if @@task_state==0
#
#      @@task_state=1
#
#      @sys_2001 = SysArg.find_by_code('2001') #提醒服务最后运行时间
#      et_before = @sys_2001.val
#      et_now_t = Time.now
#      et_now = et_now_t.to_s(:db)
#      @sys_2001.val = et_now
#      @sys_2001.save
#      t_32(et_before,et_now_t,et_now)
#    end
#  end

  def t_b
    if @@task_state==0

      @@task_state=1

      @sys_2001 = SysArg.find_by_code('2001') #提醒服务最后运行时间
      et_before = @sys_2001.val
      et_now_t = Time.now
      et_now = et_now_t.to_s(:db)
      @sys_2001.val = et_now
      @sys_2001.save

      # 1:收费被助理确认以后,直接提醒处长指定一名助理办案,2工作日后仍未指定的,提醒到秘书长处。
      begin
        t_1(et_before,et_now)
      rescue
      end
      # 2:处长指定办案人员后,直接提醒办案人员发出仲裁通知,2工作日之后仍未发出的,提醒到处长处。
      begin
        t_2(et_before,et_now)
      rescue
      end
      # 3：仲裁庭回避申请相关提醒
      begin
        t_3(et_before,et_now)
      rescue
      end
      # 4:管辖权异议相关提醒
      begin
        t_4(et_before,et_now)
      rescue
      end
      # 5:发开庭通知相关函的提醒
      begin
        t_5(et_before,et_now)
      rescue
      end
      ##########################################################################################################
      # 6:决定审计、鉴定或评估的,仲裁助理在3个工作日内联系有关专业机构,如果仍未联系,则提醒到处长处。在收到有关专业机构的报价之日起10个工作日内商定仲裁庭,确定具体的专业机构和有关报价；10个工作日内仍未确定,提醒到处长处。
      begin
        t_6(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 7:开庭中仲裁庭使用信息中新建和删除的时候进行提示前台，订房信息新建和删除时候提示前台,案件合议中案件庭使用信息中新建和删除的时候进行提示前台，
      begin
        t_7(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 8: 审限到期前,系统提醒助理作出裁决。1个月,15天,5天,3天
      begin
        t_8(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 9: 校核人员指定后,直接提醒校核人员进行仲裁员评价
      begin
        t_9(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 10: 当支出超过收入,即结余为负数时,需要提醒补收费用。每天只提醒一次（提醒到助理）
      begin
        t_10(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 11: 退费申请经助理输入后,报秘书处长审批,审批后信息到出纳工作提醒中。
      begin
        t_11(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 12: 开庭前2个工作日,提示助理,短信通知的仲裁员。同时生成短信提醒信息，提醒仲裁员开庭信息,当事人，代理人
      begin
        t_12(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 13: 发文报批后立刻提示审批人进行审批
      begin
        t_13(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 14: 出纳收款后提醒助理进行确认
      begin
        t_14(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 15:助理确认收款明细后,提醒出纳
      begin
        t_15(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 16:助理确认收款明细到【案件收费】后,检查案件是否已经立案,如果未立案则提醒到处长,
      begin
        t_16(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 17：发开庭通知的时候，判断是否有欠缴费用，如果有则提醒
      begin
        t_17(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 18：年初计算更新仲裁员年龄
      begin
        t_18(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 19：立案后提醒到出纳，某发票号已对应到案件
      begin
        t_19(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 20：立案后提醒到处长，提醒处长有案件立案，办案助理是谁
      begin
        t_20(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 21：删除一年前的提醒信息
      begin
        t_21(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 22：案件结案后，N天后对未填写执行情况的案件，提示填写执行情况。
      begin
        t_22(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 23：生成短信提醒信息，提醒仲裁员开庭信息,当事人，代理人
      #    begin
      #      t_23(et_before,et_now_t,et_now)
      #    rescue
      #    end
      ##########################################################################################################
      # 24：每天检查前一天操作的结案记录（以操作时间为准），结案的裁决或撤案是否已结上传了裁决书或者撤案书。如果没有上传，则提醒到制作裁决者（创建该案件结案信息的人）。
      begin
        t_24(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 25：每天生成仲裁员人案统计表。
      begin
        if et_now.slice(0,10)>et_before.slice(0,10)
          t_25()
        end
      rescue
      end
      ##########################################################################################################
      # 26：每天检查咨询记录，把咨询有效期小于今天的咨询记录设置为历史咨询记录。
      begin
        t_26(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 27：检查对应到案件的费用是否被对应到明细了，如果没对应则提醒到助理。
      begin
        t_27(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 28: 案件发出仲裁通知
      begin
        t_28(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 29: 结案10天后提醒助理该案件未归档,20天提醒到处长
      begin
        t_29(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 30: 对咨询案件，在创建咨询案件2天后，发出提醒给咨询案件的接待助理
      begin
        t_30(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
      # 31: 对咨询案件，在创建咨询案件2天后，发出提醒给咨询案件的接待助理
      begin
        t_31(et_before,et_now_t,et_now)
      rescue
      end

      ##########################################################################################################
      # 32: 针对外网当事方留言信息，发出提醒到办案助理
      begin
        t_32(et_before,et_now_t,et_now)
      rescue
      end
      #########################################################################################################
      # 101: 取外网评价的统计信息保存到内网
      begin
        t_101(et_before,et_now_t,et_now)
      rescue
      end

      ##########################################################################################################
      # 800: 一年内未确认的待退费传入历史页面
      begin
        t_800()
      rescue
      end

      ##########################################################################################################
      # 911：备份数据库
      begin
        t_911(et_before,et_now_t,et_now)
      rescue
      end
      ##########################################################################################################
=begin      
      begin
        t_33(et_before,et_now)
      rescue
      end
      #####################################3
=end
      @@task_state=0

    else

    end

  end

  ##################
  def t_1(et_before,et_now)
    #1:收费被助理确认以后,直接提醒处长指定一名助理办案,2工作日后仍未指定的,提醒到秘书长处。
    #直接提醒处长指定一名助理办案
    @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and check_dt>='#{et_before}' and check_dt<'#{et_now}'",:order=>"check_dt",:select=>"distinct should_id as should_id")
    for c in @tc
      @tsc=TbShouldCharge.find(c.should_id)
      if TbCase.find_by_recevice_code(@tsc.recevice_code).clerk==''
        if @tsc.used=='Y' and (@tsc.typ=='0001' or @tsc.typ=='0004') and @tsc.re_rmb_money!=0
          @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
          for ud in @ud
            if Remind.find_by_reason_id("#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 1")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id= "#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 1"
              @remin.contents="案件咨询流水号:#{@tsc.recevice_code},案件已收费请指定办案助理。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200 and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #2个工作日后仍未指定的,提醒到秘书长处
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and check_dt>='#{wwdd} 00:00:01' and check_dt<'#{wwdd2} 00:00:01'",:order=>"check_dt",:select=>"distinct should_id as should_id")
      for c in @tc
        @tsc=TbShouldCharge.find(c.should_id)
        if TbCase.find_by_recevice_code(@tsc.recevice_code).clerk==''
          if @tsc.used=='Y' and (@tsc.typ=='0001' or @tsc.typ=='0004') and @tsc.re_rmb_money!=0
            @ud=UserDuty.find(:all,:conditions=>"duty_code='0002'",:select=>"distinct user_code as user_code",:order=>"user_code")
            for ud in @ud
              if Remind.find_by_reason_id("#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 2")==nil
                @remin=Remind.new
                @remin.used='Y'
                @remin.reason_id="#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 2"
                @remin.contents="案件咨询流水号:#{@tsc.recevice_code},案件已收费请指定办案助理。"
                @remin.dt1=Date.today
                @remin.uu=ud.user_code
                @remin.state=1
                @remin.typ='0001'
                @remin.u='system'
                @remin.u_t=Time.now
                if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200  and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                  @remin.save
                end
              end
            end
          end
        end
      end
    end
  end

  def t_2(et_before,et_now)
    ### 2:处长指定办案人员后,直接提醒办案人员发出仲裁通知,2工作日之后仍未发出的,提醒到处长处。
    #直接提醒办案人员发出仲裁通知
    #方式一:先检查交款记录
    @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and check_dt>='#{et_before}' and check_dt<'#{et_now}'",:order=>"check_dt",:select=>"distinct should_id as should_id")
    for c in @tc
      @tsc=TbShouldCharge.find(c.should_id)
      if @tsc.used=='Y' and (@tsc.typ=='0001' or  @tsc.typ=='0004') and @tsc.re_rmb_money!=0
        @tcc=PubTool.new.get_first_record(TbClerkchange.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}'",:order=>"id desc"))
        if @tcc!=nil
          if TbDoc.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}' and (typ_code='0005' or typ_code='0006' or typ_code='0007' or typ_code='0008' or typ_code='0009' or typ_code='0010' or typ_code='0011' or typ_code='0012')").empty?
            #if Remind.find_by_reason_id("#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 1")==nil
            if Remind.find(:all,:conditions=>"reason_id like '#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-%tb_clerkchanges-%1'").empty?
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 1"
              @remin.contents="立案号:#{@tsc.case_code},案件咨询流水号:#{@tsc.recevice_code},提醒发仲裁通知,【发文】中发【仲裁通知】。"
              @remin.url="/case_doc/list?recevice_code=#{@tsc.recevice_code}"
              @remin.dt1=Date.today
              if TbCase.find_by_recevice_code(@tsc.recevice_code).clerk!=''
                @remin.uu=TbCase.find_by_recevice_code(@tsc.recevice_code).clerk
              else
                @remin.uu=TbCase.find_by_recevice_code(@tsc.recevice_code).clerk_2
              end
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200  and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #方式二:先检查助理更换记录
    @tcc_1=TbClerkchange.find(:all,:conditions=>"t>='#{et_before}' and t<'#{et_now}'",:select=>"distinct recevice_code as recevice_code",:order=>"id desc")
    for tcc_1 in @tcc_1
      @tcc=PubTool.new.get_first_record(TbClerkchange.find(:all,:conditions=>"recevice_code='#{tcc_1.recevice_code}'",:order=>"id desc"))
      @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and clerk<>'' and recevice_code='#{@tcc.recevice_code}'",:select=>"distinct should_id as should_id")
      for c in @tc
        @tsc=TbShouldCharge.find(c.should_id)
        if @tsc.used='Y' and  (@tsc.typ=='0001' or  @tsc.typ=='0004') and @tsc.re_rmb_money!=0
          if TbDoc.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}' and (typ_code='0005' or typ_code='0006' or typ_code='0007' or typ_code='0008' or typ_code='0009' or typ_code='0010' or typ_code='0011' or typ_code='0012')").empty?
            #if Remind.find_by_reason_id("#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 1")==nil
            if Remind.find(:all,:conditions=>"reason_id like '#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-%tb_clerkchanges-%1'").empty?
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{@tsc.recevice_code} #{TbCase.find_by_recevice_code(@tsc.recevice_code).clerk} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 1"
              @remin.contents="立案号:#{@tsc.case_code},案件咨询流水号:#{@tsc.recevice_code},提醒发仲裁通知,【发文】中发【仲裁通知】。"
              @remin.url="/case_doc/list?recevice_code=#{@tsc.recevice_code}"
              @remin.dt1=Date.today
              if TbCase.find_by_recevice_code(@tsc.recevice_code).clerk!=''
                @remin.uu=TbCase.find_by_recevice_code(@tsc.recevice_code).clerk
              else
                @remin.uu=TbCase.find_by_recevice_code(@tsc.recevice_code).clerk_2
              end
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200  and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #2个工作日后仍发仲裁通知,提醒到处长。方式一:先检查交款记录
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and check_dt>='#{wwdd} 00:00:01' and check_dt<'#{wwdd2} 00:00:01'",:order=>"check_dt",:select=>"distinct should_id as should_id")
      for c in @tc
        @tsc=TbShouldCharge.find(c.should_id)
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for ud in @ud
          if @tsc.used=='Y' and (@tsc.typ=='0001' or @tsc.typ=='0004') and @tsc.re_rmb_money!=0
            @tcc=PubTool.new.get_first_record(TbClerkchange.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}'",:order=>"id desc"))
            if @tcc!=nil
              if TbDoc.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}' and (typ_code='0005' or typ_code='0006' or typ_code='0007' or typ_code='0008' or typ_code='0009' or typ_code='0010' or typ_code='0011' or typ_code='0012')").empty?
                #if Remind.find_by_reason_id("#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 2")==nil
                if Remind.find(:all,:conditions=>"reason_id like '#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-%tb_clerkchanges-%2'")==nil
                  @remin=Remind.new
                  @remin.used='Y'
                  @remin.reason_id= "#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 2"
                  @case=TbCase.find_by_recevice_code(@tsc.recevice_code)
                  @remin.contents="助理:#{User.find_by_code(@case.clerk).name}，立案号:#{@case.case_code},案件咨询流水号:#{@tsc.recevice_code},提醒发仲裁通知,【发文】中【仲裁通知】。"
                  @remin.dt1=Date.today
                  @remin.uu=ud.user_code
                  @remin.state=1
                  @remin.typ='0001'
                  @remin.u='system'
                  @remin.u_t=Time.now
                  if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200 and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                    @remin.save
                  end
                end
              end
            end
          end
        end
      end
    end
    #2个工作日后仍未指定的,提醒到处长。方式二:先检查助理更换记录
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @tcc_1=TbClerkchange.find(:all,:conditions=>"t>='#{wwdd} 00:00:01' and t<'#{wwdd2} 00:00:01'",:select=>"distinct recevice_code as recevice_code",:order=>"id desc")
      for tcc_1 in @tcc_1
        @tcc=PubTool.new.get_first_record(TbClerkchange.find(:all,:conditions=>"recevice_code='#{tcc_1.recevice_code}'",:order=>"id desc"))
        @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and clerk<>'' and recevice_code='#{@tcc.recevice_code}'",:select=>"distinct should_id as should_id")
        for c in @tc
          @tsc=TbShouldCharge.find(c.should_id)
          @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
          for ud in @ud
            if @tsc.used='Y' and (@tsc.typ=='0001' or @tsc.typ=='0004') and @tsc.re_rmb_money!=0
              if TbDoc.find(:all,:conditions=>"recevice_code='#{@tsc.recevice_code}' and (typ_code='0005' or typ_code='0006' or typ_code='0007' or typ_code='0008' or typ_code='0009' or typ_code='0010' or typ_code='0011' or typ_code='0012')").empty?
                #if Remind.find_by_reason_id("#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 2")==nil
                if Remind.find(:all,:conditions=>"reason_id like '#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-%tb_clerkchanges-%2'").empty?
                  @remin=Remind.new
                  @remin.used='Y'
                  @remin.reason_id="#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} tb_clerkchanges-#{@tcc.id} 2"
                  @case=TbCase.find_by_recevice_code(@tsc.recevice_code)
                  @remin.contents="助理:#{User.find_by_code(@case.clerk).name}，立案号:#{@case.case_code},案件咨询流水号:#{@tsc.recevice_code},提醒发仲裁通知,【发文】中发【仲裁通知】。"
                  @remin.dt1=Date.today
                  @remin.uu=ud.user_code
                  @remin.state=1
                  @remin.typ='0001'
                  @remin.u='system'
                  @remin.u_t=Time.now
                  if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200  and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                    @remin.save
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  #    仲裁庭回避申请相关提醒：
  #    1 在仲裁庭回避里面输入收到回避申请的日期。
  #    ——系统进行判断,如果5天后没有输入起草回避决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
  #    2 输入起草回避决定草稿的时间。
  #    ——系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。
  #    3 输入回避决定草稿完成时间。
  #    ——系统进行判断,如果5天后没有输入D中的回避决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
  #    4 输入回避决定报总会时间。
  #    ——提醒程序结束。
  def t_3(et_before,et_now)
    # 1 仲裁庭回避申请日期距现在5个工作日
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1 and  requestdate>='#{wwdd}' and  requestdate<'#{wwdd2}' and senddate is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 1")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 1"
              @remin.contents="立案号:#{c.case_code},提醒仲裁员回避申请转交给对方当事人和仲裁庭,【仲裁员回避记录】中录入【转交给对方当事人和仲裁庭时间】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #在仲裁员回避里面输入收到回避申请的日期。系统进行判断,如果5个工作日后没有输入起草回避决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>5)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>4)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and requestdate>='#{wwdd}'  and requestdate<'#{wwdd2}' and draftingdate is NULL")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 2")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 2"
            @remin.contents="立案号:#{c.case_code},提醒起草仲裁员回避决定草稿,【仲裁员回避中】输入【起草回避决定草稿时间】。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #5+2=7
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>7)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>6)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y'  and remind=1 and requestdate>='#{wwdd}' and requestdate<'#{wwdd2}' and draftingdate is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 3")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 3"
              @remin.contents="立案号:#{c.case_code},提醒起草仲裁员回避决定草稿,【仲裁员回避记录】中录入【起草回避决定草稿时间】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #输入起草回避决定草稿的时间。系统进行判断,如果2个工作后没有输入回避决定草稿完成时间中的草稿完成时间,则提醒助理。提醒后1个工作日仍未完成的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and draftingdate>='#{wwdd}' and draftingdate<'#{wwdd2}' and drafteddate is NULL")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 4")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 4"
            @remin.contents="立案号:#{c.case_code},提醒完成仲裁员回避决定草稿,【仲裁员回避记录】中录入【完成回避决定草稿时间】。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #2+1=3
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>3)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and draftingdate>='#{wwdd}'  and draftingdate<'#{wwdd2}' and drafteddate is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 5")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 5"
              @remin.contents="立案号:#{c.case_code},提醒【仲裁员回避记录】中录入【完成回避决定草稿】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #输入回避决定草稿完成时间。系统进行判断,如果5个工作后没有输入回避决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
#    if et_now.slice(0,10)>et_before.slice(0,10)
#      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>5)
#      wwdd=PubTool.new.get_last_record(wd).date
#      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>4)
#      wwdd2=PubTool.new.get_last_record(wd2).date
#      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and drafteddate>='#{wwdd}' and drafteddate<'#{wwdd2}' and  reporteddate is NULL")
#      if @te!=nil
#        for c in @te
#          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 6")==nil
#            @remin=Remind.new
#            @remin.used='Y'
#            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 6"
#            @remin.contents="立案号:#{c.case_code},提醒仲裁员回避决定上报总会,【仲裁员回避记录】中录入【回避决定上报总会时间】。"
#            @remin.dt1=Date.today
#            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
#              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
#            else
#              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
#            end
#            @remin.state=1
#            @remin.typ='0001'
#            @remin.u='system'
#            @remin.u_t=Time.now
#            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
#              @remin.save
#            end
#          end
#        end
#      end
#    end
    #5+2=7
#    if et_now.slice(0,10)>et_before.slice(0,10)
#      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>7)
#      wwdd=PubTool.new.get_last_record(wd).date
#      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>6)
#      wwdd2=PubTool.new.get_last_record(wd2).date
#      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and drafteddate>='#{wwdd}' and drafteddate<'#{wwdd2}' and reporteddate is NULL")
#      if @te!=nil
#        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
#        for c in @te
#          for ud in @ud
#            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 7")==nil
#              @remin=Remind.new
#              @remin.used='Y'
#              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 7"
#              @remin.contents="立案号:#{c.case_code},提醒仲裁员回避决定上报总会,【仲裁员回避记录】中录入【回避决定上报总会】。"
#              @remin.dt1=Date.today
#              @remin.uu=ud.user_code
#              @remin.state=1
#              @remin.typ='0001'
#              @remin.u='system'
#              @remin.u_t=Time.now
#              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
#                @remin.save
#              end
#            end
#          end
#        end
#      end
#    end
    #输入回避决定报总会时间。提醒程序结束。
#    if et_now.slice(0,10)>et_before.slice(0,10)
#      @te=TbEvite.find(:all,:conditions=>"used='Y' and reporteddate>='#{et_before.slice(0,10)}' and reporteddate<'#{et_now.slice(0,10)}'")
#      if @te!=nil
#        for c in @te
#          Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
#        end
#      end
#    end
    #不提醒。提醒程序结束。
    @tc=TbEvite.find(:all,:conditions=>"used='Y' and  remind=2 and remind_t>='#{et_before}' and remind_t<'#{et_now}'")
    for c in @tc
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
    end
#    #不提醒。提醒程序结束。
#    @tc=TbEvite.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
#    for c in @tc
#      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
#    end
  end

  #   管辖权异议相关的提醒
  #   1 在管辖权异议界面输入收到管辖权异议申请的日期。
  #   ——系统进行判断,如果5天后没有输入B中的起草管辖权决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
  #   2 输入起草管辖权决定草稿的时间。
  #   ——系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。
  #   3 输入管辖权决定草稿完成时间。
  #   ——系统进行判断,如果5天后没有输入D中的管辖权决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
  #   4 输入回避决定报总会时间。
  #   ——提醒程序结束。
  #
  #   在管辖权异议申请界面可以设置取消提醒功能,要求输入原因才能取消提醒并记录。request_date
  #   比如有些案子是当时就可以确定有管辖权的,在收到申请以后就答复当事人了,不需要进行下面的流程。
  def t_4(et_before,et_now)
    workday7 = Workday.before_day(7) # 今天前的第7个工作日
    workday6 = Workday.before_day(6) # 今天前的第6个工作日
    workday5 = Workday.before_day(5) # 今天前的第5个工作日
    workday4 = Workday.before_day(4) # 今天前的第4个工作日
    workday3 = Workday.before_day(3) # 今天前的第3个工作日
    workday2 = Workday.before_day(2) # 今天前的第2个工作日
    workday1 = Workday.before_day(1) # 今天前的第1个工作日

    do_remind = et_now.slice(0,10) > et_before.slice(0,10) # 一天只运行一次

    if do_remind
      te_request_54 = TbJurisdiction.find(:all,
        :conditions => "registrar<>'0002' and used='Y' and remind=1 and  request_date>='#{workday5}' and request_date< '#{workday4}' and idea_date is NULL"
      ) # 管辖权异议申请日期据现在 5 个工作日，此时还 未录入草稿起草日期（还未开始起草）
      

      te_request_76 = TbJurisdiction.find(:all,
        :conditions => "registrar<>'0002' and used='Y' and remind=1 and  request_date>='#{workday7}' and  request_date<'#{workday6}' and idea_date is NULL"
      ) # 管辖权异议申请日期据现在 7 个工作日，此时还 未录入草稿起草日期（还未开始起草）

      te_idea_21 = TbJurisdiction.find(
        :all, :conditions => "registrar<>'0002' and used='Y' and remind=1 and  idea_date>='#{workday2}' and  idea_date<'#{workday1}' and check_date is NULL"
      ) #起草草稿日期据现在 2个工作日， 此时还未录入草稿完成时间

      te_idea_32 = TbJurisdiction.find(
        :all, :conditions => "registrar<>'0002' and used='Y' and remind=1 and  idea_date>='#{workday3}' and  idea_date<'#{workday2}' and check_date is NULL"
      ) #  起草草稿日期据现在3个工作日 ， 此时还未录入草稿完成时间

#      te_check_54 = TbJurisdiction.find(:all,
#        :conditions => "used='Y' and remind=1 and  check_date>='#{workday5}' and  check_date<'#{workday4}' and draft_date is NULL"
#      ) #  草稿完成时间据现在 5个工作日，此时还未录入草稿报总会日期

#      te_check_76 = TbJurisdiction.find(:all,
#        :conditions => "used='Y' and remind=1 and  check_date>='#{workday7}' and  check_date<'#{workday6}' and draft_date is NULL"
#      ) # 草稿完成时间据现在 7个工作日，此时还未录入草稿报总会日期

      #具有处长职务的用户
      user_duty = UserDuty.find(:all,:conditions => "duty_code='0001'", :select => "distinct user_code",:order => "user_code")
      #15个工作日之后没输入决定完成时间的要提醒到助理和处长，之后每5个工作日提醒一次，提醒20次。
      (0..20).each{|n|
        w_start=Workday.before_day(15 + 5 * n)
        w_end=Workday.before_day(15 + 5 * n - 1)
        TbJurisdiction.find(:all, :conditions => "registrar<>'0002' and used='Y' and remind=1 and  request_date>='#{w_start}' and request_date< '#{w_end}' and decide_date is NULL").each{|c|
          current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk_2')
          current_party=""
          TbParty.find(:all,:conditions=>"recevice_code='#{c.recevice_code}' and partytype=1 and used='Y'",:order=>"id",:select=>"id,partyname").each{|p|
            current_party = current_party + p.partyname + " "
          }

          reason_id = "#{c.recevice_code} #{current_case.clerk} tb_jurisdictions-#{c.id} #{w_start}"
          if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
            remin= Remind.new
            remin.used      = 'Y'
            remin.reason_id = reason_id
            remin.contents  = "#{c.case_code}号案，助理：#{User.find_by_code(current_case.clerk).name}，申请人：#{current_party}，请填写管辖权决定作出日期。"
            remin.dt1       = Date.today
            remin.uu        = current_case.clerk
            remin.state     = 1
            remin.typ       = '0001'
            remin.u         = 'system'
            remin.u_t       = Time.now
            remin.save
          end
          for ud in user_duty
           reason_id = "#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} #{w_start}"
           if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
             remin           = Remind.new
             remin.used      = 'Y'
             remin.reason_id = reason_id
             remin.contents  = "#{c.case_code}号案，助理：#{User.find_by_code(current_case.clerk).name}，申请人：#{current_party}，请填写管辖权决定作出日期。"
             remin.dt1       = Date.today
             remin.uu        = ud.user_code
             remin.state     = 1
             remin.typ       = '0001'
             remin.u         = 'system'
             remin.u_t       = Time.now
             remin.save
           end
         end
        }
      }

      #记录录入当天提醒到处长
      TbJurisdiction.find(:all, :conditions => "registrar<>'0002' and u_t>='#{et_before.slice(0,10)} 00:00:00' and used='Y' and remind=1 ").each{|c|
         current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk_2')
         for ud in user_duty
           reason_id = "#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 100"
           if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
             remin           = Remind.new
             remin.used      = 'Y'
             remin.reason_id = reason_id
             request_date_ary = c.request_date.to_s(:db).split("-")
             remin.contents  = "#{c.case_code}号案，助理：#{User.find_by_code(current_case.clerk).name}，今天录入管辖权异议，管辖权异议提出日期：#{request_date_ary[0]}年#{request_date_ary[1]}月#{request_date_ary[2]}日。"
             remin.dt1       = Date.today
             remin.uu        = ud.user_code
             remin.state     = 1
             remin.typ       = '0001'
             remin.u         = 'system'
             remin.u_t       = Time.now
             remin.save
           end
         end
      }

      #管辖权异议申请日期据现在5个工作日，但任然没有输入起草管辖权决定草稿的时间,则提醒给助理。
      for c in te_request_54
        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk_2')
        reason_id = "#{c.recevice_code} #{current_case.clerk} tb_jurisdictions-#{c.id} 1"
        if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
          remin           = Remind.new
          remin.used      = 'Y'
          remin.reason_id = reason_id
          remin.contents  = "立案号:#{c.case_code},提醒起草管辖权决定草稿,【管辖权异议申请】中输入【起草草稿的时间】。"
          remin.dt1       = Date.today
          remin.uu        = current_case.clerk || current_case.clerk_2 #提醒给助理，如果没有助理，提醒给该案件的咨询助理。
          remin.state     = 1 #状态：未确认
          remin.typ       = '0001' #提醒类型：普通提醒
          remin.u         = 'system' #操作人：系统
          remin.u_t       = Time.now
          remin.save
        end
      end

      # 提醒后2个工作日仍未录入草稿起草日期的,提醒给处长
      for c in te_request_76
        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk')
        # 如果案件已经终止或者已经被存档，则不进行提醒。
        if current_case.state < 200  and current_case.stoped == 0
          for ud in user_duty
            reason_id = "#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 2"
            if Remind.find_by_reason_id(reason_id) == nil
              remin           = Remind.new
              remin.used      = 'Y'
              remin.reason_id = reason_id
              remin.contents  = "立案号:#{c.case_code},提醒起草管辖权决定草稿,【管辖权异议申请】中输入【起草草稿的时间】。办案助理:#{User.find_by_code(current_case.clerk).name}"
              remin.dt1       = Date.today
              remin.uu        = ud.user_code
              remin.state     = 1
              remin.typ       = '0001'
              remin.u         = 'system'
              remin.u_t       = Time.now
              remin.save
            end
          end
        end
      end

      #输入起草草稿的时间。如果2个工作日后没有 录入草稿完成时间,则提醒给助理。
      for c in te_idea_21
        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk_2')
        reason_id = "#{c.recevice_code} #{current_case.clerk} tb_jurisdictions-#{c.id} 3"
        if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
          remin           = Remind.new
          remin.used      = 'Y'
          remin.reason_id = reason_id
          remin.contents  = "立案号:#{c.case_code},提醒完成管辖权决定草稿,【管辖权异议申请】中输入【草稿完成时间】。办案助理:#{User.find_by_code(current_case.clerk).name}"
          remin.dt1       = Date.today
          remin.uu        = current_case.clerk || current_case.clerk_2
          remin.state     = 1
          remin.typ       = '0001'
          remin.u         = 'system'
          remin.u_t       = Time.now
          remin.save
        end
      end

      #提醒后1个工作日仍未录入草稿完成时间的,提醒给处长
      for c in te_idea_32
        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk')
        if current_case.state < 200  and current_case.stoped == 0
          for ud in user_duty
            reason_id = "#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 4"
            if Remind.find_by_reason_id(reason_id) == nil
              remin           = Remind.new
              remin.used      ='Y'
              remin.reason_id = reason_id
              remin.contents  = "立案号:#{c.case_code},提醒完成管辖权决定草稿,【管辖权异议申请】中输入【草稿完成时间】。办案助理:#{User.find_by_code(current_case.clerk).name}"
              remin.dt1       = Date.today
              remin.uu        = ud.user_code
              remin.state     = 1
              remin.typ       = '0001'
              remin.u         = 'system'
              remin.u_t       = Time.now
              remin.save
            end
          end
        end
      end

      #草稿完成时间距现在5个工作日，任然没有输入报总会时间,则提醒助理。
#      for c in te_check_54
#        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk2')
#        reason_id = "#{c.recevice_code} #{current_case.clerk} tb_jurisdictions-#{c.id} 5"
#        if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
#          remin           = Remind.new
#          remin.used      = 'Y'
#          remin.reason_id = reason_id
#          remin.contents  = "立案号:#{c.case_code},提醒管辖权异议草稿报总会,【管辖权异议申请】中输入【草稿报总会日期】。"
#          remin.dte1      = Date.today
#          remin.uu        = current_case.clerk || current_case.clerk_2
#          remin.state     = 1
#          remin.typ       = '0001'
#          remin.u         = 'system'
#          remin.u_t       = Time.now
#          remin.save
#        end
#      end

      #提醒后2个工作日，任然没有输入报总会时间,则提醒给处长。
#      for c in te_check_76
#        current_case = TbCase.find_by_recevice_code(c.recevice_code, :select => 'state,stoped,clerk,clerk2')
#        for ud in user_duty
#          reason_id = "#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 6"
#          if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
#            remin           = Remind.new
#            remin.used      = 'Y'
#            remin.reason_id = reason_id
#            remin.contents  = "立案号:#{c.case_code},提醒管辖权异议草稿报总会,【管辖权异议申请】中输入【草稿报总会日期】。办案助理:#{User.find_by_code(current_case.clerk).name}"
#            remin.dt1       = Date.today
#            remin.uu        = ud.user_code
#            remin.state     = 1
#            remin.typ       = '0001'
#            remin.u         = 'system'
#            remin.u_t       = Time.now
#            remin.save
#          end
#        end
#      end

      #输入回避决定报总会时间。提醒程序结束。
#      @te = TbJurisdiction.find(:all, :conditions => "used='Y' and draft_date>='#{et_before.slice(0,10)}' and draft_date<'#{et_now.slice(0,10)}'")
#      for c in @te
#        #Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
#      end
    end

    #对于状态为不提醒的，变更为提醒程序结束，used='N' 。
    tc = TbJurisdiction.find(:all, :conditions => "registrar<>'0002' and used='Y' and  remind=2 and remind_t>='#{et_before}' and remind_t<'#{et_now}'")
    for c in tc
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
    end

    #不提醒。提醒程序结束。
    tc = TbJurisdiction.find(:all,:conditions => "registrar<>'0002' and used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for c in tc
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
    end
    # 一点思考：
    # 这么做提醒的话，需要提醒服务每天都运行，这样才不会漏掉，
    #否则如果一个案件录入的异议申请日期是8个工作日之前的，那么就不会进行任何提醒了！！
  end

  #  开庭相关提醒
  #  说明：助理应在组庭后3个工作日内与仲裁庭联系商定开庭日期,并在开庭日期确定后1个工作日内发出开庭通知,3工作日后仍未确定开庭日期的,提醒到处长处。
  #  检查案件,组庭日期后3日内是否有开庭记录,如果没有开庭记录则要提醒到处长。开庭日期确定后1个工作日是发开庭通知的时间,要提醒助理。
  #  组庭日期后3日内是否有开庭记录,如果没有开庭记录则要提醒到处长
  def t_5(et_before,et_now)
    workday3 = Workday.before_day(3) # 今天前的第3个工作日
    workday2 = Workday.before_day(2) # 今天前的第2个工作日
    do_remind = et_now.slice(0,10) > et_before.slice(0,10) # 一天只运行一次

    if do_remind
      te = TbCaseorg.find(:all, :conditions => "used='Y' and orgdate>='#{workday3}' and orgdate<'#{workday2}'")
      ud = UserDuty.find(:all, :conditions => "duty_code='0001'", :select => "distinct user_code as user_code", :order => "user_code")

      # 如果超过组庭日期3个工作日内没有录入开庭信息则提醒给处长。
      for c in te
        current_case = TbCase.find_by_recevice_code(c.recevice_code)
        if TbSitting.find(:all, :conditions => "used='Y' and recevice_code='#{c.recevice_code}'").empty?
          for ud in ud
            reason_id = "#{c.recevice_code} #{ud.user_code} tb_caseorgs-#{c.id} 1"
            if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
              remin           = Remind.new
              remin.used      = 'Y'
              remin.reason_id = reason_id
              remin.contents  = "立案号:#{c.case_code},提醒开庭,确定开庭日期,录入【开庭信息】。办案助理:#{User.find_by_code(current_case.clerk).name}"
              remin.dt1       = Date.today
              remin.uu        = ud.user_code
              remin.state     = 1
              remin.typ       = '0001'
              remin.u         = 'system'
              remin.u_t       = Time.now
              remin.save
            end
          end
        end
      end
    end
    #开庭日期确定后1个工作日是发开庭通知的时间,要提醒助理。
    if do_remind
      te = TbSitting.find(:all, :conditions => "used='Y' and u_t>='#{et_before.slice(0,10)} 00:00:01' and u_t<'#{et_now.slice(0,10)} 00:00:01'")
      for c in te
        current_case = TbCase.find_by_recevice_code(c.recevice_code)
        flag = TbDoc.find(:all,
                  :conditions => "recevice_code='#{c.recevice_code}' and (typ_code='0026' or
                                  typ_code='0027' or typ_code='0030' or typ_code='0031' or
                                  typ_code='0032' or typ_code='0033' or typ_code='00271' or
                                  typ_code='002902' or typ_code='003102' )"
                ).empty?
        #or typ_code='002903' or typ_code='002904' or  typ_code='003101'  or typ_code='003103'
        if flag
          reason_id = "#{c.recevice_code} #{current_case.clerk} tb_sittings-#{c.id} 1"
          if current_case.state < 200  and current_case.stoped == 0 and Remind.find_by_reason_id(reason_id) == nil
            remin           = Remind.new
            remin.used      = 'Y'
            remin.reason_id = reason_id
            remin.contents  = "立案号：#{c.case_code},提醒发开庭通知,【发文】中发【开庭通知】。"
            remin.url       = "/case_doc/list?recevice_code=#{c.recevice_code}"
            remin.dt1       = Date.today
            remin.uu        = current_case.clerk.blank? current_case.clerk_2 || current_case.clerk
            remin.state     = 1
            remin.typ       = '0001'
            remin.u         = 'system'
            remin.u_t       = Time.now
            remin.save
          end
        end
      end
    end
  end

  def t_6(et_before,et_now_t,et_now)
    ### 6:决定审计、鉴定或评估的,仲裁助理在3个工作日内联系有关专业机构,如果仍未联系,则提醒到处长处。在收到有关专业机构的报价之日起10个工作日内商定仲裁庭,确定具体的专业机构和有关报价；10个工作日内仍未确定,提醒到处长处。
    #决定审计、鉴定或评估的,仲裁助理在3个工作日内联系有关专业机构,如果仍未联系,则提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>3)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbDetection.find(:all,:conditions=>"used='Y' and arbitral_decision_t>='#{wwdd}' and arbitral_decision_t<'#{wwdd2}' and contact_organization_t is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 1")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 1"
              @remin.contents="立案号:#{c.case_code},提醒联系检测机构,【检测信息记录】中填入【联系机构的时间】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #在收到有关专业机构的报价之日起10个工作日内商定仲裁庭,确定具体的专业机构和有关报价；10个工作日内仍未确定,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>10)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>9)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbDetection.find(:all,:conditions=>"used='Y' and organization_price_t>='#{wwdd}'  and organization_price_t<'#{wwdd2}' and definite_org_t is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 2")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 2"
              @remin.contents="立案号:#{c.case_code},提醒确定检测机构,【检测信息记录】中填入【确定机构时间】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
    #专业机构和报价确定后,仲裁助理在2个工作日内将有关情况报秘书处处长审批（如果未报审批则提醒助理）。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbDetection.find(:all,:conditions=>"used='Y' and definite_org_t>='#{wwdd}' and definite_org_t<'#{wwdd2}' and send_pproval_t is NULL")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_detections-#{c.id} 3")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_detections-#{c.id} 3"
            @remin.contents="立案号:#{c.case_code},提醒把检测有关情况报处长审批,【检测信息记录】中录入【送交审批时间】。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #在批准后2个工作日内将报价等事项书面通知有关当事人（如果未通知则提醒助理）。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbDetection.find(:all,:conditions=>"used='Y' and pproval_t>='#{wwdd}' and pproval_t<'#{wwdd2}'  and trans_party_t is NULL")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_detections-#{c.id} 4")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_detections-#{c.id} 4"
            @remin.contents="立案号:#{c.case_code},提醒将报价等事项书面通知有关当事人,【检测信息记录】中录入【转给当事人的时间】。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #在收到当事人预缴的全部费用后3个工作日内,仲裁助理应办妥分会与专业机构之间签订委托协议书的事宜（是否就是签约）,3个工作日内仍未签约的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>3)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbDetection.find(:all,:conditions=>"used='Y' and fees_received_t>='#{wwdd}' and fees_received_t<'#{wwdd2}'  and agency_contract_t is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 5")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_detections-#{c.id} 5"
              @remin.contents="立案号:#{c.case_code},提醒与检测机构签约,【检测信息记录】中录入【和机构签约时间】。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
                @remin.save
              end
            end
          end
        end
      end
    end
  end

  def t_7(et_before,et_now_t,et_now)
    ### 7:开庭中仲裁庭使用信息中新建和删除的时候进行提示前台，订房信息新建和删除时候提示前台,案件合议中案件庭使用信息中新建和删除的时候进行提示前台，
    ### 仲裁庭开庭使用情况提醒到前台
    #判断新建的仲裁庭开庭使用情况
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0001' and used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te.empty? != true
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 1"
            arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
            @remin.contents="立案号:#{c.case_code},增加了仲裁庭使用信息,#{arbitroom_info}。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    #判断删除的仲裁庭开庭使用情况

    @tm=TbArbitroom.find(:all,:conditions=>"usestyle='0001' and used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for c in @tm
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for ud in @ud
        if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 7")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 7"
          arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
          庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
          <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
          时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
          @remin.contents="立案号:#{c.case_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
          @remin.dt1=Date.today
          @remin.uu=ud.user_code
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          if TbCase.find_by_recevice_code(c.recevice_code).state<200
            @remin.save
          end
        end
      end
    end

    ### 合议庭合议使用情况，提醒到前台。
    #判断合议庭的新建情况
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0002' and used='Y'  and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te.empty? !=true
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 4")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 4"
            arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
            @remin.contents="立案号:#{c.case_code},增加了仲裁庭使用信息,#{arbitroom_info}。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    #判断合议庭的删除情况
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0002' and used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te.empty? != true
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 5")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 5"
            arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
            @remin.contents="立案号:#{c.case_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    ### 仲裁员预订酒店的情况提醒到前台
    # 判断订房信息新建记录
    @te=TbArbithotel.find(:all,:conditions=>"state='0003' and usestyle='0001' and used='Y'  and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te.empty? != true
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbithotels-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbithotels-#{c.id} 1"
            info="预订人:#{User.find_by_code(c.u).name}<br>仲裁员:#{TbArbitman.find_by_code(c.arbitman).name}<br>入住日期:#{c.usedate}<br>房间数量:#{c.rooms}<br>住宿天数:#{c.days}<br>详细信息:#{c.descript}"
            @remin.contents="立案号:#{c.case_code},增加了订房信息,#{info}。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    # 判断订房信息删除记录
    @te=TbArbithotel.find(:all,:conditions=>"state='0003' and usestyle='0001' and used='N'  and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te.empty? != true
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbithotels-#{c.id} 2")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbithotels-#{c.id} 2"
            info="预订人:#{User.find_by_code(c.u).name}<br>仲裁员:#{TbArbitman.find_by_code(c.arbitman).name}<br>入住日期:#{c.usedate}<br>房间数量:#{c.rooms}<br>住宿天数:#{c.days}<br>详细信息:#{c.descript}"
            @remin.contents="立案号:#{c.case_code},减少了订房信息,#{info}。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end


  end

  def t_8(et_before,et_now_t,et_now)
    ### 8: 审限到期前,系统提醒助理作出裁决。1个月,15天,5天,3天
    #提前1个月提醒
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_30=et_now_t.months_since(1).to_date.to_s(:db)
      @te=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and caseendbook_id_first is null and finally_limit_dat='#{limit_date_30}'",:select=>"id,recevice_code,case_code")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 1"
            @remin.contents="立案号:#{c.case_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},请确认实际开支费用相关信息录入完成，并作出裁决。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).caseendbook_id_first==nil   and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #提前15天提醒
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_15=et_now_t.since(3600 * 24 * 15).to_date.to_s(:db)
      @te=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and caseendbook_id_first is null  and finally_limit_dat='#{limit_date_15}'",:select=>"id,recevice_code,case_code")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 2")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 2"
            @remin.contents="立案号:#{c.case_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},请确认实际开支费用相关信息录入完成，并作出裁决。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).caseendbook_id_first==nil  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #提前5天提醒
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_5=et_now_t.since(3600 * 24 * 5).to_date.to_s(:db)
      @te=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and caseendbook_id_first is null  and finally_limit_dat='#{limit_date_5}'",:select=>"id,recevice_code,case_code")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 3")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 3"
            @remin.contents="立案号:#{c.case_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒作出裁决。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).caseendbook_id_first==nil  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
    #提前3天提醒
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_3=et_now_t.since(3600 * 24 * 3).to_date.to_s(:db)
      @te=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and state<100 and caseendbook_id_first is null  and finally_limit_dat='#{limit_date_3}'",:select=>"id,recevice_code,case_code")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 4")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_cases-finally_limit_dat-#{c.id} #{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s()} 4"
            @remin.contents="立案号:#{c.case_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒作出裁决。"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).caseendbook_id_first==nil  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
        end
      end
    end
  end

  def t_10(et_before,et_now_t,et_now)
    ### 10: 当支出超过收入,即结余为负数时,需要提醒补收费用。每天只提醒一次（提醒到助理）
    #t_10(et_before,et_now_t,et_now)
    #代收代支费用支出
    @te=TbExpendDetail.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'",:select=>"id,case_code,recevice_code")
    if @te!=nil
      for c in @te
        condi="dt1='#{Date.today.to_s}' and ( (reason_id like '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends%') )"
        should_charge=PubTool.new.get_first_record(TbShouldCharge.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_charges where used='Y' and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_charge==nil
          should_charge=0
        else
          should_charge=should_charge.re_rmb_money
        end
        if should_charge==nil
          should_charge=0
        end

        should_refund=PubTool.new.get_first_record(TbShouldRefund.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_refunds where used='Y' and state=2 and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_refund==nil
          should_refund=0
        else
          should_refund=should_refund.re_rmb_money
        end
        if should_refund==nil
          should_refund=0
        end

        expend_detail=PubTool.new.get_first_record(TbExpendDetail.find_by_sql("select sum(rmb_money) as rmb_money from tb_expend_details where used='Y' and recevice_code='#{c.recevice_code}'"))
        if expend_detail==nil
          expend_detail=0
        else
          expend_detail=expend_detail.rmb_money
        end
        if expend_detail==nil
          expend_detail=0
        end

        arbitman_spend=PubTool.new.get_first_record(TbArbitmanSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitman_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitman_spend==nil
          arbitman_spend=0
        else
          arbitman_spend=arbitman_spend.rmb_money
        end
        if arbitman_spend==nil
          arbitman_spend=0
        end

        arbitcourt_spend=PubTool.new.get_first_record(TbArbitcourtSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitcourt_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        else
          arbitcourt_spend=arbitcourt_spend.rmb_money
        end
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        end

        other_spends=PubTool.new.get_first_record(TbOtherSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_other_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if other_spends==nil
          other_spends=0
        else
          other_spends=other_spends.rmb_money
        end
        if other_spends==nil
          other_spends=0
        end

        cre=should_charge - should_refund - expend_detail - arbitman_spend - arbitcourt_spend - other_spends

        if cre<0
          if Remind.find(:all,:conditions=>condi).empty? and Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    #仲裁员费用支出

    @te=TbArbitmanSpend.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'",:select=>"id,case_code,recevice_code")
    if @te!=nil
      for c in @te
        condi="dt1='#{Date.today.to_s}' and ( (reason_id like '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends%') )"
        should_charge=PubTool.new.get_first_record(TbShouldCharge.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_charges where used='Y' and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_charge==nil
          should_charge=0
        else
          should_charge=should_charge.re_rmb_money
        end
        if should_charge==nil
          should_charge=0
        end

        should_refund=PubTool.new.get_first_record(TbShouldRefund.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_refunds where used='Y' and state=2 and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_refund==nil
          should_refund=0
        else
          should_refund=should_refund.re_rmb_money
        end
        if should_refund==nil
          should_refund=0
        end

        expend_detail=PubTool.new.get_first_record(TbExpendDetail.find_by_sql("select sum(rmb_money) as rmb_money from tb_expend_details where used='Y' and recevice_code='#{c.recevice_code}'"))
        if expend_detail==nil
          expend_detail=0
        else
          expend_detail=expend_detail.rmb_money
        end
        if expend_detail==nil
          expend_detail=0
        end

        arbitman_spend=PubTool.new.get_first_record(TbArbitmanSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitman_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitman_spend==nil
          arbitman_spend=0
        else
          arbitman_spend=arbitman_spend.rmb_money
        end
        if arbitman_spend==nil
          arbitman_spend=0
        end

        arbitcourt_spend=PubTool.new.get_first_record(TbArbitcourtSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitcourt_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        else
          arbitcourt_spend=arbitcourt_spend.rmb_money
        end
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        end

        other_spends=PubTool.new.get_first_record(TbOtherSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_other_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if other_spends==nil
          other_spends=0
        else
          other_spends=other_spends.rmb_money
        end
        if other_spends==nil
          other_spends=0
        end

        cre=should_charge - should_refund - expend_detail - arbitman_spend - arbitcourt_spend - other_spends

        if cre<0
          if Remind.find(:all,:conditions=>condi).empty? and Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    #仲裁庭费用支出

    @te=TbArbitcourtSpend.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'",:select=>"id,case_code,recevice_code")
    if @te!=nil
      for c in @te
        condi="dt1='#{Date.today.to_s}' and ( (reason_id like '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends%') )"
        should_charge=PubTool.new.get_first_record(TbShouldCharge.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_charges where used='Y' and typ<>'0001' and typ<>'0002' and typ<>'0003'  and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_charge==nil
          should_charge=0
        else
          should_charge=should_charge.re_rmb_money
        end
        if should_charge==nil
          should_charge=0
        end

        should_refund=PubTool.new.get_first_record(TbShouldRefund.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_refunds where used='Y' and state=2 and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}'"))
        if should_refund==nil
          should_refund=0
        else
          should_refund=should_refund.re_rmb_money
        end
        if should_refund==nil
          should_refund=0
        end

        expend_detail=PubTool.new.get_first_record(TbExpendDetail.find_by_sql("select sum(rmb_money) as rmb_money from tb_expend_details where used='Y' and recevice_code='#{c.recevice_code}'"))
        if expend_detail==nil
          expend_detail=0
        else
          expend_detail=expend_detail.rmb_money
        end
        if expend_detail==nil
          expend_detail=0
        end

        arbitman_spend=PubTool.new.get_first_record(TbArbitmanSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitman_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitman_spend==nil
          arbitman_spend=0
        else
          arbitman_spend=arbitman_spend.rmb_money
        end
        if arbitman_spend==nil
          arbitman_spend=0
        end

        arbitcourt_spend=PubTool.new.get_first_record(TbArbitcourtSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitcourt_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        else
          arbitcourt_spend=arbitcourt_spend.rmb_money
        end
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        end

        other_spends=PubTool.new.get_first_record(TbOtherSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_other_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if other_spends==nil
          other_spends=0
        else
          other_spends=other_spends.rmb_money
        end
        if other_spends==nil
          other_spends=0
        end

        cre=should_charge - should_refund - expend_detail - arbitman_spend - arbitcourt_spend - other_spends

        if cre<0
          if Remind.find(:all,:conditions=>condi).empty? and Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end

    #其它费用支出

    @te=TbOtherSpend.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'",:select=>"id,case_code,recevice_code")
    if @te!=nil
      for c in @te
        condi="dt1='#{Date.today.to_s}' and ( (reason_id like '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_expend_details%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitman_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_arbitcourt_spends%') or (reason_id like  '#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends%') )"
        should_charge=PubTool.new.get_first_record(TbShouldCharge.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_charges where used='Y' and typ<>'0001' and typ<>'0002' and typ<>'0003' and  typ<>'0004' and typ<>'0005' and typ<>'0006'  and recevice_code='#{c.recevice_code}'"))
        if should_charge==nil
          should_charge=0
        else
          should_charge=should_charge.re_rmb_money
        end
        if should_charge==nil
          should_charge=0
        end

        should_refund=PubTool.new.get_first_record(TbShouldRefund.find_by_sql("select sum(re_rmb_money) as re_rmb_money from tb_should_refunds where used='Y' and state=2 and typ<>'0001' and typ<>'0002' and typ<>'0003'  and  typ<>'0004' and typ<>'0005' and typ<>'0006'  and recevice_code='#{c.recevice_code}'"))
        if should_refund==nil
          should_refund=0
        else
          should_refund=should_refund.re_rmb_money
        end
        if should_refund==nil
          should_refund=0
        end

        expend_detail=PubTool.new.get_first_record(TbExpendDetail.find_by_sql("select sum(rmb_money) as rmb_money from tb_expend_details where used='Y' and recevice_code='#{c.recevice_code}'"))
        if expend_detail==nil
          expend_detail=0
        else
          expend_detail=expend_detail.rmb_money
        end
        if expend_detail==nil
          expend_detail=0
        end

        arbitman_spend=PubTool.new.get_first_record(TbArbitmanSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitman_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitman_spend==nil
          arbitman_spend=0
        else
          arbitman_spend=arbitman_spend.rmb_money
        end
        if arbitman_spend==nil
          arbitman_spend=0
        end

        arbitcourt_spend=PubTool.new.get_first_record(TbArbitcourtSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_arbitcourt_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        else
          arbitcourt_spend=arbitcourt_spend.rmb_money
        end
        if arbitcourt_spend==nil
          arbitcourt_spend=0
        end

        other_spends=PubTool.new.get_first_record(TbOtherSpend.find_by_sql("select sum(rmb_money) as rmb_money from tb_other_spends where used='Y' and recevice_code='#{c.recevice_code}'"))
        if other_spends==nil
          other_spends=0
        else
          other_spends=other_spends.rmb_money
        end
        if other_spends==nil
          other_spends=0
        end

        cre=should_charge - should_refund - expend_detail - arbitman_spend - arbitcourt_spend - other_spends

        if cre<0
          if Remind.find(:all,:conditions=>condi).empty? and Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_other_spends-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end
  end

  def t_9(et_before,et_now_t,et_now)
    ### 9: 校核人员指定后,直接提醒校核人员进行校核评价
    @te=TbCheckStaff.find(:all,:conditions=>"used='Y' and typ='0001' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      for c in @te
        if Remind.find_by_reason_id("#{c.recevice_code} #{c.staff} tb_check_staffs-#{c.id} 1")==nil
          case_1=TbCase.find_by_recevice_code(c.recevice_code)
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="#{c.recevice_code} #{c.staff} tb_check_staffs-#{c.id} 1"
          @remin.contents="立案号:#{c.case_code},请输入校核评价信息。办案助理:#{User.find_by_code(case_1.clerk).name}。"
          @remin.url="/award_judge/judge_list?recevice_code=#{c.recevice_code}"
          @remin.dt1=Date.today
          @remin.uu=c.staff
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          if TbCase.find_by_recevice_code(c.recevice_code).state<200
            @remin.save
          end
        end
      end
    end
  end

  def t_11(et_before,et_now_t,et_now)
    ### 11: 退费申请经助理输入后,报秘书处长审批,审批后信息到出纳工作提醒中。
    @te=TbShouldRefund.find(:all,:conditions=>"used='Y' and state=4 and check2_dt>='#{et_before}' and check2_dt<'#{et_now}' and check_dt is NULL")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0004'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_should_refunds-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_should_refunds-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},新增退费信息,请确认。"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200
              @remin.save
            end
          end
        end
      end
    end
  end

  def t_12(et_before,et_now_t,et_now)
    ### 12: 开庭前2个工作日,提示助理,短信通知的仲裁员。生成开庭短信提醒（仲裁员，当事人，代理人）
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date>'#{et_now.slice(0,10)}'",:order=>"date asc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date>'#{et_now.slice(0,10)}'",:order=>"date asc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbSitting.find(:all,:conditions=>"used='Y' and sittingdate>'#{wwdd2}' and sittingdate<='#{wwdd}'")
      if @te!=nil
        for c in @te
          sitting=c
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 2")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 2"
            @remin.contents="立案号:#{c.case_code},两个工作日后开庭,提醒短信通知仲裁员。"
            @remin.url="/sms_alert2/list?recevice_code=#{c.recevice_code}"
            @remin.dt1=Date.today
            if TbCase.find_by_recevice_code(c.recevice_code).clerk!=''
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk
            else
              @remin.uu=TbCase.find_by_recevice_code(c.recevice_code).clerk_2
            end
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
              @remin.save
            end
          end
          ####################################################################################
          clerk=TbCase.find_by_recevice_code(sitting.recevice_code).clerk
          ### 短信至仲裁员
          @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-%'")
          if @sms_a.empty?
            @ca=TbCasearbitman.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
            for ca in @ca
              content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
              if TbSmsAlert.find_by_content_id(content_id)==nil
                @sms=TbSmsAlert.new
                @sms.used='Y'
                @sms.typ='0002'
                @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
                @sms.p_typ="0001"
                @sms.p=ca.arbitman
                @sms.p_name=TbArbitman.find_by_code(ca.arbitman).name
                @sms.mobiletel=TbArbitman.find_by_code(ca.arbitman).mobiletel
                if sitting.add_typ=='0001'
                  zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                end
                @sms.contents=contents
                @sms.send_state=100
                @sms.c_t=Time.now()
                if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
                  @sms.save
                end
              end
            end
          end

          ### 短信至当事人
          @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-%'")
          if @sms_a.empty?
            @ca=TbParty.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
            for ca in @ca
              content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
              if TbSmsAlert.find_by_content_id(content_id)==nil
                @sms=TbSmsAlert.new
                @sms.used='Y'
                @sms.typ='0002'
                @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
                @sms.p_typ="0005"
                @sms.p=ca.id.to_s
                @sms.p_name=ca.partyname
                @sms.mobiletel=ca.mobiletel
                if sitting.add_typ=='0001'
                  zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                end
                @sms.contents=contents
                @sms.send_state=100
                @sms.c_t=Time.now()
                if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
                  @sms.save
                end
              end
            end
          end

          ### 短信至代理人
          @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-%'")
          if @sms_a.empty?
            @ca=TbAgent.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
            for ca in @ca
              content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
              if TbSmsAlert.find_by_content_id(content_id)==nil
                @sms=TbSmsAlert.new
                @sms.used='Y'
                @sms.typ='0002'
                @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
                @sms.p_typ="0006"
                @sms.p=ca.id.to_s
                @sms.p_name=ca.name
                @sms.mobiletel=ca.mobiletel
                if sitting.add_typ=='0001'
                  zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                end
                @sms.contents=contents
                @sms.send_state=100
                @sms.c_t=Time.now()
                if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
                  @sms.save
                end
              end
            end
          end
          ####################################################################################
        end
      end
    end
  end

  def t_13(et_before,et_now_t,et_now)
    ### 发文报批后立刻提示审批人进行审批
    @te=TbDocApproval.find(:all,:conditions=>"(state=0 or state=-1) and call_t>='#{et_before}' and call_t<'#{et_now}' ")
    if @te!=nil
      for c in @te
        if Remind.find_by_reason_id("#{c.recevice_code} #{c.a_u} tb_doc_approvals-#{c.id} 1")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="#{c.recevice_code} #{c.a_u} tb_doc_approvals-#{c.id} 1"
          @remin.contents="提醒审批发文。立案号:#{TbCase.find_by_recevice_code(c.recevice_code).case_code},文件流水号:#{c.file_code},发文编号:#{c.send_code},申请人:#{User.find_by_code(c.call_u).name}。"
          @remin.dt1=Date.today
          @remin.uu=c.a_u
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          if TbCase.find_by_recevice_code(c.recevice_code).state<200  and TbCase.find_by_recevice_code(c.recevice_code).stoped==0
            @remin.save
          end
        end
      end
    end
  end

  def t_14(et_before,et_now_t,et_now)
    ### 出纳收款后提醒助理进行确认
    @te=TbCharge.find(:all,:conditions=>"used='Y' and state=1 and typ='a' and u_t>='#{et_before}' and u_t<'#{et_now}' ")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0003' or duty_code='0004' ",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{ud.user_code} tb_charges-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{ud.user_code} tb_charges-#{c.id} 1"
            contents="新增收款信息。收款号:#{c.code},付款人名称:#{c.p},付款时间:#{c.c_dt.to_s(:db)},金额:￥#{c.rmb_money}。"
            @ccc=TbShouldCharge.find_by_sql("select distinct tb_cases.case_code as case_code,tb_cases.recevice_code as recevice_code,tb_cases.state as state,tb_cases.clerk as clerk,tb_cases.clerk_2 as clerk_2 from tb_should_charges,tb_cases where tb_cases.state>=1 and tb_cases.state<100 and tb_cases.state<>3 and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y' and tb_cases.used='Y' and tb_should_charges.typ<>'0002' and tb_should_charges.typ<>'0003' and tb_should_charges.typ<>'0005' and tb_should_charges.typ<>'0006' and tb_should_charges.re_rmb_money=0 and (tb_should_charges.rmb_money - tb_should_charges.redu_rmb_money)=#{c.rmb_money} order by tb_cases.recevice_code")
            if not @ccc.empty?
              contents=contents + "<br/>与以下案件应收款信息基本相符:<br/>"
            end
            for ccc in @ccc
              @case = TbCase.find_by_recevice_code(ccc.recevice_code)
              if  (@case.state<4 && @case.state!=1 ) || (@case.state==1 && (Date.today - @case.receivedate > 210)) || (@case.state>=4 && (Date.today - @case.accepttime > 210))
              else
                contents=contents + "立案号:#{ccc.case_code},"
                contents=contents + "咨询流水号:#{ccc.recevice_code},"
                if ccc.clerk!='' and ccc.clerk!=nil
                  contents=contents + "办案助理:#{User.find_by_code(ccc.clerk).name}。"
                elsif ccc.clerk_2!='' and ccc.clerk_2!=nil
                  contents=contents + "咨询助理:#{User.find_by_code(ccc.clerk_2).name}。"
                end
              end
            end
            @remin.contents=contents
            @remin.url="/charge_correspondence/charge_list"
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
        end
      end
    end
  end

  def t_15(et_before,et_now_t,et_now)
    ### 助理确认收款明细后,提醒出纳
    @te=TbChargeCorr.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}' ")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0004'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{ud.user_code} tb_charge_corrs-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{ud.user_code} tb_charge_corrs-#{c.id} 1"
            tsc=TbShouldCharge.find(c.should_charge_id)
            tc=TbCharge.find(c.charge_id)
            contents="收款记录对应信息如下:<br/>"
            contents=contents+"收款号:#{tc.code}"
            if tc.typ=='c'
              contents=contents + "(拆分)"
            end
            contents=contents + ",付款人名称:#{tc.p},金额:￥#{tc.rmb_money}"
            if tc.typ=='c'
              contents=contents + "(拆分)"
            end
            contents=contents+"。<br/>"
            contents=contents+"立案号:#{tsc.case_code},咨询流水号:#{tsc.recevice_code},收款类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0031' and data_val='#{tsc.typ}'").data_text}"
            @remin.contents=contents
            @remin.dt1=Date.today
            @remin.uu=ud.user_code
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
        end
      end
    end
  end

  def t_16(et_before,et_now_t,et_now)
    ### 助理确认收款明细到【案件收费】后,检查案件是否已经立案,如果未立案则提醒到处长,
    @te=TbChargeCorr.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}' ")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te
        for ud in @ud
          if Remind.find_by_reason_id("#{ud.user_code} tb_charge_corrs-#{c.id} 2")==nil
            tsc=TbShouldCharge.find(c.should_charge_id)
            #tc=TbCharge.find(c.charge_id)
            case_1=TbCase.find_by_recevice_code(tsc.recevice_code)
            if (tsc.typ=='0001' or tsc.typ=='0004') and case_1.state==1
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{ud.user_code} tb_charge_corrs-#{c.id} 2"
              contents="立案提醒。案件咨询流水号:#{tsc.recevice_code}。"
              if case_1.clerk!='' and case_1.clerk!=nil
                contents=contents + "办案助理:#{User.find_by_code(case_1.clerk).name}。"
              elsif case_1.clerk_2!='' and case_1.clerk_2!=nil
                contents=contents + "咨询助理:#{User.find_by_code(case_1.clerk_2).name}。"
              end
              contents=contents+"应收案件收费:￥#{tsc.rmb_money}。"
              contents=contents+"实收:￥#{tsc.re_rmb_money}。"
              @remin.contents=contents
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              @remin.save
            end
          end
        end
      end
    end
  end

  def t_17(et_before,et_now_t,et_now)
    ### 发开庭通知的时候，判断是否有欠缴费用，如果有则提醒
    @te=TbDoc.find(:all,:conditions=>"used='Y' and (typ_code='0026' or typ_code='0027' or typ_code='0030' or typ_code='0031' or typ_code='0032' or typ_code='0033') and t>='#{et_before}' and t<'#{et_now}' ")
    if @te!=nil
      for c in @te
        if Remind.find_by_reason_id("#{c.recevice_code} #{c.u} tb_docs-#{c.id} 1")==nil
          ccc=TbShouldCharge.count(:conditions=>"used='Y' and recevice_code='#{c.recevice_code}'")
          sss=TbShouldCharge.count(:conditions=>"used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006' and recevice_code='#{c.recevice_code}' and (rmb_money  - redu_rmb_money - re_rmb_money)>0")
          if (ccc==nil or ccc==0) or (sss!=nil and sss!=0)
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{c.u} tb_docs-#{c.id} 1"
            if ccc==nil or ccc==0
              contents="交费提醒，立案号:#{TbCase.find_by_recevice_code(c.recevice_code).case_code},咨询流水号:#{c.recevice_code},已经创建开庭通知书，但是还没有交费记录。"
            elsif sss!=nil and sss!=0
              contents="交费提醒，立案号:#{TbCase.find_by_recevice_code(c.recevice_code).case_code},咨询流水号:#{c.recevice_code},已经创建开庭通知书，但是还有欠缴费用未交。"
            end
            @remin.contents=contents
            @remin.dt1=Date.today
            @remin.uu=c.u
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
        end
      end
    end
  end

  def t_18(et_before,et_now_t,et_now)
    ### 每年年初去修改仲裁员的年龄
    if et_now.slice(0,4)>et_before.slice(0,4)
      @arbit=TbArbitman.find(:all,:order=>"id")
      for arb in @arbit
        arb.age=Time.now.year-arb.birthday.year
        arb.save
      end
    end
  end

  def t_19(et_before,et_now_t,et_now)

    ### 立案后提醒到出纳，某发票号已对应到案件
    @case=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and nowdate_t>='#{et_before}' and nowdate_t<'#{et_now}'",:order=>"nowdate_t")
    @ud=UserDuty.find(:all,:conditions=>"duty_code='0004'",:select=>"distinct user_code as user_code",:order=>"user_code")
    for c in @case
      for ud in @ud
        if Remind.find_by_reason_id("case_nowdate_t #{ud.user_code} #{c.recevice_code} #{c.nowdate_t.to_s(:db)}")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="case_nowdate_t #{ud.user_code} #{c.recevice_code} #{c.nowdate_t.to_s(:db)}"
          @charge=TbCharge.find(:all,:conditions=>"used='Y' and typ<>'c' and recevice_code='#{c.recevice_code}'",:order=>"code")
          ccc=''
          for ch in @charge
            ccc="发票号:" + ch.code + "  "
          end
          @remin.contents=ccc + "，立案号为:#{c.case_code}"
          @remin.dt1=Date.today
          @remin.uu=ud.user_code
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          if TbCase.find_by_recevice_code(c.recevice_code).state<200
            @remin.save
          end
        end
      end
    end

  end

  def t_20(et_before,et_now_t,et_now)

    ### 立案后提醒到处长，提醒处长有案件立案，办案助理是谁
    @case=TbCase.find(:all,:conditions=>"used='Y' and state>=4 and nowdate_t>='#{et_before}' and nowdate_t<'#{et_now}'",:order=>"nowdate_t")
    @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
    for c in @case
      for ud in @ud
        if Remind.find_by_reason_id("cz case_nowdate_t #{ud.user_code} #{c.recevice_code} #{c.nowdate_t.to_s(:db)}")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="cz case_nowdate_t #{ud.user_code} #{c.recevice_code} #{c.nowdate_t.to_s(:db)}"
          @remin.contents="已立案提醒，立案号为:#{c.case_code}，办案助理:#{User.find_by_code(c.clerk).name},咨询流水号:#{c.recevice_code}"
          @remin.dt1=Date.today
          @remin.uu=ud.user_code
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          if TbCase.find_by_recevice_code(c.recevice_code).state<200
            @remin.save
          end
        end
      end
    end

  end

  def t_21(et_before,et_now_t,et_now)
    ### 21: 删除一年前的提醒信息
    limit_date_360=et_now_t.months_ago(12).to_date.to_s(:db)
    if et_now.slice(0,10)>et_before.slice(0,10)
      Remind.delete_all("dt1<'#{limit_date_360}'")
    end
  end

  def t_22(et_before,et_now_t,et_now)
    ### 22: 案件结案后，半年后，提示填写执行情况
    if et_now.slice(0,10)>et_before.slice(0,10)
      #limit_date_180=et_now_t.months_ago(6).to_date.to_s(:db)
      limit_date=et_now_t.to_date - SysArg.find_by_code('1011').val.to_i
      limit_date=limit_date.to_s(:db)
      @endbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and decideDate='#{limit_date}'")
      for endbook in @endbook
        @case=TbCase.find_by_recevice_code(endbook.recevice_code)
        if @case.runstyle==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="zl caseendbook #{@case.clerk} #{@case.recevice_code}"
          @remin.contents="立案号为:#{@case.case_code}，请填写执行情况"
          @remin.url="/case_p/select_3/#{@case.id}?act_r=show_implement&contr_r=wind_up_case"
          @remin.dt1=Date.today
          @remin.uu=@case.clerk
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          @remin.save
        end
      end
    end
  end

  def t_23(et_before,et_now_t,et_now)
    ### 生成短信提醒信息，提醒开庭信息(仲裁员、当事人、代理人)
    #1：检查开庭记录
    @sitting=TbSitting.find(:all,:conditions=>"used='Y'  and u_t>='#{et_before}' and u_t<'#{et_now}'",:order=>"u_t")
    for sitting in @sitting
      clerk=TbCase.find_by_recevice_code(sitting.recevice_code).clerk
      ### 短信至仲裁员
      @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-%'")
      if @sms_a.empty?
        @ca=TbCasearbitman.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
        for ca in @ca
          content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
          if TbSmsAlert.find_by_content_id(content_id)==nil
            @sms=TbSmsAlert.new
            @sms.used='Y'
            @sms.typ='0002'
            @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
            @sms.p_typ="0001"
            @sms.p=ca.arbitman
            @sms.p_name=TbArbitman.find_by_code(ca.arbitman).name
            @sms.mobiletel=TbArbitman.find_by_code(ca.arbitman).mobiletel
            if sitting.add_typ=='0001'
              zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            end
            @sms.contents=contents
            @sms.send_state=100
            @sms.c_t=Time.now()
            if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
              @sms.save
            end
          end
        end
      end

      ### 短信至当事人
      @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-%'")
      if @sms_a.empty?
        @ca=TbParty.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
        for ca in @ca
          content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
          if TbSmsAlert.find_by_content_id(content_id)==nil
            @sms=TbSmsAlert.new
            @sms.used='Y'
            @sms.typ='0002'
            @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
            @sms.p_typ="0005"
            @sms.p=ca.id.to_s
            @sms.p_name=ca.partyname
            @sms.mobiletel=ca.mobiletel
            if sitting.add_typ=='0001'
              zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            end
            @sms.contents=contents
            @sms.send_state=100
            @sms.c_t=Time.now()
            if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
              @sms.save
            end
          end
        end
      end

      ### 短信至代理人
      @sms_a=TbSmsAlert.find(:all,:conditions=>"used='Y' and content_id like '%-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-%'")
      if @sms_a.empty?
        @ca=TbAgent.find(:all,:conditions=>"used='Y' and recevice_code='#{sitting.recevice_code}'")
        for ca in @ca
          content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
          if TbSmsAlert.find_by_content_id(content_id)==nil
            @sms=TbSmsAlert.new
            @sms.used='Y'
            @sms.typ='0002'
            @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
            @sms.p_typ="0006"
            @sms.p=ca.id.to_s
            @sms.p_name=ca.name
            @sms.mobiletel=ca.mobiletel
            if sitting.add_typ=='0001'
              zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            end
            @sms.contents=contents
            @sms.send_state=100
            @sms.c_t=Time.now()
            if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
              @sms.save
            end
          end
        end
      end

    end
    #2：检查仲裁员分配记录
    @ca=TbCasearbitman.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for ca in @ca
      sitting=TbSitting.find(:first,:conditions=>"used='Y' and recevice_code='#{ca.recevice_code}'",:order=>"sittingdate desc")
      if sitting!=nil
        clerk=TbCase.find_by_recevice_code(sitting.recevice_code).clerk
        content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
        if TbSmsAlert.find_by_content_id(content_id)==nil
          @sms=TbSmsAlert.new
          @sms.used='Y'
          @sms.typ='0002'
          @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0001-arbitman-#{ca.arbitman}"
          @sms.p_typ="0001"
          @sms.p=ca.arbitman
          @sms.p_name=TbArbitman.find_by_code(ca.arbitman).name
          @sms.mobiletel=TbArbitman.find_by_code(ca.arbitman).mobiletel
          if sitting.add_typ=='0001'
            zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          else
            ktd=""
            if sitting.area_code!='' and sitting.area_code!=nil
              ktd=Region.find_by_code(sitting.area_code).name
            end
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          end
          @sms.contents=contents
          @sms.send_state=100
          @sms.c_t=Time.now()
          if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
            @sms.save
          end
        end
      end
    end
    #3：检查当事人信息
    @ca=TbParty.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for ca in @ca
      sitting=TbSitting.find(:first,:conditions=>"used='Y' and recevice_code='#{ca.recevice_code}'",:order=>"sittingdate desc")
      if sitting!=nil
        clerk=TbCase.find_by_recevice_code(sitting.recevice_code).clerk
        content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
        if TbSmsAlert.find_by_content_id(content_id)==nil
          @sms=TbSmsAlert.new
          @sms.used='Y'
          @sms.typ='0002'
          @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0005-party-#{ca.id}"
          @sms.p_typ="0005"
          @sms.p=ca.id.to_s
          @sms.p_name=ca.partyname
          @sms.mobiletel=ca.mobiletel
          if sitting.add_typ=='0001'
            zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          else
            ktd=""
            if sitting.area_code!='' and sitting.area_code!=nil
              ktd=Region.find_by_code(sitting.area_code).name
            end
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          end
          @sms.contents=contents
          @sms.send_state=100
          @sms.c_t=Time.now()
          if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
            @sms.save
          end
        end
      end
    end
    #4：检查代理人信息
    @ca=TbAgent.find(:all,:conditions=>"used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for ca in @ca
      sitting=TbSitting.find(:first,:conditions=>"used='Y' and recevice_code='#{ca.recevice_code}'",:order=>"sittingdate desc")
      if sitting!=nil
        clerk=TbCase.find_by_recevice_code(sitting.recevice_code).clerk
        content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
        if TbSmsAlert.find_by_content_id(content_id)==nil
          @sms=TbSmsAlert.new
          @sms.used='Y'
          @sms.typ='0002'
          @sms.content_id="#{clerk}-sitting-#{sitting.recevice_code}-#{sitting.id}-0006-agent-#{ca.id}"
          @sms.p_typ="0006"
          @sms.p=ca.id.to_s
          @sms.p_name=ca.name
          @sms.mobiletel=ca.mobiletel
          if sitting.add_typ=='0001'
            zct=TbDictionary.find(:first,:conditions=>"typ_code='0023'  and  data_val='#{sitting.sittingplace}'").data_text
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          else
            ktd=""
            if sitting.area_code!='' and sitting.area_code!=nil
              ktd=Region.find_by_code(sitting.area_code).name
            end
            contents="华南国际经济贸易仲裁委员会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          end
          @sms.contents=contents
          @sms.send_state=100
          @sms.c_t=Time.now()
          if TbCase.find_by_recevice_code(sitting.recevice_code).state<200
            @sms.save
          end
        end
      end
    end

  end

  def t_24(et_before,et_now_t,et_now)
    ### 24:每天检查前一天操作的结案记录（以操作时间为准），结案的裁决或撤案是否已经上传了裁决书或者撤案书。如果没有上传，则提醒到制作裁决者（创建该案件结案信息的人）。
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_1=et_now_t.ago(3600 * 24 * 1).to_date.to_s(:db)
      @endbook=TbCaseendbook.find(:all,:conditions=>"used='Y' and u_t>='#{limit_date_1} 00:00:01' and u_t<='#{limit_date_1} 23:59:59'")
      for endbook in @endbook
        @case_book=CaseBook.find(:all,:conditions=>"used='Y' and typ='0002' and recevice_code='#{endbook.recevice_code}'")
        if @case_book.empty?
          if Remind.find_by_reason_id("caseendbook #{endbook.u} #{endbook.recevice_code} #{endbook.id} case_book")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="caseendbook #{endbook.u} #{endbook.recevice_code} #{endbook.id} case_book"
            @remin.contents="立案号为:#{endbook.case_code}，请上传裁决书或者撤案书"
            @remin.url=""
            @remin.dt1=Date.today
            @remin.uu=endbook.u
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
        end
      end
    end
  end


  # 仲裁员人案统计
  def t_25()
    ### 25:每天生成仲裁员人案统计表
    et_now=Time.now.to_s(:db)
    ReportArbitmanCase.delete_all()
    @arbitman_case = VArbitmanCase.find(:all, :conditions=>"code is not null", :group=>"code",:order=>"code")
    for c in @arbitman_case
      @arbitmancase=ReportArbitmanCase.new()
      @arbitmancase.tim=et_now
      @arbitmancase.code=c.code
      @arbitmancase.name=c.name

      # 在办案件数量
      a1 = TbCase.find_by_sql("select count(distinct(c.recevice_code)) as cn from tb_cases as c,tb_casearbitmen as ca where c.used='Y' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.recevice_code=ca.recevice_code and ca.used='Y' and ca.arbitman='#{c.code}'")
      @arbitmancase.a1=SysArg.get_first_record(a1).cn
      
      #已结案件数量
      a2 = VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as n_l",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null",c.code])
      @arbitmancase.a2 = a2.blank? ? 0 : a2.n_l.to_i

      # 性别、手机、电话、传真
      @arbitmancase.sex       = c.sex
      @arbitmancase.mobiletel = c.mobiletel
      @arbitmancase.telh      = c.telh
      @arbitmancase.fax       = c.fax

      @arbitmancase.special   = c.special
      @arbitmancase.city      = c.city

      #  仲裁员评价（助理评价）
      sc = TbEvaluate.find_by_sql("
        select sum(e.score) as scores,count(distinct e.recevice_code) as e_n
        from tb_evaluates as e,tb_cases as c
        where e.used='Y' and e.arbitman='#{c.code}' and
              e.recevice_code=c.recevice_code and c.used='Y' and
              c.state>=4 and c.caseendbook_id_first is not null"
      )
      sc_1 = sc.first.scores   # 仲裁员评价 所有案件的总分
      sc_2 = sc.first.e_n.to_i # 仲裁员评价 所有案件的数量
      if !sc_1.blank? and sc_2 != 0
        @arbitmancase.score = (sc_1.to_i.to_f + sc_2*100)/sc_2
      end
      
      #校核评价
      sc2 = TbAwardJudge.find_by_sql("
        SELECT avg(score)AS scores, recevice_code
        FROM 	tb_award_judges
        WHERE used = 'Y' AND (arbitman1='#{c.code}' or arbitman2='#{c.code}' or arbitman3='#{c.code}')
        GROUP BY recevice_code
      ")

      sc_1 = 0
      sc_2 = sc2.size
      sc2.each do |s|
        sc_1 = sc_1 + s.scores.to_f
      end
      if sc_1 != nil and sc_2 != 0
        @arbitmancase.score2 = sc_1.to_f/sc_2
      end
      
      #已结案件中，担任首席/独任的总数（A类) #################################
      a_a=VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as nl",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null and (arbitmantype='0001' or arbitmantype='0002')",c.code])
      if a_a!=nil
        a_a=a_a.nl
      else
        a_a=0
      end
      @arbitmancase.a_a=a_a
      j_ad=0
      #A类：起草裁决书的数量
      award=TbAwardDetail.find_by_sql("select count(distinct(a.recevice_code)) as ac from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{c.code}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0001' or cc.arbitmantype='0002')")
      for awa in award
        if awa!=nil
          @arbitmancase.a_b=awa.ac
          j_ad=j_ad + awa.ac.to_i
        end
      end
      #A类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4
           and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0001' or tb_casearbitmen.arbitmantype='0002')")
      for d in delays
        if d!=nil
          @arbitmancase.a_c=d.ac
        end
      end
      #A类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:select=>"count(distinct(e.recevice_code)) as ad",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0001' or va.arbitmantype='0002')",:conditions=>["e.used='Y' and e.arbitman=?",c.code])
      if tb_evalate!=nil
        @arbitmancase.a_d=tb_evalate.ad
      end
      #A类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{c.code}' and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.a_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end
      #B类    ###################################
      b_a=VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as nl",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null and (arbitmantype='0003' or arbitmantype='0004')",c.code])
      if b_a!=nil
        b_a=b_a.nl
      else
        b_a=0
      end
      @arbitmancase.b_a=b_a
      #B类：起草裁决书的数量
      award=TbAwardDetail.find_by_sql("select count(a.recevice_code) as ac from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{c.code}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0003' or cc.arbitmantype='0004')")
      for awa2 in award
        if awa2!=nil
          @arbitmancase.b_b=awa2.ac
          j_ad=j_ad + awa2.ac.to_i
        end
      end
      @arbitmancase.ad=j_ad
      #B类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4 and tb_cases.caseendbook_id_first is not null
          and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0003' or tb_casearbitmen.arbitmantype='0004')")
      for d_1 in delays
        if d_1!=nil
          @arbitmancase.b_c=d_1.ac
        end
      end
      #B类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:select=>"count(distinct(e.recevice_code)) as ad",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0003' or va.arbitmantype='0004')",:conditions=>["e.used='Y' and e.arbitman=?",c.code])
      if tb_evalate!=nil
        @arbitmancase.b_d=tb_evalate.ad
      end
      #B类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{c.code}' and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.b_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end

      @arbitmancase.save
    end
  end

  #被TbArbitman模型调用
  def t_25_by_arbitman(code)
    puts "t_25_by_arbitman start #{Time.now.to_s(:db)}"
    et_now=Time.now.to_s(:db)
    ReportArbitmanCase.delete_all("code='#{code}'")
    @arbitman_case = VArbitmanCase.find(:all, :conditions=>"code='#{code}'" ,:group=>"code",:order=>"code")
    for c in @arbitman_case
      @arbitmancase=ReportArbitmanCase.new()
      @arbitmancase.tim=et_now
      @arbitmancase.code=c.code
      @arbitmancase.name=c.name

      # 在办案件数量
      a1 = TbCase.find_by_sql("select count(distinct(c.recevice_code)) as cn from tb_cases as c,tb_casearbitmen as ca where c.used='Y' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.recevice_code=ca.recevice_code and ca.used='Y' and ca.arbitman='#{c.code}'")
      @arbitmancase.a1=SysArg.get_first_record(a1).cn

      #已结案件数量
      a2 = VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as n_l",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null",c.code])
      @arbitmancase.a2 = a2.blank? ? 0 : a2.n_l.to_i

      # 性别、手机、电话、传真
      @arbitmancase.sex       = c.sex
      @arbitmancase.mobiletel = c.mobiletel
      @arbitmancase.telh      = c.telh
      @arbitmancase.fax       = c.fax

      @arbitmancase.special = c.special
      @arbitmancase.city = c.city
      
      #  仲裁员评价（助理评价）
      sc = TbEvaluate.find_by_sql("
        select sum(e.score) as scores,count(distinct e.recevice_code) as e_n
        from tb_evaluates as e,tb_cases as c
        where e.used='Y' and e.arbitman='#{c.code}' and
              e.recevice_code=c.recevice_code and c.used='Y' and
              c.state>=4 and c.caseendbook_id_first is not null"
      )
      sc_1 = sc.first.scores   # 仲裁员评价 所有案件的总分
      sc_2 = sc.first.e_n.to_i # 仲裁员评价 所有案件的数量
      if !sc_1.blank? and sc_2 != 0
        @arbitmancase.score = (sc_1.to_i.to_f + sc_2*100)/sc_2
      end

      #校核评价
      sc2 = TbAwardJudge.find_by_sql("
        SELECT avg(score)AS scores, recevice_code
        FROM 	tb_award_judges
        WHERE used = 'Y' AND (arbitman1='#{c.code}' or arbitman2='#{c.code}' or arbitman3='#{c.code}')
        GROUP BY recevice_code
      ")

      sc_1 = 0
      sc_2 = sc2.size
      sc2.each do |s|
        sc_1 = sc_1 + s.scores.to_f
      end
      if sc_1 != nil and sc_2 != 0
        @arbitmancase.score2 = sc_1.to_f/sc_2
      end

      #已结案件中，担任首席/独任的总数（A类) #################################
      a_a=VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as nl",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null and (arbitmantype='0001' or arbitmantype='0002')",c.code])
      if a_a!=nil
        a_a=a_a.nl
      else
        a_a=0
      end
      @arbitmancase.a_a=a_a
      j_ad=0
      #A类：起草裁决书的数量
      award=TbAwardDetail.find_by_sql("select count(distinct(a.recevice_code)) as ac from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{c.code}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0001' or cc.arbitmantype='0002')")
      for awa in award
        if awa!=nil
          @arbitmancase.a_b=awa.ac
          j_ad=j_ad + awa.ac.to_i
        end
      end
      #A类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4
           and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0001' or tb_casearbitmen.arbitmantype='0002')")
      for d in delays
        if d!=nil
          @arbitmancase.a_c=d.ac
        end
      end
      #A类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:select=>"count(distinct(e.recevice_code)) as ad",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0001' or va.arbitmantype='0002')",:conditions=>["e.used='Y' and e.arbitman=?",c.code])
      if tb_evalate!=nil
        @arbitmancase.a_d=tb_evalate.ad
      end
      #A类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{c.code}' and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.a_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end
      #B类    ###################################
      b_a=VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as nl",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null and (arbitmantype='0003' or arbitmantype='0004')",c.code])
      if b_a!=nil
        b_a=b_a.nl
      else
        b_a=0
      end
      @arbitmancase.b_a=b_a
      #B类：起草裁决书的数量
      award=TbAwardDetail.find_by_sql("select count(a.recevice_code) as ac from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{c.code}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0003' or cc.arbitmantype='0004')")
      for awa2 in award
        if awa2!=nil
          @arbitmancase.b_b=awa2.ac
          j_ad=j_ad + awa2.ac.to_i
        end
      end
      @arbitmancase.ad=j_ad
      #B类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4 and tb_cases.caseendbook_id_first is not null
          and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0003' or tb_casearbitmen.arbitmantype='0004')")
      for d_1 in delays
        if d_1!=nil
          @arbitmancase.b_c=d_1.ac
        end
      end
      #B类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:select=>"count(distinct(e.recevice_code)) as ad",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0003' or va.arbitmantype='0004')",:conditions=>["e.used='Y' and e.arbitman=?",c.code])
      if tb_evalate!=nil
        @arbitmancase.b_d=tb_evalate.ad
      end
      #B类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{c.code}' and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.b_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end

      @arbitmancase.save
    end
    puts "t_25_by_arbitman end  #{Time.now.to_s(:db)}"
  end


#  t_25_by_recevice_code被以下模型调用
#  tb_casearbitmen
#  TbEvaluate
#  TbAwardJudge
#  tb_award_details
#  tb_awards
#  tb_casedelays
#  tb_caseendbook
  def t_25_by_recevice_code(recevice_code)
    puts "t_25_by_recevice_code start #{Time.now.to_s(:db)}"
    et_now=Time.now.to_s(:db)
    @arbitman_case = VArbitmanCaseAll.find(:all, :conditions=>"recevice_code='#{recevice_code}' and code is not null" ,:group=>"code",:order=>"code")
    for c in @arbitman_case
      ReportArbitmanCase.delete_all("code='#{c.code}'")
      t_25_by_arbitman(c.code)
    end
    puts "t_25_by_recevice_code end #{Time.now.to_s(:db)}"
  end

  def t_26(et_before,et_now_t,et_now)
    ### 26:每天检查咨询记录，把咨询有效期小于今天的咨询记录设置为历史咨询记录。
    if et_now.slice(0,10)>et_before.slice(0,10)
      @case=TbCase.find(:all,:conditions=>"used='Y' and state=1 and recevice_code_limit_dat<'#{et_now.slice(0,10)}'")
      for c in @case
        if c.state==1
          f=TbCaseFlow.add_flow(c.recevice_code,'0002')
          if f!=0
            c.state=f
          end
        end
        c.save
      end
    end
  end

  def t_27(et_before,et_now_t,et_now)
    ### 27:检查对应到案件的费用是否被对应到明细了，如果没对应则提醒到助理。
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_1=et_now_t.ago(3600 * 24 * 1).to_date.to_s(:db)
      @charge=TbCharge.find(:all,:conditions=>"used='Y' and (typ='a' or typ='c') and state='2' and should_id=0 and check_dt>='#{limit_date_1} 00:00:01' and check_dt<='#{limit_date_1} 23:59:59'")
      for charge in @charge
        @case=TbCase.find_by_recevice_code(charge.recevice_code)
        if @case.clerk!=""
          clerk=@case.clerk
        else
          clerk=@case.clerk_2
        end
        if Remind.find_by_reason_id("charge #{clerk} #{charge.recevice_code} #{charge.id} 1")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="charge #{clerk} #{charge.recevice_code} #{charge.id} 1"
          @remin.contents="立案号为:#{charge.case_code}，咨询流水号为：#{charge.recevice_code}，有一个金额为#{charge.rmb_money}RMB的收费记录未对应到明细，请进行明细对应。"
          @remin.url="/charge_correspondence_detail/list?recevice_code=#{charge.recevice_code}"
          @remin.dt1=Date.today
          @remin.uu=clerk
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          @remin.save
        end
      end
    end
  end

  def t_28(et_before,et_now_t,et_now)
    ### 立案后未组庭案件15,20,30天提醒助理，45,60,90,120天提醒助理和处长。
    ### 立案后未组庭案件15,20,30天提醒助理
    do_remind = et_now.slice(0,10) > et_before.slice(0,10) # 一天只运行一次
    if do_remind
      ### 立案后未组庭案件15,20,30天提醒助理
      @case = TbCase.find(:all, :select => 'recevice_code,case_code,nowdate,clerk',:conditions=>"state=4 and caseorg_id_first is null and caseendbook_id_first is null and (nowdate='#{et_now_t.ago(3600 * 24 * 15).to_date.to_s(:db)}' or nowdate='#{et_now_t.ago(3600 * 24 * 20).to_date.to_s(:db)}' or nowdate='#{et_now_t.ago(3600 * 24 * 30).to_date.to_s(:db)}')")
      for c in @case
        @remin = Remind.new
        @remin.used = 'Y'
        @remin.reason_id = "#{c.recevice_code} #{c.clerk} zctz #{et_now.slice(0,10)}"
        @remin.contents = "#{c.case_code}案(申请人:#{get_party_1(c.recevice_code)})，助理:#{User.find_by_code(c.clerk).name},尚未组庭。如需延期提醒，请使用[确定延期]功能。"
        @remin.dt1 = Date.today
        @remin.uu = c.clerk
        @remin.state = 1
        @remin.typ = '0001'
        @remin.u = 'system'
        @remin.u_t = Time.now
        @remin.save
      end

      ### 立案后未组庭案件45,60,90,120天提醒助理和处长。
      @case = TbCase.find(:all, :select => 'recevice_code,case_code,nowdate,clerk',:conditions=>"state=4 and caseorg_id_first is null and caseendbook_id_first is null and (nowdate='#{et_now_t.ago(3600 * 24 * 45).to_date.to_s(:db)}' or nowdate='#{et_now_t.ago(3600 * 24 * 60).to_date.to_s(:db)}' or nowdate='#{et_now_t.ago(3600 * 24 * 90).to_date.to_s(:db)}' or nowdate='#{et_now_t.ago(3600 * 24 * 120).to_date.to_s(:db)}')")
      for c in @case
        @remin = Remind.new
        @remin.used = 'Y'
        @remin.reason_id = "#{c.recevice_code} #{c.clerk} zctz #{et_now.slice(0,10)}"
        @remin.contents = "#{c.case_code}案(申请人:#{get_party_1(c.recevice_code)})，助理:#{User.find_by_code(c.clerk).name},尚未组庭。如需延期提醒，请使用[确定延期]功能。"
        @remin.dt1 = Date.today
        @remin.uu = c.clerk
        @remin.state = 1
        @remin.typ = '0001'
        @remin.u = 'system'
        @remin.u_t = Time.now
        @remin.save

        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for ud in @ud
          @remin = Remind.new
          @remin.used = 'Y'
          @remin.reason_id = "#{c.recevice_code} #{ud.user_code} zctz #{et_now.slice(0,10)}"
          @remin.contents = "#{c.case_code}案(申请人:#{get_party_1(c.recevice_code)})，助理:#{User.find_by_code(c.clerk).name},尚未组庭。如需延期提醒，请使用[确定延期]功能。"
          @remin.dt1 = Date.today
          @remin.uu = ud.user_code
          @remin.state = 1
          @remin.typ = '0001'
          @remin.u = 'system'
          @remin.u_t = Time.now
          @remin.save
        end
      end
    end
  end

  def t_29(et_before,et_now_t,et_now)
    ### 29:结案10天后提醒助理该案件未归档,20天提醒到处长。
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_1=et_now_t.ago(3600 * 24 * 10).to_date.to_s(:db)
      @end_book=TbCaseendbook.find(:all,:conditions=>"used='Y' and decideDate='#{limit_date_1}'")
      for end_book in @end_book
        @case=TbCase.find_by_recevice_code(end_book.recevice_code)
        if @case.clerk!=""
          clerk=@case.clerk
        else
          clerk=@case.clerk_2
        end
        if @case.file_receive_u.blank?
          if Remind.find_by_reason_id("caseendbook29 #{clerk} #{end_book.recevice_code} #{end_book.id} 10")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="caseendbook29 #{clerk} #{end_book.recevice_code} #{end_book.id} 10"
            @remin.contents="#{@case.case_code}案，已于#{end_book.decideDate}结案,结案已经10天,请助理#{User.find_by_code(@case.clerk).name}提交案卷."
            @remin.url=""
            @remin.dt1=Date.today
            @remin.uu=clerk
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
        end
      end

      n=80
      while n>1
        limit_date=et_now_t.ago(3600 * 24 * 10  * n).to_date.to_s(:db)
        @end_book=TbCaseendbook.find(:all,:conditions=>"used='Y' and decideDate='#{limit_date}'")
        for end_book in @end_book
          @case=TbCase.find_by_recevice_code(end_book.recevice_code)
          if @case.clerk!=""
            clerk=@case.clerk
          else
            clerk=@case.clerk_2
          end
          if @case.file_receive_u.blank?
            if Remind.find_by_reason_id("caseendbook29 #{clerk} #{end_book.recevice_code} #{end_book.id} #{10*n}")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="caseendbook29 #{clerk} #{end_book.recevice_code} #{end_book.id} #{10*n}"
              @remin.contents="#{@case.case_code}案，已于#{end_book.decideDate}结案,结案已经#{10 * n}天,请助理#{User.find_by_code(@case.clerk).name}提交案卷."
              @remin.url=""
              @remin.dt1=Date.today
              @remin.uu=clerk
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              @remin.save
            end
=begin
            @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
            for ud in @ud
              if Remind.find_by_reason_id("caseendbook29 #{ud.user_code} #{end_book.recevice_code} #{end_book.id} #{10*n}")==nil
                @remin=Remind.new
                @remin.used='Y'
                @remin.reason_id="caseendbook29 #{ud.user_code} #{end_book.recevice_code} #{end_book.id} #{10*n}"
                @remin.contents="#{@case.case_code}案，已于#{end_book.decideDate}结案,结案已经#{10 * n}天,请助理#{User.find_by_code(@case.clerk).name}提交案卷."
                @remin.url=""
                @remin.dt1=Date.today
                @remin.uu=ud.user_code
                @remin.state=1
                @remin.typ='0001'
                @remin.u='system'
                @remin.u_t=Time.now
                @remin.save
              end
            end
=end
          end
          
        end
        n= n - 1
      end
    end
  end

  def t_30(et_before,et_now_t,et_now)
    ### 30:对咨询案件，在创建咨询案件2天后，发出提醒给咨询案件的接待助理.
    if et_now.slice(0,10)>et_before.slice(0,10)
      limit_date_1=et_now_t.ago(3600 * 24 * 2).to_date.to_s(:db)
      @case = TbCase.find(:all,:conditions=>"used='Y' and state=1 and receivedate='#{limit_date_1}'")
      for c in @case
        if c.clerk_2!=""
          clerk=c.clerk_2
        else
          clerk=c.clerk
        end
        party = TbParty.find_by_recevice_code_and_used_and_partytype(c.recevice_code,"Y",1)
        r = Remind.find_by_reason_id("case30 #{clerk} #{c.recevice_code} #{c.id}")
        unless r
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="case30 #{clerk} #{c.recevice_code} #{c.id}"
          @remin.contents="申请人：#{party.partyname if party}案，请确认已经向申请人发出受理通知。咨询接待助理：#{User.find_by_code(clerk).name}."
          @remin.url=""
          @remin.dt1=Date.today
          @remin.uu=clerk
          @remin.state=1
          @remin.typ='0001'
          @remin.u='system'
          @remin.u_t=Time.now
          @remin.save
        end
      end
    end
  end

  def t_31(et_before,et_now_t,et_now)
    ### 31:提醒增加：“XXX案，已于yyyy-mm-dd结案，结案已经XX天,请助理XXX提交材料报秘书处长核发仲裁员报酬。”同时提醒给助理和处长。检查设置：与2）的条件相同，即：2013-11-1之后结案（包括撤案）的、存在仲裁员的、结案后10天没有“处长确认日期”的案件，进行提醒。之后每5个工作日检查提醒一次，直到条件消失。
    if et_now.slice(0,10)>et_before.slice(0,10)
      @end_book=TbCaseendbook.find(:all,:conditions=>"decideDate>'2013-11-01' and used='Y' and recevice_code in (select recevice_code from tb_cases where remun_state='N' and state>=4  and state < 150) and mod(datediff('#{et_now}',decideDate),5)=0")
      for end_book in @end_book
        if TbCasearbitman.find_by_recevice_code_and_used(end_book.recevice_code,'Y')
          @case=TbCase.find_by_recevice_code(end_book.recevice_code)
          if @case.clerk!=""
            clerk=@case.clerk
          else
            clerk=@case.clerk_2
          end
          ttt= et_now_t.to_date - end_book.decideDate
          if Remind.find_by_reason_id("caseendbook31 #{clerk} #{end_book.recevice_code} #{end_book.id} #{ttt}")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="caseendbook31 #{clerk} #{end_book.recevice_code} #{end_book.id} #{ttt}"
            @remin.contents="#{@case.case_code}案，已#{end_book.decideDate.to_s(:db)}已结案，结案已经#{ttt}天,请助理#{User.find_by_code(@case.clerk).name}提交材料报秘书处长核发仲裁员报酬。"
            @remin.url=""
            @remin.dt1=Date.today
            @remin.uu=clerk
            @remin.state=1
            @remin.typ='0001'
            @remin.u='system'
            @remin.u_t=Time.now
            @remin.save
          end
=begin
          @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
          for ud in @ud
            if Remind.find_by_reason_id("caseendbook31 #{ud.user_code} #{end_book.recevice_code} #{end_book.id} #{ttt}")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="caseendbook31 #{ud.user_code} #{end_book.recevice_code} #{end_book.id} #{ttt}"
              @remin.contents="#{@case.case_code}案，已#{end_book.decideDate.to_s(:db)}已结案，结案已经#{ttt}天,请助理#{User.find_by_code(@case.clerk).name}提交材料报秘书处长核发仲裁员报酬。"
              @remin.url=""
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              @remin.save
            end
          end
=end
        end
      end
    end
  end

  def t_32(et_before,et_now_t,et_now)
    @mes=PartyMessage.find(:all,:conditions=>"used='Y'  and party_t>='#{et_before}' and party_t<'#{et_now}'",:order=>"party_t")
    for mes in @mes
      @case = TbCase.find_by_recevice_code(mes.recevice_code)
      ### 短信至仲裁员
      if Remind.find_by_reason_id("party_message #{@case.clerk} #{@mes.id}")==nil
        @remin=Remind.new
        @remin.used='Y'
        @remin.reason_id="party_message #{@case.clerk} #{@mes.id}"
        @remin.contents="#{@case.case_code}号案件有当事方留言，留言人：#{WUser.find_by_code(mes.party).name}，留言内容：#{mes.message}。"
        @remin.url=""
        @remin.dt1=Date.today
        @remin.uu=@case.clerk
        @remin.state=1
        @remin.typ='0001'
        @remin.u='system'
        @remin.u_t=Time.now
        @remin.save
      end
    end
  end

  def t_101(et_before,et_now_t,et_now)
    if et_now.slice(0,10)>et_before.slice(0,10)
      jrdb = Jrdb::Jrdb.new
      req_evaluate_1 = Jrdb::ReqPacket.new
      req_evaluate_1.from = "evaluate"
      req_evaluate_1.select = "'party_to_arbitman_1' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_1 = Array.new
      con_1 << "category='party_to_arbitman_1' and used='Y'"
      req_evaluate_1.group = "recevice_code,u,user_code"
      req_evaluate_1.conditions = con_1
      @res_evaluate_1 = jrdb.find_all(req_evaluate_1)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_2 = Jrdb::ReqPacket.new
      req_evaluate_2.from = "evaluate"
      req_evaluate_2.select = "'party_to_arbitman_2' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_2 = Array.new
      con_2 << "category='party_to_arbitman_2' and used='Y'"
      req_evaluate_2.group = "recevice_code,u,user_code"
      req_evaluate_2.conditions = con_2
      @res_evaluate_2 = jrdb.find_all(req_evaluate_2)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_3 = Jrdb::ReqPacket.new
      req_evaluate_3.from = "evaluate"
      req_evaluate_3.select = "'arbitman_to_arbitman' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_3 = Array.new
      con_3 << "category='arbitman_to_arbitman' and used='Y'"
      req_evaluate_3.group = "recevice_code,u,user_code"
      req_evaluate_3.conditions = con_3
      @res_evaluate_3 = jrdb.find_all(req_evaluate_3)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_4 = Jrdb::ReqPacket.new
      req_evaluate_4.from = "evaluate"
      req_evaluate_4.select = "'assistant_to_arbitman' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_4 = Array.new
      con_4 << "category='assistant_to_arbitman' and used='Y'"
      req_evaluate_4.group = "recevice_code,u,user_code"
      req_evaluate_4.conditions = con_4
      @res_evaluate_4 = jrdb.find_all(req_evaluate_4)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_5 = Jrdb::ReqPacket.new
      req_evaluate_5.from = "evaluate"
      req_evaluate_5.select = "'arbitman_to_assistant' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_5 = Array.new
      con_5 << "category='arbitman_to_assistant' and used='Y'"
      req_evaluate_5.group = "recevice_code,u,user_code"
      req_evaluate_5.conditions = con_5
      @res_evaluate_5 = jrdb.find_all(req_evaluate_5)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_6 = Jrdb::ReqPacket.new
      req_evaluate_6.from = "evaluate"
      req_evaluate_6.select = "'party_to_assistant_1' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_6 = Array.new
      con_6 << "category='party_to_assistant_1' and used='Y'"
      req_evaluate_6.group = "recevice_code,u,user_code"
      req_evaluate_6.conditions = con_6
      @res_evaluate_6 = jrdb.find_all(req_evaluate_6)

      jrdb = Jrdb::Jrdb.new
      req_evaluate_7 = Jrdb::ReqPacket.new
      req_evaluate_7.from = "evaluate"
      req_evaluate_7.select = "'party_to_assistant_2' as category,recevice_code,u,user_code,sum(score) as score_sum "
      con_7 = Array.new
      con_7 << "category='party_to_assistant_2' and used='Y'"
      req_evaluate_7.group = "recevice_code,u,user_code"
      req_evaluate_7.conditions = con_7
      @res_evaluate_7 = jrdb.find_all(req_evaluate_7)

      jrdb = Jrdb::Jrdb.new
      req_train_sum = Jrdb::ReqPacket.new
      req_train_sum.from = "train,train_reg"
      req_train_sum.select = "YEAR(train.do_date) as do_year,train_reg.user_type as user_type,train_reg.user as user,sum(train_reg.score) as score_sum"
      con_train_sum = Array.new
      con_train_sum << "train.active='1' and train.status=1 and train_reg.used='Y' and train.id=train_reg.train_id"
      req_train_sum.group = "train_reg.user_type,train_reg.user,YEAR(train.do_date)"
      req_train_sum.conditions = con_train_sum
      @res_train_sum = jrdb.find_all(req_train_sum)

      if @res_evaluate_1.status == "1" && @res_evaluate_2.status == "1" && @res_evaluate_3.status == "1" && @res_evaluate_4.status == "1" && @res_evaluate_5.status == "1" && @res_evaluate_6.status == "1" && @res_evaluate_7.status == "1" && @res_train_sum.status == "1"
        EvaluateSum.delete_all("1=1")
        if @res_evaluate_1.dataset.size!="0"
          for r in @res_evaluate_1.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_2.dataset.size!="0"
          for r in @res_evaluate_2.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_3.dataset.size!="0"
          for r in @res_evaluate_3.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_4.dataset.size!="0"
          for r in @res_evaluate_4.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_5.dataset.size!="0"
          for r in @res_evaluate_5.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_6.dataset.size!="0"
          for r in @res_evaluate_6.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        if @res_evaluate_7.dataset.size!="0"
          for r in @res_evaluate_7.dataset.rows
            e_sum = EvaluateSum.new
            e_sum.category = r.get_data("category")
            e_sum.recevice_code = r.get_data("recevice_code")
            e_sum.u = r.get_data("u")
            e_sum.user_code = r.get_data("user_code")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

        TrainSum.delete_all("1=1")
        if @res_train_sum.dataset.size!="0"
          for r in @res_train_sum.dataset.rows
            e_sum = TrainSum.new
            e_sum.do_year = r.get_data("do_year")
            e_sum.user_type = r.get_data("user_type")
            e_sum.user = r.get_data("user")
            e_sum.score_sum = r.get_data("score_sum")
            e_sum.t = Time.now
            e_sum.save
          end
        end

      end   
      
    end
  end

  def t_800()
    @ttt = TbShouldRefund.find(:all, :conditions=>"used='Y' and state=1 and a_state=0 and TIMESTAMPDIFF(DAY, u_t, now())>365")
    @ttt.each{|c|
      c.a_state = 1
      c.save
    }
  end

  def t_911(et_before,et_now_t,et_now)
    ### 备份数据库
    if et_now.slice(0,10)>et_before.slice(0,10)
      system "/usr/bin/mysqldump --skip-opt -q --create-options -R -uroot -proot zc > /usr/local/zc_database_bak/zc_#{et_now.slice(0,10)}.sql"
      del_e=et_now_t.ago(3600 * 24 * 7).to_date.to_s(:db)
      if del_e.slice(8,2)=='01'
      else
        File.open("/usr/local/zc_database_bak/zc_#{del_e}.sql","w+"){}
        File.delete("/usr/local/zc_database_bak/zc_#{del_e}.sql")
      end
    end
  end

=begin
  #2015年3月27日增加
  #结案后，助理填写了仲裁员报酬的，直接提醒处长发报酬。
  def t_33(et_before,et_now)
    #1:收费被助理确认以后,直接提醒处长指定一名助理办案
    #直接提醒处长指定一名助理办案

    @tc=TbCharge.find(:all,:conditions=>"(typ='a' or typ='c') and used='Y' and state=2 and should_id<>0 and check_dt>='#{et_before}' and check_dt<'#{et_now}'",:order=>"check_dt",:select=>"distinct should_id as should_id")
    for c in @tc
      @tsc=TbShouldCharge.find(c.should_id)
      if TbCase.find_by_recevice_code(@tsc.recevice_code).clerk==''
        if @tsc.used=='Y' and (@tsc.typ=='0001' or @tsc.typ=='0004') and @tsc.re_rmb_money!=0
          @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
          for ud in @ud
            if Remind.find_by_reason_id("#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 1")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id= "#{@tsc.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 1"
              @remin.contents="案件咨询流水号:#{@tsc.recevice_code},案件已收费请指定办案助理。"
              @remin.dt1=Date.today
              @remin.uu=ud.user_code
              @remin.state=1
              @remin.typ='0001'
              @remin.u='system'
              @remin.u_t=Time.now
              if TbCase.find_by_recevice_code(@tsc.recevice_code).state<200 and TbCase.find_by_recevice_code(@tsc.recevice_code).stoped==0
                @remin.save
              end
              
            end
          end
        end
      end
    end

    @ra = RemunerationAward.find(:all, :conditions => "used = 'Y' and u2 = NULL and t1 >= '#{et_before}' and t1 < '#{et_now}'", :order => t1)
    for r in @ra
      # 所有的处长
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
      # @ud = 'mqqian'      
      for ud in @ud
        if Remind.find_by_reason_id("#{@ra.recevice_code} #{ud.user_code} tb_should_charges-#{@tsc.id} 1")==nil
        @remin=Remind.new
        @remin.used='Y'
        @remin.reason_id= "#{@ra.recevice_code} #{ud.user_code} remuneration_awards-#{@ra.id} 1"
        @remin.contents="案件咨询流水号:#{@ra.recevice_code},案件已结案，助理已填写仲裁员报酬，请处长审批。"
        @remin.dt1=Date.today
        @remin.uu=ud
        @remin.state=1
        @remin.typ='0001'
        @remin.u='system'
        @remin.u_t=Time.now
        end
      end
    end
  end
=end
  def get_party_1(recevice_code)
    partys=""
    TbParty.find(:all,:conditions=>["recevice_code=? and partytype=? and used='Y'",recevice_code,1]).each{|p|
      partys = partys + p.partyname + ","
    }
    if partys != ""
      partys = partys.slice(0,partys.length-1)
    end
    return partys
  end
end
