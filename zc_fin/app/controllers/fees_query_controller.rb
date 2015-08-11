class FeesQueryController < ApplicationController
  
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    c="state>=4 and state<100 and clerk='#{session[:user_code]}'"
    @case=TbCase.find(:all,:order=>@order,:conditions=>c)
  end
  
  def detail
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @charge=TbShouldCharge.find(:all,:order=>'payment,id',:conditions=>c)
    end
    
    @state={1=>"未确认",2=>"出纳已确认",3=>"已招回",4=>"处长已确认"}
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @refund=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
    end
    
  end
  
  def detail_1
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @charge=TbShouldCharge.find(:all,:order=>'payment,id',:conditions=>c)
    end
  end
  
  def detail_2
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @state={1=>"未确认",2=>"出纳已确认",3=>"已招回",4=>"处长已确认"}
      @refund=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
    end    
  end
  
end
