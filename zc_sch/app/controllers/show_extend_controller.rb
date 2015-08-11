#显示报酬发放信息的控制器
#添加人 苏获
#添加时间 20090527
class ShowExtendController < ApplicationController
  #显示所有的报酬发放的列表
  def list_extend_code
    @hant_search_1_page_name="list_extend_code"
    @hant_search_1=[['char','extend_code','发放编号','text',[]],['date','extend_dat','发放日期','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
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
    p=PubTool.new()
    c="1=1 "
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @extend_code_pages,@tb_extend_codes =paginate(:tb_extend_codes,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
#    @extend_code_pages,@tb_extend_codes =paginate(:tb_extend_codes,:order=>@order,:per_page=>@page_lines.to_i)
 end
  #某个报酬发放编码下的报酬发放列表
  def list_extend
    @extend_code = params[:extend_code]
    @extend_dat = params[:extend_dat]
    @u = params[:u]
    @order=params[:order]
    if @order==nil or @order==""
      @order="end_code asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
    end
    #查询条件的处理
    c = "extend_code = '" + params[:id] + "'"
    @general_code = params[:general_code]
    if @general_code != nil and @general_code != ""
      c += "and general_code = " + @general_code
    end
    @case_code = params[:case_code]
    if(@case_code != nil and @case_code != "")
      c += " and case_code = '" + @case_code + "'"
    end
    @recevice_code = params[:recevice_code]
    if(@recevice_code != nil and @recevice_code != "")
      c += " and recevice_code = '" + @recevice_code + "'"
    end
    @end_code = params[:end_code]
    if @end_code != nil and @end_code != ""
      c += "and end_code = " + @end_code
    end
    #人员类型处理稍微复杂
    @p_typ = params[:p_typ]
    if(@p_typ != nil and @p_typ != "未选")
      if @p_typ == "仲裁员"
        c += " and p_typ = " + "0001"
      elsif @p_typ == "助理"
        c += " and p_typ = " + "0002"
      else
        c += " and p_typ = " + "0003"
      end
    end
    @p = params[:p]
    if(@p != nil and @p != "")
      c += " and p = '" + @p + "'"
    end
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions => c,:order=>"end_code asc",:per_page=>@page_lines.to_i)
        
  end
end
