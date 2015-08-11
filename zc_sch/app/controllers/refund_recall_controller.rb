class RefundRecallController < ApplicationController
  
  def list
    @state={2=>"出纳已确认",3=>"已招回",4=>"处长已确认"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','case_code','立案号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
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
    
    c="used='Y' and (state=2 or state=3 or state=4) and (typ<>'0002' and typ<>'0003' and typ<>'0005'  and typ<>'0006'  ) "
    p=PubTool.new() 
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @should_pages,@should=paginate(:tb_should_refunds,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end 
  
  def recall
    @should=TbShouldRefund.find(params[:id])
    if @should.state==2 or @should.state==4
      @should.state=3
      @should.recall_u=session[:user_code]
      @should.recall_dt=Time.now
      if @should.save
        if @should.typ=='0001' or @should.typ=='0004'
          TbShouldRefund.update_all("state=3","parent_id=#{@should.id}")
        end
        flash[:notice]="记录召回成功！"
      else
        flash[:notice]="记录召回失败！"
      end
    else
      flash[:notice]="记录召回失败！"
    end
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
  
  
  def detail_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:parent_id]}"
    @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
  end
  
  
end
