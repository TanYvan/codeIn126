class Remuneration9Controller < ApplicationController
  
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration9.find(:all,:order=>'assistant',:conditions=>c) 
    end
  end
  
  def new
#    @caseassistant=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name")
    @remun=TbRemuneration9.new()
    clerk=TbCase.find_by_recevice_code(session[:recevice_code_1]).clerk
    if clerk!=''
      @remun.assistant=clerk
    end
  end
  
  def new_2
#    @caseassistant=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name")
    @remun=TbRemuneration9.new()
    clerk=TbCase.find_by_recevice_code(session[:recevice_code_1]).clerk
    if clerk!=''
      @remun.assistant=clerk
    end
  end
   
  def create
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0002' and p='#{params[:remun][:assistant]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration9.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0002',params[:remun][:assistant])    
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="创建失败"
        render :action=>"list"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end
  
  def create_2
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0002' and p='#{params[:remun][:assistant]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration9.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0002',params[:remun][:assistant])    
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="创建失败"
        render :action=>"list_2"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求，请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end 
  end
   
  
  def delete
    @remun=TbRemuneration9.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],'0002',@remun.assistant)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration9.find(params[:id])
    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del(session[:recevice_code_1],'0002',@remun.assistant)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
