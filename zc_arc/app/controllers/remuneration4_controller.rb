class Remuneration4Controller < ApplicationController
  
  def list
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration4.find(:all,:order=>'typ',:conditions=>c) 
    end
  end
  
  def list_2
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration4.find(:all,:order=>'typ',:conditions=>c) 
    end
  end
  
  def new_all
    @remun=TbDictionary.find(:all,:conditions=>"typ_code='0039' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
  end
  
  def new
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}
    @p=@pb + @pa
    @remun=TbRemuneration4.new()
  end
  
  def new_all_2
    @remun=TbDictionary.find(:all,:conditions=>"typ_code='0039' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.code,p.name]}.insert(0,["",""])
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.code,p.name]}.insert(0,["",""])
  end
  
  def new_2
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}
    @p=@pb + @pa
    @remun=TbRemuneration4.new()
  end
  
  def create_all
    @remun=TbDictionary.find(:all,:conditions=>"typ_code='0039' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    begin
      for arb in @remun
        if params["hid_name_"+arb.data_val]!=nil
          @remun=TbRemuneration4.new()
          @remun.used='Y'
          @remun.recevice_code=session[:recevice_code_1]
          @remun.case_code=session[:case_code_1]
          @remun.general_code=session[:general_code_1]
          @remun.typ=params["remun_typ_name_"+arb.data_val]
          @remun.p_typ=params["remun_p_typ_name_"+arb.data_val]
          if @remun.p_typ=='0001'
            @remun.p=params["remun_p_name_"+arb.data_val]
          else
            @remun.p=params["remun_p_2_name_"+arb.data_val]
          end
          @remun.remark=params["remark_name_"+arb.data_val]
          @remun.u1=session[:user_code]
          @remun.t1=Time.now()
          extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{@remun.p_typ}' and p='#{@remun.p}' and used='Y' and extend_code<>''")
          if @remun.p!='' and extend==nil   
            if @remun.save
              TbBonusPenalty.add(session[:recevice_code_1],@remun.p_typ,@remun.p)
            end
          end
        end
      end
      flash[:notice]="批量创建成功"
      redirect_to :action=>"list"
    rescue
      flash[:notice]="批量创建失败"
      render :action=>"new_all"
    end
  end
  
  def create
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{params[:remun][:p_typ]}' and p='#{params[:remun][:p]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration4.new(params[:remun])
      p=@remun.p
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],params[:remun][:p_typ],params[:remun][:p])
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="创建失败"
        redirect_to :action=>"list"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end
  
  def create_all_2
    @remun=TbDictionary.find(:all,:conditions=>"typ_code='0039' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    begin
      for arb in @remun
        if params["hid_name_"+arb.data_val]!=nil
          @remun=TbRemuneration4.new()
          @remun.used='Y'
          @remun.recevice_code=session[:recevice_code_1]
          @remun.case_code=session[:case_code_1]
          @remun.general_code=session[:general_code_1]
          @remun.typ=params["remun_typ_name_"+arb.data_val]
          @remun.p_typ=params["remun_p_typ_name_"+arb.data_val]
          if @remun.p_typ=='0001'
            @remun.p=params["remun_p_name_"+arb.data_val]
          else
            @remun.p=params["remun_p_2_name_"+arb.data_val]
          end
          @remun.remark=params["remark_name_"+arb.data_val]
          @remun.u1=session[:user_code]
          @remun.t1=Time.now()
          extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{@remun.p_typ}' and p='#{@remun.p}' and used='Y' and extend_code<>''")
          if @remun.p!='' and extend==nil            
            if @remun.save
              TbBonusPenalty.add(session[:recevice_code_1],@remun.p_typ,@remun.p)
            end
          end
        end
      end
      flash[:notice]="批量创建成功"
      redirect_to :action=>"list_2"
    rescue
      flash[:notice]="批量创建失败"
      render :action=>"new_all_2"
    end
  end
  
  def create_2
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{params[:remun][:p_typ]}' and p='#{params[:remun][:p]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration4.new(params[:remun])
      p=@remun.p
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],params[:remun][:p_typ],params[:remun][:p])
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="创建失败"
        redirect_to :action=>"list_2"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end
   
    
  def delete
    @remun=TbRemuneration4.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],@remun.p_typ,@remun.p)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration4.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],@remun.p_typ,@remun.p)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
  def p_set 
    if params[:p_typ]=='0001'
      a=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name")
    elsif params[:p_typ]=='0002'
      a=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where  users.used='Y' and users.states='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name")
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
  
end
