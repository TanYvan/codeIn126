=begin
创建人：聂灵灵
创建时间：2009-6-4
类的描述：此类是处理案件费用减交页面的信息及维护。
页面：
案件费用减交信息列表:/reduction/reduction_list
创建案件费用减交信息：/reduction/reduction_new
修改案件费用减交信息：/reduction/reduction_edit
=end
class ReductionController < ApplicationController
  def rate_set 
    render :update do |page|
      page.remove 'reduction_rate'
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
      page.remove 'reduction_counselor'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  
  def reduction_list
    @con= {"0001"=>"申请人","0002"=>"被申请人","0003"=>"申请方代理人","0004"=>"被申请方代理人"}
    @case=nil#当前办理案件
    if session[:recevice_code_4]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_4])
      c="recevice_code='#{session[:recevice_code_4]}' and used='Y'"
      @reduction=TbReduction.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def should_charge_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006' and typ<>'0009'"
    @should=TbShouldCharge.find(:all,:order=>'payment,id',:conditions=>c)
  end
     
  def reduction_new
    @should_charge=TbShouldCharge.find(params[:id])
    @reduction=TbReduction.new()
    @reduction.should_charge_id=params[:id]
    @reduction.consultant=@should_charge.payment
    @reduction.typ=@should_charge.typ
    @reduction.currency=@should_charge.currency
    @reduction.f_money=@should_charge.f_money
    @reduction.rate=@should_charge.rate
    @reduction.rmb_money=@should_charge.rmb_money
    @reduction.receptionist=session[:user_code]
    @reduction.apply_date = Date.today
  end

  def reduction_create
    @reduction=TbReduction.new(params[:reduction])
    @reduction.recevice_code=session[:recevice_code_4]
    @reduction.case_code=session[:case_code_4]
    @reduction.general_code=session[:general_code_4]
    @reduction.u=session[:user_code]
    @reduction.u_t=Time.now()
    if @reduction.save
      @should_charge=TbShouldCharge.find(@reduction.should_charge_id)
      r_sum=TbReduction.sum(:rmb_money,:conditions=>"used='Y' and should_charge_id='#{@reduction.should_charge_id}'")
      if r_sum==nil
        r_sum=0
      end
      @should_charge.redu_rmb_money=r_sum
      @should_charge.save
      @reduction.payment=@should_charge.payment
      @case= TbCase.find_by_recevice_code(@reduction.recevice_code)
      if @reduction.typ == "0001" or @reduction.typ == "0004"
        if @case.aribitprog_num != '0001' and @case.aribitprog_num != '0002'
          @reduction.rmb_money_0003 = @reduction.rmb_money
        else
          scale_1 = TbShouldCharge.sum(:rmb_money, :conditions => "used='Y' and recevice_code='#{@reduction.recevice_code}' and (typ = '0002' or typ = '0005')")
          scale_2 = TbShouldCharge.sum(:rmb_money, :conditions => "used='Y' and recevice_code='#{@reduction.recevice_code}' and (typ='0002' or  typ='0003' or typ='0005' or  typ='0006')")
          if scale_1 == nil
            scale_1 = 0
          end
          if scale_2 == nil
            scale_2 = 0
          end
          if scale_2 == 0
            scale = 0
          else
            scale = scale_1 / scale_2
          end
          @reduction.rmb_money_0002 = (@reduction.rmb_money * scale ).round
          @reduction.rmb_money_0003 = @reduction.rmb_money - @reduction.rmb_money_0002
        end
        @reduction.save
      end
      flash[:notice]="创建成功"
      redirect_to :action=>"reduction_list"
    else
      render :action=>"reduction_new"
    end
  end

  def reduction_edit
    @reduction=TbReduction.find(params[:id])
    @partyid=@reduction.counselor
    @partyname=TbParty.find(:first,:conditions=>["id = ?",@partyid]).partyname
  end

  def reduction_update
    @reduction=TbReduction.find(params[:id])
    @reduction.u=session[:user_code]
    @reduction.u_t=Time.now()
    if @reduction.update_attributes(params[:reduction])
      flash[:notice]="修改成功"
      redirect_to :action=>"reduction_list"
    else
      flash[:notice]="修改失败"
      render :action=>"reduction_edit",:id=>params[:id]
    end
  end


  def reduction_edit_2
    @reduction=TbReduction.find(params[:id])
  end

  def reduction_update_2
    @reduction=TbReduction.find(params[:id])
    @reduction.u=session[:user_code]
    @reduction.u_t=Time.now()
    if @reduction.update_attributes(params[:reduction])
      flash[:notice]="修改成功"
      redirect_to :action=>"reduction_list"
    else
      flash[:notice]="修改失败"
      render :action=>"reduction_edit_2",:id=>params[:id]
    end
  end

  def reduction_delete
    @reduction=TbReduction.find(params[:id])
    @reduction.used="N"
    @reduction.u=session[:user_code]
    @reduction.u_t=Time.now()
    if @reduction.save
      @should_charge=TbShouldCharge.find(@reduction.should_charge_id)
      r_sum=TbReduction.sum(:rmb_money,:conditions=>"used='Y' and should_charge_id='#{@reduction.should_charge_id}'")
      if r_sum==nil
        r_sum=0
      end
      @should_charge.redu_rmb_money=r_sum
      @should_charge.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"reduction_list"
  end
  
  def should_charge_view
    @should_charge=TbShouldCharge.find(params[:id])
  end
  
end
