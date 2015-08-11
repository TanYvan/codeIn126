class ArbitmanSpendController < ApplicationController
  def case_list  
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','tb_cases_case_code','立案号','text',[]],
      ['char','tb_cases_end_code','结案号','text',[]],
      ['char','tb_parties_partyname','当事人名称','text',[]]
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_cases_case_code,tb_cases_general_code desc"
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
    c="tb_cases_state>=4"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #sql="select distinct tb_cases.recevice_code as recevice_code,tb_cases.state as state,tb_cases.general_code as general_code,tb_cases.case_code as case_code,tb_cases.end_code as end_code,tb_cases.clerk as clerk,tb_cases.nowdate as nowdate from tb_cases,tb_parties as t where #{c}  order by #{@order}"
    #@case_pages,@case=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_id,tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y' "
    if PubTool.new().sql_check_3(c)!=false
      @arbitman_spend=TbArbitmanSpend.find(:all,:order=>'recevice_code,sittingdate,arbitman_typ,arbitman,typ',:conditions=>c)
    end
  end
  
  def new
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @arbitman_spend=TbArbitmanSpend.new()
    @aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
  end
  
  def new_2
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @arbitman_spend=TbArbitmanSpend.new()
    @aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
    
  end
  
  def create
    p=PubTool.new()
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if @c.state>=4
      @arbitman_spend=TbArbitmanSpend.new(params[:arbitman_spend])
      @arbitman_spend.recevice_code=params[:recevice_code]
      @arbitman_spend.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @arbitman_spend.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @arbitman_spend.u=session[:user_code]
      @arbitman_spend.u_t=Time.now()
      @arb=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{@arbitman_spend.recevice_code}' and arbitman='#{@arbitman_spend.arbitman}'")
      @arb=p.get_first_record(@arb)
      if @arb!=nil
        @arbitman_spend.arbitman_typ=@arb.arbitmantype
      end
      if @arbitman_spend.save
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        flash[:notice]="创建失败"
        render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
  
  def create_2
    p=PubTool.new()
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if @c.state>=4
      begin
        @ddd=TbDictionary.find(:all,:conditions=>"typ_code='0036' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")  
        for ddd in @ddd
          if params["rmb_money_"+ddd.data_val]!=nil and params["rmb_money_"+ddd.data_val]!='0'
            @arbitman_spend=TbArbitmanSpend.new(params[:arbitman_spend])
            @arbitman_spend.recevice_code=params[:recevice_code]
            @arbitman_spend.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
            @arbitman_spend.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
            @arbitman_spend.u=session[:user_code]
            @arbitman_spend.u_t=Time.now()
            @arb=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{@arbitman_spend.recevice_code}' and arbitman='#{@arbitman_spend.arbitman}'")
            @arb=p.get_first_record(@arb)
            if @arb!=nil
              @arbitman_spend.arbitman_typ=@arb.arbitmantype
            end
            @arbitman_spend.typ=ddd.data_val
            @arbitman_spend.rmb_money=params["rmb_money_"+ddd.data_val]
            @arbitman_spend.save
          end
        end
        flash[:notice]="创建成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      rescue
        flash[:notice]="创建失败"
        render :action=>"new_2" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
  
  def new_all
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @arbitman_spend=TbArbitmanSpend.new()
    @aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
  end
  
  def create_all
    p=PubTool.new()
    @c=TbCase.find_by_recevice_code(params[:recevice_code])
    if @c.state>=4
      @typ=TbDictionary.find(:all,:conditions=>"typ_code='0036' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text") 
      begin
        for typ in @typ
          if params["rmb_money_#{typ.data_val}"]!=nil and params["rmb_money_#{typ.data_val}"]!=''
            @arbitman_spend=TbArbitmanSpend.new(params[:arbitman_spend])
            @arbitman_spend.recevice_code=params[:recevice_code]
            @arbitman_spend.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
            @arbitman_spend.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
            @arbitman_spend.typ=typ.data_val
            @arbitman_spend.rmb_money=params["rmb_money_#{typ.data_val}"]
            @arbitman_spend.u=session[:user_code]
            @arbitman_spend.u_t=Time.now()
            @arb=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{@arbitman_spend.recevice_code}' and arbitman='#{@arbitman_spend.arbitman}'")
            @arb=p.get_first_record(@arb)
            if @arb!=nil
              @arbitman_spend.arbitman_typ=@arb.arbitmantype
            end
            @arbitman_spend.save
          end
        end
        flash[:notice]="批量创建成功"
      rescue
        flash[:notice]="失败创建失败"
      end
      
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
     
  end
  
  def edit
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @arbitman_spend=TbArbitmanSpend.find(params[:id])
  end 

  def update
    p=PubTool.new()
    @arbitman_spend=TbArbitmanSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@arbitman_spend.recevice_code)
    if @c.state>=4
      @arbitman_spend.u=session[:user_code]
      @arbitman_spend.u_t=Time.now()
      @arb=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{@arbitman_spend.recevice_code}' and arbitman='#{params[:arbitman_spend][:arbitman]}'")
      @arb=p.get_first_record(@arb)
      if @arb!=nil
        @arbitman_spend.arbitman_typ=@arb.arbitmantype
      end
      if @arbitman_spend.update_attributes(params[:arbitman_spend]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
      end
    end
     
  end
   
  def delete
    @arbitman_spend=TbArbitmanSpend.find(params[:id])
    @c=TbCase.find_by_recevice_code(@arbitman_spend.recevice_code)
    if @c.state>=4
      @arbitman_spend.used="N"
      @arbitman_spend.u=session[:user_code]
      @arbitman_spend.u_t=Time.now()
      if @arbitman_spend.save
        TbArbitmanSpend.update_all("used='N'","parent_id=#{@arbitman_spend.id}")
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end
  #查看仲裁员开支费用明细信息
  def p_s
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @clerk=@case.clerk
    @case_code=@case.case_code
    @end_code=@case.end_code
    @aribitprog_num = @case.aribitprog_num
    @zl=User.find(:first,:conditions=>["used='Y' and code=?",@clerk]).name
    @money=Money.find(:all,:conditions=>["used='Y'"],:order=>"code")
    #申请人预缴实际开支
    @should=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f2 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    #被申请人预缴实际开支
    @should_r=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2_r=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f11 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f12 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])

    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
      @a = PubTool.arbitrator(params[:recevice_code],'0002')
      @b = PubTool.arbitrator(params[:recevice_code],'0003')
      @c = PubTool.arbitrator(params[:recevice_code],'0004')
    else#if @aribitprog_num=='0002' or @aribitprog_num=='0004'
      @a = PubTool.arbitrator(params[:recevice_code],'0001')
    end
    @typ=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0036' and data_val<>'0001'"])
    @typ1=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0037'"])
    @sitting=TbSitting.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8142' and state='Y'",:order=>"typ_code")
    @typ21=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=1 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @typ22=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=2 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @r1 = ""
    @r2 = ""
    @typ21.each do |r1|
      if r1!=nil
        @r1 =@r1 + r1.remark + " "
      end
    end
    @typ22.each do |r1|
      if r1!=nil
        @r2 =@r2 + r1.remark + " "
      end
    end
    #当事人实际开支费用总计(￥)
    @app_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @res_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=2 and recevice_code=?",params[:recevice_code]])
    #当事人抹零费用总计(￥)
    @a_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @r_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=2 and recevice_code=?",params[:recevice_code]])

  end
  def p_s_2
   @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @clerk=@case.clerk
    @case_code=@case.case_code
    @end_code=@case.end_code
    @aribitprog_num = @case.aribitprog_num
    @zl=User.find(:first,:conditions=>["used='Y' and code=?",@clerk]).name
    @money=Money.find(:all,:conditions=>["used='Y'"],:order=>"code")
    #申请人预缴实际开支
    @should=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f2 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    #被申请人预缴实际开支
    @should_r=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2_r=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f11 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f12 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])

    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
      @a = PubTool.arbitrator(params[:recevice_code],'0002')
      @b = PubTool.arbitrator(params[:recevice_code],'0003')
      @c = PubTool.arbitrator(params[:recevice_code],'0004')
    else#if @aribitprog_num=='0002' or @aribitprog_num=='0004'
      @a = PubTool.arbitrator(params[:recevice_code],'0001')
    end
    @typ=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0036' and data_val<>'0001'"])
    @typ1=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0037'"])
    @sitting=TbSitting.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8142' and state='Y'",:order=>"typ_code")
    @typ21=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=1 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @typ22=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=2 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @r1 = ""
    @r2 = ""
    @typ21.each do |r1|
      if r1!=nil
        @r1 =@r1 + r1.remark + " "
      end
    end
    @typ22.each do |r1|
      if r1!=nil
        @r2 =@r2 + r1.remark + " "
      end
    end
    #当事人实际开支费用总计(￥)
    @app_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @res_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=2 and recevice_code=?",params[:recevice_code]])
    #当事人抹零费用总计(￥)
    @a_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @r_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=2 and recevice_code=?",params[:recevice_code]])

  end
end
