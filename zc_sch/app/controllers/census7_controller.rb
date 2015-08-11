#2009-7-9 niell 费用统计
class Census7Controller < ApplicationController
  def list7
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @dispute2={"01"=>"全部","02"=>"是","03"=>"否"} #结案与否
    @dispute3={"01"=>"全部","02"=>"本请求","03"=>"反请求"} #争议金额类型
    @datestyle=params[:datestyle]
    @date1=params[:date1]
    @date2=params[:date2]
    @endcase=params[:endcase]
    @moneytype=params[:moneytype]
    @amout1=params[:amout1]
    @amout2=params[:amout2]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list7"
    end
    if @amout1==nil or @amout2==nil
#      flash[:notice]="请输入金额！"
      render :action=>"list7"
    elsif  @amout1>@amout2
      flash[:notice]="请输入正确的金额！"
      render :action=>"list7"
    
      #立案时间段
      if @datestyle=='01'
        #结案的和不结案的，本请求和反请求的争议金额
        if @endcase=='01'
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
              and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}'")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' 
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_case_amounts.used='Y' and tb_cases.used='Y'
              and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' 
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          
          end
        elsif @endcase=='02' #结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.nowdate<='#{@date2}'  and tb_cases.end_u!=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'  and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u!=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
           
            end
          elsif  @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'  and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          elsif @moneytype=='03'
            @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
          where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
          tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
          tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
          
          end
        elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.nowdate<='#{@date2}'  and tb_cases.end_u=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}'  and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and 
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.nowdate>='#{@date1}' and
              tb_cases.nowdate<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          
          end
        
        end
        #结案时间段
      elsif @datestyle=='02'
        #结案的和不结案的，本请求和反请求的争议金额
        if @endcase=='01'
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}'")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' 
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' 
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' 
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' 
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          
          end
        elsif @endcase=='02' #结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}'  and tb_cases.end_u!=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u!=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          
          end
        elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and  tb_cases.end_u=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and 
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u=''")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and 
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          
          end
        
        end
        #立案结案时间段
      elsif @datestyle=='03'
        #结案的和不结案的，本请求和反请求的争议金额
        if @endcase=='01'
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
                where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
                tb_cases.end_t<='#{@date2}'")
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
                where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
                tb_cases.end_t<='#{@date2}'
                and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
                where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
                tb_cases.end_t<='#{@date2}'
                and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'")
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' 
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}'
              and tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y'")
            
            end
          
          end
        elsif @endcase=='02' #结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and  tb_cases.end_u!=''")
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u!=''")
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u!=''")
            
            end
          
          end
        elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
          if @moneytype=='01'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and  tb_cases.end_u=''")
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
               @partytype=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and tb_case_amounts.used='Y' and tb_cases.used='Y' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and tb_cases.end_u=''")
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='02'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}'  and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
              @partytype1=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='1' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          elsif @moneytype=='03'
            if @amout1==nil or @amout2==nil #无争议金额段
                @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and 
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            elsif @amout!=nil and @amout!=nil  #有争议金额段
               @partytype2=TbCaseAmount.find_by_sql("select sum(rmb_money) as aa,count(tb_cases.id) as cc from tb_case_amounts,tb_cases
              where tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_case_amounts.recevice_code=tb_cases.recevice_code and tb_cases.end_t>='#{@date1}' and
              tb_cases.end_t<='#{@date2}' and tb_case_amounts.rmb_money>='#{@amout1}' and tb_case_amounts.rmb_money<='#{@amout2}' and
              tb_case_amounts.partytype='2' and tb_case_amounts.used='Y' and tb_cases.used='Y' and tb_cases.end_u=''")
            
            end
          
          end
        
        end
      
      end

    end
    
  end
end
