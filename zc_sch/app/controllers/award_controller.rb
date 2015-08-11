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
    @award=TbAward.new()
    @award.recedate=Date.today
    @award.refereeAdate=Date.today
    @award.refereeBdate=Date.today
    @award.arbiterAdate=Date.today
    @award.arbiterBdate=Date.today
    @award.lastDate=Date.today
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
     @award=TbAward.find(params[:id])
  end

  def award_update
     @award=TbAward.find(params[:id])
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
#裁决书交由仲裁员及仲裁员意见、日期  2009-7-28  聂灵灵
  def award1_list
    c="award_id = #{params[:award_id]} and used='Y'"
    @award1_pages,@award1=paginate(:tb_award1s,:order=>'id',:conditions=>c,:order=>"type1")
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
