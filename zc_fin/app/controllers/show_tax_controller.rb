class ShowTaxController < ApplicationController
  
  #当月扣税总表
  def list
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"差旅补助"}
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d=Time.now.to_date.to_s(:db)
      @d1=@d.slice(0,4)
      @d2=@d.slice(5,2)
    end
    c="used='Y' and tax_rmb<>0 and t_extend_code like '#{@d1}#{@d2}%'"
    p=PubTool.new()
    if p.sql_check_3(c)!=false
      @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>c,:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
    end
  end
  
end
