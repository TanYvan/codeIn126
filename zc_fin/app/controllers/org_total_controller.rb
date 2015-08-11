class OrgTotalController < ApplicationController
  def p_set
    if params[:p_typ]=="" or params[:p_typ]==nil
      org=[["",""]]
    elsif params[:p_typ]=='0001'
      org=TbOrg.find(:all,:conditions=>"used='Y'",:order=>'code',:select=>"name,code").collect{|p|[p.name,p.code]}.insert(0,["",""])
    elsif params[:p_typ]=='0002'
      org=TbPeriod.find_by_sql("select tb_expertconsults.code as code,tb_expertconsults.name as name from tb_expertconsults where tb_expertconsults.used='Y'  order by tb_expertconsults.name").collect{|p|[p.name,p.code]}.insert(0,["",""])
    end
    render :update do |page|
      page.remove 'org_code'
      page.replace_html 'pv_set', :partial => 'pv',:object=>org
    end
  end
  def list
    @org_typ_all=[["",""],["机构","0001"],["专家","0002"]]
    @d1=params[:d1]
    @d2=params[:d2]
    @org_typ=params[:org_typ]
    @org_code=params[:org_code]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @case_code=params[:case_code]
    if @org_typ==nil or @org_typ==""
      @org_code_all=[["",""]]
    elsif @org_typ=="0001"
      @org_code_all=TbOrg.find(:all,:conditions=>"used='Y'",:order=>'code',:select=>"code,name").collect{|p|[p.name,p.code]}.insert(0,["",""])
    elsif @org_typ=="0002"
      @org_code_all=TbPeriod.find_by_sql("select tb_expertconsults.code as code,tb_expertconsults.name as name from tb_expertconsults where tb_expertconsults.used='Y'  order by tb_expertconsults.name").collect{|p|[p.name,p.code]}.insert(0,["",""])
    end
    c = "tb_cases.used='Y' and tb_org_appraisals.used='Y' and tb_cases.recevice_code=tb_org_appraisals.recevice_code and tb_org_appraisals.consign_t>='#{@d1}' and tb_org_appraisals.consign_t<='#{@d2}'"
    if @case_code!='' and @case_code!=nil
      c =c + " and tb_cases.case_code like '%#{@case_code}%'"
    end
    if @org_typ!='' and @org_typ!=nil
      c =c + " and tb_org_appraisals.org_typ='#{@org_typ}'"
    end
    if @org_code!='' and @org_code!=nil
      c =c + " and tb_org_appraisals.org_code='#{@org_code}'"
    end
    p=PubTool.new()
    if  p.sql_check_3(c)!=false
      @org_total=TbOrgAppraisal.find_by_sql("select tb_org_appraisals.org_typ as org_typ,tb_org_appraisals.org_code as org_code,count(tb_org_appraisals.org_code) as c,sum(tb_org_appraisals.time_limit) as time_limit_sum,sum(tb_org_appraisals.charge_ratio) as charge_ratio_sum,sum(CASE tb_org_appraisals.obj WHEN 'Y' THEN  1  ELSE 0 END) as obj_sum, 
sum(CASE tb_org_appraisals.efficiency WHEN 'A' THEN  1  ELSE 0 END) as efficiency_A,sum(CASE tb_org_appraisals.efficiency WHEN 'B' THEN  1  ELSE 0  END) as efficiency_B,sum(CASE tb_org_appraisals.efficiency WHEN 'C' THEN  1  ELSE 0 END) as efficiency_C,
sum(CASE tb_org_appraisals.report_quality WHEN 'A' THEN  1  ELSE 0 END) as report_quality_A,sum(CASE tb_org_appraisals.report_quality WHEN 'B' THEN  1  ELSE 0 END) as report_quality_B,sum(CASE tb_org_appraisals.report_quality WHEN 'C' THEN  1  ELSE 0 END) as report_quality_C
    from tb_org_appraisals,tb_cases where #{c} group by tb_org_appraisals.org_typ,tb_org_appraisals.org_code order by tb_org_appraisals.org_typ,tb_org_appraisals.org_code ")
    end
  end
  
  def detail
    c="used='Y' and org_typ='#{params[:org_typ]}' and org_code='#{params[:org_code]}' and consign_t>='#{params[:d1]}' and consign_t<='#{params[:d2]}'"
    p=PubTool.new()
    if p.sql_check_3(c)!=false
      @org_appraisal=TbOrgAppraisal.find(:all,:conditions=>c,:order=>"consign_t asc")
    end  
  end
  
  def detail_view
    @org_appraisal=TbOrgAppraisal.find(params[:id])
  end
  
end
