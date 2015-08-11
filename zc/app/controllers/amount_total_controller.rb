class AmountTotalController < ApplicationController
  def list
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="typ"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @hant_search_1_r=params[:hant_search_1_r]
    @hant_search_1_page_name="list"
    @hant_search_1=[
      ['char','(CASE caseendbook_id_first is null WHEN true  THEN  0 ELSE 1 END)','是否结案','select',[[0,"否"],[1,"是"]],0],
      ['number','amount','争议金额','text',[],0],
      ['date','IFNULL(nowdate,\\\'\\\')','立案日期','text',[],Time.now.at_beginning_of_year.to_date.to_s(:db)],
    ]

    @hant_search_1_list=['(CASE caseendbook_id_first is null WHEN true  THEN  0 ELSE 1 END)','IFNULL(nowdate,\\\'\\\')']
    @hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    if @hant_search_1_word==nil
      @hant_search_1_word="(CASE caseendbook_id_first is null WHEN true  THEN  0 ELSE 1 END) = 0  and IFNULL(nowdate,'')>='" + Time.now.at_beginning_of_year.to_date.to_s(:db) + "'"
      @hant_search_1_text="是否结案 等于 否 并且 立案日期 大于等于 #{Time.now.at_beginning_of_year.to_date.to_s(:db)}"
    else
      
    end
    if p.sql_check_3(@hant_search_1_word)!=false
      @typ=TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y'",:order=>'data_val',:select=>"data_val,data_text")
    end
  end
  #查看不同仲裁程序类型案件争议金额的基本信息
  def every_case
    p=PubTool.new()
    @hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    if p.sql_check_3(@hant_search_1_word)!=false
      @case=TbCase.find(:all,:conditions=>["used='Y' and state>=4 and aribitprog_num=? and #{@hant_search_1_word}",params[:aribitprog_num]],:order=>"general_code")
      @data_text=TbDictionary.find(:first,:conditions=>["typ_code='0001' and state='Y' and data_val=?",params[:aribitprog_num]]).data_text
    end
  end

  def every_case1
    p=PubTool.new()
    @hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    if p.sql_check_3(@hant_search_1_word)!=false
      @case=TbCase.find(:all,:conditions=>["used='Y' and state>=4 and amount<10000000  and aribitprog_num=? and #{@hant_search_1_word}",params[:aribitprog_num]],:order=>"right(case_code,7)")
      @data_text=TbDictionary.find(:first,:conditions=>["typ_code='0001' and state='Y' and data_val=?",params[:aribitprog_num]]).data_text
    end
  end

  def every_case2
    p=PubTool.new()
    @hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    if p.sql_check_3(@hant_search_1_word)!=false
      @case=TbCase.find(:all,:conditions=>["used='Y' and state>=4 and amount>=10000000 and amount<50000000  and aribitprog_num=? and #{@hant_search_1_word}",params[:aribitprog_num]],:order=>"right(case_code,7)")
      @data_text=TbDictionary.find(:first,:conditions=>["typ_code='0001' and state='Y' and data_val=?",params[:aribitprog_num]]).data_text
    end
  end

  def every_case3
    p=PubTool.new()
    @hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    if p.sql_check_3(@hant_search_1_word)!=false
      @case=TbCase.find(:all,:conditions=>["used='Y' and state>=4 and amount>=50000000  and aribitprog_num=? and #{@hant_search_1_word}",params[:aribitprog_num]],:order=>"right(case_code,7)")
      @data_text=TbDictionary.find(:first,:conditions=>["typ_code='0001' and state='Y' and data_val=?",params[:aribitprog_num]]).data_text
    end
  end
end
