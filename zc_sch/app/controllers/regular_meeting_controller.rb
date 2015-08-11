#秘书处例会类、会议列表和基本信息
#添加人  苏获
#添加时间 20090526
class RegularMeetingController < ApplicationController
  def list_regular_meeting
      
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
    end
      
    @hant_search_1_page_name="list_regular_meeting"
    @hant_search_1=[
      ['date','dat','日期','text',[]],['char','record_by','会议记录人','text',[]],
      ['char','content','内容摘要','text',[]],
    ]
        
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
        
    @meeting_pages,@regular_meetings =paginate(:regular_meetings,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)          
       
  end
    
  #新建会议记录
  def new_regular_meeting
    @regular_meeting = RegularMeeting.new
    @regular_meeting.dat=Date.today
  end
  #添加会议记录
  def create_regular_meeting
    @regular_meeting = RegularMeeting.new(params[:regular_meeting])
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.save 
      flash[:notice] = "会议记录添加成功！"
      redirect_to :action =>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "会议记录添加失败！"
      render :action =>"new_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end     
  end
    
  #修改会议记录
  def edit_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id])
  end
  #更新会议记录
  def update_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id]) 
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.update_attributes(params[:regular_meeting]) 
      flash[:notice]="修改成功！"  
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败！"
      render :action=>"edit_regular_meeting", :id => params[:id]
    end        
  end
  #删除回忆记录
  def delete_regular_meeting
    @regular_meeting = RegularMeeting.find(params[:id]) 
    @regular_meeting.used = 'N'
    @regular_meeting.u = session[:user_code]
    @regular_meeting.u_time = Time.now           
    if @regular_meeting.save
      flash[:notice]="删除成功！"  
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败！"
      redirect_to :action=>"list_regular_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end           
  end    
    
  #######################################################################################
  #添加人 苏获
  #添加时间 20090527
  #参会人员列表
  def list_meeting_attendant
    @meeting_attedants = RegularMeetingAttendant.find(:all, :conditions => ["used = 'Y' and regular_meeting_id = ?",params[:id]])
  end
  #新建参会人员
  def new_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.new
  end
  #添加参会人员
  def create_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.new(params[:regular_meeting_attendant])
    @meeting_attedant.regular_meeting_id = params[:regular_meeting_id]
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now 
    if @meeting_attedant.save
      flash[:notice]="添加参与人员成功！"  
      redirect_to :action=>"list_meeting_attendant",:id => params[:regular_meeting_id]
    else
      flash[:notice]="添加参与人员失败！"
      render :action=>"new_meeting_attendant", :regular_meeting_id => params[:regular_meeting_id]
    end
  end
  #删除参会人员
  def delete_meeting_attendant
    @meeting_attedant = RegularMeetingAttendant.find(params[:id])
    @meeting_attedant.used = 'N'
    @meeting_attedant.u = session[:user_code]
    @meeting_attedant.u_time = Time.now         
    if @meeting_attedant.save
      flash[:notice]="删除参与人员成功！"  
      redirect_to :action=>"list_meeting_attendant",:id => params[:regular_meeting_id]
    else
      flash[:notice]="删除参与人员失败！"
      redirect_to :action=>"list_meeting_attendant", :id => params[:regular_meeting_id]
    end
  end

end

