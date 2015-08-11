class PeriodCheckController < ApplicationController
  def list
    @hant_search_1_r=params[:hant_search_1_r]
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','expire','届','text',[]],
      ['char','name','姓名','text',[]],
      ['char','code','编码','text',[]]]
    @hant_search_1_list=['expire','name','code']
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
    @expire_pages,@expire=paginate(:tb_period_expires,:conditions=>c ,:order=>"expire",:select=>"distinct expire,code,name",:per_page=>@page_lines.to_i)
  end
end
