class ShouldRefundCheckController < ApplicationController
  
  def list
    s="tb_should_refunds.id,tb_should_refunds.state,tb_should_refunds.recevice_code,tb_should_refunds.case_code,tb_should_refunds.u,tb_should_refunds.typ,tb_should_refunds.payment,tb_should_refunds.partyname,tb_should_refunds.currency,tb_should_refunds.f_money,tb_should_refunds.rate,tb_should_refunds.rmb_money,tb_should_refunds.redu_rmb_money,tb_should_refunds.re_rmb_money,tb_should_refunds.remark,tb_should_refunds.check2_u,tb_should_refunds.check2_dt,tb_should_refunds.check2_remark,tb_should_refunds.check_u,tb_should_refunds.check_dt,tb_should_refunds.check_remark,tb_should_refunds.recall_u,tb_should_refunds.recall_dt"
    c="tb_should_refunds.used='Y' and tb_should_refunds.state=4 and (tb_should_refunds.typ<>'0002' and tb_should_refunds.typ<>'0003' and tb_should_refunds.typ<>'0005'  and tb_should_refunds.typ<>'0006'  ) "
    @should=TbShouldRefund.find(:all,:order=>'tb_should_refunds.recevice_code',:joins=>" inner join tb_cases  on tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_should_refunds.used='Y'",:select=>s,:conditions=>c)
  end  
  
  def edit
     @should=TbShouldRefund.find(params[:id])
  end 
  
  def check
    check=TbShouldRefund.find(params[:id])
    if check.state==4
      check.update_attributes(params[:should])
      check.state=2
      check.re_rmb_money=check.rmb_money - check.redu_rmb_money
      check.check_u=session[:user_code]
      check.check_dt=Time.now()
      if check.save
        if check.typ=='0001' or check.typ=='0004'
          TbShouldRefund.update_all("state=2","parent_id=#{check.id}")
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
  
end
