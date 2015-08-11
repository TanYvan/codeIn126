class ShouldRefundCheck2Controller < ApplicationController
  def list
    s="tb_should_refunds.id,tb_should_refunds.state,tb_should_refunds.recevice_code,tb_should_refunds.case_code,tb_should_refunds.u,tb_should_refunds.typ,tb_should_refunds.payment,tb_should_refunds.partyname,tb_should_refunds.currency,tb_should_refunds.f_money,tb_should_refunds.rate,tb_should_refunds.rmb_money,tb_should_refunds.redu_rmb_money,tb_should_refunds.re_rmb_money,tb_should_refunds.remark,tb_should_refunds.check2_u,tb_should_refunds.check2_dt,tb_should_refunds.check2_remark,tb_should_refunds.check_u,tb_should_refunds.check_dt,tb_should_refunds.check_remark,tb_should_refunds.recall_u,tb_should_refunds.recall_dt"
    c="tb_cases.used='Y' and tb_should_refunds.used='Y' and tb_should_refunds.state=1 and (tb_should_refunds.typ<>'0002' and tb_should_refunds.typ<>'0003' and tb_should_refunds.typ<>'0005'  and tb_should_refunds.typ<>'0006'  ) and (tb_should_refunds.rmb_money - tb_should_refunds.redu_rmb_money)<>0"
    @should=TbShouldRefund.find(:all,:order=>'tb_should_refunds.recevice_code',:joins=>" inner join tb_cases  on tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_should_refunds.used='Y'",:select=>s,:conditions=>c)
  end  
  
  def edit
     @should=TbShouldRefund.find(params[:id])
  end 
  
  def check
    check=TbShouldRefund.find(params[:id])
    if check.state==1
      check.update_attributes(params[:should])
      check.state=4
      check.check2_u=session[:user_code]
      check.check2_dt=Time.now()
      if check.save
        if check.typ=='0001' or check.typ=='0004'
          TbShouldRefund.update_all("state=4","parent_id=#{check.id}")
        end
        flash[:notice]="退费确认成功！"
      else
        flash[:notice]="退费确认失败！"
      end
    else
      flash[:notice]="退费确认失败！"
    end
    redirect_to :action=>"list"
  end 
  def detail_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:parent_id]}"
    @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
  end
  def detail_list_list  #内容显示错误
    #当前办理案件
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    #查出仲裁员
    @case_arbitmen =TbCasearbitman.find(:all,:conditions=>"used='Y' and recevice_code='#{params[:recevice_code]}'")
    @arr1=""
    if PubTool.new.get_first_record(@case_arbitmen)!=nil
      for a in @case_arbitmen
        @arbitmanname = TbArbitman.find(:first,:conditions=>["code=? and used='Y'",a.arbitman])
        if @arbitmanname != nil
          @arr1 += @arbitmanname.name+ " "
        end
      end
    end
    #助理
    if @case!=nil
      @zl = User.find(:first,:conditions=>["code=? and used='Y'",@case.clerk])
      if @zl!=nil
        @zl = @zl.name
      else
        @zl=""
      end
    end
    #结案方式
    caseendbook = TbCaseendbook.find(:first,:conditions=>["recevice_code='#{params[:recevice_code]}' and used='Y'"])
    if caseendbook != nil
      endcasestyle = caseendbook.endStyle
      @endstyle = TbDictionary.find(:first,:conditions=>"typ_code='8117' and data_val='#{endcasestyle}'")
      if @endstyle != nil
        @endstyle = @endstyle.data_text
      else
        @endstyle = " "
      end
    else
      @endstyle = " "
    end
    #申请人，被申请人地区
    @area11=""
    @area1 = TbParty.find(:all,:order=>'id',:conditions=>"recevice_code='#{params[:recevice_code]}' and used='Y' and partytype=1")
    @area1.each do|ar|
      if ar!=nil
        if ar.area!=nil
          @area11 = @area11 + Region.find_by_code(ar.area).name+"、"
        end
      else
        @area11 = ""
      end
    end
    if @area11!=""
      @area11=@area11.slice(0,@area11.length-3)
    end
    @area22=""
    @area2 = TbParty.find(:all,:order=>'id',:conditions=>"recevice_code='#{params[:recevice_code]}' and used='Y' and partytype=2")
    if PubTool.new.get_first_record(@area2)!= nil
      @area2.each do |ar2|
        if ar2.area !=nil
          @area22 = @area22 + Region.find_by_code(ar2.area).name+"、"
        end
      end
      if @area22!=""
        @area22=@area22.slice(0,@area22.length-3)
      end
    else
      @area22 = ""
    end
    #仲裁协议类型
    if @case!=nil
      record = TbDictionary.find(:first,:conditions=>"typ_code='0003' and data_val='#{@case.aribitprotprog_num}'")
      if record != nil
        @pro_tp = record.data_text
      else
        @pro_tp = " "
      end
      #仲裁类型
      arbit_record = TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{@case.aribitprog_num}'")
      if arbit_record != nil
        @arbit_tp = arbit_record.data_text
      else
        @arbit_tp = " "
      end
    end
    #组庭日期
    case_org = TbCaseorg.find(:first,:conditions=>"recevice_code='#{params[:recevice_code]}' and used='Y'")
    if case_org != nil
      @orgdate = case_org.orgdate
    else
      @orgdate = " "
    end
    #选定的制裁机构
    if @case!=nil
      arbit_agent = TbDictionary.find(:first,:conditions=>"typ_code='0004' and data_val='#{@case.agent}'")
      if arbit_agent != nil
        @arbit_agent = arbit_agent.data_text
      else
        @arbit_agent = " "
      end
    end
    #费用明细
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:parent_id]}"
    @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
  end
  
end
