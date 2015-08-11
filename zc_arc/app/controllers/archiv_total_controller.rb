class ArchivTotalController < ApplicationController
  
  def list
    @clerk=params[:clerk]
    @d1=params[:d1]
    @d2=params[:d2]
    if @clerk==nil
      @clerk=''
    end
    if @d1==nil
      @d1=Time.now.months_ago(1).to_date.to_s(:db)
      @d1 = @d1.slice(0,7)+"-01"
    end
    if @d2==nil
      @d2=Time.now.months_since(1).to_date.to_s(:db)
      @d2 = @d2.slice(0,7)+"-01"
    end
    p=PubTool.new()
    if p.sql_check_3(@clerk)!=false and p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
      if @clerk==''
        @ttt = TbCase.find_by_sql("select  tb_cases.clerk,users.name,count(tb_cases.id) as end_count,sum(case WHEN (file_up_u='') THEN 0 ELSE 1  END) as arc_count,sum(CASE WHEN (tb_cases.file_up_t is  null or tb_caseendbooks.decideDate  is  null) THEN 0 ELSE DATEDIFF(tb_cases.file_up_t,tb_caseendbooks.decideDate)  END) as  d_count,sum(CASE WHEN (tb_cases.file_receive_t is  null or tb_caseendbooks.decideDate  is  null) THEN 0 ELSE DATEDIFF(tb_cases.file_receive_t,tb_caseendbooks.decideDate)  END) as  d_count_2  ,sum(tb_cases.file_num_1) as file_num_1,sum(tb_cases.file_num_2) as file_num_2,sum(tb_cases.file_num_3) as file_num_3,sum(case when (tb_cases.file_typ='0001') then 1 else 0 end) as file_typ_0001,sum(case when (tb_cases.file_typ='0002') then 1 else 0 end) as file_typ_0002 from tb_cases,tb_caseendbooks,users where tb_cases.clerk=users.code and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_caseendbooks.decideDate>='#{@d1}' and tb_caseendbooks.decideDate<='#{@d2}' group by tb_cases.clerk order by users.ord")
      else 
        @ttt= TbCase.find_by_sql("select  tb_cases.clerk,users.name,count(tb_cases.id) as end_count,sum(case WHEN (file_up_u='') THEN 0 ELSE 1  END) as arc_count,sum(CASE WHEN (tb_cases.file_up_t is  null or tb_caseendbooks.decideDate  is  null) THEN 0 ELSE DATEDIFF(tb_cases.file_up_t,tb_caseendbooks.decideDate)  END) as  d_count,sum(CASE WHEN (tb_cases.file_receive_t is  null or tb_caseendbooks.decideDate  is  null) THEN 0 ELSE DATEDIFF(tb_cases.file_receive_t,tb_caseendbooks.decideDate)  END) as  d_count_2  ,sum(tb_cases.file_num_1) as file_num_1,sum(tb_cases.file_num_2) as file_num_2,sum(tb_cases.file_num_3) as file_num_3,sum(case when (tb_cases.file_typ='0001') then 1 else 0 end) as file_typ_0001,sum(case when (tb_cases.file_typ='0002') then 1 else 0 end) as file_typ_0002 from tb_cases,tb_caseendbooks,users where tb_cases.clerk=users.code and tb_cases.caseendbook_id_first=tb_caseendbooks.id and tb_cases.used='Y' and tb_caseendbooks.used='Y' and tb_caseendbooks.decideDate>='#{@d1}' and tb_caseendbooks.decideDate<='#{@d2}' and tb_cases.clerk='#{@clerk}'  group by tb_cases.clerk order by users.ord")
      end
    end
    
  end
  
end
