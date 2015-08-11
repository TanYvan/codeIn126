=begin
创建人：聂灵灵
创建时间：2009-7-6
类的描述：案件基本类型统计。
页面：census/list
=end
class CensusController < ApplicationController
  def list
    @dispute={"0001"=>"立案时间段","0002"=>"结案时间段","0003"=>"立案结案时间段"}  #时间段类型
    @dispute2={"001"=>"全部","01"=>"是","02"=>"否"}  #结案方式
    @dispute3={"01"=>"案件大类","02"=>"案件小类","03"=>"依据仲裁协议类型统计"}    #统计类型
    @date1=params[:date1]
    @date2=params[:date2]
    @endcase=params[:endcase]
    @censustype=params[:censustype]
    @datestyle=params[:datestyle]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list"
    end
    #立案时间段
    if @datestyle=='0001'
      if @endcase=='001' && @censustype=='01'
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:select=>"count(casetype_num) as t1")
      elsif @endcase=='01' && @censustype=='01'
        #选案件大类,是
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=100",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(aribitprotprog_num) as t1")
      else
      end
      #结案时间段
    elsif @datestyle=='0002'
      if @endcase=='001' && @censustype=='01'
        @basecensus=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(casetype_num) as t1")
      elsif @endcase=='01' && @censustype=='01'
        #选案件大类,是
        @basecensus=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(aribitprotprog_num) as t1")
      else
      end
    #立案，结案时间段
    elsif @datestyle=='0003'
      if @endcase=='001' && @censustype=='01'
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(casetype_num) as t1")
      elsif @endcase=='01' && @censustype=='01'
        #选案件大类,是
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100 ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y'",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=100",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and end_t>='#{@date1}' and end_t<='#{@date2}' and used='Y' and state>=1 and state<100",:select=>"count(aribitprotprog_num) as t1")
      else
      end
    else
    end

  end
end
