class DataOldTController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @data_old_t_pages,@data_old_ts= paginate(:data_old_ts,:conditions=>"st=0",:order=>"id",:per_page=>@page_lines.to_i)
  end

#  def show
#    @data_old_t = DataOldT.find(params[:id])
#  end

#  def new
#    @data_old_t = DataOldT.new
#  end
#
#  def create
#    @data_old_t = DataOldT.new(params[:data_old_t])
#    if @data_old_t.save
#      flash[:notice] = 'DataOldT was successfully created.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
#  end

  def edit
    @data_old_t = DataOldT.find(params[:id])
  end

  def update
    @data_old_t = DataOldT.find(params[:id])
    if @data_old_t.update_attributes(params[:data_old_t])
      flash[:notice] = '修改成功'
      redirect_to :action => 'list', :id => @data_old_t,:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = '修改失败'
      render :action => 'edit',:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def insert_do
    @condi = params[:condi]
    array_con = @condi.split(",")
    begin
      array_con.each do |con|
        d=DataOldT.find(con)
        ###
        @case=TbCase.new()
        @case.recevice_code=d.recevice_code
        @case.general_code=d.general_code
        @case.case_code=d.case_code
        @case.receivedate=d.receivedate
        @case.nowdate=d.nowdate
        @case.accepttime=d.accepttime
        @case.casereason=d.casereason
        @case.clerk=d.clerk
        @case.clerk_2=d.clerk
        @case.aribitprog_num=d.aribitprog_num
        @case.aribitprotprog_num=d.aribitprotprog_num
        @case.t_casetype_num=d.t_casetype_num
        @case.finally_limit_dat=d.finally_limit_dat
        @case.trial_typ=d.trial_typ
        @case.end_code=d.end_code
        ### 组庭信息
        @caseorg=TbCaseorg.new()
        @caseorg.recevice_code=d.recevice_code
        @caseorg.general_code=d.general_code
        @caseorg.case_code=d.case_code
        @caseorg.orgdate=d.orgdate
        @caseorg.limitdate=d.finally_limit_dat
        @caseorg.save
        ### 仲裁员信息
        if d.arbitman_0001!=""
          @arb=TbCasearbitman.new()
          @arb.recevice_code=d.recevice_code
          @arb.general_code=d.general_code
          @arb.case_code=d.case_code
          @arb.arbitman=d.arbitman_0001
          if d.arbitman_0002!="" or d.arbitman_0003!=""
            @arb.arbitmantype="0002"
          else
            @arb.arbitmantype="0001"
          end
          @arb.arbitmansign=d.arbitmansign_0001
          @arb.save
        end
        if d.arbitman_0002!=""
          @arb=TbCasearbitman.new()
          @arb.recevice_code=d.recevice_code
          @arb.general_code=d.general_code
          @arb.case_code=d.case_code
          @arb.arbitman=d.arbitman_0002
          @arb.arbitmantype="0003"
          @arb.arbitmansign=d.arbitmansign_0002
          @arb.save
        end
        if d.arbitman_0003!=""
          @arb=TbCasearbitman.new()
          @arb.recevice_code=d.recevice_code
          @arb.general_code=d.general_code
          @arb.case_code=d.case_code
          @arb.arbitman=d.arbitman_0003
          @arb.arbitmantype="0004"
          @arb.arbitmansign=d.arbitmansign_0003
          @arb.save
        end
        ### 结案信息
        @end=TbCaseendbook.new()
        @end.recevice_code=d.recevice_code
        @end.general_code=d.general_code
        @end.case_code=d.case_code
        @end.arbitBookNum=d.end_code
        @end.endStyle=d.end_style
        @end.decideDate=d.end_date
        @end.save
        ### 延期日期
        if d.delayDate!=nil
          @delay=TbCasedelay.new()
          @delay.recevice_code=d.recevice_code
          @delay.general_code=d.general_code
          @delay.case_code=d.case_code
          @delay.requestman_typ="0000"
          @delay.reason="-"
          @delay.delayDate=d.delayDate
          @delay.save
        end
        ### 反请求收费情况信息表
        if d.b_should_charge_0002!=0 or d.b_should_charge_0003!=0
          @b_should_charge=TbShouldCharge.new()
          @b_should_charge.recevice_code=d.recevice_code
          @b_should_charge.general_code=d.general_code
          @b_should_charge.case_code=d.case_code
          @b_should_charge.typ='0001'
          @b_should_charge.payment="0002"
          @b_should_charge.rmb_money=d.b_should_charge_0002 + d.b_should_charge_0003
          @b_should_charge.currency="0001"
          @b_should_charge.f_money=d.b_should_charge_0002 + d.b_should_charge_0003
          @b_should_charge.redu_rmb_money=d.b_reduction
          @b_should_charge.re_rmb_money=d.b_charge - (d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2 )
          @b_should_charge.save
          ##
          @b_should_charge_0002=TbShouldCharge.new()
          @b_should_charge_0002.recevice_code=d.recevice_code
          @b_should_charge_0002.general_code=d.general_code
          @b_should_charge_0002.case_code=d.case_code
          @b_should_charge_0002.typ='0002'
          @b_should_charge_0002.payment="0002"
          @b_should_charge_0002.rmb_money=d.b_should_charge_0002
          @b_should_charge_0002.currency="0001"
          @b_should_charge_0002.f_money=d.b_should_charge_0002
          @b_should_charge_0002.parent_id=@b_should_charge.id
          @b_should_charge_0002.save
          ##
          @b_should_charge_0003=TbShouldCharge.new()
          @b_should_charge_0003.recevice_code=d.recevice_code
          @b_should_charge_0003.general_code=d.general_code
          @b_should_charge_0003.case_code=d.case_code
          @b_should_charge_0003.typ='0003'
          @b_should_charge_0003.payment="0002"
          @b_should_charge_0003.rmb_money=d.b_should_charge_0003
          @b_should_charge_0003.currency="0001"
          @b_should_charge_0003.f_money=d.b_should_charge_0003
          @b_should_charge_0003.parent_id=@b_should_charge.id
          @b_should_charge_0003.save
        end
        ### 反请求退费情况信息表
        if d.b_refunds!=0
          @b_refunds=TbShouldRefund.new()  
          @b_refunds.recevice_code=d.recevice_code
          @b_refunds.general_code=d.general_code
          @b_refunds.case_code=d.case_code
          @b_refunds.typ="0001"
          @b_refunds.payment="0002"   
          @b_refunds.rmb_money=d.b_refunds
          @b_refunds.currency="0001"
          @b_refunds.f_money=d.b_refunds
          @b_refunds.re_rmb_money=d.b_refunds
          @b_refunds.state=2
          @b_refunds.save
          ##
          @b_refunds_0003=TbShouldRefund.new()  
          @b_refunds_0003.recevice_code=d.recevice_code
          @b_refunds_0003.general_code=d.general_code
          @b_refunds_0003.case_code=d.case_code
          @b_refunds_0003.typ="0003"
          @b_refunds_0003.payment="0002"   
          @b_refunds_0003.rmb_money=d.b_refunds
          @b_refunds_0003.currency="0001"
          @b_refunds_0003.f_money=d.b_refunds
          @b_refunds_0003.parent_id=@b_refunds.id
          @b_refunds_0003.state=2
          @b_refunds_0003.save
        end
        ### 反请求方无明确争议金额收费
        if d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2 !=0
          @b_should_charge_0004=TbShouldCharge.new()
          @b_should_charge_0004.recevice_code=d.recevice_code
          @b_should_charge_0004.general_code=d.general_code
          @b_should_charge_0004.case_code=d.case_code
          @b_should_charge_0004.typ='0004'
          @b_should_charge_0004.payment="0002"
          @b_should_charge_0004.rmb_money=d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2 
          @b_should_charge_0004.currency="0001"
          @b_should_charge_0004.f_money=d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2
          @b_should_charge_0004.re_rmb_money=d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2
          @b_should_charge_0004.save
          ##
          @b_should_charge_0006=TbShouldCharge.new()
          @b_should_charge_0006.recevice_code=d.recevice_code
          @b_should_charge_0006.general_code=d.general_code
          @b_should_charge_0006.case_code=d.case_code
          @b_should_charge_0006.typ='0006'
          @b_should_charge_0006.payment="0002"
          @b_should_charge_0006.rmb_money=d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2
          @b_should_charge_0006.currency="0001"
          @b_should_charge_0006.f_money=d.b_should_charge_0004 + d.b_should_qt + d.b_should_qt2
          @b_should_charge_0006.parent_id=@b_should_charge_0004.id
          @b_should_charge_0006.save
        end
        ### 反请求方 审计费 代收代支
        if d.b_should_charge_0007!=0
          @b_should_charge_0007=TbShouldCharge.new()
          @b_should_charge_0007.recevice_code=d.recevice_code
          @b_should_charge_0007.general_code=d.general_code
          @b_should_charge_0007.case_code=d.case_code
          @b_should_charge_0007.typ='0007'
          @b_should_charge_0007.payment="0002"
          @b_should_charge_0007.rmb_money=d.b_should_charge_0007
          @b_should_charge_0007.currency="0001"
          @b_should_charge_0007.f_money=d.b_should_charge_0007
          @b_should_charge_0007.re_rmb_money=d.b_should_charge_0007
          @b_should_charge_0007.save
        end
        ### 反请求方争议金额
        if d.b_amount!=0
          @b_amount=TbCaseAmount.new()
          @b_amount.recevice_code=d.recevice_code
          @b_amount.general_code=d.general_code
          @b_amount.case_code=d.case_code
          @b_amount.partytype=2
          @b_amount.typ="0001"
          @b_amount.amount_typ="0001"
          @b_amount.currency="0001"
          @b_amount.f_money=d.b_amount
          @b_amount.rmb_money=d.b_amount
          @b_amount.save
          if d.b_amount_rmb!=0
            @b_amount_rmb=TbCaseAmountDetail.new()
            @b_amount_rmb.recevice_code=d.recevice_code
            @b_amount_rmb.general_code=d.general_code
            @b_amount_rmb.case_code=d.case_code
            @b_amount_rmb.partytype=2
            @b_amount_rmb.typ="0001"
            @b_amount_rmb.amount_typ="0001"
            @b_amount_rmb.currency="0001"
            @b_amount_rmb.f_money=d.b_amount_rmb
            @b_amount_rmb.rmb_money=d.b_amount_rmb
            @b_amount_rmb.parent_id=@b_amount.id
            @b_amount_rmb.save
          end
          if d.b_amount_usa!=0
            @b_amount_usa=TbCaseAmountDetail.new()
            @b_amount_usa.recevice_code=d.recevice_code
            @b_amount_usa.general_code=d.general_code
            @b_amount_usa.case_code=d.case_code
            @b_amount_usa.partytype=2
            @b_amount_usa.typ="0001"
            @b_amount_usa.amount_typ="0001"
            @b_amount_usa.currency="0002"
            @b_amount_usa.f_money=d.b_amount_usa
            @b_amount_usa.rate=d.b_rate_usa
            @b_amount_usa.rmb_money=SysArg.round_2(d.b_amount_usa * d.b_rate_usa)
            @b_amount_usa.parent_id=@b_amount.id
            @b_amount_usa.save
          end
          if d.b_amount_hk!=0
            @b_amount_hk=TbCaseAmountDetail.new()
            @b_amount_hk.recevice_code=d.recevice_code
            @b_amount_hk.general_code=d.general_code
            @b_amount_hk.case_code=d.case_code
            @b_amount_hk.partytype=2
            @b_amount_hk.typ="0001"
            @b_amount_hk.amount_typ="0001"
            @b_amount_hk.currency="0003"
            @b_amount_hk.f_money=d.b_amount_hk
            @b_amount_hk.rate=d.b_rate_hk / 100
            @b_amount_hk.rmb_money=SysArg.round_2(d.b_amount_hk * d.b_rate_hk / 100)
            @b_amount_hk.parent_id=@b_amount.id
            @b_amount_hk.save
          end
        end
        ### 反请求不明确争议金额
        if d.b_amount_0002!=0
          @b_amount_0002=TbCaseAmount.new()
          @b_amount_0002.recevice_code=d.recevice_code
          @b_amount_0002.general_code=d.general_code
          @b_amount_0002.case_code=d.case_code
          @b_amount_0002.partytype=2
          @b_amount_0002.typ="0001"
          @b_amount_0002.amount_typ="0002"
          @b_amount_0002.currency="0001"
          @b_amount_0002.f_money=d.b_amount_0002
          @b_amount_0002.rmb_money=d.b_amount_0002
          @b_amount_0002.save
          
          @b_amount_0002_rmb=TbCaseAmountDetail.new()
          @b_amount_0002_rmb.recevice_code=d.recevice_code
          @b_amount_0002_rmb.general_code=d.general_code
          @b_amount_0002_rmb.case_code=d.case_code
          @b_amount_0002_rmb.partytype=2
          @b_amount_0002_rmb.typ="0001"
          @b_amount_0002_rmb.amount_typ="0002"
          @b_amount_0002_rmb.currency="0001"
          @b_amount_0002_rmb.f_money=d.b_amount_0002
          @b_amount_0002_rmb.rmb_money=d.b_amount_0002
          @b_amount_0002_rmb.parent_id=@b_amount_0002.id
          @b_amount_0002_rmb.save
          
        end
        #######
        #######
        ### 请求收费情况信息表
        if d.a_should_charge_0002!=0 or d.a_should_charge_0003!=0
          @a_should_charge=TbShouldCharge.new()
          @a_should_charge.recevice_code=d.recevice_code
          @a_should_charge.general_code=d.general_code
          @a_should_charge.case_code=d.case_code
          @a_should_charge.typ='0001'
          @a_should_charge.payment="0001"
          @a_should_charge.rmb_money=d.a_should_charge_0002 + d.a_should_charge_0003
          @a_should_charge.currency="0001"
          @a_should_charge.f_money=d.a_should_charge_0002 + d.a_should_charge_0003
          @a_should_charge.redu_rmb_money=d.a_reduction
          @a_should_charge.re_rmb_money=d.a_charge - (d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2)
          @a_should_charge.save
          ##
          @a_should_charge_0002=TbShouldCharge.new()
          @a_should_charge_0002.recevice_code=d.recevice_code
          @a_should_charge_0002.general_code=d.general_code
          @a_should_charge_0002.case_code=d.case_code
          @a_should_charge_0002.typ='0002'
          @a_should_charge_0002.payment="0001"
          @a_should_charge_0002.rmb_money=d.a_should_charge_0002
          @a_should_charge_0002.currency="0001"
          @a_should_charge_0002.f_money=d.a_should_charge_0002
          @a_should_charge_0002.parent_id=@a_should_charge.id
          @a_should_charge_0002.save
          ##
          @a_should_charge_0003=TbShouldCharge.new()
          @a_should_charge_0003.recevice_code=d.recevice_code
          @a_should_charge_0003.general_code=d.general_code
          @a_should_charge_0003.case_code=d.case_code
          @a_should_charge_0003.typ='0003'
          @a_should_charge_0003.payment="0001"
          @a_should_charge_0003.rmb_money=d.a_should_charge_0003
          @a_should_charge_0003.currency="0001"
          @a_should_charge_0003.f_money=d.a_should_charge_0003
          @a_should_charge_0003.parent_id=@a_should_charge.id
          @a_should_charge_0003.save
        end
        ### 请求退费情况信息表
        if d.a_refunds!=0
          @a_refunds=TbShouldRefund.new()  
          @a_refunds.recevice_code=d.recevice_code
          @a_refunds.general_code=d.general_code
          @a_refunds.case_code=d.case_code
          @a_refunds.typ="0001"
          @a_refunds.payment="0001"   
          @a_refunds.rmb_money=d.a_refunds
          @a_refunds.currency="0001"
          @a_refunds.f_money=d.a_refunds
          @a_refunds.re_rmb_money=d.a_refunds
          @a_refunds.state=2
          @a_refunds.save
          ##
          @a_refunds_0003=TbShouldRefund.new()  
          @a_refunds_0003.recevice_code=d.recevice_code
          @a_refunds_0003.general_code=d.general_code
          @a_refunds_0003.case_code=d.case_code
          @a_refunds_0003.typ="0003"
          @a_refunds_0003.payment="0001"   
          @a_refunds_0003.rmb_money=d.a_refunds
          @a_refunds_0003.currency="0001"
          @a_refunds_0003.f_money=d.a_refunds
          @a_refunds_0003.parent_id=@a_refunds.id
          @a_refunds_0003.state=2
          @a_refunds_0003.save
        end
        ### 请求方无明确争议金额收费
        if d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2 !=0
          @a_should_charge_0004=TbShouldCharge.new()
          @a_should_charge_0004.recevice_code=d.recevice_code
          @a_should_charge_0004.general_code=d.general_code
          @a_should_charge_0004.case_code=d.case_code
          @a_should_charge_0004.typ='0004'
          @a_should_charge_0004.payment="0001"
          @a_should_charge_0004.rmb_money=d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2
          @a_should_charge_0004.currency="0001"
          @a_should_charge_0004.f_money=d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2
          @a_should_charge_0004.re_rmb_money=d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2
          @a_should_charge_0004.save
          ##
          @a_should_charge_0006=TbShouldCharge.new()
          @a_should_charge_0006.recevice_code=d.recevice_code
          @a_should_charge_0006.general_code=d.general_code
          @a_should_charge_0006.case_code=d.case_code
          @a_should_charge_0006.typ='0006'
          @a_should_charge_0006.payment="0001"
          @a_should_charge_0006.rmb_money=d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2
          @a_should_charge_0006.currency="0001"
          @a_should_charge_0006.f_money=d.a_should_charge_0004  + d.a_should_qt + d.a_should_qt2
          @a_should_charge_0006.parent_id=@a_should_charge_0004.id
          @a_should_charge_0006.save
        end
        ### 请求方 审计费 代收代支
        if d.a_should_charge_0007!=0
          @a_should_charge_0007=TbShouldCharge.new()
          @a_should_charge_0007.recevice_code=d.recevice_code
          @a_should_charge_0007.general_code=d.general_code
          @a_should_charge_0007.case_code=d.case_code
          @a_should_charge_0007.typ='0007'
          @a_should_charge_0007.payment="0001"
          @a_should_charge_0007.rmb_money=d.a_should_charge_0007
          @a_should_charge_0007.currency="0001"
          @a_should_charge_0007.f_money=d.a_should_charge_0007
          @a_should_charge_0007.re_rmb_money=d.a_should_charge_0007
          @a_should_charge_0007.save
        end
        ### 请求方争议金额
        if d.a_amount!=0
          @a_amount=TbCaseAmount.new()
          @a_amount.recevice_code=d.recevice_code
          @a_amount.general_code=d.general_code
          @a_amount.case_code=d.case_code
          @a_amount.partytype=1
          @a_amount.typ="0001"
          @a_amount.amount_typ="0001"
          @a_amount.currency="0001"
          @a_amount.f_money=d.a_amount
          @a_amount.rmb_money=d.a_amount
          @a_amount.save
          if d.a_amount_rmb!=0
            @a_amount_rmb=TbCaseAmountDetail.new()
            @a_amount_rmb.recevice_code=d.recevice_code
            @a_amount_rmb.general_code=d.general_code
            @a_amount_rmb.case_code=d.case_code
            @a_amount_rmb.partytype=1
            @a_amount_rmb.typ="0001"
            @a_amount_rmb.amount_typ="0001"
            @a_amount_rmb.currency="0001"
            @a_amount_rmb.f_money=d.a_amount_rmb
            @a_amount_rmb.rmb_money=d.a_amount_rmb
            @a_amount_rmb.parent_id=@a_amount.id
            @a_amount_rmb.save
          end
          if d.a_amount_usa!=0
            @a_amount_usa=TbCaseAmountDetail.new()
            @a_amount_usa.recevice_code=d.recevice_code
            @a_amount_usa.general_code=d.general_code
            @a_amount_usa.case_code=d.case_code
            @a_amount_usa.partytype=1
            @a_amount_usa.typ="0001"
            @a_amount_usa.amount_typ="0001"
            @a_amount_usa.currency="0002"
            @a_amount_usa.f_money=d.a_amount_usa
            @a_amount_usa.rate=d.a_rate_usa
            @a_amount_usa.rmb_money=SysArg.round_2(d.a_amount_usa * d.a_rate_usa)
            @a_amount_usa.parent_id=@a_amount.id
            @a_amount_usa.save
          end
          if d.a_amount_hk!=0
            @a_amount_hk=TbCaseAmountDetail.new()
            @a_amount_hk.recevice_code=d.recevice_code
            @a_amount_hk.general_code=d.general_code
            @a_amount_hk.case_code=d.case_code
            @a_amount_hk.partytype=1
            @a_amount_hk.typ="0001"
            @a_amount_hk.amount_typ="0001"
            @a_amount_hk.currency="0003"
            @a_amount_hk.f_money=d.a_amount_hk
            @a_amount_hk.rate=d.a_rate_hk / 100
            @a_amount_hk.rmb_money=SysArg.round_2(d.a_amount_hk * d.a_rate_hk / 100)
            @a_amount_hk.parent_id=@a_amount.id
            @a_amount_hk.save
          end
        end
        ### 请求不明确争议金额
        if d.a_amount_0002!=0
          @a_amount_0002=TbCaseAmount.new()
          @a_amount_0002.recevice_code=d.recevice_code
          @a_amount_0002.general_code=d.general_code
          @a_amount_0002.case_code=d.case_code
          @a_amount_0002.partytype=1
          @a_amount_0002.typ="0001"
          @a_amount_0002.amount_typ="0002"
          @a_amount_0002.currency="0001"
          @a_amount_0002.f_money=d.a_amount_0002
          @a_amount_0002.rmb_money=d.a_amount_0002
          @a_amount_0002.save
          
          @a_amount_0002_rmb=TbCaseAmountDetail.new()
          @a_amount_0002_rmb.recevice_code=d.recevice_code
          @a_amount_0002_rmb.general_code=d.general_code
          @a_amount_0002_rmb.case_code=d.case_code
          @a_amount_0002_rmb.partytype=1
          @a_amount_0002_rmb.typ="0001"
          @a_amount_0002_rmb.amount_typ="0002"
          @a_amount_0002_rmb.currency="0001"
          @a_amount_0002_rmb.f_money=d.a_amount_0002
          @a_amount_0002_rmb.rmb_money=d.a_amount_0002
          @a_amount_0002_rmb.parent_id=@a_amount_0002.id
          @a_amount_0002_rmb.save
          
        end
        ### 申请人、申请人代理人
        if d.party!=""
          party_text=d.party
          pp=party_text.split("】【")
          
          agent_text=d.agent
          ab=agent_text.split("』『")
          
          i=0
          pp.each do |p_name|
            @party=TbParty.new()
            @party.recevice_code=d.recevice_code
            @party.general_code=d.general_code
            @party.case_code=d.case_code
            @party.partytype=1
            @party.partyname=p_name.gsub("】","").gsub("【","")
            @party.save
            if ab[i]!=nil
              abab=ab[i].split("][")
              abab.each do |a_name|
                @agent=TbAgent.new()
                @agent.recevice_code=d.recevice_code
                @agent.general_code=d.general_code
                @agent.case_code=d.case_code
                @agent.status="0000"
                @agent.partytype=1
                @agent.party_id=@party.id
                a_name_a=a_name.split("（")
                if a_name_a[0]!=nil
                  @agent.name=a_name_a[0].gsub("『","").gsub("』","").gsub("]","").gsub("[","").gsub("（","").gsub("）","")
                end
                if a_name_a[1]!=nil
                  @agent.company=a_name_a[1].gsub("『","").gsub("』","").gsub("]","").gsub("[","").gsub("（","").gsub("）","")
                end
                if @agent.company==nil or @agent.company==""
                  @agent.company="-"
                end
                @agent.save
              end
            end
            i=i+1
          end
      
        end
        ### 被申请人、被申请人代理人
        if d.b_party!=""
          party_text=d.b_party
          pp=party_text.split("】【")
          
          agent_text=d.b_agent
          ab=agent_text.split("『』")
          
          i=0
          pp.each do |p_name|
            @party=TbParty.new()
            @party.recevice_code=d.recevice_code
            @party.general_code=d.general_code
            @party.case_code=d.case_code
            @party.partytype=2
            @party.partyname=p_name.gsub("】","").gsub("【","")
            @party.save
            if ab[i]!=nil
              abab=ab[i].split("][")
              abab.each do |a_name|
                @agent=TbAgent.new()
                @agent.recevice_code=d.recevice_code
                @agent.general_code=d.general_code
                @agent.case_code=d.case_code
                @agent.status="0000"
                @agent.partytype=2
                @agent.party_id=@party.id
                a_name_a=a_name.split("（")
                if a_name[0]!=nil
                  @agent.name=a_name_a[0].gsub("『","").gsub("』","").gsub("]","").gsub("[","").gsub("（","").gsub("）","")
                end
                if a_name[1]!=nil
                  @agent.company=a_name_a[1].gsub("『","").gsub("』","").gsub("]","").gsub("[","").gsub("（","").gsub("）","")
                end
                if @agent.company==nil or @agent.company==""
                  @agent.company="-"
                end
                @agent.save
              end
            end
            i=i+1
          end
        end
        ###
        
        
        
        
        ### 补充tb_cases表信息
        if @caseorg!=nil
          @case.caseorg_id_first=@caseorg.id
          @case.caseorg_id_last=@caseorg.id
        end
        if @end!=nil
          @case.caseendbook_id_first=@end.id
          @case.caseendbook_id_last=@end.id
        end
        ###
        @case.amount_2=d.b_amount + d.b_amount_0002
        @case.amount_1=d.a_amount + d.a_amount_0002
        @case.amount=@case.amount_1 + @case.amount_2
        ###
        @case.state=280
        @case.save
        d.st=1
        d.save
        
        @caseorg=nil
        @end=nil
      end  
      flash[:notice]="历史数据批量创建成功！"  
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="历史数据批量创建失败！"
      render :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]  
    end
  end
  
#  def destroy
#    DataOldT.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end
end
