=begin
创建人：聂灵灵
创建时间：2009-5-14
类的描述：此控制器是处理字典表页面的信息及维护。
页面：
字典表信息列表:/dictionary/dictionary_list
创建字典表信息：/dictionary/dictionary_new
修改字典表信息：/dictionary/dictionary_edit
=end
class DictionaryController < ApplicationController

  def dictionary_list
    @hant_search_1_page_name="dictionary_list"
    @hant_search_1=[['char','typ_code','类别编码','text',[]],
      ['char','data_val','参数值','text',[]],
      ['char','data_text','参数显示','text',[]],
      ['char','data_parent','父参数','text',[]],
      ['char','state','参数状态','text',[]]
    ]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit] 
    if @search_condit==nil
      @search_condit=""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end

    @dictionary_pages,@dictionary=paginate(:tb_dictionaries,:conditions=>c,:order=>"typ_code,data_parent,ind,data_val",:per_page=>@page_lines.to_i)
  end
  def dictionary_new
    @dictionary=TbDictionary.new()
    @dictionary.state='Y'
  end
  def dictionary_create
    @dictionary=TbDictionary.new(params[:dictionary])
    if @dictionary.save
      flash[:notice]="创建成功"
      redirect_to :action=>"dictionary_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"dictionary_new",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def dictionary_edit
    @dictionary=TbDictionary.find(params[:id])
  end

  def dictionary_update
    @dictionary=TbDictionary.find(params[:id])
    if @dictionary.update_attributes(params[:dictionary])
      flash[:notice]="修改成功"
      redirect_to :action=>"dictionary_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"dictionary_edit",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def dictionary_delete
    @dictionary=TbDictionary.find(params[:id])
    @dictionary.state"N"
    @dictionary.used="N"
    if @dictionary.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"dictionary_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
