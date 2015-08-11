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
    @dispute3={"01"=>"案件大类","02"=>"案件小类","03"=>"依据仲裁协议类型统计","04"=>"总会案件分类"}    #统计类型
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
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:select=>"count(casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is  null  ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
        @total1=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is  null",:select=>"count(casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'  and caseendbook_id_first is  null",:group=>"casetype_num2",:order=>"casetype_num2",:select=>"casetype_num2,count(casetype_num2) as num2")
        @total2=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'  and caseendbook_id_first is  null",:select=>"count(casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'  and caseendbook_id_first is  null",:group=>"aribitprotprog_num",:order=>"aribitprotprog_num",:select=>"aribitprotprog_num,count(aribitprotprog_num) as num")
        @total=TbCase.find(:first,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'  and caseendbook_id_first is  null",:select=>"count(aribitprotprog_num) as t1")
      elsif @endcase=='001' && @censustype=='04'
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='01' && @censustype=='04'
        #选择总会案件分类，是
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='02' && @censustype=='04'
        #选择总会案件分类，否
        @prom=TbCase.find(:all,:conditions=>"nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is null",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      else
      end
      #结案时间段
    elsif @datestyle=='0002'
      if @endcase=='001' && @censustype=='01'
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='01' && @censustype=='01'
        #选案件大类,是
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='001' && @censustype=='04'
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='01' && @censustype=='04'
        #选择总会案件分类，是
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='02' && @censustype=='04'
        #选择总会案件分类，否
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      else
      
      end
    #立案，结案时间段
    elsif @datestyle=='0003'
      if @endcase=='001' && @censustype=='01'
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='01' && @censustype=='01'
        #选案件大类,是
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='02' && @censustype=='01'
        #选案件大类,否
        @basecensus=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num",:order=>"ca.casetype_num",:select=>"ca.casetype_num,count(ca.casetype_num) as num")
        @total1=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num) as t1")
      elsif @endcase=='001' && @censustype=='02'
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='01' && @censustype=='02'
        #选择案件小类，是
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='02' && @censustype=='02'
        #选择案件小类，否
        @basecensus2=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.casetype_num2",:order=>"ca.casetype_num2",:select=>"ca.casetype_num2,count(ca.casetype_num2) as num2")
        @total2=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.casetype_num2) as t2")
      elsif @endcase=='001' && @censustype=='03'
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='01' && @censustype=='03'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='02' && @censustype=='03'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.aribitprotprog_num",:order=>"ca.aribitprotprog_num",:select=>"ca.aribitprotprog_num,count(ca.aribitprotprog_num) as num")
        @total=TbCase.find(:first,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:select=>"count(ca.aribitprotprog_num) as t1")
      elsif @endcase=='001' && @censustype=='04'
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='01' && @censustype=='04'
        #选择依据仲裁协议类型统计，是
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      elsif @endcase=='02' && @censustype=='04'
        #选择依据仲裁协议类型统计，否
        @prom=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"t_casetype_num",:order=>"t_casetype_num",:select=>"t_casetype_num,sum(case aribitprog_num when '0001' then 1 else 0 end) as num_0001,sum(case aribitprog_num when '0002' then 1 else 0 end) as num_0002,sum(case aribitprog_num when '0003' then 1 else 0 end) as num_0003,sum(case aribitprog_num when '0004' then 1 else 0 end) as num_0004,sum(case aribitprog_num when '0005' then 1 else 0 end) as num_0005,sum(case aribitprog_num when '0006' then 1 else 0 end) as num_0006,sum(case aribitprog_num when '0007' then 1 else 0 end) as num_0007,sum(case aribitprog_num when '0008' then 1 else 0 end) as num_0008")
      else
      end
    else
    end

  end
  def  list2
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=100000
    end
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil
      @date1 = Time.now.at_beginning_of_year.to_date
    end
    if @date2==nil
      @date2 = Time.now.to_date
    end
    if @date1==nil or @date2==nil or @date1=="" or @date2==""
      flash[:notice]="请选择正确的时间！"
      render :action=>"list2"
    elsif @date1>@date2
      flash[:notice]="时间有误，请重新选择！"
      render :action=>"list2"
    else#,count(clerk_id) as n1
      @casepro_pages,@casepro=paginate_by_sql(TbCasepro,"select clerk_id from tb_casepros where used='Y' and happdate>='#{@date1}' and happdate<='#{@date2}' group by clerk_id order by clerk_id",@page_lines.to_i)
      @casepro1 = TbCasepro.count(:id,:conditions=>["used='Y' and happdate>=? and happdate<=?",@date1,@date2])
    end
  end
end
