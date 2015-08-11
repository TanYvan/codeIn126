=begin
创建人：聂灵灵
创建时间：2009-5-8
类的描述：实体类是tb_experts,table是tb_experts
此类主要实现专家咨询的创建(expert下的expert_new页面)，
修改(expert下的expert_edit页面)，
列表显示(expert下的expert_list页面)功能
=end
class ExpertController < ApplicationController

   def expert_list
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
          c="recevice_code='#{session[:recevice_code]}' and used='Y'"
          @expert=TbExpert.find(:all,:order=>'id',:conditions=>c)
        end
    end

      def expert_new
        @expert=TbExpert.new()
        @expert.present_date=Date.today
        @expert.approval_date=Date.today
        @expert.hand_date=Date.today
        @expert.convoke_date=Date.today
        @expert.turn_date=Date.today
      end
     def expert_create
       @expert=TbExpert.new(params[:expert])
       @expert.recevice_code=session[:recevice_code]
       @expert.case_code=session[:case_code]
       @expert.general_code=session[:general_code]
       @expert.u=session[:user_code]
       @expert.u_t=Time.now()
       if @expert.save
          flash[:notice]="创建成功"
          redirect_to :action=>"expert_list"
       else
          flash[:notice]="创建失败"
          render :action=>"expert_new"
       end
    end

  def expert_edit
     @expert=TbExpert.find(params[:id])
  end

  def expert_update
     @expert=TbExpert.find(params[:id])
     @expert.u=session[:user_code]
     @expert.u_t=Time.now()
     if @expert.update_attributes(params[:expert])
        flash[:notice]="修改成功"
        redirect_to :action=>"expert_list"
     else
	flash[:notice]="修改失败"
        render :action=>"expert_edit",:id=>params[:id]
     end
  end

  def expert_delete
     @expert=TbExpert.find(params[:id])
     @expert.used="N"
     @expert.u=session[:user_code]
     @expert.u_t=Time.now()
     if @expert.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"expert_list"
  end
end
