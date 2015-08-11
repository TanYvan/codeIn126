class Remuneration23Set2Controller < ApplicationController
  def edit_tax
    #@tax_a=TaxDetail.find(:first,:conditions=>["name='合计_理论值' and mark=?", params[:mark]])
    #@tax=TaxDetail.find(:all,:conditions=>["name<>'合计_理论值' and mark=?",params[:mark]], :order => "id")
    @tax_a=TaxDetail.find(:first,:conditions=>["code='0000-0000' and mark=?", params[:mark]])
    @tax=TaxDetail.find(:all,:conditions=>["code<>'0000-0000' and mark=?",params[:mark]], :order => "id")
  end

  def update_tax
    t=params[:mark].split("_")
    for tax in TaxDetail.find(:all,:conditions=>["code<>'0000-0000' and mark=?",params[:mark]])
     tax.rmb= params["rmb_"+tax.id.to_s].to_d
     tax.remark= params["remark_"+tax.id.to_s]
     tax.save
    end
    @remun=TbRemuneration23.find(t[1])
    @remun.tax_rmb=TaxDetail.find(:first,:conditions=>["code='0000' and mark=?", "remuneration23_#{@remun.id}"]).rmb
    @remun.extend_rmb = @remun.should_rmb - @remun.tax_rmb # 实发数额
    @remun.save
    flash[:notice] = "修改成功"
    redirect_to :action=>"list", :hant_search_1_word=>params[:hant_search_1_word] ,:hant_search_1_text =>params[:hant_search_1_text], :search_condit => params[:search_condit]
  end
  
  def p_set 
    if params[:p_typ]=='0001'
      a=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_2]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name")
    elsif params[:p_typ]=='0004'
      a=UserDuty.find_by_sql("select users.code as code,users.name as name from users where users.used='Y' and users.states='Y' and users.code<>'admin' order by ord")
    else
      a=""
    end
    
    if a==""
    else
      render :update do |page|
        page.remove 'remun_p'
        #page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
        page.replace_html 'p_s', :partial => 'pv',:object=>a
      end
    end
  end 
  
  def list
    @p_typ={'0001'=>'仲裁员','0004'=>'员工'}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','case_code','受案号','text',[]],['char','end_code','结案号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc,p_typ asc,p asc"
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
    c="used='Y' and ope_typ='0002' and typ<='0091'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @remun_pages,@remun=paginate(:tb_remuneration23s,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def new
    @remun=TbRemuneration23.new()
    @case_code=params[:case_code]
    if @case_code==nil
      @case_code=""
    end
    @remun.case_code=@case_code
    @end_code=params[:end_code]
    if @end_code==nil
      @end_code=""
    end
    @remun.end_code=@end_code
    @ad=params[:ad]
    if @ad==nil
      @ad="checked"
    end
  end
  
  def new_2
    @remun=TbRemuneration23.new()
    @case_code=params[:case_code]
    if @case_code==nil
      @case_code=""
    end
    @remun.case_code=@case_code
    @end_code=params[:end_code]
    if @end_code==nil
      @end_code=""
    end
    @remun.end_code=@end_code
    @ad=params[:ad]
    if @ad==nil
      @ad="checked"
    end
  end

  def new_3
    @remun=TbRemuneration23.new()
        @case_code=params[:case_code]
    if @case_code==nil
      @case_code=""
    end
    @remun.case_code=@case_code
    @end_code=params[:end_code]
    if @end_code==nil
      @end_code=""
    end
    @remun.end_code=@end_code
    @ad=params[:ad]
    if @ad==nil
      @ad="checked"
    end
  end

  def create
    @remun=TbRemuneration23.new(params[:remun])
    @remun.ope_typ='0002'
    @remun.u=session[:user_code]
    @remun.save
    @remun.t=Time.now()
    if params[:che]==nil
      @remun.tax_rmb=0
      @remun.tax_base_rmb=0
    else
      @remun.tax_base_rmb = Tax.new.get_tax_base_2(@remun.should_rmb) # 应纳税所得额
      t = 'N' # 是否本单位人员
      if params[:remun][:p_typ] == '0004'
        t = 'Y'
      elsif TbArbitman.find_by_code(params[:p_code]).isunit == 'Y'
        t = 'Y'
      end
      #@remun.tax_rmb=Tax.new.get_tax_1(@remun.should_rmb,t)
      TaxDetail.set_tax("remuneration23_#{@remun.id}",@remun.tax_base_rmb)
      #@remun.tax_rmb=TaxDetail.find(:first,:conditions=>["name='合计' and mark=?", "remuneration23_#{@remun.id}"]).rmb
      @remun.tax_rmb=TaxDetail.find(:first,:conditions=>["code='0000' and mark=?", "remuneration23_#{@remun.id}"]).rmb
    end
    @remun.extend_rmb=@remun.should_rmb - @remun.tax_rmb
    if @remun.p_typ=='0001'
      @remun.p=params[:p_code]
    end
    if params[:ad]==nil
      r_p="list"
      ad=""
    else
      r_p="new"
      ad="checked"
    end
    
    if @remun.save
      flash[:notice]="创建成功"
      redirect_to :action=>r_p,:ad=>ad,:case_code=>@remun.case_code,:end_code=>@remun.end_code,:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      redirect_to :action=>r_p,:ad=>ad,:case_code=>@remun.case_code,:end_code=>@remun.end_code,:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end
  
  def create_2
    
   if params[:ad]==nil
      r_p="list"
      ad=""
    else
      r_p="new_2"
      ad="checked"
    end
    
    should_rmb_0091=params[:should_rmb_0091]
    
    begin
      
      if should_rmb_0091 !='0'
        @remun=TbRemuneration23.new(params[:remun])
        @remun.ope_typ='0002'
        @remun.u=session[:user_code]
        @remun.t=Time.now()
        @remun.typ='0091'
        @remun.should_rmb=should_rmb_0091
        @remun.tax_base_rmb=0
        @remun.tax_rmb=0
        @remun.extend_rmb=@remun.should_rmb
        @remun.save
        parent_id=@remun.id
      end
      
      @ddd=TbDictionary.find(:all,:conditions=>"typ_code='0050' and data_parent='0091' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
      for ddd in @ddd
        if params["should_rmb_"+ddd.data_val] !=nil and params["should_rmb_"+ddd.data_val] !=0
          @remun_2=TbRemuneration23.new(params[:remun])
          @remun_2.ope_typ='0002'
          @remun_2.u=session[:user_code]
          @remun_2.t=Time.now()
          @remun_2.typ=ddd.data_val
          @remun_2.should_rmb=params["should_rmb_"+ddd.data_val]
          @remun_2.tax_base_rmb=0
          @remun_2.tax_rmb=0
          @remun_2.extend_rmb=@remun_2.should_rmb
          @remun_2.parent_id=parent_id
          @remun_2.save
        end
      end
      
      flash[:notice]="创建成功"
      redirect_to :action=>r_p,:ad=>ad,:case_code=>params[:remun][:case_code],:end_code=>params[:remun][:end_code],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    rescue
      flash[:notice]="创建失败"
      redirect_to :action=>r_p,:ad=>ad,:case_code=>params[:remun][:case_code],:end_code=>params[:remun][:end_code],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end

  def create_3

    if params[:ad]==nil
      r_p="list"
      ad=""
    else
      r_p="new_3"
      ad="checked"
    end

    should_rmb_0092 = params[:should_rmb_0092]
    should_rmb_0091 = params[:should_rmb_0091]
#    begin
      if should_rmb_0091 !='0'
        @remun=TbRemuneration23.new(params[:remun])
        @remun.ope_typ='0002'
        @remun.u=session[:user_code]
        @remun.t=Time.now()
        @remun.typ='0091'
        @remun.should_rmb=should_rmb_0091
        @remun.tax_base_rmb=0
        @remun.tax_rmb=0
        @remun.extend_rmb=@remun.should_rmb
        @remun.save
        parent_id=@remun.id
      end

      @ddd=TbDictionary.find(:all,:conditions=>"typ_code='0050' and data_parent='0091' and data_val<>'0092' and state='Y' and used='Y'",:order=>'ind,data_val',:select=>"data_val,data_text")
      for ddd in @ddd # 创建子记录（出差或者补助）
        if params["should_rmb_"+ddd.data_val] !=nil and params["should_rmb_"+ddd.data_val] !=0
          @remun_2=TbRemuneration23.new(params[:remun])
          @remun_2.ope_typ='0002'
          @remun_2.u=session[:user_code]
          @remun_2.t=Time.now()
          @remun_2.typ=ddd.data_val
          @remun_2.should_rmb=params["should_rmb_"+ddd.data_val]
          @remun_2.tax_base_rmb=0
          @remun_2.tax_rmb=0
          @remun_2.extend_rmb=@remun_2.should_rmb
          @remun_2.parent_id=parent_id
          @remun_2.save
        end
      end

      if should_rmb_0092 !='0'
        @remun=TbRemuneration23.new(params[:remun])
        @remun.ope_typ='0002'
        @remun.u=session[:user_code]
        @remun.t=Time.now()
        @remun.typ='0092'
        @remun.should_rmb=should_rmb_0092
        @remun.tax_base_rmb=0
        @remun.tax_rmb=0
        @remun.extend_rmb=@remun.should_rmb
        @remun.parent_id=parent_id
        @remun.save
        parent_id=@remun.id
      end

      @ddd=TbDictionary.find(:all,:conditions=>"typ_code='0050' and data_parent='0092' and state='Y' and used='Y'",:order=>'ind,data_val',:select=>"data_val,data_text")
      for ddd in @ddd # 创建子记录（出差或者补助）
        if params["should_rmb_"+ddd.data_val] !=nil and params["should_rmb_"+ddd.data_val] !=0
          @remun_2=TbRemuneration23.new(params[:remun])
          @remun_2.ope_typ='0002'
          @remun_2.u=session[:user_code]
          @remun_2.t=Time.now()
          @remun_2.typ=ddd.data_val
          @remun_2.should_rmb=params["should_rmb_"+ddd.data_val]
          @remun_2.tax_base_rmb=0
          @remun_2.tax_rmb=0
          @remun_2.extend_rmb=@remun_2.should_rmb
          @remun_2.parent_id=parent_id
          @remun_2.save
        end
      end
      flash[:notice]="创建成功"
      redirect_to :action=>r_p,:ad=>ad
#    rescue
#      flash[:notice]="创建失败"
#      redirect_to :action=>r_p,:ad=>ad
#    end
  end

  def delete
    @remun=TbRemuneration23.find(params[:id])
    TaxDetail.del_tax("remuneration23_#{@remun.id}")
    if @remun.used=='Y' and @remun.extend_code==''
      @remun.used="N"
      @remun.u=session[:user_code]
      @remun.t=Time.now()
      if @remun.save
        TbRemuneration23.update_all("used='N'","parent_id=#{@remun.id}")
        TbRemuneration23.find(:all,:conditions =>"parent_id=#{@remun.id}").each{|r| TbRemuneration23.update_all("used='N'","parent_id=#{r.id}")}
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end
end
