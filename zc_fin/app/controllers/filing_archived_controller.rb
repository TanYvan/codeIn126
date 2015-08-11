class FilingArchivedController < ApplicationController
  
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],['char','tb_cases_general_code','总案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['date','date(tb_cases_file_up_t)','归档时间','text',[]],['char','tb_cases_clerk','助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(tb_cases_case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="tb_cases_state=220" #and clerk='#{session[:user_code]}'
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_file_num_1,tb_cases_file_num_2,tb_cases_file_num_3,tb_cases_file_typ from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
    @case_c=VCaseQuery1List1.find_by_sql("select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate,tb_cases_file_num_1,tb_cases_file_num_2,tb_cases_file_num_3,tb_cases_file_typ from v_case_query1_list1s where #{c} ")
    @case_count=SysArg.get_first_record(@case_c)
    if @case_count==nil
      @count=0
    else
      @count=@case_c.length
    end
  end
  
  def recall_do
    @case=TbCase.find(params[:id])
    if @case.state==220
       f=TbCaseFlow.del_flow(@case.recevice_code,'0010')
       if f!=0
         @case.state=f
       end 
       @case.file_up_u=''
       @case.file_up_t=Time.now
       if @case.update_attributes(params[:case]) 
          flash[:notice]="立案号：#{@case.case_code}案件归档回退成功"
       else
          flash[:notice]="立案号：#{@case.case_code}案件归档回退失败"
       end
       redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end
  
end
