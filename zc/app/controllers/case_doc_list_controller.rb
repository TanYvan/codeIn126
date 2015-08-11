class CaseDocListController < ApplicationController
  
  def case_list
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],['char','tb_cases_general_code','总案号','text',[]],['char','tb_cases_end_code','结案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_recevice_code desc"
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
    c="1=1"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def list
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    @doc=TbDoc.find(:all,:order=>'id',:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
  end
  
  def doc_down
    @doc=TbDoc.find(params[:id])
    @yea=@doc.recevice_code.slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/public/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}")#,:filename=>"#{name}.doc"/
  end
  
end
