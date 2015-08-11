class CaseAmountController < ApplicationController

  def list
    @case = nil#当前办理案件
    if session[:case_code] == nil
    else
      @case = TbCase.find_by_recevice_code(session[:recevice_code])
      @partytype = {1 => "申请人", 2 => "被申请人"} #当事人
      @typ = {"0001" => "争议金额", "0002" => "追加争议金额", "0003" => "减少争议金额"} #争议金额类型
      @amount_typ = {"0001" => "明确金额", "0002" => "不明确金额"} #争议金额类别
      # 本请求争议金额
      @amount1 = TbCaseAmount.find(:all, :conditions => "recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=1", :order => 'id')
      # 反请求争议金额
      @amount2 = TbCaseAmount.find(:all, :conditions => "recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=2", :order => 'id')
      # 申请人明确争议金额
      @applicant_definites = Cost.new.get_sum(session[:recevice_code], "1", "0001")
      # 被申请人明确争议金额
      @respondent_definites = Cost.new.get_sum(session[:recevice_code], "2", "0001")
      # 申请人不明确争议金额
      @applicant_undefinites = Cost.new.get_sum(session[:recevice_code], "1", "0002")
      # 被申请人不明确争议金额
      @respondent_undefinites = Cost.new.get_sum(session[:recevice_code], "2", "0002")
      # 申请人费用汇总
      applicant_all = @applicant_definites+@applicant_undefinites
      # 被申请人费用汇总
      respondent_all = @respondent_definites+@respondent_undefinites
      #金融案件仲裁费/立案费

      if @case != nil
        if @case.aribitprog_num == "0005" or @case.aribitprog_num == "0006" or @case.aribitprog_num == "0007" or @case.aribitprog_num == "0008"
          if applicant_all != 0
            @applicant_arbitration_fee = Cost.new.get_03_02(applicant_all)   #仲裁费
            @applicant_registration_fee = Cost.new.get_03_01(applicant_all)  #立案费
          else
            @applicant_arbitration_fee = 0
            @applicant_registration_fee = 0
          end
          if respondent_all != 0
            @respondent_arbitration_fee = Cost.new.get_03_02(respondent_all)
            @respondent_registration_fee = Cost.new.get_03_01(respondent_all)
          else
            @respondent_arbitration_fee = 0
            @respondent_registration_fee = 0
          end
          @applicant_litigation_fee = 0             #受理费
          @applicant_processing_fee = 0           #处理费
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
      #涉外案件仲裁费/立案费

        elsif @case.aribitprog_num == "0003" or @case.aribitprog_num == "0004"
          if applicant_all != 0
            @applicant_arbitration_fee = Cost.new.get_02_02(applicant_all)       #仲裁费
            @applicant_registration_fee = Cost.new.get_02_01(applicant_all)      #立案费
          else
            @applicant_arbitration_fee = 0
            @applicant_registration_fee = 0
          end
          if respondent_all != 0
            @respondent_arbitration_fee = Cost.new.get_02_02(respondent_all)
            @respondent_registration_fee = Cost.new.get_02_01(respondent_all) 
          else
            @respondent_arbitration_fee = 0
            @respondent_registration_fee = 0
          end
          @applicant_litigation_fee = 0             #受理费
          @applicant_processing_fee = 0             #处理费
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
      #国内案件受理费/处理费计算
      elsif @case.aribitprog_num == "0001" or @case.aribitprog_num == "0002"
        if respondent_all != 0
          @respondent_litigation_fee = Cost.new.get_01_01(respondent_all)
          @respondent_processing_fee = Cost.new.get_01_02(respondent_all)
        else
          @respondent_litigation_fee = 0
          @respondent_processing_fee = 0
        end
        if applicant_all != 0
          @applicant_litigation_fee = Cost.new.get_01_01(applicant_all)
          @applicant_processing_fee = Cost.new.get_01_02(applicant_all)
        else
          @applicant_litigation_fee = 0
          @applicant_processing_fee = 0
        end
        @applicant_arbitration_fee = 0
        @applicant_registration_fee = 0
        @respondent_arbitration_fee = 0
        @respondent_registration_fee = 0
      end
      @applicant_sum = @applicant_arbitration_fee+@applicant_registration_fee+@applicant_litigation_fee+@applicant_processing_fee
      @respondent_sum = @respondent_arbitration_fee+@respondent_registration_fee+@respondent_litigation_fee+@respondent_processing_fee
      end
    end
  end

  def new
    @amount=TbCaseAmount.new()
    @amount.dt=Date.today
    @amount.currency='0001'
    @amount.f_money=0
    @amount.rate=1
    @amount.rmb_money=0
    @respondent = TbParty.find(
      :all,
      :conditions => "used='Y' and partytype=2 and recevice_code='#{session[:recevice_code]}'",
      :order => "id",
      :select => "id,partyname"
    ).collect{|p|[p.partyname,p.id]}.insert(0,["",""])
    # 当 @respondent.size 的值大于二的时候，说明有多个被申请人，此时才可以为多个被申请人录入各自的反请求争议金额
  end

  def create
    @current_case          = TbCase.find_by_recevice_code(session[:recevice_code])
    @amount               = TbCaseAmount.new(params[:amount])
    @amount.recevice_code = session[:recevice_code]
    @amount.case_code     = @current_case.case_code
    @amount.general_code  = @current_case.general_code
    @amount.partytype     = params[:partytype]
    @amount.u             = session[:user_code]
    @amount.u_t           = Time.now()
    @amount.party_id      = @amount.party_id.to_i

    sum1 = (Cost.new.get_sum1(session[:recevice_code],@amount.partytype,"0001",@amount.party_id) + Cost.new.get_sum1(session[:cecevice_code],@amount.partytype,"0002",@amount.party_id))
    sum2 = (Cost.new.get_sum(session[:recevice_code],@amount.partytype,"0001") + Cost.new.get_sum(session[:cecevice_code],@amount.partytype,"0002"))

    if (@amount.typ == "0003" and params[:spec] == "on"  and @amount.rmb_money > sum1) or (@amount.typ == "0003" and  @amount.rmb_money > sum2)
      flash[:notice]="创建失败,减少争议金额不能大于原争议金额的总和！"
      render :action=>"new", :recevice_code => session[:recevice_code]
    else
      
      old_registration_fee = Cost.new.get_fee1(params[:partytype], 1, session[:recevice_code], @amount.party_id) # 原来的立案费
      old_arbitration_fee  = Cost.new.get_fee1(params[:partytype], 2, session[:recevice_code], @amount.party_id) # 原来的仲裁费

      if @amount.save
        @money = Money.find(:all,:conditions=>"used='Y'",:order=>"code")
        for m in @money
          if params["rmb_money_"+m.code] != '0'
            @amount_detail = TbCaseAmountDetail.new()
            @amount_detail.parent_id = @amount.id
            @amount_detail.recevice_code = session[:recevice_code]
            @amount_detail.case_code = @current_case.case_code
            @amount_detail.general_code = @current_case.general_code
            @amount_detail.partytype = params[:partytype]
            @amount_detail.u = session[:user_code]
            @amount_detail.u_t = @amount.u_t
            @amount_detail.typ = @amount.typ
            @amount_detail.amount_typ = @amount.amount_typ
            @amount_detail.dt = @amount.dt
            @amount_detail.currency = m.code
            @amount_detail.f_money = params["f_money_"+m.code]
            @amount_detail.rate = params["rate_"+m.code]
            @amount_detail.rmb_money = params["rmb_money_"+m.code]
            @amount_detail.save
          end
        end
        
        # 调用是有方法的函数，在增加争议金额的时候进行应收或应退的增加
        should_add(session[:user_code],session[:recevice_code],@amount,old_registration_fee,old_arbitration_fee,@amount.party_id)
        
        @current_case.amount   = Cost.new.get_sum(session[:recevice_code],"0","0000")
        @current_case.amount_1 = Cost.new.get_sum(session[:recevice_code],"1","0000")
        @current_case.amount_2 = Cost.new.get_sum(session[:recevice_code],"2","0000")
        if @current_case.save
          flash[:notice]="创建成功"
          redirect_to :action=>"list",:recevice_code=>session[:recevice_code]
        else
          flash[:notice]="创建失败"
          render :action=>"new" ,:recevice_code=>session[:recevice_code]
        end
      else
        flash[:notice]="创建失败"
        render :action=>"new" ,:recevice_code=>session[:recevice_code]
      end
    end
  end

  def edit
    @amount=TbCaseAmount.find(params[:id])
  end

  def update
    @amount=TbCaseAmount.find(params[:id])
    @amount.u=session[:user_code]
    @amount.u_t=Time.now()
    if @amount.update_attributes(params[:amount])
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @case.amount=Cost.new.get_sum(session[:recevice_code],"0","0000")
      @case.amount_1=Cost.new.get_sum(session[:recevice_code],"1","0000")
      @case.amount_2=Cost.new.get_sum(session[:recevice_code],"2","0000")
      if @case.save
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>session[:recevice_code]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:id=>params[:id]
    end

  end

  def delete
    @amount=TbCaseAmount.find(params[:id])
    @amount.used="N"
    @amount.u=session[:user_code]
    @amount.u_t=Time.now()
    if @amount.save
      TbCaseAmountDetail.update_all("used='N'","parent_id=#{@amount.id}")
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      @case.amount=Cost.new.get_sum(session[:recevice_code],"0","0000")
      @case.amount_1=Cost.new.get_sum(session[:recevice_code],"1","0000")
      @case.amount_2=Cost.new.get_sum(session[:recevice_code],"2","0000")
      @case.save
      TbShouldCharge.update_all("used='N'","case_amount_id='#{@amount.id}'")
      TbShouldRefund.update_all("used='N'","case_amount_id='#{@amount.id}'") 
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:recevice_code=>params[:recevice_code]
  end

  def rate_set
    render :update do |page|
      page.remove 'amount_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end

  private

  # 该函数在增加争议金额的时候进行应收或应退的增加
  # user_code  操作用户的编码
  # recevice_code 咨询流水号
  # amount 增加的争议金额信息的对象参数，根据该参数可以判断到当事人类型
  # old_registration_fee 增加前的立案费或受理费
  # old_arbitration_fee  增加前的仲裁费或处理费
  def should_add(user_code,recevice_code,amount,old_registration_fee,old_arbitration_fee,party_id)

    @case = TbCase.find_by_recevice_code(recevice_code)
    @partytype = {"1"=>"申请人","2"=>"被申请人"}
    @case_amount_typ = {"0001"=>"争议金额","0002"=>"追加争议金额","0003"=>"减少争议金额"}
    @amount_typ = {"0001"=>"明确金额","0002"=>"不明确金额"}
    # 添加相应的应收款信息 ####################################################
    new_registration_fee = Cost.new.get_fee1(amount.partytype,1,recevice_code,party_id) # 新的立案费
    new_arbitration_fee  = Cost.new.get_fee1(amount.partytype,2,recevice_code,party_id) # 新的仲裁费
    difference_r = new_registration_fee - old_registration_fee
    difference_a = new_arbitration_fee  - old_arbitration_fee
    sum_r_a = difference_r + difference_a

    if sum_r_a > 0  # 增加应收费记录 案件费用
      @should = TbShouldCharge.new()
      @should.used = 'Y'
      @should.recevice_code = recevice_code
      @should.case_code = @case.case_code
      @should.general_code = @case.general_code
      @should.case_amount_id = amount.id
      @should.typ = "0001"
      if amount.partytype == '1'
        @should.payment = '0001'
      else
        @should.payment = '0002'
      end
      @should.rmb_money = sum_r_a
      @should.currency = '0001'
      @should.f_money = sum_r_a
      @should.re_rmb_money = 0
      @should.rate = 1
      @should.remark = "对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
      @should.u = user_code
      @should.u_t = Time.now()
      @should.save
      parent_id = @should.id

      if difference_r != 0 # 增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0002"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= difference_r
        @should.currency='0001'
        @should.f_money= difference_r
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if difference_a != 0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0003"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= difference_a
        @should.currency='0001'
        @should.f_money= difference_a
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end
      
    elsif (difference_r + difference_a) == 0 and difference_r != 0 #增加应收费记录 案件费用
      
      @should=TbShouldCharge.new()
      @should.used='Y'
      @should.recevice_code=recevice_code
      @should.case_code=@case.case_code
      @should.general_code=@case.general_code
      @should.case_amount_id=amount.id
      @should.typ="0001"
      if amount.partytype=='1'
        @should.payment='0001'
      else
        @should.payment='0002'
      end
      @should.rmb_money= difference_r + difference_a
      @should.currency='0001'
      @should.f_money= difference_r + difference_a
      @should.re_rmb_money=0
      @should.rate=1
      @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
      @should.u=user_code
      @should.u_t=Time.now()
      @should.save
      parent_id=@should.id

      if difference_r !=0 #增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0002"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= difference_r
        @should.currency='0001'
        @should.f_money= difference_r
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if difference_a != 0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code = recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.case_amount_id=amount.id
        @should.typ="0003"
        if amount.partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money = difference_a
        @should.currency='0001'
        @should.f_money= difference_a
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end
      
    elsif sum_r_a < 0 #增加应退费记录 案件费用

      @should_r=TbShouldRefund.new()
      @should_r.used='Y'
      @should_r.recevice_code=recevice_code
      @should_r.case_code=@case.case_code
      @should_r.general_code=@case.general_code
      @should_r.case_amount_id=amount.id
      @should_r.typ="0001"
      if amount.partytype=='1'
        @should_r.payment='0001'
      else
        @should_r.payment='0002'
      end
      @should_r.rmb_money= -1 * sum_r_a
      @should_r.currency='0001'
      @should_r.f_money= -1 * sum_r_a
      @should_r.rate=1
      @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
      @should_r.state=1
      @should_r.u=user_code
      @should_r.u_t=Time.now()
      @should_r.save
      parent_id=@should_r.id

      if difference_r != 0 #增加应退费记录 立案费或受理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.case_amount_id=amount.id
        @should_r.typ="0002"
        if amount.partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * difference_r
        @should_r.currency='0001'
        @should_r.f_money= -1 * difference_r
        @should_r.rate=1
        @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.save
      end

      if difference_a != 0      #增加应退费记录 仲裁费或处理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.case_amount_id=amount.id
        @should_r.typ="0003"
        if amount.partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * difference_a
        @should_r.currency='0001'
        @should_r.f_money= -1 * difference_a
        @should_r.rate=1
        @should_r.remark="对应 #{@partytype[amount.partytype]} #{@case_amount_typ[amount.typ]} #{@amount_typ[amount.amount_typ]}：￥#{amount.rmb_money}"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.save
      end

    end

  end
  
end
