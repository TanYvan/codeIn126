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
    if @date3==nil or @date3==""
      @date3="1"
    end
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
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.clerk='#{asst}' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
    elsif @datestyle=='02' #结案时间段
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.clerk='#{asst}' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
    elsif @datestyle=='03' #立案结案时间段
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.clerk='#{asst}' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
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
    if @date3==nil or @date3==""
      @date3="1"
    end
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list61"
    end
    if @datestyle=='01' #立案时间段
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
    elsif @datestyle=='02' #结案时间段
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
    elsif @datestyle=='03' #立案结案时间段
      @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and datediff(b.decideDate,ca.finally_limit_dat)>'#{@date3}'",:order=>"ca.recevice_code,ca.clerk,ca.nowdate,b.decideDate")
    else
    end
  end
end
