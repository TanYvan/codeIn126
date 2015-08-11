class ShouldChargeController < ApplicationController
  #咨询助理或办案助理为自己的案件
  def case_list_1  
    @hant_search_1_page_name="case_list_1"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
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
    c="used='Y' and ((clerk='#{session[:user_code]}' and state>=4 and state<=100) or ((clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') and state>=1 and state<3)) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @should=TbShouldCharge.find(:all,:order=>'payment,id',:conditions=>c)
    end
  end
  
  def detail_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:parent_id]}"
    if PubTool.new().sql_check_3(c)!=false
      @should=TbShouldCharge.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def detail_edit
    @should=TbShouldCharge.find(params[:id])
    @should_p=TbShouldCharge.find(@should.parent_id)
  end 

  def detail_update
    @should=TbShouldCharge.find(params[:id])
    #if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code]
    if session[:user_code]!=nil
      @should.u=session[:user_code]
    else
      @should.u=session[:user_code_2]
    end
    @should.u_t=Time.now()
    if @should.update_attributes(params[:should])
      @should_p=TbShouldCharge.find(@should.parent_id)
      @should_c=TbShouldCharge.find(:all,:conditions=>"recevice_code='#{@should_p.recevice_code}' and used='Y' and parent_id=#{@should_p.id}")
      for should_c in @should_c
        if should_c.id!=@should.id
          should_c.f_money=@should_p.f_money - @should.f_money
          should_c.rmb_money=@should_p.rmb_money - @should.rmb_money
          should_c.save
        end
      end
      redirect_to :controller=>"should_charge",:action=>"detail_list",:parent_id=>params[:parent_id],:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ],:t_typ2=>params[:t_typ2]
    else
      render :controller=>"should_charge",:action=>"detail_edit",:id=>params[:id],:parent_id=>params[:parent_id],:t_typ=>params[:t_typ]
    end
    #end
     
  end
  
  def new
    @should=TbShouldCharge.new()
  end
  
  def create
    #if TbCase.find_by_recevice_code(params[:recevice_code]).clerk==session[:user_code]
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @should=TbShouldCharge.new(params[:should])
    @should.recevice_code=params[:recevice_code]
    @should.case_code=@case.case_code
    @should.general_code=@case.general_code
    if session[:user_code]!=nil
      @should.u=session[:user_code]
    else
      @should.u=session[:user_code_2]
    end
    @should.u_t=Time.now()
    if @should.save
      if @should.typ=="0004"
        ###华南仲裁委个性化。无明确争议金额收费的划分方法： 1）涉外案件，无明确争议金额收费作为仲裁费收取，不用再划分；国内案件，对于存在了明确或者不明确争议金额的，根据已经算出的受理费、处理费之间的比例，划分无明确争议金额收费的受理费、处理费；不存在明确或者不明确争议金额的，不用划分，受理费为零、处理费为零。
        if @case.aribitprog_num=='0003' or @case.aribitprog_num=='0004'
          @should_new_2=TbShouldCharge.new()
          @should_new_2.recevice_code=params[:recevice_code]
          @should_new_2.case_code=@case.case_code
          @should_new_2.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new_2.u=session[:user_code]
          else
            @should_new_2.u=session[:user_code_2]
          end
          @should_new_2.u_t=Time.now()
          @should_new_2.typ="0006"
          @should_new_2.payment=@should.payment
          @should_new_2.rmb_money=@should.rmb_money
          @should_new_2.currency=@should.currency
          @should_new_2.f_money=@should.f_money
          @should_new_2.re_rmb_money=0
          @should_new_2.rate=@should.rate
          @should_new_2.parent_id=@should.id
          @should_new_2.save
        else
          if TbShouldCharge.find(:all,:conditions=>"used='Y' and recevice_code='#{params[:recevice_code]}' and typ='0001'").empty?
            scale=0
          else
            scale_1=TbShouldCharge.sum(:rmb_money,:conditions=>"used='Y'  and recevice_code='#{params[:recevice_code]}'  and typ='0002'")
            scale_2=TbShouldCharge.sum(:rmb_money,:conditions=>"used='Y' and recevice_code='#{params[:recevice_code]}'  and (typ='0002' or  typ='0003')")
            if scale_1==nil
              scale_1=0
            end
            if scale_2==nil
              scale_2=0
            end
            if scale_2==0
              scale=0
            else
              scale=scale_1 / scale_2
            end
          end
          ##########
          @should_new=TbShouldCharge.new()
          @should_new.recevice_code=params[:recevice_code]
          @should_new.case_code=@case.case_code
          @should_new.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new.u=session[:user_code]
          else
            @should_new.u=session[:user_code_2]
          end
          @should_new.u_t=Time.now()
          @should_new.typ="0005"
          @should_new.payment=@should.payment
          if scale==0
            @should_new.rmb_money=0
          else
            @should_new.rmb_money=@should.rmb_money * scale
            @should_new.rmb_money=@should_new.rmb_money.round
          end
          @should_new.currency=@should.currency
          if scale==0
            @should_new.f_money=0
          else
            @should_new.f_money=@should.f_money * scale
            @should_new.f_money=@should_new.f_money.round
          end
          @should_new.re_rmb_money=0
          @should_new.rate=@should.rate
          @should_new.parent_id=@should.id
          @should_new.save
          ###########
          @should_new_2=TbShouldCharge.new()
          @should_new_2.recevice_code=params[:recevice_code]
          @should_new_2.case_code=@case.case_code
          @should_new_2.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new_2.u=session[:user_code]
          else
            @should_new_2.u=session[:user_code_2]
          end
          @should_new_2.u_t=Time.now()
          @should_new_2.typ="0006"
          @should_new_2.payment=@should.payment
          if scale==0
            @should_new_2.rmb_money=0
          else
            @should_new_2.rmb_money=@should.rmb_money - @should_new.rmb_money
          end
          @should_new_2.currency=@should.currency
          if scale==0
            @should_new_2.f_money=0
          else
            @should_new_2.f_money=@should.f_money - @should_new.f_money
          end
          @should_new_2.re_rmb_money=0
          @should_new_2.rate=@should.rate
          @should_new_2.parent_id=@should.id
          @should_new_2.save
          ###########3
        end
      end
          
      
      flash[:notice]="创建成功"
      redirect_to :controller=>"should_charge",:action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    else
      render :controller=>"should_charge",:action=>"new" ,:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    end
    #else
    #  render :text=>"应收款创建失败。原因：该案件助理不是您！"
    #end
  end
  
  def edit
    @should=TbShouldCharge.find(params[:id])
  end 

  def update
    @should=TbShouldCharge.find(params[:id])
    #if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code]
    if session[:user_code]!=nil
      @should.u=session[:user_code]
    else
      @should.u=session[:user_code_2]
    end
    @should.u_t=Time.now()
    if @should.update_attributes(params[:should])
      flash[:notice]="修改成功"
      redirect_to :controller=>"should_charge",:action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    else
      flash[:notice]="修改失败"
      render :controller=>"should_charge",:action=>"edit",:id=>params[:id],:t_typ=>params[:t_typ]
    end
    #end
     
  end
   
  def delete
    @should=TbShouldCharge.find(params[:id])
    #if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code] and TbChargeCorr.find(:all,:conditions=>"used='Y' and should_charge_id='#{@should.id}'").empty?
    if TbChargeCorr.find(:all,:conditions=>"used='Y' and should_charge_id='#{@should.id}'").empty?
      @should.used="N"
      if session[:user_code]!=nil
        @should.u=session[:user_code]
      else
        @should.u=session[:user_code_2]
      end
      @should.u_t=Time.now()
      if @should.save
        TbShouldCharge.update_all("used='N'","parent_id=#{@should.id}")
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :controller=>"should_charge",:action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    end
  end
  
  def rate_set 
    render :update do |page|
      page.remove 'should_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end
  
end
