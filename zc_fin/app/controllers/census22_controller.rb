class Census22Controller < ApplicationController
  def list
    @dispute={"0001"=>"立案时间段","0002"=>"结案时间段","0003"=>"立案结案时间段"}  #时间段类型
    @dispute2={"001"=>"全部","01"=>"是","02"=>"否"}  #结案方式
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
    if @datestyle==nil
      @datestyle='0001'
    end
    if @endcase==nil
      @endcase="001"
    end
    p=PubTool.new()
    if p.sql_check_3(@date1)!=false and p.sql_check_3(@date2)!=false and p.sql_check_3(@datestyle)!=false and p.sql_check_3(@endcase)!=false
      #立案时间段
      if @datestyle=='0001'
        if @endcase=='001' 
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y'",:group=>"case_type1",:order=>"case_type1",:select=>"case_type1,count(case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='01'
          #选案件大类,是
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is not null ",:group=>"case_type1",:order=>"case_type1",:select=>"case_type1,count(case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='02'
          #选案件大类,否
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and caseendbook_id_first is  null  ",:group=>"case_type1",:order=>"case_type1",:select=>"case_type1,count(case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        end
        #结案时间段
      elsif @datestyle=='0002'
        if @endcase=='001' 
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='01' 
          #选案件大类,是
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='02'
          #选案件大类,否
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        end
      #立案，结案时间段
      elsif @datestyle=='0003'
        if @endcase=='001' 
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='01' 
          #选案件大类,是
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        elsif @endcase=='02' 
          #选案件大类,否
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:group=>"ca.case_type1",:order=>"ca.case_type1",:select=>"ca.case_type1,count(ca.case_type1) as num")
          @case_c=@case.sum{|pp| pp.num.to_i}
        end
      else
      end
     
    end  
  end
  
  def list_2
    @dispute={"0001"=>"立案时间段","0002"=>"结案时间段","0003"=>"立案结案时间段"}  #时间段类型
    @dispute2={"001"=>"全部","01"=>"是","02"=>"否"}  #结案方式
    @date1=params[:date1]
    @date2=params[:date2]
    @endcase=params[:endcase]
    @censustype=params[:censustype]
    @datestyle=params[:datestyle]
    @case_type1=params[:case_type1]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    if @date1>@date2
      flash[:notice]="时间选择错误，请重新选择！"
      render :action=>"list"
    end
    if @datestyle==nil
      @datestyle='0001'
    end
    if @endcase==nil
      @endcase="001"
    end
    p=PubTool.new()
    if p.sql_check_3(@case_type1)!=false and p.sql_check_3(@date1)!=false and p.sql_check_3(@date2)!=false and p.sql_check_3(@datestyle)!=false and p.sql_check_3(@endcase)!=false
      #立案时间段
      if @datestyle=='0001'
        if @endcase=='001' 
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and case_type1='#{@case_type1}'",:order=>"right(case_code,7) desc",:select=>"recevice_code,case_code,amount,clerk")
        elsif @endcase=='01'
          #选案件大类,是
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and case_type1='#{@case_type1}' and caseendbook_id_first is not null ",:order=>"right(case_code,7) desc",:select=>"recevice_code,case_code,amount,clerk")
        elsif @endcase=='02'
          #选案件大类,否
          @case=TbCase.find(:all,:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and nowdate>='#{@date1}' and nowdate<='#{@date2}' and used='Y' and case_type1='#{@case_type1}' and caseendbook_id_first is  null  ",:order=>"right(case_code,7) desc",:select=>"recevice_code,case_code,amount,clerk")
        end
        #结案时间段
      elsif @datestyle=='0002'
        if @endcase=='001' 
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")

        elsif @endcase=='01' 
          #选案件大类,是
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")
        elsif @endcase=='02'
          #选案件大类,否
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' ",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")
        end
      #立案，结案时间段
      elsif @datestyle=='0003'
        if @endcase=='001' 
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")
        elsif @endcase=='01' 
          #选案件大类,是
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")
        elsif @endcase=='02' 
          #选案件大类,否
          @case=TbCase.find(:all,:joins=>"as ca inner join tb_caseendbooks as b on (ca.aribitprog_num='0003' or ca.aribitprog_num='0004' or ca.aribitprog_num='0007' or ca.aribitprog_num='0008') and ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id  and ca.used='Y' and b.used='Y' and ca.case_type1='#{@case_type1}'",:conditions=>"ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y'",:order=>"right(ca.case_code,7) desc",:select=>"ca.recevice_code,ca.case_code,ca.amount,ca.clerk")
       end
      else
      end
      
    end
    
  end
  
end
