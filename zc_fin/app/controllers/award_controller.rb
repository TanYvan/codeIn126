=begin
创建人：聂灵灵
创建时间：2009-5-13
类的描述：此控制器是处理办理案件用户结案管理的裁决书管理页面的信息维护。首先判断是否选择案件，若无则选择案件,
         然后对裁决书管理信息进行创建及修改、删除维护。TbAward是实体类。
页面：
裁决书管理信息列表:/award/award_list
创建裁决书管理信息:/award/award_new
修改裁决书管理信息:/award/award_edit
=end
class AwardController < ApplicationController

  def p_set
    if params[:draftsman_typ]=='0001'
      a=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name")
    elsif params[:draftsman_typ]=='0002'
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      a=User.find_by_sql(["select users.code as code,users.name as name from users where  users.code=? ",@case.clerk])
    else
      a=""
    end

    if a==""
    else
      render :update do |page|
        page.remove 'award_draftsman'
        page.replace_html 'p_s1', :partial => 'pv1',:object=>a
      end
    end
  end
  
  def p_all_set
    if params["draftsman_typ"]=='0001'
      a=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.Name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name")
    elsif params["draftsman_typ"]=='0002'
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      a=User.find_by_sql(["select users.code as code,users.name as name from users where  users.code=? ",@case.clerk])
    else
      a=""
    end

    if a==""
    else
      render :update do |page|
        aa=[params[:typ],a]
        page.remove "draftsman_id_#{params[:typ]}"
        page.replace_html "p_s1_#{params[:typ]}", :partial => 'pv_all',:object=>aa
      end
    end
  end
  
  def award_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @award=TbAward.find(:all,:order=>'id',:conditions=>c)
    end
  end
  
  def award_new
    @pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}.insert(0,["",""])
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}.insert(0,["",""])
    @p=@pb + @pa
    @award=TbAward.new()    
  end

  def award_create
    @award=TbAward.new(params[:award])
    @award.recevice_code=session[:recevice_code]
    @award.case_code=session[:case_code]
    @award.general_code=session[:general_code]
    @award.u=session[:user_code]
    @award.u_t=Time.now()
    if @award.save
      flash[:notice]="创建成功"
      redirect_to :action=>"award_list"
    else
      render :action=>"award_new"
    end
  end

  def award_edit
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}.insert(0,["",""])
    @award=TbAward.find(params[:id])
  end

  def award_update
    @award=TbAward.find(params[:id])
    @award.recevice_code=session[:recevice_code]
    @award.case_code=session[:case_code]
    @award.general_code=session[:general_code]
    @award.u=session[:user_code]
    @award.u_t=Time.now()
    if @award.update_attributes(params[:award])
      flash[:notice]="修改成功"
      redirect_to :action=>"award_list"
    else
      flash[:notice]="修改失败"
      render :action=>"award_edit"
    end
  end

  def award_delete
    @award=TbAward.find(params[:id])
    @award.used="N"
    @award.u=session[:user_code]
    @award.u_t=Time.now()
    if @award.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"award_list"
  end
  
  def award_detail_list
    @award=TbAwardDetail.find(:all,:order=>'typ,draftsman_typ,draftsman',:conditions=>["recevice_code=? and used='Y' and p_id=?",session[:recevice_code],params[:p_id]])
  end
  
  def award_detail_new
    #@pa=UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.used='Y' and users.states='Y' and  users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.name").collect{|p|[p.name,p.code]}.insert(0,["",""])
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" ).collect{|p|[p.name,p.code]}#.insert(0,["",""])
    #@p=@pb + @pa
    @award=TbAwardDetail.new()    
  end
  
  def award_detail_new_all
    @typ=TbDictionary.find(:all,:conditions=>"typ_code='0059' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @case=TbCase.find_by_recevice_code(session[:recevice_code])
    @pa=User.find_by_sql(["select users.code as code,users.name as name from users where  users.code=? ",@case.clerk])
    @pb=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name   from tb_casearbitmen,tb_arbitmen where tb_casearbitmen.recevice_code='#{session[:recevice_code]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    @award=TbAwardDetail.new()    
  end
  
  def award_detail_create
    @award=TbAwardDetail.new(params[:award])
    @award.p_id=params[:p_id]
    @award.recevice_code=session[:recevice_code]
    @award.case_code=session[:case_code]
    @award.general_code=session[:general_code]
    @award.u=session[:user_code]
    @award.u_t=Time.now()
    if @award.save
      flash[:notice]="创建成功"
      redirect_to :action=>"award_detail_list",:p_id=>params[:p_id]
    else
      render :action=>"award_detail_new",:p_id=>params[:p_id]
    end
  end

  def award_detail_create_all
    @typ=TbDictionary.find(:all,:conditions=>"typ_code='0059' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    begin
      for typ in @typ
        if params["award_hid_name_#{typ.data_val}"]!=nil
          @award=TbAwardDetail.new()
          @award.p_id=params[:p_id]
          @award.recevice_code=session[:recevice_code]
          @award.case_code=session[:case_code]
          @award.general_code=session[:general_code]
          @award.typ=params["award_hid_name_#{typ.data_val}"]
          @award.draftsman_typ=params["draftsman_typ_name_#{typ.data_val}"]
          @award.remark=params["remark_name_#{typ.data_val}"]
          @award.u=session[:user_code]
          @award.u_t=Time.now()
          if @award.draftsman_typ=='0001'
            if params["draftsman_arbitman_name_#{typ.data_val}"]!=''
              @award.draftsman=params["draftsman_arbitman_name_#{typ.data_val}"]
              @award.save
            end
          else
            if params["draftsman_clerk_name_#{typ.data_val}"]!=''
              @award.draftsman=params["draftsman_clerk_name_#{typ.data_val}"]
              @award.save
            end
          end
        end
      end
      flash[:notice]="批量创建成功"   
    rescue
      flash[:notice]="批量创建失败"
    end
    redirect_to :action=>"award_detail_list",:p_id=>params[:p_id]
  end
  
  def award_detail_delete
    @award=TbAwardDetail.find(params[:id])
    @award.used="N"
    @award.u=session[:user_code]
    @award.u_t=Time.now()
    if @award.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"award_detail_list",:p_id=>params[:p_id]
  end
  
  #裁决书交由仲裁员及仲裁员意见、日期  2009-7-28  聂灵灵
  def award1_list
    c="award_id = #{params[:award_id]} and used='Y'"
    @award1_pages,@award1=paginate(:tb_award1s,:conditions=>c,:order=>"type1")
    @type3={'1'=>"裁决初稿转其他仲裁员的日期",'2'=>"助理收到仲裁员反馈意见的日期"}
  end

  def award1_new
    @award1=TbAward1.new()
    @award1.date1=Date.today
  end

  def award1_create
    @award1=TbAward1.new(params[:award1])
    @award1.recevice_code=session[:recevice_code]
    @award1.case_code=session[:case_code]
    @award1.general_code=session[:general_code]
    @award1.award_id=params[:award_id]
    @award1.u=session[:user_code]
    @award1.u_t=Time.now()
    if @award1.save
      flash[:notice]="创建成功"
      redirect_to :action=>"award1_list",:award_id=>params[:award_id]
    else
      render :action=>"award1_new",:award_id=>params[:award_id]
    end
  end

  def award1_edit
    @award1=TbAward1.find(params[:id])
  end

  def award1_update
    @award1=TbAward1.find(params[:id])
    @award1.u=session[:user_code]
    @award1.u_t=Time.now()
    if @award1.update_attributes(params[:award1])
      flash[:notice]="修改成功"
      redirect_to :action=>"award1_list",:award_id=>params[:award_id]
    else
      flash[:notice]="修改失败"
      render :action=>"award1_edit",:award_id=>params[:award_id]
    end
  end

  def award1_delete
    @award1=TbAward1.find(params[:id])
    @award1.used="N"
    @award1.u=session[:user_code]
    @award1.u_t=Time.now()
    if @award1.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"award1_list",:award_id=>params[:award_id]
  end

end
