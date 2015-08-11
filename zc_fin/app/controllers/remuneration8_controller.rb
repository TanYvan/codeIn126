class Remuneration8Controller < ApplicationController
  
  def list
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration8.find(:all,:order=>'p_typ',:conditions=>c) 
    end
  end
  
  def list_2
    @p_typ={'0001'=>'仲裁员','0002'=>'助理'}
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration8.find(:all,:order=>'p_typ',:conditions=>c) 
    end
  end
  
  def new
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}
    @p=@pb + @pa
    @remun=TbRemuneration8.new()
  end
  
  def new_2
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}
    @p=@pb + @pa
    @remun=TbRemuneration8.new()
  end
   
  def create
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{params[:remun][:p_typ]}' and p='#{params[:remun][:p]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration8.new(params[:remun])
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
  
  def create_2
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='#{params[:remun][:p_typ]}' and p='#{params[:remun][:p]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration8.new(params[:remun])
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
    @remun=TbRemuneration8.find(params[:id])
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
    @remun=TbRemuneration8.find(params[:id])
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
      a=a.collect{|p|[p.name,p.code]}
    elsif params[:p_typ]=='0002'
      user_code=TbCase.find_by_recevice_code(session[:recevice_code_1]).clerk
      user_name=User.find_by_code(user_code).name
      a=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and users.code<>'#{user_code}' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name")
      a=a.collect{|p|[p.name,p.code]}
      a=a.insert(0,[user_name,user_code])
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
