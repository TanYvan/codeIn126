class AdjudgebrikeController < ApplicationController
    def adjudgebrike_list
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
          c="recevice_code='#{session[:recevice_code]}' and used='Y'"
          @adjudgebrike=TbAdjudgebrike.find(:all,:order=>'id',:conditions=>c)
        end
    end
#添加仲裁中止
    def adjudgebrike_new
       @adjudgebrike=TbAdjudgebrike.new()
       @adjudgebrike.end_date=Date.today
       @adjudgebrike.start_date=Date.today
    end

    def adjudgebrike_create
       @adjudgebrike=TbAdjudgebrike.new(params[:adjudgebrike])
       @adjudgebrike.recevice_code=session[:recevice_code]
       @adjudgebrike.case_code=session[:case_code]
       @adjudgebrike.general_code=session[:general_code]
       @adjudgebrike.u=session[:user_code]
       @adjudgebrike.u_t=Time.now()
       if @adjudgebrike.save
          flash[:notice]="创建成功"          
          redirect_to :action=>"adjudgebrike_list"
       else
          render :action=>"adjudgebrike_new"
       end
    end
#修改仲裁中止
  def adjudgebrike_edit
     @adjudgebrike=TbAdjudgebrike.find(params[:id])
  end

  def adjudgebrike_update
     @adjudgebrike=TbAdjudgebrike.find(params[:id])
     @adjudgebrike.u=session[:user_code]
     @adjudgebrike.u_t=Time.now()
     if @adjudgebrike.update_attributes(params[:adjudgebrike])
        flash[:notice]="修改成功"
        redirect_to :action=>"adjudgebrike_list"
     else
	flash[:notice]="修改失败"
        render :action=>"adjudgebrike_edit",:id=>params[:id]
     end
  end
#删除仲裁中止
  def adjudgebrike_delete
     @adjudgebrike=TbAdjudgebrike.find(params[:id])
     @adjudgebrike.used="N"
     @adjudgebrike.u=session[:user_code]
     @adjudgebrike.u_t=Time.now()
     if @adjudgebrike.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"adjudgebrike_list"
  end
  
end
