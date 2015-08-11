class ExpendDetailCheck2Controller < ApplicationController
  def list
    s="tb_expend_details.*"
    c="tb_cases.used='Y' and tb_expend_details.used='Y' and tb_expend_details.state=1 "
    @should=TbExpendDetail.find(:all,:order=>'tb_expend_details.recevice_code',:joins=>" inner join tb_cases  on tb_expend_details.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_expend_details.used='Y'",:select=>s,:conditions=>c)
  end

  def edit
     @should=TbExpendDetail.find(params[:id])
  end

  def check
    check=TbExpendDetail.find(params[:id])
    if check.state==1
      check.update_attributes(params[:should])
      check.state=4
      check.check2_u=session[:user_code]
      check.check2_dt=Time.now()
      if check.save
        flash[:notice]="支出确认成功！"
      else
        flash[:notice]="支出确认失败！"
      end
    else
      flash[:notice]="支出确认失败！"
    end
    redirect_to :action=>"list"
  end
  
end
