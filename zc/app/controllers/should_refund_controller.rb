class ShouldRefundController < ApplicationController
  def case_list_1
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    #立案阶段的案件 在办案件
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
     @n1 = TbCase.count(:id,:conditions=>c)
    #已结未归档案件
    @page_lines3=params[:page_lines]
    if @page_lines3==nil or @page_lines3==""
      @page_lines3= session[:lines]
    end
    c3="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<150 and caseendbook_id_first is not null and file_submit_u=''"
    @case_pages3,@case3=paginate(:tb_cases,:conditions=>c3,:order=>@order,:per_page=>@page_lines3.to_i)
    @n3 = TbCase.count(:id,:conditions=>c3)

  end
  
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @state={1=>"未确认",2=>"出纳已确认",3=>"已召回",4=>"处长已确认"}
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def detail_list
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:parent_id]}"
    if PubTool.new().sql_check_3(c)!=false
      @should=TbShouldRefund.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def detail_edit
    @should=TbShouldRefund.find(params[:id])
    @should_p=TbShouldRefund.find(@should.parent_id)
  end 

  def detail_update
    @should=TbShouldRefund.find(params[:id])
    #if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code]
    if session[:user_code]!=nil
      @should.u=session[:user_code]
    else
      @should.u=session[:user_code_2]
    end
    @should.u_t=Time.now()
    if @should.update_attributes(params[:should]) 
      @should_p=TbShouldRefund.find(@should.parent_id)
      @should_c=TbShouldRefund.find(:all,:conditions=>"recevice_code='#{@should_p.recevice_code}' and used='Y' and parent_id=#{@should_p.id}")
      for should_c in @should_c
        if should_c.id!=@should.id
          should_c.f_money=@should_p.f_money - @should.f_money
          should_c.rmb_money=@should_p.rmb_money - @should.rmb_money
          should_c.save
        end
      end
      redirect_to :action=>"detail_list",:parent_id=>params[:parent_id],:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ],:t_typ2=>params[:t_typ2]
    else
      render :action=>"detail_edit",:id=>params[:id],:parent_id=>params[:parent_id],:t_typ=>params[:t_typ]
    end
    #end
     
  end
  
  def new
    @should=TbShouldRefund.new()
    @should.refund_date=Date.today()
  end
  
  def create
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    #    if TbCase.find_by_recevice_code(params[:recevice_code]).clerk==session[:user_code]
    @should=TbShouldRefund.new(params[:should])
    @should.recevice_code=params[:recevice_code]
    @should.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
    @should.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
    if session[:user_code]!=nil
      @should.u=session[:user_code]
    else
      @should.u=session[:user_code_2]
    end
    @should.u_t=Time.now()
    if @should.save
        
      if @should.typ=="0004" or @should.typ=="0001"
        ###华南仲裁委个性化。无明确争议金额收费的划分方法： 1）涉外案件，无明确争议金额收费作为仲裁费收取，不用再划分；国内案件，对于存在了明确或者不明确争议金额的，根据已经算出的受理费、处理费之间的比例，划分无明确争议金额收费的受理费、处理费；不存在明确或者不明确争议金额的，不用划分，受理费为零、处理费为零。
        if @case.aribitprog_num=='0003' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0007' or @case.aribitprog_num=='0008'
          @should_new_2=TbShouldRefund.new()
          @should_new_2.recevice_code=params[:recevice_code]
          @should_new_2.case_code=@case.case_code
          @should_new_2.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new_2.u=session[:user_code]
          else
            @should_new_2.u=session[:user_code_2]
          end
          @should_new_2.u_t=Time.now()
          if @should.typ=="0004"
            @should_new_2.typ="0006"
          elsif @should.typ=="0001"
            @should_new_2.typ="0003"
          end
          @should_new_2.payment=@should.payment
          @should_new_2.rmb_money=@should.rmb_money
          @should_new_2.currency=@should.currency
          @should_new_2.f_money=@should.f_money
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
          @should_new=TbShouldRefund.new()
          @should_new.recevice_code=params[:recevice_code]
          @should_new.case_code=@case.case_code
          @should_new.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new.u=session[:user_code]
          else
            @should_new.u=session[:user_code_2]
          end
          @should_new.u_t=Time.now()
          if @should.typ=="0004"
            @should_new.typ="0005"
          elsif @should.typ=="0001"
            @should_new.typ="0002"
          end
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
          @should_new.rate=@should.rate
          @should_new.parent_id=@should.id
          @should_new.save
          ###########
          @should_new_2=TbShouldRefund.new()
          @should_new_2.recevice_code=params[:recevice_code]
          @should_new_2.case_code=@case.case_code
          @should_new_2.general_code=@case.general_code
          if session[:user_code]!=nil
            @should_new_2.u=session[:user_code]
          else
            @should_new_2.u=session[:user_code_2]
          end
          @should_new_2.u_t=Time.now()
          if @should.typ=="0004"
            @should_new_2.typ="0006"
          elsif @should.typ=="0001"
            @should_new_2.typ="0003"
          end
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
          @should_new_2.rate=@should.rate
          @should_new_2.parent_id=@should.id
          @should_new_2.save  
          ###########3
        end
      end
      ChargeUp.new.up(params[:recevice_code])    
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    else
      render :action=>"new" ,:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
    end
    #    end
     
  end
  
  def edit
    @should=TbShouldRefund.find(params[:id])
  end 

  def update
    @should=TbShouldRefund.find(params[:id])
#    if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code] or TbCase.find_by_recevice_code(@should.recevice_code).clerk_2==session[:user_code]
      if session[:user_code]!=nil
        @should.u=session[:user_code]
      else
        @should.u=session[:user_code_2]
      end
      @should.u_t=Time.now()
      if @should.update_attributes(params[:should]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id],:t_typ=>params[:t_typ]
      end
#    end
     
  end
   
  def delete
    @should=TbShouldRefund.find(params[:id])
#    if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code] or TbCase.find_by_recevice_code(@should.recevice_code).clerk_2==session[:user_code]
      @should.used="N"
      @should.u=session[:user_code]
      @should.u_t=Time.now()
      if @should.save
        TbShouldRefund.update_all("used='N'","parent_id=#{@should.id}")
        ChargeUp.new.up(params[:recevice_code])
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:t_typ=>params[:t_typ]
#    end
  end
  
  
  def rate_set 
    render :update do |page|
      page.remove 'should_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end
  
end
