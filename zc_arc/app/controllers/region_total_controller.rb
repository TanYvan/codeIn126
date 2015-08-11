class RegionTotalController < ApplicationController
  #当事人国别统计
  def list
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @typ==nil
      @typ='1'
    end
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='0' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end
  
  #某地区当事人数量统计
  def list_2
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    @area=params[:area]
    if @d1!=nil and @d2!=nil and @area!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@area)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(tb_cases.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(tb_cases.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area = regions.code and regions.code='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
      end
    end
  end
  
  #广东省各市当事人统计
  def list_3
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @typ==nil
      @typ='1'
    end
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='001001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='001001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end
  
  #国内各省当事人统计
  def list_4
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @typ==nil
      @typ='1'
    end
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    if @d1!=nil and @d2!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(regions.code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='001' and nowdate>='#{@d1}' and nowdate<='#{@d2}'   group by regions.code order by regions.code")
      end
    end
  end
  
  #某地区案件数量统计
  def list_5
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    @area=params[:area]
    if @d1!=nil and @d2!=nil and @area!=nil
      if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false and p.sql_check_3(@area)!=false
        puts "select regions.code as code,regions.name as name,count(distinct tb_cases.recevice_code) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code"
        @re=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(distinct CONCAT(tb_parties.area ,tb_parties.recevice_code)) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and (tb_parties.area like CONCAT(regions.code,'%')) and regions.parent='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
        @re_2=TbCase.find_by_sql("select regions.code as code,regions.name as name,count(distinct CONCAT(tb_parties.area ,tb_parties.recevice_code)) as c from tb_cases,tb_parties,regions where tb_cases.used='Y' and tb_parties.used='Y' and tb_cases.state>=4 and tb_cases.recevice_code=tb_parties.recevice_code and tb_parties.area=regions.code and regions.code='#{@area}' and nowdate>='#{@d1}' and nowdate<='#{@d2}' group by regions.code order by regions.code")
      end
    end
  end
  
end
