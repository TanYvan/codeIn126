class ChargeFunController < ApplicationController
  def list 
    @app_roles=TbDictionary.find(:all,:conditions=>"typ_code='8143' and used='Y' and state='Y'",:order=>"data_val")
  end

  def charge_fun_detail_list
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_details = ChargeFunDetail.find(:all,:conditions=>["used='Y' and role_code=?",@charge_fun.data_val],:order=>"app_code")
    @case_app={}
    TbDictionary.find(:all,:conditions=>"typ_code='0001'",:select=>"data_val,data_text").each{|p|
      @case_app.merge!(p.data_val => p.data_text)
    }
    @fun=Cost.new.fun
  end

  def charge_fun_detail_new
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_detail = ChargeFunDetail.new
    @fun=Cost.new.fun.map{|p|[p[1], p[0]]}.insert(0,["",""])
    @case_app=TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y' and used='Y'",:select=>"data_val,data_text").map{|p|[p.data_text,p.data_val]}.insert(0,["",""])
  end

  def charge_fun_detail_create
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_detail=ChargeFunDetail.new(params[:charge_fun_detail])
    @charge_fun_detail.role_code = @charge_fun.data_val
    @charge_fun_detail.u=session[:user_code]
    @charge_fun_detail.u_t=Time.now()
    if @charge_fun_detail.save
      flash[:notice]="创建成功"
      redirect_to :action=>"charge_fun_detail_list",:app_role => @charge_fun.data_val
    else
      flash[:notice]="创建失败"
      render :action=>"charge_fun_detail_new"
    end
  end

  def charge_fun_detail_edit
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_detail=ChargeFunDetail.find(params[:id])
    @fun=Cost.new.fun.map{|p|[p[1], p[0]]}.insert(0,["",""])
    @case_app=TbDictionary.find(:all,:conditions=>"typ_code='0001' and state='Y'  and used='Y'",:select=>"data_val,data_text").map{|p|[p.data_text,p.data_val]}.insert(0,["",""])
  end

  def charge_fun_detail_update
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_detail = ChargeFunDetail.find(params[:id])
    @charge_fun_detail.u=session[:user_code]
    @charge_fun_detail.u_t=Time.now()
    if @charge_fun_detail.update_attributes(params[:charge_fun_detail])
      flash[:notice]="修改成功"
      redirect_to :action => "charge_fun_detail_list", :id => params[:id], :app_role => @charge_fun.data_val
    else
      render :action=>"charge_fun_detail_edit",:id=>params[:id]
    end
  end
  
  def charge_fun_detail_delete
    @charge_fun=TbDictionary.find_by_typ_code_and_data_val('8143', params[:app_role])
    @charge_fun_detail = ChargeFunDetail.find(params[:id])
    @charge_fun_detail.used = 'N'
    @charge_fun_detail.u=session[:user_code]
    @charge_fun_detail.u_t=Time.now()
    if @charge_fun_detail.update_attributes(params[:charge_fun_detail])
      flash[:notice]="修改成功"
    else
      flash[:notice]="修改失败"
    end
    redirect_to :action => "charge_fun_detail_list", :id => params[:id], :app_role => @charge_fun.data_val
  end

end
