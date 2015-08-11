class ShouldChargeQueryController < ApplicationController
  def list
    @v1=params[:v1]
    @v2=params[:v2]
    if @v1==nil or @v2==nil
      @should=nil
    else
      @should=TbShouldCharge.find_by_sql("select distinct recevice_code as recevice_code  from tb_should_charges where used='Y' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'  and (rmb_money - redu_rmb_money - re_rmb_money)>=#{@v1}  and (rmb_money - redu_rmb_money - re_rmb_money)<=#{@v2}   order by recevice_code")
    end
  end
end
