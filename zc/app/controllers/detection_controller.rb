class DetectionController < ApplicationController
    def detection_list
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
          c="recevice_code='#{session[:recevice_code]}' and used='Y'"
          @detection=TbDetection.find(:all,:order=>'id',:conditions=>c)
        end
    end
#添加检测(审计、笔迹鉴定)
      def detection_new
        @detection=TbDetection.new()
        @detection.make_date=Date.today
        #@detection.contract_date=Date.today
        #@detection.conclusion_date=Date.today
      end
      def detection_create
       @detection=TbDetection.new(params[:detection])
       @detection.recevice_code=session[:recevice_code]
       @detection.case_code=session[:case_code]
       @detection.general_code=session[:general_code]
       @detection.u=session[:user_code]
       @detection.u_t=Time.now()
       if @detection.save
          flash[:notice]="创建成功"
          redirect_to :action=>"detection_list"
       else
          flash[:notice]="创建失败"
          render :action=>"detection_new"
       end
    end
#修改检测(审计、笔迹鉴定)
  def detection_edit
     @detection=TbDetection.find(params[:id])
  end

  def detection_update
     @detection=TbDetection.find(params[:id])
     @detection.u=session[:user_code]
     @detection.u_t=Time.now()
     if @detection.update_attributes(params[:detection])
        flash[:notice]="修改成功"
        redirect_to :action=>"detection_list"
     else
	flash[:notice]="修改失败"
        render :action=>"detection_edit",:id=>params[:id]
     end
  end
#删除检测(审计、笔迹鉴定)
  def detection_delete
     @detection=TbDetection.find(params[:id])
     @detection.used="N"
     @detection.u=session[:user_code]
     @detection.u_t=Time.now()
     if @detection.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"detection_list"
  end
end
