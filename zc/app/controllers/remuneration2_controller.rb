class Remuneration2Controller < ApplicationController
   
  def list
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration2.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def list_2
    @case=nil#当前办理案件
    if session[:recevice_code_1]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code_1])
      c="recevice_code='#{session[:recevice_code_1]}' and used='Y'"
      @remun=TbRemuneration2.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def new_all
    @remun=TbRemuneration2.new()
  end
  
  def new
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration2.new()
  end
  
  def new_all_2
    @remun=TbRemuneration2.new()
  end
  
  def new_2
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @remun=TbRemuneration2.new()
  end
   
  def create_all
    p=params[:remun][:p]
    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      for arb in @casearbitman
        @remun=TbRemuneration2.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.arbitman=arb.arbitman
        @remun.p=p
        @remun.rmb=Tax.new.get_page_fee(@remun.p)
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
          TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
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
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{params[:remun][:arbitman]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration2.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.rmb=Tax.new.get_page_fee(@remun.p)
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',params[:remun][:arbitman])
        TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        flash[:notice]="创建成功"
        redirect_to :action=>"list"
      else
        flash[:notice]="创建失败"
        render :action=>"new"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求,请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end  
  end
  
  def create_all_2
    p=params[:remun][:p]
    @casearbitman=TbCasearbitman.find(:all,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and used='Y'",:order=>"arbitmantype"  )
    begin
      for arb in @casearbitman
        @remun=TbRemuneration2.new()
        @remun.used='Y'
        @remun.recevice_code=session[:recevice_code_1]
        @remun.case_code=session[:case_code_1]
        @remun.general_code=session[:general_code_1]
        @remun.arbitman=arb.arbitman
        @remun.p=p
        @remun.rmb=Tax.new.get_page_fee(@remun.p)
        @remun.u1=session[:user_code]
        @remun.t1=Time.now()
        extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
        if @remun.save and extend==nil
          TbBonusPenalty.add(session[:recevice_code_1],'0001',@remun.arbitman)
          TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
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
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{params[:remun][:arbitman]}' and used='Y' and extend_code<>''")
    if extend==nil
      @remun=TbRemuneration2.new(params[:remun])
      @remun.recevice_code=session[:recevice_code_1]
      @remun.case_code=session[:case_code_1]
      @remun.general_code=session[:general_code_1]
      @remun.rmb=Tax.new.get_page_fee(@remun.p)
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.add(session[:recevice_code_1],'0001',params[:remun][:arbitman])
        TbBonusPenalty.up_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',0,@remun.rmb)
        flash[:notice]="创建成功"
        redirect_to :action=>"list_2"
      else
        flash[:notice]="创建失败"
        render :action=>"new_2"
      end
    else
      render :text=>"本案件中该仲裁员的报酬已经发放完毕(发放编号为#{extend.extend_code})。<br/>如果有继续发放报酬的需求,请通过报酬奖励方式进行（报酬奖励模块大概在处长操作中）。"
    end  
  end
   
#  def edit
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
#    @remun=TbRemuneration2.find(params[:id])
#  end
  
#  def edit_2
#    @casearbitman=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code_1]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
#    @remun=TbRemuneration2.find(params[:id])
#  end

#  def update
#    @remun=TbRemuneration2.find(params[:id])
#    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
#      @remun.u1=session[:user_code]
#      @remun.t1=Time.now()
#      if @remun.update_attributes(params[:remun]) 
#        flash[:notice]="修改成功"
#        redirect_to :action=>"list"
#      else
#        flash[:notice]="修改失败"
#        render :action=>"edit",:id=>params[:id]
#      end
#    end
#    
#  end
#  
#  def update_2
#    @remun=TbRemuneration2.find(params[:id])
#    if @remun.used=='Y' and @remun.rmb==0 and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
#      @remun.u1=session[:user_code]
#      @remun.t1=Time.now()
#      if @remun.update_attributes(params[:remun]) 
#        flash[:notice]="修改成功"
#        redirect_to :action=>"list_2"
#      else
#        flash[:notice]="修改失败"
#        render :action=>"edit_2",:id=>params[:id]
#      end
#    end
#    
#  end
   
  def delete
    @remun=TbRemuneration2.find(params[:id])
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
    if @remun.used=='Y' and extend==nil and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list"
    end
  end
  
  def delete_2
    @remun=TbRemuneration2.find(params[:id])
    extend=TbBonusPenalty.find(:first,:conditions=>"recevice_code='#{session[:recevice_code_1]}' and typ='0001' and p='#{@remun.arbitman}' and used='Y' and extend_code<>''")
    if @remun.used=='Y' and extend==nil and TbCase.find_by_recevice_code(@remun.recevice_code).clerk==session[:user_code]
      @remun.used="N"
      @remun.u1=session[:user_code]
      @remun.t1=Time.now()
      if @remun.save
        TbBonusPenalty.del_set(session[:recevice_code_1],'0001',@remun.arbitman,'zc_rmb',@remun.rmb)
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list_2"
    end
  end
  
end
