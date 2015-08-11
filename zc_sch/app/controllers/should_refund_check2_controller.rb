class ShouldRefundCheck2Controller < ApplicationController
  def list
    c="used='Y' and state=1 and (typ<>'0002' and typ<>'0003' and typ<>'0005'  and typ<>'0006'  ) and (rmb_money - redu_rmb_money)<>0"
    @should=TbShouldRefund.find(:all,:order=>'recevice_code',:conditions=>c)
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
  
end
