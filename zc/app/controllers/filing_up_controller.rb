class FilingUpController < ApplicationController

  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_cases.end_code','结案号','text',[]],['char','tb_cases.case_code','立案号','text',[]],['char','clerk','助理','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord").collect{|p|[p.code,p.name]}.insert(0,["","全部"])]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="decideDate asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20000000000
    end
    @hant_search_1_r = params[:hant_search_1_r]
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
    c=" tb_caseendbooks.used = 'Y' AND tb_cases.state < 200  and tb_caseendbooks.decideDate > '2010-1-1' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    s=" SELECT tb_caseendbooks.decideDate,  tb_cases.*
        FROM tb_caseendbooks
        LEFT JOIN tb_cases ON tb_caseendbooks.recevice_code = tb_cases.recevice_code AND tb_cases.used = 'Y'
        WHERE " + c + " order by " + @order
    @case_pages, @case=paginate_by_sql(TbCaseendbook, s, @page_lines.to_i)
    @n_l = TbCaseendbook.count(c," LEFT JOIN tb_cases ON tb_caseendbooks.recevice_code = tb_cases.recevice_code AND tb_cases.used = 'Y' ")
  end

  def subm_text
    @case=TbCase.find(params[:id])
  end
  
  def subm
    @case=TbCase.find(params[:id])
    if @case.state<200
      if TbCaseFlow.check(@case.recevice_code,'0009')
         f=TbCaseFlow.add_flow(@case.recevice_code,'0009')
         if f!=0
           @case.state=f
         end
         @case.file_receive_u=session[:user_code]
         @case.file_receive_t=Time.now
         if @case.update_attributes(params[:case])
            flash[:notice]="立案号：#{@case.case_code}案件接收成功"
         else
            flash[:notice]="立案号：#{@case.case_code}案件接收失败"
         end
         redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
       else
            render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
       end
    end
  end

end
