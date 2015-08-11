#2009-7-13  niell  财务统计
class FinanceController < ApplicationController
  def list1
    @datestyle=params[:datestyle]
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil and @date2==nil
      @date1=Date.today
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list1"
    end
    k=params[:k]
    j=params[:j]
    if k!=nil and j!=nil
      assistant=params[:k][:assistant]
      prog=params[:j][:prog]
    end
    #立案时间段
    if @datestyle=='01'
      if prog=='1' or prog==nil #仲裁程序选择全部
        @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and clerk='#{assistant}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      else   #仲裁程序为字典表中的
        @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and clerk='#{assistant}' and aribitprog_num='#{prog}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      end
    #结案时间段
    elsif @datestyle=='02'
      if prog=='1' or prog==nil #仲裁程序选择全部
        @case=TbCase.find(:all,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{assistant}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      else   #仲裁程序为字典表中的
        @case=TbCase.find(:all,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{assistant}' and aribitprog_num='#{prog}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      end
    #立案结案时间段
    elsif @datestyle=='03'
      if prog=='1' or prog==nil #仲裁程序选择全部
        @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}'  and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{assistant}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      else   #仲裁程序为字典表中的
        @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}'  and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{assistant}' and aribitprog_num='#{prog}'",:group=>"recevice_code",:select=>"recevice_code,case_code,clerk",:order=>"recevice_code")
      end
    else
    end

  end
end
