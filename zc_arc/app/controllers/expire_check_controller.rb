#2009-7-20  niell  届信息查询
class ExpireCheckController < ApplicationController
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','expire','届','text',[]],
      ['char','arbitman_name','姓名','text',[]],
      ['char','arbitman_num','仲裁员编码','text',[]]]
    @hant_search_1_list=['expire','arbitman_name','arbitman_num']
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c=" used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @tb_arbitmanexprires_pages,@expires=paginate(:tb_arbitmanexprires,:conditions=>c ,:order=>"expire",:select=>"distinct expire,arbitman_name,arbitman_num",:per_page=>@page_lines.to_i)
  end
end
