class ChargeCorrespondenceDetailController < ApplicationController
  
  def charge_case_list
    @hant_search_1_page_name="charge_case_list"
    #@hant_search_1=[['char','tb_cases.recevice_code','咨询流水号','text',[]]]  
    @hant_search_1=[['char','v_case_query1_list1s.tb_cases_case_code','案号','text',[]],['char','v_case_query1_list1s.tb_parties_partyname','当事人名称','text',[]],['char','v_case_query1_list1s.tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','v_case_query1_list1s.tb_cases_recevice_code','咨询流水号','text',[]]]    
    @order=params[:order]
    if @order==nil or @order==""
      @order="v_case_query1_list1s.tb_cases_recevice_code desc"
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
    if session[:chang]=='2'
      c="tb_charges.used='Y' and v_case_query1_list1s.tb_cases_recevice_code=tb_charges.recevice_code and v_case_query1_list1s.tb_cases_state>=200"
    else
      c="tb_charges.used='Y' and v_case_query1_list1s.tb_cases_recevice_code=tb_charges.recevice_code and v_case_query1_list1s.tb_cases_state>=200 and v_case_query1_list1s.tb_cases_clerk='#{session[:user_code]}'"
    end
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    #@charge_pages,@charge=paginate(:tb_charges,:conditions=>c,:select=>'distinct recevice_code',:order=>@order,:per_page=>@page_lines.to_i)
    @charge_pages,@charge=paginate_by_sql(TbCharge,"select distinct tb_charges.recevice_code as recevice_code from tb_charges,v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @charge=TbCharge.find(:all,:conditions=>"used='Y' and state=2 and recevice_code='#{params[:recevice_code]}'",:order=>"code,id")
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'"
    if PubTool.new().sql_check_3(c)!=false
      @should=TbShouldCharge.find(:all,:conditions=>c,:order=>'id')
    end
  end
  
  def edit
    @should=TbShouldCharge.find(params[:id])
  end 

  def update
    @should=TbShouldCharge.find(params[:id])
#    if TbCase.find_by_recevice_code(@should.recevice_code).clerk==session[:user_code] 
      @should.u=session[:user_code]
      @should.u_t=Time.now()
      if @should.update_attributes(params[:should]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:recevice_code=>params[:recevice_code]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:id=>params[:id]
      end
#    end 
  end
  
  def charge_corr_list 
    c="state=2 and used='Y' and should_charge_id='#{params[:should_charge_id]}'"
    if PubTool.new().sql_check_3(c)!=false
      @charge_corr=TbChargeCorr.find(:all,:conditions=>c,:order=>"id")
    end
  end  
  
  def charge_corr_add
    @charge=TbCharge.find(:all,:conditions=>"used='Y' and  state=2 and (typ='a' or typ='c') and recevice_code='#{params[:recevice_code]}' and should_id=0",:order=>"code,id")
  end
  
  def charge_corr_create
    @sss=TbShouldCharge.find(params[:should_charge_id])
    @ccc=TbCharge.find(params[:charge_id])
    if @sss.rmb_money - @sss.redu_rmb_money - @sss.re_rmb_money  < @ccc.rmb_money - 300
      flash[:notice]="添加失败！原因：对应金额(#{@ccc.rmb_money} - 300 )不能大于欠交金额(#{@sss.rmb_money - @sss.redu_rmb_money - @sss.re_rmb_money})。"
      redirect_to :action=>"charge_corr_list",:should_charge_id=>params[:should_charge_id],:recevice_code=>params[:recevice_code]
    else
      @charge_corr=TbChargeCorr.new()
      @charge_corr.charge_id=params[:charge_id]
      @charge_corr.should_charge_id=params[:should_charge_id]
      @charge_corr.recevice_code=params[:recevice_code]
      @charge_corr.case_code=TbCase.find_by_recevice_code(params[:recevice_code]).case_code
      @charge_corr.general_code=TbCase.find_by_recevice_code(params[:recevice_code]).general_code
      @charge_corr.u=session[:user_code]
      @charge_corr.u_t=Time.now()
      @charge=TbCharge.find(params[:charge_id])
      @charge.should_id=params[:should_charge_id]
      @c=TbCase.find_by_recevice_code(params[:recevice_code])
#      if (TbCase.find_by_recevice_code(params[:recevice_code]).clerk==session[:user_code] or TbCase.find_by_recevice_code(params[:recevice_code]).clerk=='') and  @charge.recevice_code==params[:recevice_code]
      if  @charge.recevice_code==params[:recevice_code]
        if @charge_corr.save and @charge.save
          @should=TbShouldCharge.find(@charge_corr.should_charge_id)
          re_rmb_money=TbCharge.sum("rmb_money",:conditions=>"used='Y' and  state=2 and should_id=#{@charge_corr.should_charge_id}")
          if re_rmb_money==nil
            re_rmb_money=0
          end
          @should.re_rmb_money=re_rmb_money
          @should.save
          ChargeUp.new.up(@should.recevice_code)
          flash[:notice]="添加成功！"
          redirect_to :action=>"list",:should_charge_id=>params[:should_charge_id],:recevice_code=>params[:recevice_code]
        else
          flash[:notice]="添加失败！"
          redirect_to :action=>"charge_corr_list",:should_charge_id=>params[:should_charge_id],:recevice_code=>params[:recevice_code]
        end   
      end
      
    end
    
  end
  
  def charge_corr_delete
    @charge_corr=TbChargeCorr.find(params[:id])
    #if (TbCase.find_by_recevice_code(@charge_corr.recevice_code).clerk==session[:user_code]   or  TbCase.find_by_recevice_code(params[:recevice_code]).clerk=='')   and  TbCharge.find(@charge_corr.charge_id).recevice_code==params[:recevice_code]
    if TbCharge.find(@charge_corr.charge_id).recevice_code==params[:recevice_code]
      @charge_corr.used="N"
      @charge_corr.u=session[:user_code]
      @charge_corr.u_t=Time.now()
      @charge=TbCharge.find(@charge_corr.charge_id)
      @charge.should_id=0
      if @charge_corr.save and @charge.save
        @should=TbShouldCharge.find(@charge_corr.should_charge_id)
        re_rmb_money=TbCharge.sum("rmb_money",:conditions=>"used='Y' and  state=2 and should_id=#{@charge_corr.should_charge_id}")
        if re_rmb_money==nil
          re_rmb_money=0
        end
        @should.re_rmb_money=re_rmb_money
        @should.save
        ChargeUp.new.up(@should.recevice_code)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"charge_corr_list",:recevice_code=>params[:recevice_code],:should_charge_id=>params[:should_charge_id]
    end
  end
  
  
  def split_list 
    if @order==nil or @order==""
      @order="id asc"
    end
    c="used='Y' and typ='c' and parent_id=#{params[:charge_id]}"
    if PubTool.new().sql_check_3(c)!=false
      @charge=TbCharge.find(params[:charge_id])
      @split=TbCharge.find(:all,:order=>@order,:conditions=>c)
    end
  end
  
  def split_new
    @charge=TbCharge.find(params[:charge_id])
    @f_money=TbCharge.sum(:f_money,:conditions=>["used='Y' and parent_id=?",params[:charge_id]])
    if @f_money==nil
      @f_money=0
    end
    @rmb_money=TbCharge.sum(:rmb_money,:conditions=>["used='Y' and parent_id=?",params[:charge_id]])
    if @rmb_money==nil
      @rmb_money=0
    end
    @charge.parent_id=params[:charge_id]
    @charge.f_money=@charge.f_money - @f_money
    @charge.rmb_money=@charge.rmb_money - @rmb_money
    @charge.remark=""
  end
  
  def split_create
     @charge=TbCharge.new(params[:charge])
     @charge.typ='c'
     @charge.parent_id=params[:charge_id]
     @charge.state=2
     @charge.u=session[:user_code]
     @charge.u_t=Time.now()
     if @charge.save
       @ccc=TbCharge.find(params[:charge_id])
       @ccc.typ='b'
       @ccc.split_rmb_money=TbCharge.sum(:rmb_money,:conditions=>"used='Y' and parent_id=#{@charge.parent_id} and typ='c'")
       @ccc.save
       flash[:notice]="创建成功"
       redirect_to :action=>"split_list",:charge_id=>params[:charge_id],:recevice_code=>params[:recevice_code]
     else
       flash[:notice]="创建失败"
       render :action=>"split_new",:charge_id=>params[:charge_id],:recevice_code=>params[:recevice_code]
     end
     
  end
  
  def split_delete 
    @charge=TbCharge.find(params[:id])
     if @charge.should_id==0
       @charge.used="N"
       if @charge.save  
          @c=TbCharge.find(@charge.parent_id)
          @c.split_rmb_money=TbCharge.sum(:rmb_money,:conditions=>"used='Y' and parent_id=#{@charge.parent_id} and typ='c'")
          @spl=TbCharge.find(:all,:conditions=>"used='Y' and parent_id=#{@charge.parent_id}")
          if @spl.empty?
            @c.typ='a' 
          end
          @c.save
          flash[:notice]="删除成功"
       else
          flash[:notice]="删除失败"
       end
       redirect_to :action=>"split_list",:charge_id=>@charge.parent_id,:recevice_code=>params[:recevice_code]
     end
  end
  
  
  def detail_list
    @aribitprog_num=TbCase.find(:first,:conditions=>"used='Y' and recevice_code='#{params[:recevice_code]}'").aribitprog_num
    c="recevice_code='#{params[:recevice_code]}' and used='Y' and parent_id=#{params[:id]}"
    if PubTool.new().sql_check_3(c)!=false
      @should_pages,@should=paginate(:tb_should_charges,:order=>'id',:conditions=>c)
    end
  end
  
end
