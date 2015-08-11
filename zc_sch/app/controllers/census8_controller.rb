#niell 2009-7-9 实际开支费用统计
class Census8Controller < ApplicationController
  def list8
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @dispute2={"01"=>"全部","02"=>"是","03"=>"否"} #结案与否
    @datestyle=params[:datestyle]
    @date1=params[:date1]
    @date2=params[:date2]
    @endcase=params[:endcase]
    k=params[:k]
    j=params[:j]
    @amout1=params[:amout1]
    @amout2=params[:amout2]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list8"
    end
    if k!=nil and j!=nil
      endstyle=params[:k][:endstyle]
      aribitprog_num=params[:j][:prog]
    end
    if @amout1==nil or @amout2==nil
#      flash[:notice]="请输入金额！"
      render :action=>"list8"
    elsif  @amout1>@amout2
      flash[:notice]="请输入正确的金额！"
      render :action=>"list8"
    else
    end
    #立案时间段
    if @datestyle=='01'
       #1 结案方式:全部 ,结案与否：全部,仲裁程序：全部
      if @endcase=='01' && endstyle=='1' && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' 
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'")
          #收入----实收
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' 
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' 
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        else
        end
        #2 结案方式:结案 ,结案与否：是,仲裁程序：每种仲裁程序类别
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil && aribitprog_num!=nil && aribitprog_num!='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges,tb_caseendbooks
          where tb_cases.used='Y' and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_caseendbooks.used='Y'
          and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}' 
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
           and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y' 
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code 
           and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_caseendbooks.used='Y'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
        else
        end
      #3  结案方式:每种方式 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'   and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges,tb_caseendbooks
          where tb_cases.used='Y' and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_caseendbooks.used='Y'
           and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
            and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
            and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'   and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_caseendbooks.used='Y'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.recevice_code=tb_caseendbooks.recevice_code
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
        else
        end
      #4  结案方式:全部 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and and tb_cases.state>=100
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        else
        end
      #5  结案方式:全部 ,结案与否：是, 仲裁程序：每种仲裁程序
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num!=nil && aribitprog_num!='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}' 
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and and tb_cases.state>=100
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}'")
        else
        end
      end
      #结案时间段
    elsif @endcase=='02'
      #1 结案方式:全部 ,结案与否：全部,仲裁程序：全部
      if @endcase=='01' && endstyle=='1' && aribitprog_num=='1' 
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' 
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' 
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil  #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        else
        end
      #2 结案方式: 每种方式,结案与否：是 ，仲裁程序：每种仲裁程序类型
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil && aribitprog_num!=nil && aribitprog_num!='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_caseendbooks,tb_should_charges
          where  tb_cases.recevice_code=tb_caseendbooks.recevice_code  and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' 
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' 
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
        else
        end
      #3  结案方式:每种方式 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil  #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_caseendbooks,tb_should_charges
          where  tb_cases.recevice_code=tb_caseendbooks.recevice_code  and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_charges.recevice_code=tb_should_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'   and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'   and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.end_t>='#{@date1}' and tb_cases.state>=100
          and tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
        else
        end
      #4  结案方式:全部 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where  tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil  #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        else
        end
      #5  结案方式:全部 ,结案与否：是, 仲裁程序：每种仲裁程序
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num!=nil && aribitprog_num!='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_should_charges
          where tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
          tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil  #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y' and tb_charges.state=2")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and tb_cases.state>=100
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}'  and tb_cases.state>=100 and
          tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}'")
        else
        end
      else
      end
      #立案结案时间段
    elsif @endcase=='03'
      #1 结案方式:全部 ,结案与否：全部,仲裁程序：全部
      if @endcase=='01' && endstyle=='1' && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where  tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}' 
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        else
        end
       #2 结案方式:结案 ,结案与否：是,仲裁程序：每种仲裁程序类别
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil && aribitprog_num!=nil && aribitprog_num!='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_cases,tb_caseendbooks,tb_should_charges
          where tb_cases.recevice_code=tb_caseendbooks.recevice_code  and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' and tb_caseendbooks.endStyle='#{endstyle}'")
        else
        end
      #3  结案方式:每种方式 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle!='1' && endstyle!=nil &&  aribitprog_num=='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_charges
          where tb_cases.recevice_code=tb_caseendbooks.recevice_code  and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'   and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_caseendbooks,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'  and tb_caseendbooks.endStyle='#{endstyle}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_caseendbooks.endStyle='#{endstyle}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases,tb_caseendbooks
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.recevice_code=tb_caseendbooks.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.state>=100
          and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'  and tb_caseendbooks.endStyle='#{endstyle}'")
        else
        end
      #4  结案方式:全部 ,结案与否：是, 仲裁程序：全部
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num=='1'
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where  and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.state>=100 ")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.state>=100")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.state>=100")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.state>=100
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.state>=100")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.state>=100")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100")
        else
        end
      #5  结案方式:全部 ,结案与否：是, 仲裁程序：每种仲裁程序
      elsif @endcase=='02' && endstyle=='1' && aribitprog_num!='1' && aribitprog_num!=nil
        if @amout1==nil or @amout2==nil #未输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
              and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_cases.used='Y' and tb_cases.state>=100
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.state>=100  and tb_cases.aribitprog_num='#{aribitprog_num}'")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}'  and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
        elsif @amout1!=nil and @amout2!=nil #输入争议金额段
          @partytype=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.aribitprog_num='#{aribitprog_num}' 
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.state>=100")
          #收入
          @recome=TbShouldCharge.find_by_sql("select sum(tb_should_charges.re_rmb_money) as dd from tb_case_amounts,tb_cases,tb_should_charges
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_should_charges.recevice_code=tb_cases.recevice_code and tb_should_charges.used='Y'")
          #应退
          @should_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as ff from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.aribitprog_num='#{aribitprog_num}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=1 and tb_should_refunds.state=2 and tb_cases.state>=100")
          #已退
          @has_refund=TbShouldRefund.find_by_sql("select sum(tb_should_refunds.rmb_money) as hh from tb_case_amounts,tb_cases,tb_should_refunds
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
          and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'
          and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_should_refunds.used='Y' and
          tb_should_refunds.state=2 and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype1=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}'  and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}'")
          @partytype2=TbCaseAmount.find_by_sql("select sum(tb_case_amounts.rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_cases.end_t>='#{@date1}' and tb_cases.end_t<='#{@date2}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
          and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.state>=100 and tb_cases.aribitprog_num='#{aribitprog_num}' ")
        else
        end
      end
    else
    end



  end
end
