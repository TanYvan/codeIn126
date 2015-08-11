class CaseorgController < ApplicationController
  
  def caseorg_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @caseorg=TbCaseorg.find(:all,:order=>'id',:conditions=>c) 
    end
  end
  
  def caseorg_new
    @caseorg=TbCaseorg.new()
    @caseorg.orgdate=Date.today
    @caseorg.sendrdate=Date.today
    @caseorg.assigndate=Date.today
    @code=params[:code]
    @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",@code])
    @aribitprog_num=@case.aribitprog_num
    @receivedate=@case.receivedate
#    if @aribitprog_num=='0001'   #国内普通4个月
#      @caseorg.limitdate=Time.now.months_since(4).to_date
#    elsif @aribitprog_num=='0002'   #国内简易3个月
#      @caseorg.limitdate=Time.now.months_since(3).to_date
#    elsif @aribitprog_num=='0003' #涉外6个月
#      @caseorg.limitdate=Time.now.months_since(6).to_date
#    elsif @aribitprog_num=='0004' #涉外简易3个月
#      @caseorg.limitdate=Time.now.months_since(3).to_date
#    elsif @aribitprog_num=='0005' #金融
#      @caseorg.limitdate=Workday.day_after_day(Date.today,45)
#    end
  end
   
  def caseorg_create
    @caseorg=TbCaseorg.new(params[:caseorg])
    @caseorg.recevice_code=session[:recevice_code]
    @caseorg.case_code=session[:case_code]
    @caseorg.general_code=session[:general_code]
    @caseorg.u=session[:user_code]
    @caseorg.u_t=Time.now()
    @case=TbCase.find_by_recevice_code(session[:recevice_code])
    
    @aribitprog_num=@case.aribitprog_num
    ttt=@caseorg.orgdate.to_time
    if @aribitprog_num=='0001'   #国内普通4个月
      @caseorg.limitdate=ttt.months_since(4).to_date
    elsif @aribitprog_num=='0002'   #国内简易3个月
      @caseorg.limitdate=ttt.months_since(3).to_date
    elsif @aribitprog_num=='0003' #涉外6个月
      @caseorg.limitdate=ttt.months_since(6).to_date
    elsif @aribitprog_num=='0004' #涉外简易3个月
      @caseorg.limitdate=ttt.months_since(3).to_date
    elsif @aribitprog_num=='0005' #金融
      @caseorg.limitdate=Workday.day_after_day(@caseorg.orgdate,45)
    end
    
    
    if TbCaseFlow.check(@caseorg.recevice_code,'0005')
      f=TbCaseFlow.add_flow(@caseorg.recevice_code,'0005')
      if f!=0
        @case.state=f
      end 
      if @caseorg.save and @case.save
        flash[:notice]="创建成功"
        
        t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseorg.recevice_code}'",:order=>"orgdate")
        t_caseorg_f=SysArg.get_first_record(t_caseorg)
        if t_caseorg_f==nil
          @case.caseorg_id_first=nil
        else
          @case.caseorg_id_first=t_caseorg_f.id
        end
        
        t_caseorg_l=SysArg.get_last_record(t_caseorg)
        if t_caseorg_l==nil
          @case.caseorg_id_last=nil
          @case.finally_limit_dat=nil
        else
          @case.caseorg_id_last=t_caseorg_l.id
          @case.finally_limit_dat=t_caseorg_l.limitdate
        end
        
        @case.save
        
        redirect_to :action=>"caseorg_list"
      else
        flash[:notice]="创建失败"
        render :action=>"caseorg_list"
      end
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
     
  end
   
  def caseorg_edit
    @caseorg=TbCaseorg.find(params[:id])
  end 

  def caseorg_update
    @caseorg=TbCaseorg.find(params[:id])
    @caseorg.u=session[:user_code]
    @caseorg.u_t=Time.now()
    if @caseorg.update_attributes(params[:caseorg]) 
      flash[:notice]="修改成功"
      
      @case=TbCase.find_by_recevice_code(@caseorg.recevice_code)
      t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseorg.recevice_code}'",:order=>"orgdate")
      t_caseorg_f=SysArg.get_first_record(t_caseorg)
      if t_caseorg_f==nil
        @case.caseorg_id_first=nil
      else
        @case.caseorg_id_first=t_caseorg_f.id
      end

      t_caseorg_l=SysArg.get_last_record(t_caseorg)
      if t_caseorg_l==nil
        @case.caseorg_id_last=nil
        @case.finally_limit_dat=nil
      else
        @case.caseorg_id_last=t_caseorg_l.id
        @case.finally_limit_dat=t_caseorg_l.limitdate
      end

      @case.save 
      
      redirect_to :action=>"caseorg_list"
    else
      flash[:notice]="修改失败"
      render :action=>"caseorg_edit",:id=>params[:id]
    end
  end
   
  def caseorg_delete
    @caseorg=TbCaseorg.find(params[:id])
    @caseorg.used="N"
    @caseorg.u=session[:user_code]
    @caseorg.u_t=Time.now()
    @case=TbCase.find_by_recevice_code(@caseorg.recevice_code)
    f=TbCaseFlow.del_flow(@caseorg.recevice_code,'0005')
    if f!=0
      @case.state=f
    end 
    if @caseorg.save and @case.save
      
      t_caseorg=TbCaseorg.find(:all,:conditions=>"used='Y' and recevice_code='#{@caseorg.recevice_code}'",:order=>"orgdate")
      t_caseorg_f=SysArg.get_first_record(t_caseorg)
      if t_caseorg_f==nil
        @case.caseorg_id_first=nil
      else
        @case.caseorg_id_first=t_caseorg_f.id
      end

      t_caseorg_l=SysArg.get_last_record(t_caseorg)
      if t_caseorg_l==nil
        @case.caseorg_id_last=nil
        @case.finally_limit_dat=nil
      else
        @case.caseorg_id_last=t_caseorg_l.id
        @case.finally_limit_dat=t_caseorg_l.limitdate
      end

      @case.save 
      
      
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"caseorg_list"
  end
  
  
  
end
