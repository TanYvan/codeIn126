#niell 2009-7-7 按仲裁程序统计
#2009-12-30  询问李后去掉统计类型
class Census3Controller < ApplicationController

  def list3
    @datestyle=params[:datestyle]
    if @datestyle==nil
      @datestyle='02'
    end
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @date1=params[:date1]
    @date2=params[:date2]
    if @date1==nil and @date2==nil
      @date1=Time.now.at_beginning_of_year.to_date
      @date2=Date.today
    end
    @case_type=TbDictionary.find(:all,:conditions=>"state='Y' and typ_code='0001'") #案件类型
    @endstyle=params[:endstyle]
    if @endstyle=="" or @endstyle==nil
      @endstyle = ""
      @endstyle_sql=" 1=1 "
    else
      @endstyle_sql=" b.endStyle='#{@endstyle}' "
    end
    p=PubTool.new()
    if @date1>@date2 or p.sql_check_3(@endstyle_sql)==false or p.sql_check_3(@dispute)==false or p.sql_check_3(@date1)==false or p.sql_check_3(@date2)==false
      flash[:notice]="请重新选择！"
      render :action=>"list3"
    end
  end

  # 按仲裁程序类型统计   案件列表
  def list3a
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @endstyle=params[:endstyle]
    @date1=params[:date1]
    @date2=params[:date2]
    if @endstyle=="" or @endstyle==nil
      @endstyle_sql=" 1=1 "
    else
      @endstyle_sql=" b.endStyle='#{@endstyle}' "
    end
    if params[:datestyle]=='01' #立案时间段
      if params[:k]=="1"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=0 and datediff(b.decideDate,ca.nowdate)<=15 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="2"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=16 and datediff(b.decideDate,ca.nowdate)<=30 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="3"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=31 and datediff(b.decideDate,ca.nowdate)<=60 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="4"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=61 and datediff(b.decideDate,ca.nowdate)<=75 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="5"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=76 and datediff(b.decideDate,ca.nowdate)<=90 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="6"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=91 and datediff(b.decideDate,ca.nowdate)<=120 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="7"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=121 and datediff(b.decideDate,ca.nowdate)<=150 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="8"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=151 and datediff(b.decideDate,ca.nowdate)<=180 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="9"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=181 and datediff(b.decideDate,ca.nowdate)<=240 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="10"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=241 and datediff(b.decideDate,ca.nowdate)<=365 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      else #params[:k]=="11"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>365 and ca.nowdate>='#{@date1}' and ca.nowdate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      end
    else
      if params[:k]=="1"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=0 and datediff(b.decideDate,ca.nowdate)<=15 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="2"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=16 and datediff(b.decideDate,ca.nowdate)<=30 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="3"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=31 and datediff(b.decideDate,ca.nowdate)<=60 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="4"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=61 and datediff(b.decideDate,ca.nowdate)<=75 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="5"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=76 and datediff(b.decideDate,ca.nowdate)<=90 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="6"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=91 and datediff(b.decideDate,ca.nowdate)<=120 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="7"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=121 and datediff(b.decideDate,ca.nowdate)<=150 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="8"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=151 and datediff(b.decideDate,ca.nowdate)<=180 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="9"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=181 and datediff(b.decideDate,ca.nowdate)<=240 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      elsif params[:k]=="10"
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>=241 and datediff(b.decideDate,ca.nowdate)<=365 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      else
        @case=TbCase.find(:all,:conditions=>"datediff(b.decideDate,ca.nowdate)>365 and b.decideDate>='#{@date1}' and b.decideDate<='#{@date2}' and ca.used='Y' and ca.aribitprog_num='#{params[:aribitprog_num]}'",:joins=>"as ca inner join tb_caseendbooks as b on ca.recevice_code=b.recevice_code and ca.caseendbook_id_first=b.id and #{@endstyle_sql} and ca.used='Y' and b.used='Y'",:select=>"ca.recevice_code as recevice_code,ca.case_code as case_code,ca.nowdate as nowdate,ca.amount as amount,ca.clerk as clerk,b.decideDate as decideDate,b.arbitBookNum as arbitBookNum")
      end
    end
  end

  # 检测（审计、鉴定、笔迹签订）  统计
  def list3_31
    @date1 = params[:date1] || Time.now.at_beginning_of_year.to_date
    @date2 = params[:date2] || Date.today
    @date3 = params[:date3] || Time.now.at_beginning_of_year.to_date
    @date4 = params[:date4] || Date.today

    k = params[:k]
    if k != nil
      endstyle = params[:k][:endstyle]
      if endstyle == nil
        endstyle = '0001'
      end
      @checked = endstyle
    end
    @case = TbDetection.find_by_sql(
      " SELECT DISTINCT
           c.recevice_code AS recevice_code,
           c.nowdate AS nowdate,
           c.case_code AS case_code
        FROM
           tb_detections AS d
        LEFT JOIN tb_cases AS c ON d.recevice_code = c.recevice_code
        AND d.used = 'Y' AND d.make_date >= '#{@date3}' AND d.make_date <= '#{@date4}'
        WHERE
           c.used = 'Y'
        AND c.state >= 4
        AND c.state < 100
        AND c.nowdate >= '#{@date1}'
        AND c.nowdate <= '#{@date2}'
        AND d.arbitration_decision = '#{endstyle}'"
    )
  end

  # 延期案件查询
  def list3_32
    @order=params[:order]
    if @order==nil or @order==""
      @order="RIGHT(c.case_code, 7)"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_page_name="list3_32"
    @hant_search_1=[
      ['date','IFNULL(d.requestdate,\\\'\\\')','延期提出日期','text',[]],
      ['date','IFNULL(e.decideDate,\\\'\\\')','结案日期','text',[]],
      ['char','c.clerk','办案助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','(CASE caseendbook_id_first is null WHEN true  THEN  0 ELSE 1 END)','是否结案','select',[[1,"是"],[0,"否"]]],
	  ['char','(case c.state<100 WHEN true  THEN  0 ELSE 1 END)','是否在办案件','select',[["",""],[0,"是"]]]
    ]
    @hant_search_1_list=['IFNULL(d.requestdate,\\\'\\\')']
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="c.used='Y' and c.state>=4"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    sql2 = "SELECT DISTINCT
               c.recevice_code AS recevice_code,
               c.nowdate AS nowdate,
               c.case_code AS case_code,
               c.clerk AS clerk,
               e.decideDate AS decideDate
            FROM
               tb_casedelays AS d
            LEFT JOIN tb_cases AS c ON d.recevice_code = c.recevice_code
            AND d.used = 'Y'
            LEFT JOIN tb_caseendbooks AS e ON d.recevice_code = e.recevice_code
            AND e.used = 'Y'
            WHERE
               #{c}
            ORDER BY
               #{@order},RIGHT(c.case_code, 7)"
    @case_pages,@case=paginate_by_sql(TbCasedelay,sql2,@page_lines.to_i)
    @ni = TbCasedelay.find_by_sql("SELECT DISTINCT  c.recevice_code AS recevice_code, c.nowdate AS nowdate, c.case_code AS case_code, c.clerk AS clerk, e.decideDate AS decideDate
            FROM tb_casedelays AS d LEFT JOIN tb_cases AS c ON d.recevice_code = c.recevice_code AND d.used = 'Y'
            LEFT JOIN tb_caseendbooks AS e ON d.recevice_code = e.recevice_code AND e.used = 'Y'
            WHERE #{c} ORDER BY #{@order},RIGHT(c.case_code, 7)")
  end

  # 当月业务数据统计
  def list3_1
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @rep1 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @op=TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y' and used='Y' and data_val<>'0001'",:order=>'data_val',:select=>"data_val,data_text")
    @rep3 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and case_type1='0001'",@d1,@d2])
    @rep5_1 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    rep6 = TbCase.sum(:amount_1,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep6 = rep6!=nil ? rep6/100000000 : 0
    rep7 = TbCase.sum(:amount_2,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep7 = rep7!=nil ? rep7/100000000 : 0
    rep8 = TbCase.sum(:amount_1,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    @rep8 = rep8!=nil ? rep8/100000000 : 0
    rep9 = TbCase.sum(:amount_2,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    @rep9 = rep9!=nil ? rep9/100000000 : 0

    rep10 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0001' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep10.empty?
      @rep10 = 0
    else
      @rep10 = rep10.length
    end
    rep11 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and e.recevice_code=c.recevice_code and c.used='Y'  and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep11.empty?
      @rep11 = 0
    else
      @rep11 = rep11.length
    end
    rep12 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0002' and e.recevice_code=c.recevice_code and c.used='Y'  and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep12.empty?
      @rep12 = 0
    else
      @rep12 = rep12.length
    end

    rep13 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0001' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep13.empty?
      @rep13 = 0
    else
      @rep13 = rep13.length
    end
    rep14 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep14.empty?
      @rep14 = 0
    else
      @rep14 = rep14.length
    end
    rep15 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0002' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep15.empty?
      @rep15 = 0
    else
      @rep15 = rep15.length
    end
    @rep16 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0002'",@d1,@d2])
    @rep17 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0004'",@d1,@d2])

    @rep18 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0001'",@d1,@d2])
    @rep19 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0003'",@d1,@d2])

    @rep20 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep21 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])

  end

  # 当月业务数据统计——生成excel文档
  def list3_1_a
    @d1=params[:d1]
    @d2=params[:d2]
    @rep1 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @op=TbDictionary.find(:all,:conditions=>"typ_code='8140' and state='Y' and used='Y' and data_val<>'0001'",:order=>'data_val',:select=>"data_val,data_text")
    @rep3 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and case_type1='0001'",@d1,@d2])
    @rep5_1 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    rep6 = TbCase.sum(:amount_1,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep6 = rep6/100000000
    rep7 = TbCase.sum(:amount_2,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep7 = rep7/100000000
    rep8 = TbCase.sum(:amount_1,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    @rep8 = rep8/100000000
    rep9 = TbCase.sum(:amount_2,:conditions=>["used='Y' and state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])
    @rep9 = rep9/100000000

    rep10 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0001' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep10.empty?
      @rep10 = 0
    else
      @rep10 = rep10.length
    end
    rep11 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and e.recevice_code=c.recevice_code and c.used='Y'  and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep11.empty?
      @rep11 = 0
    else
      @rep11 = rep11.length
    end
    rep12 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0002' and e.recevice_code=c.recevice_code and c.used='Y'  and e.id=c.caseendbook_id_first and (c.aribitprog_num='0001' or c.aribitprog_num='0002' or c.aribitprog_num='0005' or c.aribitprog_num='0006')")
    if rep12.empty?
      @rep12 = 0
    else
      @rep12 = rep12.length
    end

    rep13 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0001' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep13.empty?
      @rep13 = 0
    else
      @rep13 = rep13.length
    end
    rep14 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep14.empty?
      @rep14 = 0
    else
      @rep14 = rep14.length
    end
    rep15 = TbCase.find_by_sql("select distinct c.recevice_code as cr from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0002' and e.recevice_code=c.recevice_code and c.used='Y' and e.id=c.caseendbook_id_first and (c.aribitprog_num='0003' or c.aribitprog_num='0004' or c.aribitprog_num='0007' or c.aribitprog_num='0008')")
    if rep15.empty?
      @rep15 = 0
    else
      @rep15 = rep15.length
    end
    @rep16 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0002'",@d1,@d2])
    @rep17 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0004'",@d1,@d2])

    @rep18 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0001'",@d1,@d2])
    @rep19 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and aribitprog_num='0003'",@d1,@d2])

    @rep20 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0005' or aribitprog_num='0006')",@d1,@d2])
    @rep21 = TbCase.count(:id,:conditions=>["used='Y' and  state>=4 and nowdate>=? and nowdate<=? and (aribitprog_num='0007' or aribitprog_num='0008')",@d1,@d2])

  end

  # 适用规则项目
  def list3_2
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @ap_rule = TbDictionary.find(:all,:conditions=>"typ_code='8143' and state='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @ap_num = TbCase.count(:id,:conditions=>["used='Y' and nowdate>=? and nowdate<=?",@d1,@d2])
  end

  # 特殊约定案件统计
  def list3_3
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @ap_rule = TbDictionary.find(:all,:conditions=>"typ_code='8144' and state='Y'",:order=>'data_val',:select=>"data_val,data_text")
  end

  # 按特殊案件类型统计   案件列表
  def list3_3a
    @dispute={"01"=>"立案时间段","02"=>"结案时间段","03"=>"立案结案时间段"}  #时间段类型
    @special_convention = params[:special_convention]
    @d1=params[:d1]
    @d2=params[:d2]
    @case = TbCase.find(:all,:conditions=>["used='Y' and special_convention=? and state>=4 and nowdate>=? and nowdate<=?",@special_convention,@d1,@d2], :order => "case_code")
  end
  
  # 开庭地案件统计
  def list3_4
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    sitplace1 = TbSitting.find_by_sql("select distinct s.recevice_code as ss from tb_sittings as s where s.used='Y' and s.add_typ='0001' and sittingdate>='#{@d1}' and sittingdate<='#{@d2}'")
    if sitplace1!=nil
      @rep1 = sitplace1.length
    else
      @rep1 = 0
    end
    @reg_ions = Region.find(:all,:select=>"code,name",:order=>"code")
    sitplace2 = TbSitting.find_by_sql("select distinct s.recevice_code as ss from tb_sittings as s where s.used='Y' and s.add_typ='0002' and sittingdate>='#{@d1}' and sittingdate<='#{@d2}'")
    if sitplace2!=nil
      @rep2 = sitplace2.length
    else
      @rep2 = 0
    end
  end

  # 中外籍仲裁员数量统计
  def list3_5
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    #国内、外仲裁员
    @arbitman = TbCasearbitman.find_by_sql("select a.area_code as area1 from tb_casearbitmen as c,tb_arbitmen as a where c.used='Y' and c.u_t>='#{@d1}' and c.u_t<='#{@d2}' and c.arbitman=a.code and a.used='Y'")
    @i = 0
    @j = 0
    @arbitman.each do |ar|
      if ar.area1!='002' && ar.area1!='003' && ar.area1!='004' && ar.area1.slice(0,3)=="001"
        @i = @i + 1
      else
        @j = @j + 1
      end
    end

  end

  # 结案查询--不包括撤案的案件
  def list3_6
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @endcase=TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,e.arbitBookNum as arbitBookNum,e.case_code as case_code,e.endStyle as endStyle,e.decideDate as decideDate from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.endStyle<>'0003' and c.used='Y' and e.recevice_code=c.recevice_code and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' order by right(left(e.arbitBookNum,10),7) desc")
    @tb_caseend = TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,c.amount as amount from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle<>'0003' and c.used='Y' and c.recevice_code=e.recevice_code")
    @amount_all = 0
    @a_a1 = 0
    @a_a2 = 0
    @a_r1 = 0
    @a_r2 = 0
    @tb_caseend.each do |al|
      @amount_all = @amount_all + al.amount.to_f
      a_f1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a1 = @a_a1 + a_f1.to_i
      a_f2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a2 = @a_a2 + a_f2.to_i
      #  被申请人
      a_r1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r1 = @a_r1 + a_r1.to_i
      a_r2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r2 = @a_r2 + a_r2.to_i
    end
    @a_a12 = @a_a1 - @a_a2
    @a_r12 = @a_r1 - @a_r2
  end

  # 结案查询--生成报表
  def list3_61
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @endcase=TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,e.arbitBookNum as arbitBookNum,e.case_code as case_code,e.endStyle as endStyle,e.decideDate as decideDate from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.endStyle<>'0003' and c.used='Y' and e.recevice_code=c.recevice_code and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' order by right(left(e.arbitBookNum,10),7) desc")
    @tb_caseend = TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,c.amount as amount from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle<>'0003' and c.used='Y' and c.recevice_code=e.recevice_code")
    @amount_all = 0
    @a_a1 = 0
    @a_a2 = 0
    @a_r1 = 0
    @a_r2 = 0
    @tb_caseend.each do |al|
      @amount_all = @amount_all + al.amount.to_f
      a_f1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a1 = @a_a1 + a_f1.to_i
      a_f2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a2 = @a_a2 + a_f2.to_i
      #  被申请人
      a_r1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r1 = @a_r1 + a_r1.to_i
      a_r2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r2 = @a_r2 + a_r2.to_i
    end
    @a_a12 = @a_a1 - @a_a2
    @a_r12 = @a_r1 - @a_r2
  end

  # 结案查询--处长使用，不查看金额
  def list3_62
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(left(e.arbitBookNum,10),7)"
    end
    @clerk_all=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord")
    @clerk=params[:clerk]
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @endstyle=params[:endstyle]
    @general_code=params[:general_code]
    @case_code=params[:case_code]
    @end_code=params[:end_code]
    @clerk=params[:clerk]
    @runstyle=params[:runstyle]
    c = "e.used='Y' and c.used='Y' and e.recevice_code=c.recevice_code and e.endStyle<>'0003' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' "
    if @endstyle!='' and @endstyle!=nil
      c =c +  " and e.endStyle='#{@endstyle}' "
    end
    if @general_code!='' and @general_code!=nil
      c =c + " and e.general_code like '%#{@general_code}%'"
    end
    if @case_code!='' and @case_code!=nil
      c =c + " and e.case_code like '%#{@case_code}%'"
    end
    if @end_code!='' and @end_code!=nil
      c =c + "  and e.arbitBookNum like '%#{@end_code}%'"
    end
    if @clerk!='' and @clerk!=nil
      c =c + "  and c.clerk like '#{@clerk}'"
    end
    unless @runstyle.blank?
      c =c + "  and c.runstyle='#{@runstyle}'"
    end
    #niell 2010-10-25 提前结案
    if params[:seday]!=nil and params[:seday]!=""
      c =c + " and c.caseendbook_id_last=e.id and datediff(c.finally_limit_dat,e.decideDate)>='#{params[:seday].to_i}'"
    end
    p=PubTool.new()
    if p.sql_check_3(c)!=false
      @endcase=TbCaseendbook.find_by_sql("select distinct c.runstyle as runstyle, e.recevice_code as recevice_code,e.general_code as general_code,e.case_code as case_code,e.arbitBookNum as arbitBookNum,e.endStyle as endStyle,e.decideDate as decideDate,c.finally_limit_dat as finally_limit_dat,datediff(c.finally_limit_dat,e.decideDate) as df from tb_caseendbooks as e,tb_cases as c where #{c} order by #{@order}")
    end
   end

  # 撤案查询---
  def list3_7
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @endcase2=TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,e.arbitBookNum as arbitBookNum,e.case_code as case_code,e.endStyle as endStyle,e.decideDate as decideDate from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.endStyle='0003' and c.used='Y' and e.recevice_code=c.recevice_code and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' order by right(left(e.arbitBookNum,10),7) desc")
    @tb_caseend = TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,c.amount as amount from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and c.used='Y' and c.recevice_code=e.recevice_code")
    @amount_all = 0
    @a_a1 = 0
    @a_a2 = 0
    @a_r1 = 0
    @a_r2 = 0
    @tb_caseend.each do |al|
      @amount_all = @amount_all + al.amount.to_f
      a_f1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a1 = @a_a1 + a_f1.to_i
      a_f2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a2 = @a_a2 + a_f2.to_i
      #  被申请人
      a_r1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r1 = @a_r1 + a_r1.to_i
      a_r2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r2 = @a_r2 + a_r2.to_i
    end
    @a_a12 = @a_a1 - @a_a2
    @a_r12 = @a_r1 - @a_r2
  end

  # 撤案查询---生成文档
  def list3_71
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @endcase2=TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,e.arbitBookNum as arbitBookNum,e.case_code as case_code,e.endStyle as endStyle,e.decideDate as decideDate from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.endStyle='0003' and c.used='Y' and e.recevice_code=c.recevice_code and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' order by right(left(e.arbitBookNum,10),7) desc")
    @tb_caseend = TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,c.amount as amount from tb_caseendbooks as e,tb_cases as c where e.used='Y' and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}' and e.endStyle='0003' and c.used='Y' and c.recevice_code=e.recevice_code")
    @amount_all = 0
    @a_a1 = 0
    @a_a2 = 0
    @a_r1 = 0
    @a_r2 = 0
    @tb_caseend.each do |al|
      @amount_all = @amount_all + al.amount.to_f
      a_f1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a1 = @a_a1 + a_f1.to_i
      a_f2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_a2 = @a_a2 + a_f2.to_i
      #  被申请人
      a_r1=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r1 = @a_r1 + a_r1.to_i
      a_r2=TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",al.recevice_code])
      @a_r2 = @a_r2 + a_r2.to_i
    end
    @a_a12 = @a_a1 - @a_a2
    @a_r12 = @a_r1 - @a_r2
  end

  # 撤案查询---处长使用，不查看金额部分
  def list3_72
    @clerk_all=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord")
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @general_code=params[:general_code]
    @case_code=params[:case_code]
    @end_code=params[:end_code]
    @clerk=params[:clerk]
    c = "e.used='Y' and e.endStyle='0003' and c.used='Y' and e.recevice_code=c.recevice_code and e.decideDate>='#{@d1}' and e.decideDate<='#{@d2}'"
    if @general_code!='' and @general_code!=nil
      c = c + " and e.general_code like '%#{@general_code}%'"
    end
    if @case_code!='' and @case_code!=nil
      c =c + " and e.case_code like '%#{@case_code}%'"
    end
    if @end_code!='' and @end_code!=nil
      c =c + " and e.arbitBookNum like '%#{@end_code}%'"
    end
    if @clerk!='' and @clerk!=nil
      c =c + "  and c.clerk like '#{@clerk}'"
    end
    @endcase2=TbCaseendbook.find_by_sql("select distinct e.recevice_code as recevice_code,e.general_code as general_code,e.case_code as case_code,e.arbitBookNum as arbitBookNum,e.endStyle as endStyle,e.decideDate as decideDate from tb_caseendbooks as e,tb_cases as c where #{c} order by right(left(e.arbitBookNum,10),7)")
  end

  # 当事人统计
  def list3_8
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @agent=TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y'",:order=>"data_val",:select=>"data_val,data_text")
  end
  #优化当事人统计列表页
  def list33_8
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @agent=TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y'",:order=>"data_val",:select=>"data_val,data_text")
  end

  def list3_81
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @agent=TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y'",:order=>"data_val",:select=>"data_val,data_text")
  end

  def list33_81
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @agent=TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y'",:order=>"data_val",:select=>"data_val,data_text")
  end

  # 至少一方为深圳市,查看明细
  def list3_8a
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  def list33_8a
    if params[:r]=="r1"
      rrr = " and r1=1 "
    elsif params[:r]=="r2"
      rrr = " and r2=1 "
    elsif params[:r]=="r3"
      rrr = " and r3=1 "
    elsif params[:r]=="r4"
      rrr = " and r4=1 "
    elsif params[:r]=="r5"
      rrr = " and r5=1 "
    elsif params[:r]=="r6"
      rrr = " and r6=1 "
    else
      rrr=""
    end
    @v_list = TbCase.find_by_sql(["select tb_cases.recevice_code,tb_cases.case_code,tb_cases.clerk,tb_cases.nowdate,tb_cases.amount from tb_cases,party_regions where party_regions.nowdate>=? and party_regions.nowdate<=? and party_regions.agent=? #{rrr} and  party_regions.recevice_code=tb_cases.recevice_code order by right(tb_cases.case_code,7)",params[:d1],params[:d2],params[:agent]])
  end
  # 至少一方为广东其他地区（除深圳市以外）
  def list3_8b
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>'' ",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  # 至少一方为香港地区
  def list3_8c
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''  and tb_parties_area='002'",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  # 双方都是广东地区以外
  def list3_8d
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  def list3_8e
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  def list3_8f
    @v_list = VCaseQuery1List1.find(:all,:conditions=>["tb_cases_nowdate>=? and tb_cases_nowdate<=? and tb_cases_agent=? and tb_parties_area<>''",params[:d1],params[:d2],params[:agent]],:group=>"tb_cases_recevice_code",:order=>"right(tb_cases_case_code,7)")
  end

  # 仲裁员人案统计
  def list3_9
    @order = params[:order]
    @order = "a1 desc,name asc" if @order.blank?
    @arbitmanl = TbArbitman.count("used='Y'").to_i

    if params[:up] != nil
      Task_a.new.t_25 
    end
    @arbitmancase = ReportArbitmanCase.find(:all,:order=>@order)
  end

  # 仲裁员  办理 案案件案件明细表
  # 在办案件
  def list3_a1
    @name = TbArbitman.find(:first,:conditions=>["used='Y' and code=?",params[:code]]).name
    @arbitman_case = TbCase.find_by_sql("select distinct c.recevice_code as recevice_code,c.case_code as case_code,c.nowdate as nowdate,c.end_code as end_code,ca.arbitmansign as arbitmansign from tb_cases as c,tb_casearbitmen as ca where c.used='Y' and c.state>=4 and c.state<100 and c.caseendbook_id_first is null and c.recevice_code=ca.recevice_code and ca.used='Y' and ca.arbitman='#{params[:code]}' order by right(c.case_code,7)")
  end

  #结案案件
  def list3_a2
    @name = TbArbitman.find(:first,:conditions=>["used='Y' and code=?",params[:code]]).name
    #    if params[:k]=="1"
    #      @arbitman_case = VArbitmanCase.find(:all,:conditions=>["state>=4 and state<100 and caseendbook_id_first is null and code=?",params[:code]],:order=>"right(case_code,7)")
    if params[:k]=="2"
      @arbitman_case = VArbitmanCase.find(:all,:select=>"distinct recevice_code,nowdate,case_code,end_code",:conditions=>["state>=4 and caseendbook_id_first is not null and code=?",params[:code]],:order=>"right(case_code,7)")
    elsif params[:k]=="3"
      @arbitman_case = VArbitmanCase.find(:all,:select=>"distinct recevice_code,nowdate,case_code,end_code",:conditions=>["state>=4 and caseendbook_id_first is not null and code=? and (arbitmantype='0001' or arbitmantype='0002')",params[:code]],:order=>"right(case_code,7)")
    elsif params[:k]=="4"   #A类：起草裁决书的数量
      @arbitman_case = TbAwardDetail.find_by_sql("select distinct a.recevice_code as recevice_code,cc.case_code as case_code,cc.nowdate as nowdate,cc.end_code as end_code from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{params[:code]}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0001' or cc.arbitmantype='0002') order by right(cc.case_code,7)")
    elsif params[:k]=="5"  #A类：延期裁决案件的数量
      @arbitman_case = TbCase.find_by_sql("select distinct tb_casedelays.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.end_code as end_code from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4
         and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{params[:code]}' and (tb_casearbitmen.arbitmantype='0001' or tb_casearbitmen.arbitmantype='0002') order by right(tb_cases.case_code,7)")
    elsif params[:k]=="6" #被申请回避的次数
      @arbitman_case=TbEvite.find(:all,:select=>"distinct e.recevice_code as recevice_code,va.case_code as case_code,va.nowdate as nowdate,va.end_code as end_code",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0001' or va.arbitmantype='0002')",:conditions=>["e.used='Y' and e.arbitman=?",params[:code]],:order=>"right(va.case_code,7)")
    elsif params[:k]=="7" #平均结案时间
      @arbitman_case=TbCaseendbook.find(:all,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{params[:code]}' and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"distinct s.recevice_code as recevice_code,va.nowdate as nowdate,va.case_code as case_code,va.end_code as end_code",:order=>"right(va.case_code,7)")
    elsif params[:k]=="8"  #B类案件开始 
      @arbitman_case = VArbitmanCase.find(:all,:conditions=>["state>=4 and caseendbook_id_first is not null and code=? and (arbitmantype='0003' or arbitmantype='0004')",params[:code]],:order=>"right(case_code,7)")
    elsif params[:k]=="9"   #B类：起草裁决书的数量
      @arbitman_case = TbAwardDetail.find_by_sql("select distinct a.recevice_code as recevice_code,cc.case_code as case_code,cc.nowdate as nowdate,cc.end_code as end_code from tb_award_details as a,v_arbitman_cases as cc,tb_awards as aw where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{params[:code]}' and (a.typ='0003' or a.typ='0004') and a.recevice_code=aw.recevice_code and aw.used='Y' and a.p_id=aw.id and aw.recevice_code=cc.recevice_code and a.draftsman=cc.code and cc.state>=4 and cc.caseendbook_id_first is not null and (cc.arbitmantype='0003' or cc.arbitmantype='0004') order by right(cc.case_code,7)")
    elsif params[:k]=="10"  #B类：延期裁决案件的数量
      @arbitman_case = TbCase.find_by_sql("select distinct tb_casedelays.recevice_code as recevice_code,tb_cases.case_code as case_code,tb_cases.nowdate as nowdate,tb_cases.end_code as end_code from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4
         and tb_cases.caseendbook_id_first is not null and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{params[:code]}' and (tb_casearbitmen.arbitmantype='0003' or tb_casearbitmen.arbitmantype='0004') order by right(tb_cases.case_code,7)")
    elsif params[:k]=="11" #被申请回避的次数
      @arbitman_case=TbEvite.find(:all,:select=>"distinct e.recevice_code as recevice_code,va.case_code as case_code,va.nowdate as nowdate,va.end_code as end_code",:joins=>"as e inner join v_arbitman_cases as va on e.arbitman=va.code and e.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and (va.arbitmantype='0003' or va.arbitmantype='0004')",:conditions=>["e.used='Y' and e.arbitman=?",params[:code]],:order=>"right(va.case_code,7)")
    elsif params[:k]=="12" #平均结案时间
      @arbitman_case=TbCaseendbook.find(:all,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.caseendbook_id_first is not null and va.code='#{params[:code]}' and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"distinct s.recevice_code as recevice_code,va.nowdate as nowdate,va.case_code as case_code,va.end_code as end_code",:order=>"right(va.case_code,7)")
    elsif params[:k]=="13"#tb_caseendbooks as s, e.recevice_code=s.recevice_code and s.used='Y' and
      @arbitman_case=TbEvaluate.find_by_sql("
        SELECT distinct e.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.end_code as end_code
        FROM tb_evaluates  as e,tb_cases as c
        where  e.recevice_code=c.recevice_code
               and c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null and e.used='Y' and e.arbitman='#{params[:code]}'
        ORDER BY right(c.case_code,7)"
      )
      #    elsif params[:k]=="14" #起草裁决数量
      #      @arbitman_case=TbAwardDetail.find_by_sql("select distinct c.recevice_code as recevice_code,c.case_code as case_code,c.nowdate as nowdate,c.end_code as end_code from tb_award_details as a,tb_cases as c,tb_awards as aa where a.used='Y' and a.draftsman_typ='0001' and a.draftsman='#{params[:code]}' and (a.typ='0003' or a.typ='0004') and  a.recevice_code=aa.recevice_code and aa.used='Y' and a.p_id=aa.id and  aa.recevice_code=c.recevice_code and c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null")
      elsif params[:k]=="15" #核校评价
        @arbitman_case = TbAwardJudge.find_by_sql("select distinct c.recevice_code as recevice_code,c.case_code as case_code,c.nowdate as nowdate,c.end_code as end_code from tb_award_judges as j,tb_cases as c where j.used='Y' and (j.arbitman1='#{params[:code]}' or j.arbitman2='#{params[:code]}' or j.arbitman3='#{params[:code]}') and j.recevice_code=c.recevice_code and c.used='Y' and c.state>=4")
    end
  end

  # 仲裁员评价加减分
  def list3_a4
    @page_lines=session[:lines] if params[:lines].blank?
    @name = TbArbitman.find(:first,:conditions=>["used='Y' and code=?",params[:code]]).name
    code = params[:code]
    @add_less1_pages,@add_less1 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and a.code='#{code}' and e.score>0 order by e.u_t desc",@page_lines.to_i)
    @add_less2_pages,@add_less2 = paginate_by_sql(TbArbitman,"select e.recevice_code as recevice_code,e.score as score,e.remark as remark,a.name as name from tb_arbitmen as a,tb_evaluates as e where e.used='Y' and
      e.arbitman=a.code and a.used='Y' and a.code='#{code}' and e.score<0 order by e.u_t desc",@page_lines.to_i)
  end

  def list3_a3
    #    delays=TbCase.count("1=1","inner join tb_casearbitmen on tb_casearbitmen.arbitman='#{c.code}' and tb_casearbitmen.used='Y' and tb_cases.used='Y' and tb_cases.recevice_code=tb_casearbitmen.recevice_code   inner join tb_casedelays on tb_cases.used='Y' and tb_casedelays.used='Y' and tb_cases.recevice_code=tb_casedelays.recevice_code")
    @name = TbArbitman.find(:first,:conditions=>["used='Y' and code=?",params[:code]]).name
    @arbitman_case = VArbitmanCase.find(:all,:conditions=>["state>=4 and state<100 and caseendbook_id_first is not null and code=?",params[:code]],:order=>"general_code")
  end

  def list3_91
    @order=params[:order]
    @order="name desc" if @order.blank?
    @arbitman_case = VArbitmanCase.find(:all,:group=>"code",:order=>"code")
    for c in @arbitman_case
      @arbitmancase=ReportArbitmanCase.new()
      @arbitmancase.user_code=session[:user_code]
      @arbitmancase.code=c.code
      @arbitmancase.name=c.name
      a1=VArbitmanCase.count(:recevice_code,:conditions=>["state>=4 and state<100 and code=? and caseendbook_id_first is null",c.code])
      @arbitmancase.a1=a1
      a2=VArbitmanCase.count(:recevice_code,:conditions=>["state>=4 and state<100 and code=? and caseendbook_id_first is not null",c.code])
      @arbitmancase.a2=a2
      @arbitmancase.sex=c.sex
      @arbitmancase.mobiletel=c.mobiletel
      @arbitmancase.telh=c.telh
      @arbitmancase.fax=c.fax
      #助理评价
      sc=TbEvaluate.sum(:score,:conditions=>["used='Y' and arbitman=?",c.code])
      if a2>0 and sc!=nil
        @arbitmancase.score=(sc.to_i+ a2*100)/a2
      end
      #校核评价
      sc2=TbAwardJudge.sum(:score,:conditions=>["used='Y' and (arbitman1=? or arbitman2=? or arbitman3=?)",c.code,c.code,c.code])
      if a2>0 and sc2!=nil
        @arbitmancase.score2=sc2.to_i/a2
      end
      #起草裁决数量
      j_ad=0
      #已结案件中，担任首席/独任的总数（A类) #################################
      a_a=VArbitmanCase.count(:recevice_code,:conditions=>["state>=4 and state<100 and code=? and caseendbook_id_first is not null and (arbitmantype='0001' or arbitmantype='0002')",c.code])
      @arbitmancase.a_a=a_a
      #A类：起草裁决书的数量
      award=TbAwardDetail.find(:first,:conditions=>["a.used='Y' and a.draftsman_typ='0001' and a.draftsman=? and (a.typ='0003' or a.typ='0004')",c.code],:joins=>"as a inner join tb_cases as cc on cc.used='Y' and cc.state>=4 and cc.state<100 and cc.recevice_code=a.recevice_code",:select=>"count(distinct(a.recevice_code)) as ac")
      if award!=nil
        @arbitmancase.a_b=award.ac
        j_ad = j_ad + award.ac
      end
      #A类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4 and tb_cases.state<100
        and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0001' or tb_casearbitmen.arbitmantype='0002')")
      for d in delays
        if d!=nil
          @arbitmancase.a_c=d.ac
        end
      end
      #A类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:conditions=>["e.used='Y' and e.arbitman=?",c.code],:joins=>"as e inner join v_arbitman_cases as va on e.recevice_code=va.recevice_code and va.state>=4 and va.state<100 and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"count(distinct(e.recevice_code)) as ad")
      if tb_evalate!=nil
        @arbitmancase.a_d=tb_evalate.ad
      end
      #A类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.state<100 and va.code='#{c.code}' and (va.arbitmantype='0001' or va.arbitmantype='0002')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.a_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end
      #B类    ###################################
      b_a=VArbitmanCase.count(:recevice_code,:conditions=>["state>=4 and state<100 and code=? and caseendbook_id_first is not null and (arbitmantype='0003' or arbitmantype='0004')",c.code])
      @arbitmancase.b_a=b_a
      #B类：起草裁决书的数量
      award=TbAwardDetail.find(:first,:conditions=>["a.used='Y' and a.draftsman_typ='0001' and a.draftsman=? and (a.typ='0003' or a.typ='0004')",c.code],:joins=>"as a inner join tb_cases as cc on cc.used='Y' and cc.state>=4 and cc.state<100 and cc.recevice_code=a.recevice_code",:select=>"count(distinct(a.recevice_code)) as ac")
      if award!=nil
        @arbitmancase.b_b=award.ac
        j_ad = j_ad + award.ac
      end
      @arbitmancase.ad = j_ad
      #B类：延期裁决案件的数量
      delays=TbCase.find_by_sql("select count(distinct(tb_casedelays.recevice_code)) as ac from tb_cases,tb_casearbitmen,tb_casedelays where tb_casedelays.used='Y' and tb_casedelays.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_cases.state>=4 and tb_cases.state<100
        and tb_cases.recevice_code=tb_casearbitmen.recevice_code and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman='#{c.code}' and (tb_casearbitmen.arbitmantype='0003' or tb_casearbitmen.arbitmantype='0004')")
      for d in delays
        if d!=nil
          @arbitmancase.b_c=d.ac
        end
      end
      #B类：被申请回避的次数
      tb_evalate=TbEvite.find(:first,:conditions=>["e.used='Y' and e.arbitman=?",c.code],:joins=>"as e inner join v_arbitman_cases as va on e.recevice_code=va.recevice_code and va.state>=4 and va.state<100 and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"count(distinct(e.recevice_code)) as ad")
      if tb_evalate!=nil
        @arbitmancase.b_d=tb_evalate.ad
      end
      #B类：平均结案时间
      tb_caseendbook=TbCaseendbook.find(:first,:conditions=>["s.used='Y'"],:joins=>"as s inner join v_arbitman_cases as va on s.recevice_code=va.recevice_code and va.state>=4 and va.state<100 and va.code='#{c.code}' and (va.arbitmantype='0003' or va.arbitmantype='0004')",:select=>"sum(datediff(s.decideDate,va.nowdate)) as dat,count(distinct(s.recevice_code)) as aa")
      if tb_caseendbook!=nil
        if tb_caseendbook.aa.to_i>0
          @arbitmancase.b_e=tb_caseendbook.dat.to_i/tb_caseendbook.aa.to_i
        end
      end

      @arbitmancase.save
    end
    cc="user_code='#{session[:user_code]}'"
    @arbitmancaseaa=ReportArbitmanCase.find(:all,:conditions=>cc,:order=>@order)
    ReportArbitmanCase.delete_all("user_code='#{session[:user_code]}'")
  end

  # 仲裁员人案按时间统计
  def list3_10
    @state = {"01" => "立案时间", "02" => "组庭时间", "03" => "结案时间"}
    @datestyle = params[:datestyle]
    if @datestyle.blank?
      @datestyle = '01'
    end
    @d1 = params[:d1]
    @d2 = params[:d2]
    if @d1 == nil
      @d1 = Time.now.at_beginning_of_year.to_date
    end
    if @d2 == nil
      @d2 = Time.now.to_date
    end
    if @datestyle == '01' #立案时间
      @arbitman_case = VArbitmanCase.find(:all, :conditions => ["code is not null and nowdate>=? and nowdate<=?",@d1,@d2], :group=>"code")
    elsif @datestyle == '02'#组庭时间
      @arbitman_case = VArbitmanCase.find(:all, :conditions => ["code is not null and orgdate>=? and orgdate<=?",@d1,@d2], :group=>"code")
    else #结案时间
      @arbitman_case = VArbitmanCase.find(:all, :conditions => ["code is not null and decideDate>=? and decideDate<=?",@d1,@d2], :group=>"code")
    end
  end

  def list3_10a
    @date_style={'01'=>"立案时间",'02'=>"组庭时间",'03'=>"结案时间"}
    @name=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",params[:code]]).name
    @datestyle=params[:datestyle]
    @d1=params[:d1]
    @d2=params[:d2]
    if params[:datestyle]=='01' #立案时间
      @arbitman_case = VArbitmanCase.find(:all,:select=>"distinct recevice_code",:conditions=>["nowdate>=? and nowdate<=? and code=?",@d1,@d2,params[:code]],:order=>"right(case_code,7)")
    elsif params[:datestyle]=='02'#组庭时间
      @arbitman_case = VArbitmanCase.find(:all,:select=>"distinct recevice_code",:conditions=>["orgdate>=? and orgdate<=? and code=?",@d1,@d2,params[:code]],:order=>"right(case_code,7)")
    else #结案时间
      @arbitman_case = VArbitmanCase.find(:all,:select=>"distinct recevice_code",:conditions=>["decideDate>=? and decideDate<=? and code=?",@d1,@d2,params[:code]],:order=>"right(case_code,7)")
    end
  end

  # 次数统计
  def list3_11
    @state={"01"=>"代理人(律师事务所)","02"=>"当事人","03"=>"当事人＋代理人(律师事务所)"}
    @datestyle=params[:datestyle]
    if @datestyle==nil
      params[:datestyle]='01'
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.months_ago(1).to_date.to_s(:db)
      @d1 = @d1.slice(0,7)+"-01"
    end
    if @d2==nil
      @d2=Time.now.months_since(1).to_date.to_s(:db)
      @d2 = @d2.slice(0,7)+"-01"
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      #@page_lines=session[:lines]
      @page_lines=100
    end
    if params[:datestyle]=='01' #代理人
      sql1="select company,mobiletel,tel,post_tel_code,addr,count(DISTINCT recevice_code) as ccc from v_agents where company<>'' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by company order by count(recevice_code) desc,company asc"
      @arbitman_case1_pages,@arbitman_case1 =paginate_by_sql(VAgent,sql1,@page_lines.to_i)
      @n1=VAgent.find(:all,:conditions=>["company<>'' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"company")
    elsif params[:datestyle]=='02'#当事人
      sql2="select partyname,mobiletel,tel,post_tel_code,addr,count(DISTINCT recevice_code) as ccc from v_parties where nowdate>='#{@d1}' and nowdate<='#{@d2}' group by partyname order by count(recevice_code) desc,partyname asc"
      @arbitman_case2_pages,@arbitman_case2 =paginate_by_sql(VParty,sql2,@page_lines.to_i)
      @n2=VParty.find(:all,:conditions=>["nowdate>=? and nowdate<=?",@d1,@d2],:group=>"partyname")
    else #当事人+代理人
      sql1="select company,mobiletel,tel,post_tel_code,addr,count(DISTINCT recevice_code) as ccc from v_agents where company<>'' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by company order by count(recevice_code) desc,company asc"
      @arbitman_case1_pages,@arbitman_case1 =paginate_by_sql(VAgent,sql1,@page_lines.to_i)
      @n1=VAgent.find(:all,:conditions=>["company<>'' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"company")
      sql2="select partyname,mobiletel,tel,post_tel_code,addr,count(DISTINCT recevice_code) as ccc from v_parties where nowdate>='#{@d1}' and nowdate<='#{@d2}' group by partyname order by count(recevice_code) desc,partyname asc"
      @arbitman_case2_pages,@arbitman_case2 =paginate_by_sql(VParty,sql2,@page_lines.to_i)
      @n2=VParty.find(:all,:conditions=>["nowdate>=? and nowdate<=?",@d1,@d2],:group=>"partyname")
    end
  end

  # 与某代理人有关的案件
  def list3_11a
    @arbitman_case1 = VAgent.find(:all,:conditions=>["nowdate>=? and nowdate<=? and company=?",params[:d1],params[:d2],params[:name]],:order=>"recevice_code")
  end

  # 与某当事人有关的案件
  def list3_11b
    @arbitman_case1 = VParty.find(:all,:conditions=>["nowdate>=? and nowdate<=? and partyname=?",params[:d1],params[:d2],params[:name]],:order=>"recevice_code")
  end

  #--------------↓↓ add by duyongwen ↓↓----------------
  # 律师事务所统计 （统计内容 代理人公司名称包含“律师”）、律师统计、仲裁员统计
  def list3_15
    @state={"01"=>"律师事务所","02"=>"律师","03"=>"仲裁员"}
    @datestyle=params[:datestyle]
    if @datestyle==nil
      @datestyle = '01'
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.months_ago(1).to_date.to_s(:db)
      @d1 = @d1.slice(0,7)+"-01"
    end
    if @d2==nil
      @d2=Time.now.months_since(1).to_date.to_s(:db)
      @d2 = @d2.slice(0,7)+"-01"
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="count( DISTINCT recevice_code) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      #@page_lines=session[:lines]
      @page_lines=100
    end
    if @datestyle == '01' # 律师事务所
      sql1 = "select company,mobiletel,tel,post_tel_code,addr,COUNT(DISTINCT recevice_code) as num from v_agents where company like '%律师%' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by company order by #{@order}"
      @arbitman_case1_pages,@arbitman_case1 = paginate_by_sql(VAgent,sql1,@page_lines.to_i)
      @n1 = VAgent.find(:all, :conditions => ["company like '%律师%' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"company")
    elsif @datestyle == '02' # 律师
      sql2 = "SELECT name,company,mobiletel,tel,post_tel_code,addr,COUNT(DISTINCT recevice_code) as num FROM v_agents WHERE status='0001' AND nowdate>='#{@d1}' and nowdate<='#{@d2}' GROUP BY name,company order by #{@order}"
      @arbitman_case2_pages,@arbitman_case2 =paginate_by_sql(VAgent,sql2,@page_lines.to_i)
      @n2 = VAgent.find(:all, :conditions => ["status='0001' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"name,company")
    else # 仲裁员
      sql3 = "select name,code,sex,mobiletel,telh,fax,count(DISTINCT recevice_code) as num from v_arbitman_cases WHERE code is not null AND nowdate>='#{@d1}' and nowdate<='#{@d2}' GROUP BY code order by #{@order}"
      @arbitman_case2_pages,@arbitman_case2 =paginate_by_sql(VAgent,sql3,@page_lines.to_i)
      @n3 = VArbitmanCase.find(:all, :conditions => ["code is not null  and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"code")
    end
  end

  # 与某律师事务所相关的案件
  def list3_15a
    if params[:datestyle] == "01" # 律师事务所查询
      @case_rc = VAgent.find(:all,:select=>"distinct recevice_code", :conditions=>["nowdate>=? and nowdate<=? and company = ? ",params[:d1],params[:d2],params[:company]],:order=>"recevice_code")
    elsif params[:datestyle] == "02" # 律师查询
      @case_rc = VAgent.find(:all,:select=>"distinct recevice_code", :conditions=>["status='0001' and nowdate>=? and nowdate<=? and company = ? and name = ? ",params[:d1],params[:d2],params[:company],params[:name]],:order=>"recevice_code")
    else # 仲裁员
      @case_rc = VArbitmanCase.find(:all,:select=>"distinct recevice_code", :conditions=>["code is not null and  nowdate>=? and nowdate<=? and code = ? ",params[:d1],params[:d2],params[:code]],:order=>"recevice_code")
    end
  end

  # “律师事务所统计”页面再统计功能。
  def again

    if params[:datestyle] == "01" # 律师事务所查询
      @a_id = VAgent.find(:all,:select=>"distinct recevice_code", :conditions=>["nowdate>=? and nowdate<=? and company = ? ",params[:d1],params[:d2],params[:company]])
    elsif params[:datestyle] == "02" # 律师查询
      @a_id = VAgent.find(:all,:select=>"distinct recevice_code", :conditions=>["status='0001' and nowdate>=? and nowdate<=? and company = ? and name = ? ",params[:d1],params[:d2],params[:company],params[:name]])
    else # 仲裁员
      @a_id = VArbitmanCase.find(:all,:select=>"distinct recevice_code", :conditions=>["code is not null and  nowdate>=? and nowdate<=? and code = ? ",params[:d1],params[:d2],params[:code]])
    end
    @amount_count = 0
    @rc = ""
    for b in @a_id
      @rc += b.recevice_code + ','
      current_case = TbCase.find(:first,:conditions=>" recevice_code = '#{b.recevice_code}' and used='Y' ")
      @amount_count += current_case.amount
    end

    #案件大小分类统计
    @basecensus1=TbCase.find(:all,:conditions=>" used='Y' and recevice_code in (#{@rc.chop}) ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num,count(casetype_num) as num")
    @total1=TbCase.find(:first,:conditions=>"used='Y' and recevice_code in (#{@rc.chop}) ",:select=>"count(casetype_num) as t1")

    @basecensus2=TbCase.find(:all,:conditions=>" used='Y' and recevice_code in (#{@rc.chop}) ",:group=>"casetype_num",:order=>"casetype_num",:select=>"casetype_num2,count(casetype_num2) as num2")
    @total2=TbCase.find(:first,:conditions=>"used='Y' and recevice_code in (#{@rc.chop}) ",:select=>"count(casetype_num2) as t2")

    # 当事人地区统计
    @re1=TbCase.find_by_sql("select area,COUNT(recevice_code) as c from v_parties where recevice_code IN (#{@rc.chop})  group by area")

    # 当事人行业统计

    # 仲裁条款情况
    @type = TbDictionary.find(:all,:conditions => "typ_code='0004' and state='Y' and used='Y' ", :select => "data_val,data_text" )

    # 涉外案件、国内案件数量
    @case_count1 = TbCase.count(:conditions=>"(aribitprog_num='0003' or aribitprog_num='0004' or aribitprog_num='0007' or aribitprog_num='0008') and  recevice_code in (#{@rc.chop}) " )
    @case_count2 = TbCase.count(:conditions=>"(aribitprog_num='0001' or aribitprog_num='0002' or aribitprog_num='0005' or aribitprog_num='0006') and  recevice_code in (#{@rc.chop}) " )

    # 代（申）、代（被）情况
    @agent1 = TbAgent.find(:all, :conditions => "recevice_code in (#{@rc.chop})  and used = 'Y' and partytype='1' ",:select => "recevice_code,name,count(NAME)" ,:group=>"name")
    @agent2 = TbAgent.find(:all, :conditions => "recevice_code in (#{@rc.chop})  and used = 'Y' and partytype='2' ",:select => "recevice_code,name,count(NAME)" ,:group=>"name")


    render "census3/_genxin"
  end
  #--------------↑↑ add by duyongwen ↑↑----------------

  # 管辖权决定数统计
  def list3_12
    # 立案时间
    @d1 = params[:d1]
    @d2 = params[:d2]
    # 提出时间
    @d3 = params[:d3]
    @d4 = params[:d4]

    if(!@d1.blank? and !@d2.blank? and !@d3.blank? and !@d4.blank?) # 同时不为空
      @juri = VJurion.find(:all,
        :conditions => ["nowdate>=? and nowdate<=? and request_date>=? and request_date <=?",@d1,@d2,@d3,@d4],
        :group => "recevice_code",
        :order => "right(case_code,7)"
      )
    elsif(!@d1.blank? and !@d2.blank?)
      @juri = VJurion.find(:all,
        :conditions => ["nowdate>=? and nowdate<=?",@d1,@d2],
        :group => "recevice_code",
        :order => "right(case_code,7)"
      )
    elsif(!@d3.blank? and !@d4.blank?)
      @juri = VJurion.find(:all,
        :conditions => [" request_date>=? and request_date <=?",@d3,@d4],
        :group => "recevice_code",
        :order => "right(case_code,7)"
      )
    else
      @juri = []
    end

  end

  # 管辖权决定详细信息
  def list_j
    d1 = params[:d1]
    d2 = params[:d2]
    # 提出时间
    d3 = params[:d3]
    d4 = params[:d4]
    rc = params[:recevice_code]

    if(!d1.blank? and !d2.blank? and !d3.blank? and !d4.blank?) # 同时不为空
      @juri = VJurion.find(:all,
        :conditions => ["nowdate>=? and nowdate<=? and request_date>=? and request_date <=? and recevice_code=? ",d1,d2,d3,d4,rc],
        :order => "request_date"
      )
    elsif(!d1.blank? and !d2.blank?)
      @juri = VJurion.find(:all,
        :conditions => ["nowdate>=? and nowdate<=? and recevice_code=? ",d1,d2,rc],
        :order => "request_date"
      )
    elsif(!d3.blank? and !d4.blank?)
      @juri = VJurion.find(:all,
        :conditions => [" request_date >=? and request_date <=? and recevice_code=?",d3,d4,rc],
        :order => "request_date"
      )
    else
      @juri = []
    end

  end

  # 仲裁员回避件数
  def list3_13
    # 立案时间
    @d1 = params[:d1]
    @d2 = params[:d2]
    # 提出时间
    @d3 = params[:d3]
    @d4 = params[:d4]

    if(!@d1.blank? and !@d2.blank? and !@d3.blank? and !@d4.blank?) # 同时不为空
      @vevite = TbEvite.find(:all,
        :select => "distinct recevice_code",
        :conditions => ["used='Y' and recevice_code in (select recevice_code from tb_cases where nowdate<= ? and nowdate >=? and used='Y' ) and requestdate <= ? and requestdate >= ? ",@d2,@d1,@d4,@d3 ],
        :order => "right(case_code,7) desc"
      )
    elsif(!@d1.blank? and !@d2.blank?)
      @vevite = TbEvite.find(:all,
        :select => "distinct recevice_code",
        :conditions => ["used='Y' and recevice_code in (select recevice_code from tb_cases where nowdate<= ? and nowdate >=? and used='Y' )",@d2,@d1 ],
        :order => "right(case_code,7) desc"
      )
    elsif(!@d3.blank? and !@d4.blank?)
      @vevite = TbEvite.find(:all,
        :select => "distinct recevice_code",
        :conditions => ["used='Y' and recevice_code in (select recevice_code from tb_cases where used='Y' ) and requestdate <= ? and requestdate >= ? ",@d4,@d3 ],
        :order => "right(case_code,7) desc"
      )
    else
      @vevite = []
    end

 end

  # 补正、更正裁决数
  def list3_14
    @state = {'01'=>"补充裁决",'02'=>"裁决书更正"}

    @datestyle = params[:datestyle]
    @typ = params[:typ]
    @d1 = params[:d1]
    @d2 = params[:d2]

    if @datestyle.blank?
      @datestyle = '01'
    end

    if @typ.blank?
      @typ='1'
    end

    if @d1.blank?
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2.blank?
      @d2=Time.now.to_date
    end

    if @typ == '1' # 按照立案时间查询
      #补充裁决
      @casebook1=VCasebook.find(:all,:conditions=>["book_typ='0005' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"right(case_code,7)")
      #更正裁决
      @casebook2=VCasebook.find(:all,:conditions=>["book_typ='0004' and nowdate>=? and nowdate<=?",@d1,@d2],:group=>"right(case_code,7)")
    else # 按照结案时间查询
      #补充裁决
      @casebook1=VCasebook.find(:all,:conditions=>["book_typ='0005' and decideDate>=? and decideDate<=?",@d1,@d2],:group=>"right(case_code,7)")
      #更正裁决
      @casebook2=VCasebook.find(:all,:conditions=>["book_typ='0004' and decideDate>=? and decideDate<=?",@d1,@d2],:group=>"right(case_code,7)")
    end
  end

  # 中止案件查询
  def list3_33
    @state={-1=>"重审",1=>"咨询",2=>"历史",3=>"不受理",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请",200=>"存档"}
    @hant_search_1_page_name="list3_33"
    @hant_search_1=[
      ['char','tb_cases.case_code','立案号','text',[]],
      ['char','IFNULL(tb_adjudgebrikes.requestman_type,\\\'\\\')','要求中止方','select',TbDictionary.find(:all,:conditions=>"typ_code='8106' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_adjudgebrikes.linkman_name','中止方名称','text',[]],
      ['date','IFNULL(tb_adjudgebrikes.end_date,\\\'\\\')','中止日期','text',[]]
    ]
    @hant_search_1_list=['tb_cases.case_code','IFNULL(tb_adjudgebrikes.requestman_type,\\\'\\\')','tb_adjudgebrikes.linkman_name','IFNULL(tb_adjudgebrikes.end_date,\\\'\\\')']
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases.case_code,7)"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end

    c="tb_adjudgebrikes.recevice_code=tb_cases.recevice_code and tb_adjudgebrikes.used='Y' and tb_cases.state>=4 and tb_cases.state<100 and tb_adjudgebrikes.stoped=1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(TbCase,"select distinct tb_cases.state as tb_cases_state,tb_cases.recevice_code as tb_cases_recevice_code,tb_cases.case_code as tb_cases_case_code,tb_cases.end_code as tb_cases_end_code,tb_cases.clerk as tb_cases_clerk,tb_adjudgebrikes.requestman_type as tb_adjudgebrikes_requestman_type,tb_adjudgebrikes.linkman_name as tb_adjudgebrikes_linkman_name,tb_adjudgebrikes.end_date as tb_adjudgebrikes_end_date from tb_adjudgebrikes,tb_cases where #{c}  order by #{@order}",@page_lines.to_i)
    @c_l=TbCase.find_by_sql("select distinct tb_cases.state as tb_cases_state,tb_cases.recevice_code as tb_cases_recevice_code,tb_cases.case_code as tb_cases_case_code,tb_cases.end_code as tb_cases_end_code,tb_cases.clerk as tb_cases_clerk,tb_adjudgebrikes.requestman_type as tb_adjudgebrikes_requestman_type,tb_adjudgebrikes.linkman_name as tb_adjudgebrikes_linkman_name,tb_adjudgebrikes.end_date as tb_adjudgebrikes_end_date from tb_adjudgebrikes,tb_cases where #{c}  order by #{@order}")
  end

  # 立 结 审 案件数量统计
  def list3_34
    @da1=params[:da1]
    @da2=params[:da2]
    if @da1==nil
      @da1=Time.now.at_beginning_of_year.to_date
    end
    if @da2==nil
      @da2=Time.now.to_date
    end

    @c=TbCase.find(:first,:conditions=>["used='Y' and nowdate>=? and nowdate<=? and state>=4",@da1,@da2],:select=>"count(id) as a,sum(amount) as s")
    if @c!=nil
      @c1=@c.a.to_i
      @c2=@c.s
    else
      @c1=0
      @c2=0
    end
    #实收
    @charge=TbShouldCharge.find(:first,:conditions=>["s.used='Y' and (s.typ='0001' or s.typ='0004')"],:joins=>"as s inner join tb_cases as c on s.recevice_code=c.recevice_code and c.used='Y' and c.nowdate>='#{@da1}' and c.nowdate<='#{@da2}' and c.state>=4",:select=>"sum(s.re_rmb_money) as cc")
    if @charge!=nil
      @c3=@charge.cc
    else
      @c3=0
    end
    #一般裁决   #####################################
    @d_1=TbCase.find(:first,:conditions=>"c.used='Y' and c.state>=4  and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@da1}' and s.decideDate<='#{@da2}' and c.recevice_code=s.recevice_code and s.endStyle='0001'",:select=>"count(distinct c.recevice_code) as cc,sum(c.amount) as ss")
    if @d_1!=nil
      @d1=@d_1.cc.to_i
      @d2=@d_1.ss
    else
      @d1=0
      @d2=0
    end

    @d_4=TbShouldCharge.find_by_sql("select sum(s.re_rmb_money) as cc from tb_cases as c,tb_should_charges as s,tb_caseendbooks as e where e.used='Y' and e.endStyle='0001' and e.decideDate>='#{@da1}' and e.decideDate<='#{@da2}' and e.recevice_code=c.recevice_code and c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null and c.recevice_code=s.recevice_code and s.used='Y' and (s.typ='0001' or s.typ='0004')")
    d_4=PubTool.new.get_first_record(@d_4)
    if d_4!=nil
      @d3=d_4.cc
    else
      @d3=0
    end
    #和裁    ############################################
    @e_1=TbCase.find(:first,:conditions=>"c.used='Y' and c.state>=4  and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@da1}' and s.decideDate<='#{@da2}' and c.recevice_code=s.recevice_code and s.endStyle='0002'",:select=>"count(distinct c.recevice_code) as cc,sum(c.amount) as ss")
    if @e_1!=nil
      @e1=@e_1.cc.to_i
      @e2=@e_1.ss
    else
      @e1=0
      @e2=0
    end
    @d_4=TbShouldCharge.find_by_sql("select sum(s.re_rmb_money) as cc from tb_cases as c,tb_should_charges as s,tb_caseendbooks as e where e.used='Y' and e.endStyle='0002' and e.decideDate>='#{@da1}' and e.decideDate<='#{@da2}' and e.recevice_code=c.recevice_code and c.used='Y' and c.state>=4  and c.caseendbook_id_first is not null and c.recevice_code=s.recevice_code and s.used='Y' and (s.typ='0001' or s.typ='0004')")
    d_4=PubTool.new.get_first_record(@d_4)
    if d_4!=nil
      @e3=d_4.cc
    else
      @e3=0
    end

    #撤案     ############################################
    @f_1=TbCase.find(:first,:conditions=>"c.used='Y' and c.state>=4  and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@da1}' and s.decideDate<='#{@da2}' and c.recevice_code=s.recevice_code and s.endStyle='0003'",:select=>"count(distinct c.recevice_code) as cc,sum(c.amount) as ss")
    if @f_1!=nil
      @f1=@f_1.cc.to_i
      @f2=@f_1.ss
    else
      @f1=0
      @f2=0
    end
    @d_4=TbShouldCharge.find_by_sql("select sum(s.re_rmb_money) as cc from tb_cases as c,tb_should_charges as s,tb_caseendbooks as e where e.used='Y' and e.endStyle='0003' and e.decideDate>='#{@da1}' and e.decideDate<='#{@da2}' and e.recevice_code=c.recevice_code and c.used='Y' and c.state>=4  and c.caseendbook_id_first is not null and c.recevice_code=s.recevice_code and s.used='Y' and (s.typ='0001' or s.typ='0004')")
    d_4=PubTool.new.get_first_record(@d_4)
    if d_4!=nil
      @f3=d_4.cc
    else
      @f3=0
    end
    #未组庭  #################################### and caseorg_id_first is null
    @m_1=TbCase.find(:first,:conditions=>"used='Y' and nowdate>='#{@da1}' and nowdate<='#{@da2}' and state=4 and caseorg_id_first is null and caseendbook_id_first is null",:select=>"count(id) as cc,sum(amount) as ss")
    if @m_1!=nil
      @m1=@m_1.cc.to_i
      @m2=@m_1.ss
    else
      @m1=0
      @m2=0
    end
    #实收  and c.caseorg_id_first is null
    @charge=TbShouldCharge.find(:first,:conditions=>["s.used='Y' and (s.typ='0001' or s.typ='0004')"],:joins=>"as s inner join tb_cases as c on s.recevice_code=c.recevice_code and c.used='Y' and c.nowdate>='#{@da1}' and c.nowdate<='#{@da2}' and c.state=4 and c.caseorg_id_first is null and c.caseendbook_id_first is null",:select=>"sum(s.re_rmb_money) as cc")
    if @charge!=nil
      @m3=@charge.cc
    else
      @m3=0
    end
    #已组庭未开庭  #################################  and caseorg_id_first is not null
    @n_1=TbCase.find(:first,:conditions=>"used='Y' and nowdate>='#{@da1}' and nowdate<='#{@da2}' and state=5 and caseendbook_id_first is null and caseorg_id_first is not null and sitting_id_first is null",:select=>"count(id) as c2,sum(amount) as s2")
    if @n_1!=nil
      @n1=@n_1.c2.to_i
      @n2=@n_1.s2
    else
      @n1=0
      @n2=0
    end
    @charge=TbShouldCharge.find(:first,:conditions=>["s.used='Y' and (s.typ='0001' or s.typ='0004')"],:joins=>"as s inner join tb_cases as c on s.recevice_code=c.recevice_code and c.used='Y' and c.nowdate>='#{@da1}' and c.nowdate<='#{@da2}' and c.state=5 and c.caseendbook_id_first is null and c.caseorg_id_first is not null and c.sitting_id_first is null",:select=>"sum(s.re_rmb_money) as c3")
    if @charge!=nil
      @n3=@charge.c3
    else
      @n3=0
    end
    #已开庭  ################################# sitting_id_first
    @q_1=TbCase.find(:first,:conditions=>"used='Y' and nowdate>='#{@da1}' and nowdate<='#{@da2}' and sitting_id_first is not null and caseendbook_id_first is null",:select=>"count(id) as cc,sum(amount) as ss")
    if @q_1!=nil
      @q1=@q_1.cc.to_i
      @q2=@q_1.ss
    else
      @q1=0
      @q2=0
    end
    @charge=TbShouldCharge.find(:first,:conditions=>["s.used='Y' and (s.typ='0001' or s.typ='0004')"],:joins=>"as s inner join tb_cases as c on s.recevice_code=c.recevice_code and c.used='Y' and c.nowdate>='#{@da1}' and c.nowdate<='#{@da2}' and c.sitting_id_first is not null and c.caseendbook_id_first is null",:select=>"sum(s.re_rmb_money) as cc")
    if @charge!=nil
      @q3=@charge.cc
    else
      @q3=0
    end
  end

  # 查看立案阶段案件数量明细
  def list34_a
    @d1=params[:da1]
    @d2=params[:da2]
    if params[:k]=='1'
      @case=TbCase.find(:all,:conditions=>["used='Y' and nowdate>=? and nowdate<=? and state>=4",@d1,@d2],:order=>"right(case_code,7) desc")
    elsif params[:k]=='2'
      @case=TbCase.find(:all,:conditions=>"c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@d1}' and s.decideDate<='#{@d2}' and c.recevice_code=s.recevice_code and s.endStyle='0001'",:select=>"c.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.amount as amount,c.clerk as clerk,s.decideDate as decideDate,s.arbitBookNum as arbitBookNum",:order=>"right(c.case_code,7) desc")
    elsif params[:k]=='3'
      @case=TbCase.find(:all,:conditions=>"c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@d1}' and s.decideDate<='#{@d2}' and c.recevice_code=s.recevice_code and s.endStyle='0002'",:select=>"c.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.amount as amount,c.clerk as clerk,s.decideDate as decideDate,s.arbitBookNum as arbitBookNum",:order=>"right(c.case_code,7) desc")
    elsif params[:k]=='4'
      @case=TbCase.find(:all,:conditions=>"c.used='Y' and c.state>=4 and c.caseendbook_id_first is not null",:joins=>"as c inner join tb_caseendbooks as s on s.used='Y' and s.decideDate>='#{@d1}' and s.decideDate<='#{@d2}' and c.recevice_code=s.recevice_code and s.endStyle='0003'",:select=>"c.recevice_code as recevice_code,c.nowdate as nowdate,c.case_code as case_code,c.amount as amount,c.clerk as clerk,s.decideDate as decideDate,s.arbitBookNum as arbitBookNum",:order=>"right(c.case_code,7) desc")
    elsif params[:k]=='5'
      @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@d1}' and nowdate<='#{@d2}' and state=4 and caseorg_id_first is null and caseendbook_id_first is null",:select=>"recevice_code,nowdate,case_code,amount,clerk",:order=>"right(case_code,7) desc")
    elsif params[:k]=='6'
      @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@d1}' and nowdate<='#{@d2}' and state=5 and caseorg_id_first is not null and sitting_id_first is null and caseendbook_id_first is null",:select=>"recevice_code,nowdate,case_code,amount,clerk",:order=>"right(case_code,7) desc")
    else
      @case=TbCase.find(:all,:conditions=>"used='Y' and nowdate>='#{@d1}' and nowdate<='#{@d2}' and sitting_id_first is not null and caseendbook_id_first is null",:select=>"recevice_code,nowdate,case_code,amount,clerk",:order=>"right(case_code,7) desc")
    end
  end

  # 核校工作统计
  def list4
    @da1 = params[:da1]
    @da2 = params[:da2]
    if @da1 == nil
      @da1 = Time.now.at_beginning_of_year.to_date
    end
    if @da2 == nil
      @da2 = Time.now.to_date
    end
    @users = User.find_by_sql("
      SELECT DISTINCT
         users.CODE as code,users.NAME as name
      FROM
         users,user_duties
      WHERE users.used = 'Y' AND users.states = 'Y' AND users. CODE = user_duties.user_code
       AND user_duties.duty_code = '0007' ORDER BY users. CODE
      ")
  end

  # 核校工作统计 校核人员所有案件
  def c_list
    @da1 = params[:da1]
    @da2 = params[:da2]
    @order = params[:order]
    if @order == nil or @order == ""
      @order = "right(c.case_code,7) desc"
    end
    @endStyle = TbDictionary.find(:first,:conditions=>["typ_code='8117' and state='Y'" ])
    @arbitmantype = {"0001"=>"独","0002"=>"首","0003"=>"申","0004"=>"被"}
    sql = "
      select distinct c.recevice_code, c.state, c.general_code, c.case_code, c.end_code, c.clerk, e.decidedate, e.endstyle
      from tb_check_staffs s
      left join tb_cases c on c.recevice_code = s.recevice_code and c.used = 'Y'
      left join tb_caseendbooks e on s.recevice_code = e.recevice_code and e.used = 'Y'
      where s.used = 'Y' and s.check_time <= '#{@da2}' and s.check_time >= '#{@da1}' and s.staff = '#{params[:user_code]}'
      order by #{@order}
    "
    @case = VCaseQuery1List5.find_by_sql(sql);
  end


  # 在办案件仲裁员信息
  def list3_16
    @arbitman_case = TbCase.find_by_sql("select distinct tb_arbitmen.name as name from tb_cases,tb_casearbitmen,tb_arbitmen where tb_arbitmen.complete='N' and  tb_cases.caseorg_id_last=tb_casearbitmen.id and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_cases.state>=4 and tb_cases.caseendbook_id_first is null  and tb_cases.used='Y' and tb_casearbitmen.used='Y' order by tb_arbitmen.name")
  end


  #
  def list_32
    @hant_search_1_page_name="list_32"
    @hant_search_1=[
      ['char','tb_cases_case_code','受案号','text',[]],
      ['char','tb_cases_end_code','结案号','text',[]],
      ['date','tb_cases_nowdate','受案时间','text',[]],
      ['date','tb_caseendbooks_decideDate','结案时间','text',[]],
      ['char','tb_parties_partyname','当事人','text',[]]
    ]
    @hant_search_1_list=['tb_cases_case_code','tb_cases_nowdate','tb_caseendbooks_decideDate','tb_parties_partyname'
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="cases.tb_caseendbooks_decideDate desc"
      
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="select distinct tb_cases_recevice_code, tb_cases_case_code, tb_cases_end_code,tb_cases_nowdate, tb_caseendbooks_decideDate from v_case_query1_list1s  where tb_cases_used='Y' and tb_cases_state>=4 "
    #c="tb_cases_state>=-1 and tb_cases_state<>2 and tb_cases_state<>3"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    sql = "select cases.tb_cases_case_code as tb_cases_case_code,cases.tb_cases_nowdate as tb_cases_nowdate, cases.tb_caseendbooks_decideDate as tb_caseendbooks_decideDate,cases.tb_cases_end_code as tb_cases_end_code, (select sum(tb_should_charges.re_rmb_money)  from tb_should_charges where tb_should_charges.recevice_code=cases.tb_cases_recevice_code and tb_should_charges.typ in ('0001','0004','0009') and tb_should_charges.used='Y') as n1,(select sum(tb_should_charges.re_rmb_money)  from tb_should_charges where tb_should_charges.recevice_code=cases.tb_cases_recevice_code and tb_should_charges.typ in ('0008') and tb_should_charges.used='Y') as n2,(select sum(tb_should_refunds.rmb_money)  from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ in ('0001','0004','0009') and tb_should_refunds.used='Y') as n3,(select sum(tb_should_refunds.rmb_money) from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ='0008' and tb_should_refunds.used='Y')  as n4,(select sum(tb_should_refunds.re_rmb_money)  from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ in ('0001','0004','0009') and tb_should_refunds.used='Y') as n5,(select sum(tb_should_refunds.re_rmb_money)  from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ='0008' and tb_should_refunds.used='Y') as n6,(select sum(tb_should_charges.re_rmb_money)  from tb_should_charges where tb_should_charges.recevice_code=cases.tb_cases_recevice_code and tb_should_charges.typ in ('0007') and tb_should_charges.used='Y') as n9,(select sum(tb_should_refunds.rmb_money)  from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ in ('0007') and tb_should_refunds.used='Y') as n10,(select sum(tb_should_refunds.re_rmb_money)  from tb_should_refunds where tb_should_refunds.recevice_code=cases.tb_cases_recevice_code and tb_should_refunds.typ in ('0007') and tb_should_refunds.used='Y') as n11,fun_partyinfo_1(cases.tb_cases_recevice_code) as n12,fun_partyinfo_2(cases.tb_cases_recevice_code) as n13  from (" +  c + " ) as cases";
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1, sql +  " order by #{@order}",@page_lines.to_i)
    
  end
  
end