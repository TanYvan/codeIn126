class RefundListController < ApplicationController
  
  def list
    @state={1=>"未确认",2=>"出纳已确认",3=>"已召回",4=>"处长已确认"}
    
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_should_refunds.recevice_code desc"
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
    s="tb_should_refunds.state,tb_should_refunds.recevice_code,tb_should_refunds.u,tb_should_refunds.typ,tb_should_refunds.payment,tb_should_refunds.partyname,tb_should_refunds.currency,tb_should_refunds.f_money,tb_should_refunds.rate,tb_should_refunds.rmb_money,tb_should_refunds.redu_rmb_money,tb_should_refunds.re_rmb_money,tb_should_refunds.remark,tb_should_refunds.check2_u,tb_should_refunds.check2_dt,tb_should_refunds.check2_remark,tb_should_refunds.check_u,tb_should_refunds.check_dt,tb_should_refunds.check_remark,tb_should_refunds.recall_u,tb_should_refunds.recall_dt"
    c="tb_should_refunds.used='Y' and tb_should_refunds.u='#{session[:user_code]}' and (tb_should_refunds.typ<>'0002' and tb_should_refunds.typ<>'0003' and tb_should_refunds.typ<>'0005'  and tb_should_refunds.typ<>'0006'  )"
    p=PubTool.new() 
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @should_pages,@should=paginate(:tb_should_refunds,:order=>@order,:conditions=>c,:joins=>" inner join tb_cases  on tb_should_refunds.recevice_code=tb_cases.recevice_code and tb_cases.used='Y' and tb_should_refunds.used='Y'",:select=>s,:per_page=>@page_lines.to_i)
  end 
  
end
