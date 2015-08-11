#因减少争议金额引起的退费信息-----修改
class ChargebackController < ApplicationController
  def rate_set
    render :update do |page|
      page.remove 'chargeback_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end

  def p_set
    if params[:p_typ]=='0001'
      typ2=TbParty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'",:order=>'id',:select=>"id as id ,partyname as name")
    elsif params[:p_typ]=='0002'
      typ2=TbParty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'",:order=>'id',:select=>"id as id,partyname as name")
    elsif params[:p_typ]=='0003'
      typ2=TbAgent.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'",:order=>'id',:select=>"id,name")
    elsif params[:p_typ]=='0004'
      typ2=TbAgent.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'",:order=>'id',:select=>"id,name")
    end
    render :update do |page|
      page.remove 'chargeback_counselor'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end

  def chargeback_list
    @con= {"0001"=>"申请人","0002"=>"被申请人","0003"=>"申请方代理人","0004"=>"被申请方代理人"}
    @case=nil#当前办理案件
    if session[:recevice_code_4]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_4])
      c="recevice_code='#{session[:recevice_code_4]}' and used='Y'"
      @chargeback=TbChargeback.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def should_refund_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006' and state=1"
    @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
  end

  def chargeback_new
    @should=TbShouldRefund.find(params[:id])
    @chargeback=TbChargeback.new()
    @chargeback.should_refund_id=params[:id]
    @chargeback.consultant=@should.payment
    @chargeback.typ=@should.typ
    @chargeback.currency=@should.currency
    @chargeback.f_money=@should.f_money
    @chargeback.rate=@should.rate
    @chargeback.rmb_money=@should.rmb_money
    @chargeback.receptionist=session[:user_code]
    @chargeback.apply_date = Date.today
  end

  def chargeback_create
    @chargeback=TbChargeback.new(params[:chargeback])
    @chargeback.recevice_code=session[:recevice_code_4]
    @chargeback.case_code=session[:case_code_4]
    @chargeback.general_code=session[:general_code_4]
    @chargeback.u=session[:user_code]
    @chargeback.u_t=Time.now()
    if @chargeback.save
      @should_charge=TbShouldRefund.find(@chargeback.should_refund_id)
      r_sum=TbChargeback.sum(:rmb_money,:conditions=>"used='Y' and should_refund_id='#{@chargeback.should_refund_id}'")
      if r_sum==nil
        r_sum=0
      end
      @should_charge.redu_rmb_money=r_sum
      @should_charge.save
      flash[:notice]="创建成功"
      redirect_to :action=>"chargeback_list"
    else
      render :action=>"chargeback_new"
    end
  end
  
  def chargeback_delete
    @chargeback=TbChargeback.find(params[:id])
    @chargeback.used="N"
    @chargeback.u=session[:user_code]
    @chargeback.u_t=Time.now()
    if @chargeback.save
      @should=TbShouldRefund.find(@chargeback.should_refund_id)
      r_sum=TbChargeback.sum(:rmb_money,:conditions=>"used='Y' and should_refund_id='#{@chargeback.should_refund_id}'")
      if r_sum==nil
        r_sum=0
      end
      @should.redu_rmb_money=r_sum
      @should.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"chargeback_list"
  end

  def should_refund_view
    @should=TbShouldRefund.find(params[:id])
  end
end
