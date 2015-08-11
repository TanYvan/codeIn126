#2009-7-9  费用统计
class Census7Controller < ApplicationController
  def list7
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @dispute2={"01"=>"全部","02"=>"是","03"=>"否"} #结案与否
    @dispute3={"01"=>"全部","02"=>"本请求","03"=>"反请求"} #争议金额类型
    @datestyle=params[:datestyle]
    if params[:datestyle]==nil
      @datestyle='01'
    end
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    @endcase=params[:endcase]
    if params[:endcase]==nil
      @endcase='01'
    end
    @moneytype=params[:moneytype]
    if params[:moneytype]==nil
      @moneytype='01'
    end
    @amout1=params[:amout1]
    @amout2=params[:amout2]
    if params[:amout1]==''
      @amout1=0
    else
      @amout1=@amout1.to_i
    end
    if params[:amout2]==''
      @amout2=0
    else
      @amout2=@amout2.to_i
    end
    
    p=PubTool.new()
    if p.sql_check_3(@datestyle)!=false and p.sql_check_3(@date1)!=false and p.sql_check_3(@date2)!=false and p.sql_check_3(@endcase)!=false and p.sql_check_3(@moneytype)!=false and p.sql_check_3(@amout1)!=false and p.sql_check_3(@amout2)!=false 
        
        if @date1>@date2
          flash[:notice]="时间选择错误，请重新选择！"
          render :action=>"list7"
        end
          #立案时间段
          if @datestyle=='01'
            #结案的和不结案的，本请求和反请求的争议金额
            if @endcase=='01'
                  @n=TbCase.find_by_sql("select count(tb_cases.id) as cc from tb_cases where
                  tb_cases.used='Y' and tb_cases.nowdate>='#{@date1}' and tb_cases.nowdate<='#{@date2}' and tb_cases.amount>='#{@amout1}' and tb_cases.amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where nowdate>='#{@date1}' and
                  nowdate<='#{@date2}' and used='Y' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where nowdate>='#{@date1}' and
                  nowdate<='#{@date2}' and used='Y' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y'
                  and nowdate>='#{@date1}' and nowdate<='#{@date2}' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where nowdate>='#{@date1}' and
                  nowdate<='#{@date2}' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and used='Y'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where nowdate>='#{@date1}' and
                  nowdate<='#{@date2}' and used='Y' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

            elsif @endcase=='02' #结案的，本请求和反请求的争议金额
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

            elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")
           end
            #结案时间段
          elsif @datestyle=='02'
            #结案的和不结案的，本请求和反请求的争议金额
            if @endcase=='01'
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")
            elsif @endcase=='02' #结案的，本请求和反请求的争议金额
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

            elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}'")
           end
            #立案结案时间段
          elsif @datestyle=='03'
            #结案的和不结案的，本请求和反请求的争议金额
            if @endcase=='01'
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
            elsif @endcase=='02' #结案的，本请求和反请求的争议金额          
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code<>'' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
            elsif @endcase=='03' #未结案的，本请求和反请求的争议金额
                  @n=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n1=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @n2=TbCase.find_by_sql("select count(id) as cc from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")

                  @partytype=TbCase.find_by_sql("select sum(amount) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount>='#{@amout1}' and amount<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype1=TbCase.find_by_sql("select sum(amount_1) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_1>='#{@amout1}' and amount_1<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
                  @partytype2=TbCase.find_by_sql("select sum(amount_2) as aa from tb_cases where used='Y' and end_date>='#{@date1}' and end_date<='#{@date2}' and end_code='' and amount_2>='#{@amout1}' and amount_2<='#{@amout2}' and nowdate>='#{@date1}' and nowdate<='#{@date2}'")
            end      
          end
      
      end
      
    end    
end
