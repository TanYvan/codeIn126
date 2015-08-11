=begin
创建人：聂灵灵
创建时间：2009-6-4
类的描述：此类是处理案件费用减交页面的信息及维护。
页面：
案件费用减交信息列表:/deferral/deferral_list
创建案件费用减交信息：/deferral/deferral_new
修改案件费用减交信息：/deferral/deferral_edit
=end
class DeferralController < ApplicationController
    def p_set
      if params[:p_typ]=='0001'
        typ2=TbParty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'",:order=>'id',:select=>"id as id ,partyname as name")
      elsif params[:p_typ]=='0002'
        typ2=TbParty.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'",:order=>'id',:select=>"id as id,partyname as name")
      elsif params[:p_typ]=='0003'
        typ2=TbAgent.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'",:order=>'id',:select=>"id,name")
      elsif params[:p_typ]=='0004'
        typ2=TbAgent.find(:all,:conditions=>"recevice_code='#{session[:recevice_code]}' and partytype=2 and used='Y'",:order=>'id',:select=>"id,name")
      end
      render :update do |page|
        page.remove 'deferral_counselor'
        page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
      end
    end
    
    def deferral_list
      @con= {"0001"=>"申请人","0002"=>"被申请人","0003"=>"申请方代理人","0004"=>"被申请方代理人"}
      @case=nil#当前办理案件
      if session[:recevice_code_4]==nil
      else
        @case=TbCase.find_by_recevice_code(session[:recevice_code_4])
        c="recevice_code='#{session[:recevice_code_4]}' and used='Y'"
        @deferral=TbDeferral.find(:all,:order=>'id',:conditions=>c)
      end
    end

    def deferral_new
       @deferral=TbDeferral.new()
       @deferral.receptionist=session[:user_code]
       @deferral.apply_date = Date.today
    end

    def deferral_create
       @deferral=TbDeferral.new(params[:deferral])
       @deferral.recevice_code=session[:recevice_code]
       @deferral.case_code=session[:case_code]
       @deferral.general_code=session[:general_code]
       @deferral.u=session[:user_code]
       @deferral.u_t=Time.now()
       if @deferral.save
          flash[:notice]="创建成功"
          redirect_to :action=>"deferral_list"
       else
          render :action=>"deferral_new"
       end
    end

  def deferral_edit
     @deferral=TbDeferral.find(params[:id])
     @partyid=@deferral.counselor
     @partyname=TbParty.find(:first,:conditions=>["id = ?",@partyid]).partyname
  end

  def deferral_update
     @deferral=TbDeferral.find(params[:id])
     @deferral.u=session[:user_code]
     @deferral.u_t=Time.now()
     if @deferral.update_attributes(params[:deferral])
        flash[:notice]="修改成功"
        redirect_to :action=>"deferral_list"
     else
        flash[:notice]="修改失败"
        render :action=>"deferral_edit",:id=>params[:id]
     end
  end

  def deferral_delete
     @deferral=TbDeferral.find(params[:id])
     @deferral.used="N"
     @deferral.u=session[:user_code]
     @deferral.u_t=Time.now()
     if @deferral.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"deferral_list"
  end
end
