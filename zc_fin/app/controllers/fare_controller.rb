=begin
创建人：聂灵灵
创建时间：2009-6-3
描述：实体类是TbFare,table是tb_fares
此类主要实现案件收费快算的计算(fare下的fare_list页面)
=end
class FareController < ApplicationController
  def fare_list
    @total_money=params[:total_money]
    if params[:j]!=nil
      @n=params[:j][:cost_type]
      ntype=params[:j][:cost_type]
    end
    cost=Cost.new
    @cost=0.0
    @cost2=0.0
    #    flash[:notice]="请输入金额、选择费用类型!"
    if @total_money==nil || @total_money=="" || @total_money.to_i<0
      flash[:notice]="请输入金额!"
      render :action=>"fare_list"
    else
      if ntype=="0001"
        flash[:notice]=""
        @m=@total_money.to_f
        #  @cost: 受理费;   @cost2: 处理费
        @cost=cost.get_01_01(@m)
        @cost2=cost.get_01_02(@m)
      elsif ntype=="0002"  #涉外案件
        flash[:notice]=""
        @m=@total_money.to_f
        @cost=cost.get_02_02(@m)  #仲裁费
        @cost2=cost.get_02_01(@m)  #立案费
      else   #ntype=="0003"  金融案件
        flash[:notice]=""
        @m=@total_money.to_f
        @cost=cost.get_03_02(@m)  #仲裁费
        @cost2=cost.get_03_01(@m)  #立案费
      end
    end
  end
  
end
