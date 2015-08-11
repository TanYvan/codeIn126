class CasecommentController < ApplicationController
  #案件合议信息列表
  def casecomment_list
    @case=nil   #当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @casecomment=TbCasecomment.find(:all,:order=>'id',:conditions=>c)
    end
  end

  def casecomment_new
    @casecomment=TbCasecomment.new()
    @casecomment.comment_date = Date.today
  end

  def casecomment_create
     @casecomment=TbCasecomment.new(params[:casecomment])
     @casecomment.recevice_code=session[:recevice_code]
     @casecomment.case_code=session[:case_code]
     @casecomment.general_code=session[:general_code]
     @casecomment.u=session[:user_code]
     @casecomment.u_t=Time.now()
     if @casecomment.save
        flash[:notice]="创建成功"
        redirect_to :action=>"casecomment_list"
     else
        flash[:notice]="创建失败"
        render :action=>"casecomment_new"
     end

  end

  def casecomment_edit
     @casecomment=TbCasecomment.find(params[:id])
  end

  def casecomment_update
     @casecomment=TbCasecomment.find(params[:id])
     @casecomment.u=session[:user_code]
     @casecomment.u_t=Time.now()
     if @casecomment.update_attributes(params[:casecomment])
        flash[:notice]="修改成功"
        redirect_to :action=>"casecomment_list"
     else
	flash[:notice]="修改失败"
        render :action=>"casecomment_edit",:id=>params[:id]
     end
  end

  def casecomment_delete
     @casecomment=TbCasecomment.find(params[:id])
     @casecomment.used="N"
     @casecomment.u=session[:user_code]
     @casecomment.u_t=Time.now()
     if @casecomment.save
        @room=TbArbitroom.find(:all,:order=>'id',:conditions=>"usestyle='0002' and sitting_id=#{params[:id]} and used='Y'") 
        for r in @room
          r.used="N"
          r.u=session[:user_code]
          r.u_t=Time.now()
          r.save
        end
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"casecomment_list"
  end
#合议人员信息
  def commentarbitman_list
    c="comment_id=#{params[:comment_id]} and used='Y'"
    @commentarbitman=Commentarbitman.find(:all,:order=>'id',:conditions=>c)
  end
#创建合议人员
  def commentarbitman_new
    @commentarbitman=Commentarbitman.new()
  end

  def commentarbitman_create
     @commentarbitman=Commentarbitman.new(params[:commentarbitman])
     @commentarbitman.recevice_code=session[:recevice_code]
     @commentarbitman.case_code=session[:case_code]
     @commentarbitman.general_code=session[:general_code]
     @commentarbitman.comment_id=params[:comment_id]
     @commentarbitman.u=session[:user_code]
     @commentarbitman.u_t=Time.now()
     if @commentarbitman.save
        flash[:notice]="创建成功"
        redirect_to :action=>"commentarbitman_list",:comment_id=>params[:comment_id]
     else
        flash[:notice]="创建失败"
        render :action=>"commentarbitman_new" ,:comment_id=>params[:comment_id]
     end
  end
#修改对应的合议人员记录
  def commentarbitman_edit
     @commentarbitman=Commentarbitman.find(params[:id])
  end

  def commentarbitman_update
     @commentarbitman=Commentarbitman.find(params[:id])
     @commentarbitman.u=session[:user_code]
     @commentarbitman.u_t=Time.now()
     if @commentarbitman.update_attributes(params[:commentarbitman])
        flash[:notice]="修改成功"
        redirect_to :action=>"commentarbitman_list",:comment_id=>params[:comment_id]
     else
	flash[:notice]="修改失败"
        render :action=>"commentarbitman_edit",:comment_id=>params[:comment_id]
     end

  end
#删除一条合议人员记录
  def commentarbitman_delete
     @commentarbitman=Commentarbitman.find(params[:id])
     @commentarbitman.used="N"
     @commentarbitman.u=session[:user_code]
     @commentarbitman.u_t=Time.now()
     if @commentarbitman.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"commentarbitman_list",:comment_id=>params[:comment_id]
  end
  #使用仲裁庭
  def room_list
    c="usestyle='0002' and sitting_id=#{params[:sitting_id]} and used='Y'"
    @room=TbArbitroom.find(:all,:order=>'id',:conditions=>c) 
  end
  
  def room_new
    @room=TbArbitroom.new()
    @room.sittingdate=Date.today
  end
   
  def room_create
     @room=TbArbitroom.new(params[:room])
     @room.recevice_code=session[:recevice_code]
     @room.case_code=session[:case_code]
     @room.general_code=session[:general_code]
     @room.sitting_id=params[:sitting_id]
     @room.userId=User.find_by_code(session[:user_code]).name
     @room.usestyle="0002"
     @room.u=session[:user_code]
     @room.u_t=Time.now()
     @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @room.usetime = @use_time[params[:room][:close_t]] - @use_time[params[:room][:open_t]]

     if @room.save
        flash[:notice]="创建成功"
        redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
     else
       flash[:notice]="创建失败"
        render :action=>"room_new" ,:sitting_id=>params[:sitting_id]
     end
     
  end
   
  def room_edit
     @room=TbArbitroom.find(params[:id])
  end 

  def room_update
     @room=TbArbitroom.find(params[:id])
     @room.userId=User.find_by_code(session[:user_code]).name
     @room.u=session[:user_code]
     @room.u_t=Time.now()
     @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @room.usetime = @use_time[params[:room][:close_t]] - @use_time[params[:room][:open_t]]
     if @room.update_attributes(params[:room]) 
        flash[:notice]="修改成功"
        redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
     else
	flash[:notice]="修改失败"
        render :action=>"room_edit" ,:sitting_id=>params[:sitting_id]
     end
  end
   
  def room_delete
     @room=TbArbitroom.find(params[:id])
     @room.used="N"
     @room.u=session[:user_code]
     @room.u_t=Time.now()
     if @room.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"room_list",:sitting_id=>params[:sitting_id]
  end
end
