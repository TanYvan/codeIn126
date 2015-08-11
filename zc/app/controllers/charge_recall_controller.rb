class ChargeRecallController < ApplicationController
   
  def list 
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','tb_charges.p','付款方名称','text',[]],
      ['char','tb_charges.f_money','金额','text',[]],
      ['char','tb_cases.case_code','案号','text',[]],
      ['char','tb_charges.code','收款号','text',[]],
      ['char','tb_charges.recevice_code','咨询流水号','text',[]]      
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_charges.id desc"
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
    c="(tb_charges.state=2 or tb_charges.state=3)  and  tb_charges.used='Y' and (tb_charges.typ='a' or tb_charges.typ='b') "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @charge_pages,@charge=paginate(:tb_charges,:join=>" as tb_charges left join tb_cases on tb_charges.recevice_code=tb_cases.recevice_code",:select=>"tb_charges.*",:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def recall
    @charge=TbCharge.find(params[:id])
    if @charge.state==2
      @charge.state=3
      @charge.recall_u=session[:user_code]
      @charge.recall_dt=Time.now()
      if @charge.save 
        TbCharge.update_all("state=3","parent_id=#{params[:id]}")
        TbChargeCorr.update_all("state=3","charge_id=#{params[:id]}")  
        @ch=TbCharge.find(:all,:conditions=>"parent_id=#{params[:id]}")
        for ch in @ch
          TbChargeCorr.update_all("state=3","charge_id=#{ch.id}") 
        end
        @ccc=TbCharge.find(:all,:conditions=>"(id=#{params[:id]} or parent_id=#{params[:id]}) and should_id<>0",:select=>"distinct should_id as should_id")
        for c in @ccc
          @should=TbShouldCharge.find(c.should_id)
          re_rmb_money=TbCharge.sum("rmb_money",:conditions=>"used='Y' and  state=2 and should_id=#{c.should_id}")
          if re_rmb_money==nil
            re_rmb_money=0
          end
          @should.re_rmb_money=re_rmb_money
          @should.save
        end
        ChargeUp.new.up(@charge.recevice_code)
        flash[:notice]="记录召回成功！收款号：#{@charge.code}。"
      else
        flash[:notice]="记录召回失败！"
      end
    else
      flash[:notice]="记录召回失败！"
    end
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
  
end
