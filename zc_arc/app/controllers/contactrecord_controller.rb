class ContactrecordController < ApplicationController
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
      page.remove 'contactrecord_counselor'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  def contactrecord_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @contactrecord=TbContactrecord.find(:all,:order=>'id',:conditions=>c)
    end
  end
#创建联系记录
  def contactrecord_new
    @contactrecord=TbContactrecord.new()
    @contactrecord.receptionist=session[:user_code]
    @contactrecord.contact_time=Date.today
  end

  def contactrecord_create
     @contactrecord=TbContactrecord.new(params[:contactrecord])
     @contactrecord.recevice_code=session[:recevice_code]
     @contactrecord.case_code=session[:case_code]
     @contactrecord.general_code=session[:general_code]
     @contactrecord.u=session[:user_code]
     @contactrecord.u_t=Time.now()
     if @contactrecord.save
        flash[:notice]="创建成功"
        redirect_to :action=>"contactrecord_list"
     else
        flash[:notice]="创建失败"
        render :action=>"contactrecord_list"
     end

  end
#修改联系记录
  def contactrecord_edit
     @contactrecord=TbContactrecord.find(params[:id])
  end

  def contactrecord_update
     @contactrecord=TbContactrecord.find(params[:id])
     @contactrecord.u=session[:user_code]
     @contactrecord.u_t=Time.now()
     if @contactrecord.update_attributes(params[:contactrecord])
        flash[:notice]="修改成功"
        redirect_to :action=>"contactrecord_list"
     else
        flash[:notice]="修改失败"
        render :action=>"contactrecord_edit",:id=>params[:id]
     end
  end
#删除联系记录
  def contactrecord_delete
     @contactrecord=TbContactrecord.find(params[:id])
     @contactrecord.used="N"
     @contactrecord.u=session[:user_code]
     @contactrecord.u_t=Time.now()
     if @contactrecord.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"contactrecord_list"
  end
end
