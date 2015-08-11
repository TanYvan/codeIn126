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
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
      @typ=TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    end
  end
end
