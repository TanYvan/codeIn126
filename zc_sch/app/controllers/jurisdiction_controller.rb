=begin
创建人：聂灵灵
创建时间：2009-6-2
描述：实体类是TbJurisdiction,table是tb_jurisdictions
此类主要实现管辖权异议申请的创建(jurisdiction下的jurisdiction_new页面)，
修改(jurisdiction下的jurisdiction_edit页面)，
列表显示(jurisdiction下的jurisdiction_list页面)功能,
=end
class JurisdictionController < ApplicationController
      def jurisdiction_list
        @e={1=>"提醒",2=>"不提醒"}
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
          c="recevice_code='#{session[:recevice_code]}' and used='Y'"
          @jurisdiction=TbJurisdiction.find(:all,:order=>'id',:conditions=>c)
        end
      end

     def jurisdiction_new
        @jurisdiction=TbJurisdiction.new()
        @jurisdiction.request_date=Date.today
        @recevice_code=params[:recevice_code]
#        @jurisdiction.transmit_date=Date.today
#        @jurisdiction.receive_date=Date.today
#        @jurisdiction.check_date=Date.today
#        @jurisdiction.idea_date=Date.today
#        @jurisdiction.checkout_date=Date.today
#        @jurisdiction.draft_date=Date.today
#        @jurisdiction.decide_date=Date.today
#        @jurisdiction.parties_date=Date.today
#        @jurisdiction.stop_date=Date.today
#        @jurisdiction.reset_date=Date.today
     end
     def jurisdiction_create
       @jurisdiction=TbJurisdiction.new(params[:jurisdiction])
       @jurisdiction.recevice_code=session[:recevice_code]
       @jurisdiction.case_code=session[:case_code]
       @jurisdiction.general_code=session[:general_code]
       @jurisdiction.u=session[:user_code]
       @jurisdiction.u_t=Time.now()
       if @jurisdiction.save
          flash[:notice]="创建成功"
          redirect_to :action=>"jurisdiction_list"
       else
          flash[:notice]="创建失败"
          render :action=>"jurisdiction_new"
       end
    end

    def jurisdiction_edit
      @jurisdiction=TbJurisdiction.find(params[:id])
    end

   def jurisdiction_update
     @jurisdiction=TbJurisdiction.find(params[:id])
     @jurisdiction.u=session[:user_code]
     @jurisdiction.u_t=Time.now()
     if @jurisdiction.update_attributes(params[:jurisdiction])
        flash[:notice]="修改成功"
        redirect_to :action=>"jurisdiction_list"
     else
        flash[:notice]="修改失败"
        render :action=>"jurisdiction_edit",:id=>params[:id]
     end
   end

   def jurisdiction_delete
     @jurisdiction=TbJurisdiction.find(params[:id])
     @jurisdiction.used="N"
     @jurisdiction.u=session[:user_code]
     @jurisdiction.u_t=Time.now()
     if @jurisdiction.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"jurisdiction_list"
   end
   
   def remind_change
    @jurisdiction=TbJurisdiction.find(params[:id])
  end 

  def remind_update
    @jurisdiction=TbJurisdiction.find(params[:id])
    @jurisdiction.remind_t=Time.now()
    if @jurisdiction.update_attributes(params[:jurisdiction]) 
      flash[:notice]="设置成功"
      redirect_to :action=>"jurisdiction_list"
    else
      flash[:notice]="设置失败"
      render :action=>"remind_change",:id=>params[:id]
    end
     
  end
  
end
