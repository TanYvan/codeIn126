class ClerkChangeCzController < ApplicationController
  
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','IFNULL(tb_parties_partyname,\\\'\\\')','当事人名称','text',[]],
      ['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_recevice_code','咨询流水号','text',[]]
    ]
    @hant_search_1_list=['IFNULL(tb_parties_partyname,\\\'\\\')','tb_cases_case_code']
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_nowdate,tb_cases_general_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
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
    c="tb_cases_state<100 and tb_cases_state<>2 and tb_cases_state<>3 and tb_cases_caseendbook_id_first is null"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
   
  def change_list
    @falg={'0'=>"立案前",'1'=>"立案后"}
    @change=TbClerkchange.find(:all,:conditions=>"recevice_code='#{TbCase.find(params[:case_id]).recevice_code}'",:order=>"id") 
  end
  
  def new
    @clerks=User.find_by_sql("select code,name from users where used='Y' and states='Y' and code in (select user_code from user_duties where duty_code='0003') order by name")
    @change=TbClerkchange.new()
  end
   
  def create
    @change=TbClerkchange.new(params[:change])
    @change.recevice_code=TbCase.find(params[:case_id]).recevice_code
    @change.case_code=TbCase.find(params[:case_id]).case_code
    @change.general_code=TbCase.find(params[:case_id]).general_code
    @change.recevice_code=TbCase.find(params[:case_id]).recevice_code
    @change.beforeclerk=TbCase.find(params[:case_id]).clerk
    @change.u=session[:user_code]
    @change.t=Time.now()
     
    @case=TbCase.find(params[:case_id])
    @case.clerk=@change.afterclerk
    if @change.save and @case.save
      flash[:notice]="创建成功"
      redirect_to :action=>"change_list",:case_id=>"#{params[:case_id]}",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"change_list",:case_id=>"#{params[:case_id]}",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
     
  end
  
end
