# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

class Task_a
  def initialize
    
  end
  def t_a
    t_b
  end
  ##################
  ##################
  ##################
  def t_1(et_before,et_now_t,et_now)
    ### 1:收费被助理确认以后,直接提醒处长指定一名助理办案,2工作日后仍未指定的,提醒到秘书长处。
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
  ##################
  ##################
  ##################
  def t_2(et_before,et_now_t,et_now)
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
  ##################
  ##################
  ##################
  def t_3(et_before,et_now_t,et_now)
    ### 3:最新:在仲裁员回避里面输入收到回避申请的日期。系统进行判断,如果5天后没有输入起草回避决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入起草回避决定草稿的时间。系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。输入回避决定草稿完成时间。系统进行判断,如果5天后没有输入D中的回避决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入回避决定报总会时间。提醒程序结束。
    #仲裁助理在收到仲裁员回避申请后的2个工作日内,将该申请转交给对方当事人和仲裁庭,2个工作日后仍未发出的,提醒到处长处。
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒仲裁员回避申请转交给对方当事人和仲裁庭,【仲裁员回避记录】中录入【转交给对方当事人和仲裁庭时间】。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒起草仲裁员回避决定草稿,【仲裁员回避中】输入【起草回避决定草稿时间】。"
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒起草仲裁员回避决定草稿,【仲裁员回避记录】中录入【起草回避决定草稿时间】。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒完成仲裁员回避决定草稿,【仲裁员回避记录】中录入【完成回避决定草稿时间】。"
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒【仲裁员回避记录】中录入【完成回避决定草稿】。"
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
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>5)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>4)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and drafteddate>='#{wwdd}' and drafteddate<'#{wwdd2}' and  reporteddate is NULL")
      if @te!=nil
        for c in @te 
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 6")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_evites-#{c.id} 6"
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒仲裁员回避决定上报总会,【仲裁员回避记录】中录入【回避决定上报总会时间】。"
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
      @te=TbEvite.find(:all,:conditions=>"used='Y' and remind=1  and drafteddate>='#{wwdd}' and drafteddate<'#{wwdd2}' and reporteddate is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te 
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 7")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_evites-#{c.id} 7"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒仲裁员回避决定上报总会,【仲裁员回避记录】中录入【回避决定上报总会】。"
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
    #输入回避决定报总会时间。提醒程序结束。
    if et_now.slice(0,10)>et_before.slice(0,10)
      @te=TbEvite.find(:all,:conditions=>"used='Y' and reporteddate>='#{et_before.slice(0,10)}' and reporteddate<'#{et_now.slice(0,10)}'")
      if @te!=nil
        for c in @te 
          Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
        end
      end
    end
    #不提醒。提醒程序结束。
    @tc=TbEvite.find(:all,:conditions=>"used='Y' and  remind=2 and remind_t>='#{et_before}' and remind_t<'#{et_now}'")
    for c in @tc 
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
    end
    #不提醒。提醒程序结束。
    @tc=TbEvite.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for c in @tc 
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_evites-#{c.id}%'")
    end
  end
  ##################
  ##################
  ##################
  def t_4(et_before,et_now_t,et_now)
    ### 4:在管辖权异议界面输入收到管辖权异议申请的日期。系统进行判断,如果5天后没有输入B中的起草管辖权决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入起草管辖权决定草稿的时间。系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。输入管辖权决定草稿完成时间。系统进行判断,如果5天后没有输入D中的管辖权决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入回避决定报总会时间。提醒程序结束。在该界面中可以设置取消提醒功能,要求输入原因才能取消提醒并记录。比如有些案子是当时就可以确定有管辖权的,在收到申请以后就答复当事人了,不需要进行下面的流程。
    #在管辖权异议界面输入收到管辖权异议申请的日期。系统进行判断,如果5天后没有输入B中的起草管辖权决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>5)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>4)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  request_date>='#{wwdd}' and  request_date<'#{wwdd2}' and idea_date is NULL")
      if @te!=nil
        for c in @te 
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 1")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 1"
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒起草管辖权决定草稿,【管辖权异议申请】中输入【起草草稿的时间】。"
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
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  request_date>='#{wwdd}' and  request_date<'#{wwdd2}' and idea_date is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te 
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 2")==nil
              case_1=TbCase.find_by_recevice_code(c.recevice_code)
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 2"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒起草管辖权决定草稿,【管辖权异议申请】中输入【起草草稿的时间】。办案助理:#{User.find_by_code(case_1.clerk).name}"
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
    #输入起草管辖权决定草稿的时间。系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  idea_date>='#{wwdd}' and  idea_date<'#{wwdd2}' and checkout_date is NULL")
      if @te!=nil
        for c in @te 
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 3")==nil
            case_1=TbCase.find_by_recevice_code(c.recevice_code)
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 3"
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒完成管辖权决定草稿,【管辖权异议申请】中输入【草稿完成时间】。办案助理:#{User.find_by_code(case_1.clerk).name}"
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
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  idea_date>='#{wwdd}' and  idea_date<'#{wwdd2}' and checkout_date is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te 
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 4")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 4"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒完成管辖权决定草稿,【管辖权异议申请】中输入【草稿完成时间】。办案助理:#{User.find_by_code(TbCase.find_by_recevice_code(c.recevice_code).clerk).name}"
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
    #输入管辖权决定草稿完成时间。系统进行判断,如果5天后没有输入D中的管辖权决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>5)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>4)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  checkout_date>='#{wwdd}' and  checkout_date<'#{wwdd2}' and draft_date is NULL")
      if @te!=nil
        for c in @te
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 5")==nil          
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_jurisdictions-#{c.id} 5"
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒管辖权异议草稿报总会,【管辖权异议申请】中输入【草稿报总会日期】。"
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
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and remind=1 and  checkout_date>='#{wwdd}' and  checkout_date<'#{wwdd2}' and draft_date is NULL")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te 
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 6")==nil 
              case_1=TbCase.find_by_recevice_code(c.recevice_code)
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_jurisdictions-#{c.id} 6"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒管辖权异议草稿报总会,【管辖权异议申请】中输入【草稿报总会日期】。办案助理:#{User.find_by_code(case_1.clerk).name}"
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
    #输入回避决定报总会时间。提醒程序结束。
    if et_now.slice(0,10)>et_before.slice(0,10)
      @te=TbJurisdiction.find(:all,:conditions=>"used='Y' and draft_date>='#{et_before.slice(0,10)}' and draft_date<'#{et_now.slice(0,10)}'")
      if @te!=nil
        for c in @te 
          Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
        end
      end
    end
    #不提醒。提醒程序结束。
    @tc=TbJurisdiction.find(:all,:conditions=>"used='Y' and  remind=2 and remind_t>='#{et_before}' and remind_t<'#{et_now}'")
    for c in @tc 
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
    end
    #不提醒。提醒程序结束。
    @tc=TbJurisdiction.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    for c in @tc 
      Remind.update_all("used='N'","reason_id like '#{c.recevice_code}%tb_jurisdictions-#{c.id}%'")
    end
  end
  ##################
  ##################
  ##################
  def t_5(et_before,et_now_t,et_now)
    ### 5:仲裁助理应在组庭后3个工作日内与仲裁庭联系商定开庭日期,并在开庭日期确定后1个工作日内发出开庭通知,3工作日后仍未确定开庭日期的,提醒到处长处。
    ### 检查案件,组庭日期后3日内是否有开庭记录,如果没有开庭记录则要提醒到处长。开庭日期确定后1个工作日是发开庭通知的时间,要提醒助理。
    #组庭日期后3日内是否有开庭记录,如果没有开庭记录则要提醒到处长
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>3)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date<'#{et_now.slice(0,10)}'",:order=>"date desc",:limit=>2)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbCaseorg.find(:all,:conditions=>"used='Y' and orgdate>='#{wwdd}' and orgdate<'#{wwdd2}'")
      if @te!=nil
        @ud=UserDuty.find(:all,:conditions=>"duty_code='0001'",:select=>"distinct user_code as user_code",:order=>"user_code")
        for c in @te 
          if TbSitting.find(:all,:conditions=>"used='Y' and recevice_code='#{c.recevice_code}'").empty?
            for ud in @ud
              if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_caseorgs-#{c.id} 1")==nil   
                @remin=Remind.new
                @remin.used='Y'
                @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_caseorgs-#{c.id} 1"
                @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒开庭,确定开庭日期,录入【开庭信息】。办案助理:#{User.find_by_code(TbCase.find_by_recevice_code(c.recevice_code).clerk).name}"
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
    #开庭日期确定后1个工作日是发开庭通知的时间,要提醒助理。
    if et_now.slice(0,10)>et_before.slice(0,10)
      @te=TbSitting.find(:all,:conditions=>"used='Y' and u_t>='#{et_before.slice(0,10)} 00:00:01' and u_t<'#{et_now.slice(0,10)} 00:00:01'")
      if @te!=nil
        for c in @te 
          aribitprog_num=TbCase.find_by_recevice_code(c.recevice_code).aribitprog_num
          #if aribitprog_num!='0001' and aribitprog_num!='0002'
          if TbDoc.find(:all,:conditions=>"recevice_code='#{c.recevice_code}' and (typ_code='0026' or typ_code='0027' or typ_code='0030' or typ_code='0031' or typ_code='0032' or typ_code='0033')").empty?
            if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 1")==nil   
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 1"
              @remin.contents="立案号：#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒发开庭通知,【发文】中发【开庭通知】。"
              @remin.url="/case_doc/list?recevice_code=#{c.recevice_code}"
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
          #end
        end
      end
    end
  end
  ##################
  ##################
  ##################
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒联系检测机构,【检测信息记录】中填入【联系机构的时间】。"
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒确定检测机构,【检测信息记录】中填入【确定机构时间】。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒把检测有关情况报处长审批,【检测信息记录】中录入【送交审批时间】。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒将报价等事项书面通知有关当事人,【检测信息记录】中录入【转给当事人的时间】。"
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
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},提醒与检测机构签约,【检测信息记录】中录入【和机构签约时间】。"
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
  ##################
  ##################
  ##################
  def t_7(et_before,et_now_t,et_now)
    ### 7:开庭安排在办案系统中设置以后,自动显示到相应时间段。开庭时间变动由助理在办案系统中修改后,显示在相应时间段。（修改后,系统自动发送开庭时间变更提醒到前台的工作提醒中。）实现方法:（开庭中仲裁庭使用信息中新建和删除的时候进行提示,案件合议中案件庭使用信息中新建和删除的时候进行提示）
    #先判断仲裁庭的新建仲裁使用情况,然后判断开庭记录是否有效
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0001' and used='Y' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te 
        if TbSitting.find(c.sitting_id).used=='Y'
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 1")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 1"
              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},增加了仲裁庭使用信息,#{arbitroom_info}。"
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
#    # 先判断仲裁庭的删除仲裁使用情况,然后判断开庭记录是否有效
#    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0001' and used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
#    if @te!=nil
#      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
#      for c in @te 
#        if TbSitting.find(c.sitting_id).used=='Y'
#          for ud in @ud
#            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 2")==nil
#              @remin=Remind.new
#              @remin.used='Y'
#              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 2"
#              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}<br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>时间:#{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
#              @remin.contents="案件咨询流水号:#{c.recevice_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
#              @remin.dt1=Date.today
#              @remin.uu=ud.user_code
#              @remin.state=1
#              @remin.typ='0001'
#              @remin.u='system'
#              @remin.u_t=Time.now
#              if TbCase.find_by_recevice_code(c.recevice_code).state<200
#                @remin.save
#              end
#            end
#          end
#        end
#      end
#    end
#    # 先判断开庭记录是否有效,然后判断仲裁庭的仲裁使用情况
#    @te=TbSitting.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
#    if @te!=nil
#      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
#      for a in @te 
#        @tm=TbArbitroom.find(:all,:conditions=>"used='Y' and sitting_id=#{a.id} and usestyle='0001'") 
#        for c in @tm
#          for ud in @ud
#            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 3")==nil
#              @remin=Remind.new
#              @remin.used='Y'
#              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 3"
#              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
#              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
#              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
#              时间:#{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
#              @remin.contents="案件咨询流水号:#{c.recevice_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
#              @remin.dt1=Date.today
#              @remin.uu=ud.user_code
#              @remin.state=1
#              @remin.typ='0001'
#              @remin.u='system'
#              @remin.u_t=Time.now
#              if TbCase.find_by_recevice_code(c.recevice_code).state<200
#                @remin.save
#              end
#            end
#          end
#        end
#      end
#    end
    
    #先判断开庭记录是否有效,然后判断仲裁庭的仲裁使用情况
    @te=TbSitting.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for a in @te 
        @tm=TbArbitroom.find(:all,:conditions=>"used='N' and sitting_id=#{a.id} and usestyle='0001'") 
        for c in @tm
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 7")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 7"
              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
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
    
    #先判断仲裁庭的新建合议使用情况,然后判断合议记录是否有效
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0002' and used='Y'  and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te 
        if TbCasecomment.find(c.sitting_id).used=='Y'
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 4")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 4"
              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},增加了仲裁庭使用信息,#{arbitroom_info}。"
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
    
    #先判断仲裁庭的删除合议使用情况,然后判断合议记录是否有效
    @te=TbArbitroom.find(:all,:conditions=>"usestyle='0002' and used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for c in @te 
        if TbCasecomment.find(c.sitting_id).used=='Y'
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 5")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 5"
              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
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
    
    #先判断合议记录是否有效,然后判断仲裁庭的合议使用情况
    @te=TbCasecomment.find(:all,:conditions=>"used='N' and u_t>='#{et_before}' and u_t<'#{et_now}'")
    if @te!=nil
      @ud=UserDuty.find(:all,:conditions=>"duty_code='0005'",:select=>"distinct user_code as user_code",:order=>"user_code")
      for a in @te 
        @tm=TbArbitroom.find(:all,:conditions=>"used='N' and sitting_id=#{a.id} and usestyle='0002'") 
        for c in @tm
          for ud in @ud
            if Remind.find_by_reason_id("#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 6")==nil
              @remin=Remind.new
              @remin.used='Y'
              @remin.reason_id="#{c.recevice_code} #{ud.user_code} tb_arbitrooms-#{c.id} 6"
              arbitroom_info="预订人:#{User.find_by_code(c.u).name}<br>仲裁
              庭:#{TbDictionary.find(:first,:conditions=>"typ_code='0023' and data_val='#{c.sittingplace}' and data_val<>'0000'").data_text}
              <br>使用类型:#{TbDictionary.find(:first,:conditions=>"typ_code='0028'  and  data_val='#{c.usestyle}' and data_val<>'0000'").data_text}<br>
              时间:#{c.sittingdate.to_s(:db)} #{c.open_t}-#{c.close_t}<br>时长:#{c.usetime}小时"
              @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},减少了仲裁庭使用信息,#{arbitroom_info}。"
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
  end
  ##################
  ##################
  ##################
  def t_8(et_before,et_now_t,et_now)
    ### 8: 审限到期前,系统提醒助理做出裁决。1个月,15天,5天,3天
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒做出裁决。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒做出裁决。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒做出裁决。"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},审限日期#{TbCase.find_by_recevice_code(c.recevice_code).finally_limit_dat.to_s(:db)},提醒做出裁决。"
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
  ##################
  ##################
  ##################
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},费用超支。收费:#{should_charge},退费:#{should_refund},花费:#{expend_detail + arbitman_spend + arbitcourt_spend + other_spends}"
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
  ##################
  ##################
  ##################
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
          @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},请输入校核评价信息。办案助理:#{User.find_by_code(case_1.clerk).name}。"
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
  ##################
  ##################
  ##################
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
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},新增退费信息,请确认。"
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
  ##################
  ##################
  ##################
  def t_12(et_before,et_now_t,et_now)
    ### 12: 开庭前2个工作日,提示助理,短信通知的仲裁员。生成开庭短信提醒（仲裁员，当事人，代理人）
    if et_now.slice(0,10)>et_before.slice(0,10)
      wd=Workday.find(:all,:conditions=>"isworkday=1 and date>'#{et_now.slice(0,10)}'",:order=>"date asc",:limit=>2)
      wwdd=PubTool.new.get_last_record(wd).date
      wd2=Workday.find(:all,:conditions=>"isworkday=1 and date>'#{et_now.slice(0,10)}'",:order=>"date asc",:limit=>1)
      wwdd2=PubTool.new.get_last_record(wd2).date
      @te=TbSitting.find(:all,:conditions=>"used='Y' and sittingdate>'#{wwdd2}' and sittingdate<='#{wwdd}'",:select=>"id,recevice_code,case_code")
      if @te!=nil
        for c in @te 
          sitting=c
          if Remind.find_by_reason_id("#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 2")==nil
            @remin=Remind.new
            @remin.used='Y'
            @remin.reason_id="#{c.recevice_code} #{TbCase.find_by_recevice_code(c.recevice_code).clerk} tb_sittings-#{c.id} 2"
            @remin.contents="立案号:#{c.case_code},案件咨询流水号:#{c.recevice_code},两个工作日后开庭,提醒短信通知仲裁员。"
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
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
                else
                  ktd=""
                  if sitting.area_code!='' and sitting.area_code!=nil
                    ktd=Region.find_by_code(sitting.area_code).name
                  end
                  contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
  ##################
  ##################
  ##################
  def t_13(et_before,et_now_t,et_now)
    ### 发文报批后立刻提示审批人进行审批
    @te=TbDocApproval.find(:all,:conditions=>"(state=0 or state=-1) and call_t>='#{et_before}' and call_t<'#{et_now}' ")
    if @te!=nil
      for c in @te 
        if Remind.find_by_reason_id("#{c.recevice_code} #{c.a_u} tb_doc_approvals-#{c.id} 1")==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="#{c.recevice_code} #{c.a_u} tb_doc_approvals-#{c.id} 1"
          @remin.contents="提醒审批发文。立案号:#{TbCase.find_by_recevice_code(c.recevice_code).case_code},案件咨询流水号:#{c.recevice_code},文件流水号:#{c.file_code},发文编号:#{c.send_code},申请人:#{User.find_by_code(c.call_u).name}。"
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
  ##################
  ##################
  ##################
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
              contents=contents + "立案号:#{ccc.case_code},"
              contents=contents + "咨询流水号:#{ccc.recevice_code},"
              if ccc.clerk!='' and ccc.clerk!=nil
                contents=contents + "办案助理:#{User.find_by_code(ccc.clerk).name}。"
              elsif ccc.clerk_2!='' and ccc.clerk_2!=nil
                contents=contents + "咨询助理:#{User.find_by_code(ccc.clerk_2).name}。"
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
  def t_21(et_before,et_now_t,et_now)
    ### 21: 删除一年前的提醒信息
    limit_date_360=et_now_t.months_ago(12).to_date.to_s(:db)
    if et_now.slice(0,10)>et_before.slice(0,10)
      Remind.delete_all("dt1<'#{limit_date_360}'")
    end
  end
  ##################
  ##################
  ##################
  def t_22(et_before,et_now_t,et_now)
    ### 22: 案件结案后，半年后，提示填写执行情况
    limit_date_180=et_now_t.months_ago(6).to_date.to_s(:db)
    if et_now.slice(0,10)>et_before.slice(0,10)
      @endbook=TbCaseendbook.find(:all,:conditons=>"used='Y' and u_t>='#{limit_date_180} 00:00:31' and u_t<='#{limit_date_180} 23:59:59'")
      for endbook in @endbook
        @case=TbCase.find_by_recevice_code(endbook.recevice_code)
        if @case.runstyle==nil
          @remin=Remind.new
          @remin.used='Y'
          @remin.reason_id="zl caseendbook #{@case.clerk} #{@case.recevice_code} #{endbook.id}"
          @remin.contents="立案号为:#{@case.case_code}，请填写执行情况"
          @remin.url="/wind_up_case/show_implement"
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
  ##################
  ##################
  ##################
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
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
            contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          else
            ktd=""
            if sitting.area_code!='' and sitting.area_code!=nil
              ktd=Region.find_by_code(sitting.area_code).name
            end
            contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
            else
              ktd=""
              if sitting.area_code!='' and sitting.area_code!=nil
                ktd=Region.find_by_code(sitting.area_code).name
              end
              contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
            contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
          else
            ktd=""
            if sitting.area_code!='' and sitting.area_code!=nil
              ktd=Region.find_by_code(sitting.area_code).name
            end
            contents="中国国际经济贸易仲裁委员会华南分会开庭通知：#{sitting.case_code}号案件，开庭时间：#{sitting.sittingdate.to_s(:db)}日 #{sitting.open_t}时。办案助理:#{User.find_by_code(clerk).name}"
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
  def t_25()
    ### 25:每天生成仲裁员人案统计表
      et_now=Time.now.to_s(:db)
      ReportArbitmanCase.delete_all()
      @arbitman_case = VArbitmanCase.find(:all,:group=>"code",:order=>"code")
      for c in @arbitman_case
        @arbitmancase=ReportArbitmanCase.new()
        @arbitmancase.tim=et_now
        @arbitmancase.code=c.code
        @arbitmancase.name=c.name
        a1=TbCase.find_by_sql("select count(distinct(c.recevice_code)) as cn from tb_cases as c,tb_casearbitmen as ca where c.used='Y' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.recevice_code=ca.recevice_code and ca.used='Y' and ca.arbitman='#{c.code}'")
        @arbitmancase.a1=SysArg.get_first_record(a1).cn
        a2=VArbitmanCase.find(:first,:select=>"count(distinct(recevice_code)) as n_l",:conditions=>["state>=4 and code=? and caseendbook_id_first is not null",c.code])
        if a2!=nil
          a2=a2.n_l.to_i
        else
          a2=0
        end
        @arbitmancase.a2=a2
        @arbitmancase.sex=c.sex
        @arbitmancase.mobiletel=c.mobiletel
        @arbitmancase.telh=c.telh
        @arbitmancase.fax=c.fax
        sc=TbEvaluate.find_by_sql("select sum(e.score) as scores,count(distinct e.recevice_code) as e_n from tb_evaluates as e,tb_cases as c where e.used='Y' and e.arbitman='#{c.code}'
   and e.recevice_code=c.recevice_code and c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null")
        #      sc=TbEvaluate.find(:first,:select=>"sum(e.score) as score,count(distinct e.recevice_code) as e_n",:conditions=>["e.used='Y' and e.arbitman=?",c.code],:joins=>"as e inner join tb_cases as c on e.recevice_code=c.recevice_code and c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null")
        sc_1=SysArg.get_first_record(sc).scores
        sc_2=SysArg.get_first_record(sc).e_n.to_i
        if a2>0 and sc_1!=nil and sc_2!=0
          @arbitmancase.score=(sc_1.to_i.to_f + sc_2*100)/sc_2
          #          @arbitmancase.score=(sc.score.to_i + sc.e_n.to_i*100)/sc.e_n.to_i
        end
        #校核评价
        sc2=TbAwardJudge.find_by_sql("select sum(score) as scores,count(recevice_code) as j_n from tb_award_judges where used='Y' and (arbitman1='#{c.code}' or arbitman2='#{c.code}' or arbitman3='#{c.code}')")
        sc_1=SysArg.get_first_record(sc2).scores
        sc_2=SysArg.get_first_record(sc2).j_n.to_i
        if sc_1!=nil and sc_2!=0
          @arbitmancase.score2=sc_1.to_f/sc_2
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
        tb_evalate=TbEvite.find(:first,:conditions=>["e.used='Y' and e.arbitman=?",c.code],:joins=>"as e inner join v_arbitman_cases as va on e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"count(distinct(e.recevice_code)) as ad")
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
        tb_evalate=TbEvite.find(:first,:conditions=>["e.used='Y' and e.arbitman=?",c.code],:joins=>"as e inner join v_arbitman_cases as va on e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"count(distinct(e.recevice_code)) as ad")
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
  ##################
  ##################
  ##################
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
  ##################
  ##################
  ##################
  
  
  def t_b 
    if @@task_state==0
      
      @@task_state=1
      
      @sys_2001=SysArg.find_by_code('2001')
      et_before=@sys_2001.val
      et_now_t=Time.now
      et_now=et_now_t.to_s(:db)
      @sys_2001.val=et_now
      @sys_2001.save
    
    #########################################################################################################
    # 1:收费被助理确认以后,直接提醒处长指定一名助理办案,2工作日后仍未指定的,提醒到秘书长处。
    begin
      t_1(et_before,et_now_t,et_now)
    rescue
    end
    ###################################################################################################################
    # 2:处长指定办案人员后,直接提醒办案人员发出仲裁通知,2工作日之后仍未发出的,提醒到处长处。
    begin
      t_2(et_before,et_now_t,et_now)
    rescue
    end
    ##########################################################################################################
    # 3:最新:在仲裁庭回避里面输入收到回避申请的日期。系统进行判断,如果5天后没有输入起草回避决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入起草回避决定草稿的时间。系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。输入回避决定草稿完成时间。系统进行判断,如果5天后没有输入D中的回避决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入回避决定报总会时间。提醒程序结束。
    begin
      t_3(et_before,et_now_t,et_now)
    rescue
    end
    ##########################################################################################################
    # 4:在管辖权异议界面输入收到管辖权异议申请的日期。系统进行判断,如果5天后没有输入B中的起草管辖权决定草稿的时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入起草管辖权决定草稿的时间。系统进行判断,如果2天后没有输入C中的草稿完成时间,则提醒。提醒后1个工作日仍未完成的,提醒到处长处。输入管辖权决定草稿完成时间。系统进行判断,如果5天后没有输入D中的管辖权决定报总会时间,则提醒。提醒后2个工作日仍未完成的,提醒到处长处。输入回避决定报总会时间。提醒程序结束。在该界面中可以设置取消提醒功能,要求输入原因才能取消提醒并记录。比如有些案子是当时就可以确定有管辖权的,在收到申请以后就答复当事人了,不需要进行下面的流程。
    begin
      t_4(et_before,et_now_t,et_now)
    rescue
    end
    ##########################################################################################################  
    # 5:仲裁助理应在组庭后3个工作日内与仲裁庭联系商定开庭日期,并在开庭日期确定后1个工作日内发出开庭通知,3工作日后仍未确定开庭日期的,提醒到处长处。
    # 检查案件,组庭日期后3日内是否有开庭记录,如果没有开庭记录则要提醒到处长。开庭日期确定后1个工作日是发开庭通知的时间,要提醒助理。  
    begin
      t_5(et_before,et_now_t,et_now)
    rescue
    end
    ##########################################################################################################   
    # 6:决定审计、鉴定或评估的,仲裁助理在3个工作日内联系有关专业机构,如果仍未联系,则提醒到处长处。在收到有关专业机构的报价之日起10个工作日内商定仲裁庭,确定具体的专业机构和有关报价；10个工作日内仍未确定,提醒到处长处。
    begin
      t_6(et_before,et_now_t,et_now)
    rescue
    end
    ########################################################################################################## 
    # 7:开庭安排在办案系统中设置以后,自动显示到相应时间段。开庭时间变动由助理在办案系统中修改后,显示在相应时间段。（修改后,系统自动发送开庭时间变更提醒到前台的工作提醒中。）实现方法:（开庭中仲裁庭使用信息中新建和删除的时候进行提示,案件合议中案件庭使用信息中新建和删除的时候进行提示）
    begin
      t_7(et_before,et_now_t,et_now)
    rescue
    end
    ########################################################################################################## 
    # 8: 审限到期前,系统提醒助理做出裁决。1个月,15天,5天,3天
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
    # 22：案件结案后，半年后，提示填写执行情况。
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
    # 911：备份数据库
    begin
      t_911(et_before,et_now_t,et_now)
    rescue
    end
    ##########################################################################################################
  
    @@task_state=0
    
  else
    
  end
  
    
  end
end
