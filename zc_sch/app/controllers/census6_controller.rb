#niell  2009-07-08 超审限结案时间统计
class Census6Controller < ApplicationController
  #助理使用
  def list6
    @datestyle=params[:datestyle]
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @date1=params[:date1]
    @date2=params[:date2]
    k=params[:k]
    @date3=params[:date3]
    if k!=nil
      asst=params[:k][:asst]
    end
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list6"
    end
    if @datestyle=='01' #立案时间段
      @case=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and clerk='#{asst}' and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    elsif @datestyle=='02' #结案时间段
      @case=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and clerk='#{asst}' and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    elsif @datestyle=='03' #立案结案时间段
      @case=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and clerk='#{asst}' and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    else
    end
  end
  #处长使用
  def list61
    @datestyle=params[:datestyle]
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @date1=params[:date1]
    @date2=params[:date2]
    @date3=params[:date3]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list6"
    end
    if @datestyle=='01' #立案时间段
      @case=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'  and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    elsif @datestyle=='02' #结案时间段
      @case=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'  and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    elsif @datestyle=='03' #立案结案时间段
      @case=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'  and datediff(end_date,nowdate)>'#{@date3}'",:order=>"recevice_code")
    else
    end
  end
end
