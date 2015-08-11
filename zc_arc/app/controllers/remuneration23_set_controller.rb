class Remuneration23SetController < ApplicationController
  
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
    @case=nil#当前办理案件
    if session[:recevice_code_2]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_2])
      c="recevice_code='#{session[:recevice_code_2]}' and used='Y' and typ<='0091' and ope_typ='0001'"
      @remun=TbRemuneration23.find(:all,:order=>'p_typ,p,typ',:conditions=>c) 
    end
  end
  
  def new
    @remun=TbRemuneration23.new()
    @ad=params[:ad]
    if @ad==nil
      @ad="checked"
    end
  end
  
  def new_2
    @remun=TbRemuneration23.new()
    @ad=params[:ad]
    if @ad==nil
      @ad="checked"
    end
  end
  
  def create
    @remun=TbRemuneration23.new(params[:remun])
    @remun.recevice_code=session[:recevice_code_2]
    @remun.case_code=session[:case_code_2]
    @remun.general_code=session[:general_code_2]
    @remun.ope_typ='0001'
    @remun.u=session[:user_code]
    @remun.t=Time.now()
    if params[:che]==nil
      @remun.tax_rmb=0
    else
      @remun.tax_rmb=Tax.new.get_tax(@remun.should_rmb)
    end
    @remun.extend_rmb=@remun.should_rmb - @remun.tax_rmb
    
    if params[:ad]==nil
      r_p="list"
      ad=""
    else
      r_p="new"
      ad="checked"
    end
    
    if @remun.save
      flash[:notice]="创建成功"
      redirect_to :action=>r_p,:ad=>ad
    else
      flash[:notice]="创建失败"
      redirect_to :action=>r_p,:ad=>ad
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
        @remun.recevice_code=session[:recevice_code_2]
        @remun.case_code=session[:case_code_2]
        @remun.general_code=session[:general_code_2]
        @remun.ope_typ='0001'
        @remun.u=session[:user_code]
        @remun.t=Time.now()
        @remun.typ='0091'
        @remun.should_rmb=should_rmb_0091
        @remun.tax_rmb=0
        @remun.extend_rmb=@remun.should_rmb
        @remun.save
        parent_id=@remun.id
      end
      
      @ddd=TbDictionary.find(:all,:conditions=>"typ_code='0050' and data_parent='0091' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
      for ddd in @ddd
        if params["should_rmb_"+ddd.data_val] !=nil and params["should_rmb_"+ddd.data_val] !=0
          @remun_2=TbRemuneration23.new(params[:remun])
          @remun_2.recevice_code=session[:recevice_code_2]
          @remun_2.case_code=session[:case_code_2]
          @remun_2.general_code=session[:general_code_2]
          @remun_2.ope_typ='0001'
          @remun_2.u=session[:user_code]
          @remun_2.t=Time.now()
          @remun_2.typ=ddd.data_val
          @remun_2.should_rmb=params["should_rmb_"+ddd.data_val]
          @remun_2.tax_rmb=0
          @remun_2.extend_rmb=@remun_2.should_rmb
          @remun_2.parent_id=parent_id
          @remun_2.save
        end
      end
      
      flash[:notice]="创建成功"
      redirect_to :action=>r_p,:ad=>ad
    rescue
      flash[:notice]="创建失败"
      redirect_to :action=>r_p,:ad=>ad
    end
  end
  
  def delete
    @remun=TbRemuneration23.find(params[:id])
    if @remun.used=='Y' and @remun.extend_code==''
      @remun.used="N"
      @remun.u=session[:user_code]
      @remun.t=Time.now()
      if @remun.save
        TbRemuneration23.update_all("used='N'","parent_id=#{@remun.id}")
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
end
