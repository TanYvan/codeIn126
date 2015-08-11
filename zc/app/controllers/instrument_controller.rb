=begin
创建人：聂灵灵
创建时间：2009-6-2
描述：实体类是TbInstrument,table是tb_instruments
此类主要实现文书签字的创建(instrument下的instrument_new页面)，
修改(instrument下的instrument_edit页面)，
列表显示(instrument下的instrument_list页面)功能,
修改为裁决书校核信息填写 2010-5-13
=end
class InstrumentController < ApplicationController
  def instrument_list
    @state={"0001"=>"不签字","0002"=>"签字"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @instrument_pages,@instrument=paginate(:tb_instruments,:order=>'id',:conditions=>c)
    end
  end

  def instrument_new
    @instrument=TbInstrument.new()
  end
  #创建文书签字
  def instrument_create
    @instrument=TbInstrument.new(params[:instrument])
    @instrument.recevice_code=session[:recevice_code]
    @instrument.case_code=session[:case_code]
    @instrument.general_code=session[:general_code]
    @instrument.u=session[:user_code]
    @instrument.u_t=Time.now()
    if @instrument.save
      flash[:notice]="创建成功"
      redirect_to :action=>"instrument_list"
    else
      flash[:notice]="创建失败"
      render :action=>"instrument_new"
    end
  end

  def instrument_edit
    @instrument=TbInstrument.find(params[:id])
  end

  def instrument_update
    @instrument=TbInstrument.find(params[:id])
    @instrument.u=session[:user_code]
    @instrument.u_t=Time.now()
    if @instrument.update_attributes(params[:instrument])
      flash[:notice]="修改成功"
      redirect_to :action=>"instrument_list"
    else
      flash[:notice]="修改失败"
      render :action=>"instrument_edit",:id=>params[:id]
    end
  end

  def instrument_delete
    @instrument=TbInstrument.find(params[:id])
    @instrument.used="N"
    @instrument.u=session[:user_code]
    @instrument.u_t=Time.now()
    if @instrument.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"instrument_list"
  end
end
