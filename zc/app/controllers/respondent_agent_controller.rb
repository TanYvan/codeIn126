=begin
创建人：聂灵灵
创建时间：2009-5-11
类的描述：此控制器是处理被申请人代理人信息----被申请人代理人可以选择案件，并创建被申请人代理人信息及修改删除被申请人代理人信息。
页面：
被申请人代理人信息列表:/respondent/agent_list
创建被申请人代理人信息：/respondent/agent_new
修改被申请人代理人信息：/respondent/agent_edit
=end
class RespondentAgentController < ApplicationController
   def a_list
    company=params[:company]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    company=cov.iconv(company)
    
    if company.strip!='' and PubTool.new().sql_check_3(company)!=false
    p=TbAgent.find_by_sql("select distinct company,addr from tb_agents where company like '%#{company}%'  ORDER BY addr desc")
    else
      p=nil
    end
    render :update do |page|
      page.replace_html 'a_list', :partial => 'a_l',:object=>p
    end
  end
   def agent_list
    @isperson={1=>"是",2=>"否"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'"
      @agent=TbAgent.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def agent_new
    @agent=TbAgent.new()
  end

  def agent_create
     @agent=TbAgent.new(params[:agent])
     @agent.partytype=2
     @agent.recevice_code=session[:recevice_code]
     @agent.case_code=session[:case_code]
     @agent.general_code=session[:general_code]
     @agent.name=@agent.name.strip
     @agent.addr=@agent.addr.strip
     @agent.u=session[:user_code]
     @agent.u_t=Time.now()
     if @agent.save
        flash[:notice]="创建成功"
        redirect_to :action=>"agent_list"
     else
        flash[:notice]="创建失败"
        render :action=>"agent_new"
     end
  end

  def agent_edit
     @agent=TbAgent.find(params[:id])
  end

  def agent_update
     @agent=TbAgent.find(params[:id])
     @agent.u=session[:user_code]
     @agent.u_t=Time.now()
     if @agent.update_attributes(params[:agent])
        @agent.name=@agent.name.strip
        @agent.addr=@agent.addr.strip
        @agent.save
        flash[:notice]="修改成功"
        redirect_to :action=>"agent_list"
     else
        flash[:notice]="修改失败"
        render :action=>"agent_edit",:id=>params[:id]
     end

  end

  def agent_delete
     @agent=TbAgent.find(params[:id])
     @agent.used="N"
     @agent.u=session[:user_code]
     @agent.u_t=Time.now()
     if @agent.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"agent_list"
  end
end
