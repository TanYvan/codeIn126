#2009-7-13  niell  财务统计
class FinanceController < ApplicationController
  def list1
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @datestyle=params[:datestyle]
    if @datestyle==nil
      @datestyle='01'
    end
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list1"
    end
    @assistant=params[:assistant]
    if @assistant==nil
      @assistant="1"
    end
    @prog=params[:prog]
    if @prog==nil
      @prog="1"
    end
    #立案时间段
    if @datestyle=='01'
      if @prog=='1' or @prog==nil #仲裁程序选择全部
        if @assistant=="1"
          @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}'",:select=>"recevice_code,case_code,clerk,general_code",:per_page=>@page_lines.to_i)
        else
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and clerk='#{@assistant}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        end
      else   #仲裁程序为字典表中的
        if @assistant=="1"
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and aribitprog_num='#{@prog}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        else
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and clerk='#{@assistant}' and aribitprog_num='#{@prog}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        end
      end
    #结案时间段
    elsif @datestyle=='02'
      if @prog=='1' or @prog==nil #仲裁程序选择全部
        if @assistant=="1"
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        else
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{@assistant}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        end
      else   #仲裁程序为字典表中的
        if @assistant=="1"
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}' and aribitprog_num='#{@prog}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        else
          @case_pages,@case=paginate(:tb_cases,:conditions=>"used='Y' and end_t>='#{@date1}' and end_t<='#{@date2}' and clerk='#{@assistant}' and aribitprog_num='#{@prog}'",:select=>"recevice_code,case_code,clerk,general_code",:order=>@order,:per_page=>@page_lines.to_i)
        end
      end
    #立案结案时间段
    elsif @datestyle=='03'
      if @prog=='1' or @prog==nil #仲裁程序选择全部
        if @assistant=="1"
          sql="select c.recevice_code as recevice_code,c.case_code as case_code,c.clerk as clerk,c.general_code as general_code from tb_cases as c,tb_caseendbooks as s on c.used='Y' and c.nowdate>='#{@date1}' and c.nowdate<='#{@date2}' and c.caseendbook_id_first=s.id and s.used='Y' and s.decideDate>='#{@date1}' and s.decideDate<='#{@date2}' order by #{@order}"
          @case_pages,@case=paginate_by_sql(TbCase,sql,@page_line.to_i)
        else
          sql="select c.recevice_code as recevice_code,c.case_code as case_code,c.clerk as clerk,c.general_code as general_code from tb_cases as c,tb_caseendbooks as s on c.used='Y' and c.nowdate>='#{@date1}' and c.nowdate<='#{@date2}' and c.clerk='#{@assistant}' and c.caseendbook_id_first=s.id and s.used='Y' and s.decideDate>='#{@date1}' and s.decideDate<='#{@date2}' order by #{@order}"
          @case_pages,@case=paginate_by_sql(TbCase,sql,@page_line.to_i)
        end
      else   #仲裁程序为字典表中的
        if @assistant=="1"
          sql="select c.recevice_code as recevice_code,c.case_code as case_code,c.clerk as clerk,c.general_code as general_code from tb_cases as c,tb_caseendbooks as s on c.used='Y' and c.nowdate>='#{@date1}' and c.nowdate<='#{@date2}' and c.aribitprog_num='#{@prog}' and c.caseendbook_id_first=s.id and s.used='Y' and s.decideDate>='#{@date1}' and s.decideDate<='#{@date2}' order by #{@order}"
          @case_pages,@case=paginate_by_sql(TbCase,sql,@page_line.to_i)
        else
          sql="select c.recevice_code as recevice_code,c.case_code as case_code,c.clerk as clerk,c.general_code as general_code from tb_cases as c,tb_caseendbooks as s on c.used='Y' and c.nowdate>='#{@date1}' and c.nowdate<='#{@date2}' and c.aribitprog_num='#{@prog}' and c.clerk='#{@assistant}' and c.caseendbook_id_first=s.id and s.used='Y' and s.decideDate>='#{@date1}' and s.decideDate<='#{@date2}' order by #{@order}"
          @case_pages,@case=paginate_by_sql(TbCase,sql,@page_line.to_i)
        end
      end
    end

  end
end
