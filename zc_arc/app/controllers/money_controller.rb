=begin
创建人：聂灵灵
创建时间：2009-5-12
类的描述：此控制器是处理管理员页面的币种信息及汇率维护。可以选择创建不同的币种及修改删除币种信息。
页面：
币种信息列表:/money/list
创建币种信息：/money/new
修改币种信息：/money/edit
汇率修改：/money/edit_rate
=end
class MoneyController < ApplicationController
  
  def list
    @money=Money.find(:all,:order=>"code",:conditions=>"used='Y'")
  end
  def new
    @money=Money.new()
  end
  def create
     @money=Money.new(params[:money])
     @money.u=session[:user_code]
     @money.u_t=Time.now()
     @moneylog=MoneyLog.new()
     @moneylog.code=params[:money][:code]
     @moneylog.name=params[:money][:name]
      @moneylog.rate=params[:money][:rate]
     @moneylog.u=session[:user_code]
     @moneylog.u_t=Time.now()
     if @money.save and @moneylog.save!
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
     else
       flash[:notice]="创建失败"
       render :action=>"new"
     end
  end

  def edit
     @money=Money.find(params[:id])
  end

  def update
     @money=Money.find(params[:id])
     @money.u=session[:user_code]
     @money.u_t=Time.now()
    @moneylog=MoneyLog.new()
    @moneylog.code=params[:money][:code]
    @moneylog.name=params[:money][:name]
    @moneylog.rate=@money.rate
    @moneylog.u=session[:user_code]
    @moneylog.u_t=Time.now()
     if @money.update_attributes(params[:money]) and @moneylog.save!
        flash[:notice]="修改成功"
        redirect_to :action=>"list"
     else
        flash[:notice]="修改失败"
        render :action=>"edit"
     end
  end

  def money_delete
     @money=Money.find(params[:id])
     @money.used="N"
     @money.u=session[:user_code]
     @money.u_t=Time.now()
     if @money.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list"
  end
  #汇率的修改
  def edit_rate
    @money=Money.find(params[:id])    
    @moneylog=MoneyLog.new()
    @moneylog.code=@money.code
    @moneylog.name=@money.name
    @moneylog.rate = @money.rate
  end

  def rate_update
    @money=Money.find(params[:id])
    @money.u=session[:user_code]
    @money.u_t=Time.now()
    @money.rate = params[:moneylog][:rate]
    @moneylog=MoneyLog.new()
    @moneylog.code=@money.code
    @moneylog.name=@money.name
    @moneylog.rate = params[:moneylog][:rate]
    @moneylog.u=session[:user_code]
    @moneylog.u_t=Time.now()
    if @money.save 
       @moneylog.save
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit_rate"
    end
  end
  #汇率修改记录
  def log_rate
    @money=Money.find(params[:id])
    code=@money.code
    @moneylog=MoneyLog.find(:all,:conditions=>"code=#{code}",:order=>"u_t desc")
  end
end
