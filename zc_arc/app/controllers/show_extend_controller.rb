#显示报酬发放信息的控制器
#添加人 苏获
#添加时间 20090527
class ShowExtendController < ApplicationController
  #显示所有的报酬发放的列表
  def list_extend_code
    @hant_search_1_page_name="list_extend_code"
    @hant_search_1=[['char','t_extend_code','发放编号','text',[]],['char','remark','备注','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
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
    @extend_code_pages,@extend_codes =paginate(:tb_t_extend_codes,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
 end
  #某个报酬发放编码下的报酬发放列表
  def list_extend
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
  end
  
  def list_extend_a
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ='0001' and used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
  end
  
  def list_extend_b
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ<>'0001' and used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
  end
  
  def list_extend_c
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ='0001' and used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select bankname,bank_account,p_name,extend_rmb from tb_extends where  bank_typ='0001' and used='Y' and t_extend_code=?  order by  bankname,bank_account,p_name,p",t_extend_code])
  end
  
  def list_extend_d
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ='0002' and used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select bankname,bank_account,p_name,extend_rmb from tb_extends where  bank_typ='0002' and used='Y' and t_extend_code=? order by  bankname,bank_account,p_name,p",t_extend_code])
  end
  
  def list_extend_e
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select distinct bankname,bank_account,p,p_name from tb_extends where  used='Y' and t_extend_code=? order by  p_name,p,bankname,bank_account",t_extend_code])
  end
  
  def list_extend_f
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select distinct bankname,bank_account,p,p_name from tb_extends where  used='Y' and bank_typ='0001' and t_extend_code=? order by  p_name,p,bankname,bank_account",t_extend_code])
  end
  
  def list_extend_g
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select distinct bankname,bank_account,p,p_name from tb_extends where  used='Y' and bank_typ='0002' and t_extend_code=?  order by  p_name,p,bankname,bank_account",t_extend_code])
  end
  
end
