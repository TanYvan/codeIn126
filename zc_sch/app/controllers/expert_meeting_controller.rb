#专家会议模块控制器，专家会议列表、添加专家会议、会议参与人员名单等
#添加人 苏获
#添加时间  20090526
class ExpertMeetingController < ApplicationController
#    def list_expert_meeting
#        @order=params[:order]
#        if @order==nil or @order==""
#            @order="id desc"
#        end
#        @page_lines=params[:page_lines]
#        if @page_lines==nil or @page_lines==""
#            @page_lines= 10
#        end
#        c = "used = 'Y'"
#        p=PubTool.new()
#        if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#            c = c + @search_condit
#        end
#        @meeting_pages,@expert_meetings =paginate(:expert_meetings,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)
#
#    end
    def list_expert_meeting
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines=20
      end
      @case=nil#当前办理案件
      if session[:recevice_code]==nil
      else
        @case=TbCase.find_by_recevice_code(session[:recevice_code])
        c="recevice_code='#{session[:recevice_code]}' and used='Y'"
        @meeting_pages,@expert_meetings =paginate(:expert_meetings,:conditions => c,:per_page=>@page_lines.to_i)
      end
    end
    #新建会议记录
    def new_expert_meeting
        @expert_meeting = ExpertMeeting.new()
        @expert_meeting.dat=Date.today
    end
    #添加会议记录
    def create_expert_meeting
        @expert_meeting = ExpertMeeting.new(params[:expert_meeting])
        @expert_meeting.recevice_code=session[:recevice_code]
        @expert_meeting.case_code=session[:case_code]
        @expert_meeting.general_code=session[:general_code]
        @expert_meeting.u = session[:user_code]
        @expert_meeting.u_time = Time.now           
        if @expert_meeting.save 
            flash[:notice] = "会议记录添加成功！"
            redirect_to :action =>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
        else
            flash[:notice] = "会议记录添加失败！"
            render :action =>"new_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
        end     
    end
    
    #修改会议记录
    def edit_expert_meeting
        @expert_meeting = ExpertMeeting.find(params[:meeting_id])
    end
    #更新会议记录
    def update_expert_meeting
        @expert_meeting = ExpertMeeting.find(params[:id])
        @expert_meeting.recevice_code=session[:recevice_code]
        @expert_meeting.case_code=session[:case_code]
        @expert_meeting.general_code=session[:general_code]
        @expert_meeting.u = session[:user_code]
        @expert_meeting.u_time = Time.now           
        if @expert_meeting.update_attributes(params[:expert_meeting]) 
            flash[:notice]="修改成功！"  
            redirect_to :action=>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
        else
            flash[:notice]="修改失败！"
            render :action=>"edit_expert_meeting", :id => params[:id],:page=>params[:page],:page_lines=>params[:page_lines]
        end        
    end
    #删除回忆记录
    def delete_expert_meeting
        @expert_meeting = ExpertMeeting.find(params[:id]) 
        @expert_meeting.used = 'N'
        @expert_meeting.u = session[:user_code]
        @expert_meeting.u_time = Time.now           
        if @expert_meeting.save!
            flash[:notice]="删除成功！"
        else
            flash[:notice]="删除失败！"            
        end
        redirect_to :action=>"list_expert_meeting",:page=>params[:page],:page_lines=>params[:page_lines]
    end
    
    
    #######################################################################################
    #参会专家列表
    def list_meeting_attendant
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines=10
      end
      @search_condit=params[:search_condit]
      if @search_condit==nil
          @search_condit=""
      end
      @meeting_id=params[:meeting_id]
      c="used = 'Y' and meeting_id='#{@meeting_id}'"
      @meeting_attedant_pages,@meeting_attendant=paginate(:meeting_attendant,:conditions=>c,:order=>"expert_code",:per_page=>@page_lines.to_i)
    end
    #新建参会专家
    def new_meeting_attendant
        @page_lines=params[:page_lines]
        if @page_lines==nil or @page_lines==""
          @page_lines=20
        end
        @expertconsult_pages,@tb_expertconsults=paginate(:tb_expertconsult,:conditions=>["used = 'Y'"],:order=>"code",:per_page=>@page_lines.to_i)
    end
    #添加参会专家
    def create_meeting_attendant
        @meeting_attedant = MeetingAttendant.new
        @meeting_attedant.meeting_id = params[:meeting_id]
        @meeting_attedant.expert_code = params[:expert_code]
        @meeting_attedant.u = session[:user_code]
        @meeting_attedant.u_time = Time.now 
        if @meeting_attedant.save!
            flash[:notice]="添加成功！"  
            redirect_to :action=>"list_meeting_attendant",:meeting_id => params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
        else
            flash[:notice]="添加失败！"
            render :action=>"new_meeting_attendant", :meeting_id => params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
        end
    end
    #删除参会专家
    def delete_meeting_attendant
        @meeting_attedant = MeetingAttendant.find(params[:id])
        @meeting_attedant.used = 'N'
        @meeting_attedant.u = session[:user_code]
        @meeting_attedant.u_time = Time.now         
        if @meeting_attedant.save!
            flash[:notice]="删除参与人员成功！"            
        else
            flash[:notice]="删除参与人员失败！"
        end
        redirect_to :action=>"list_meeting_attendant",:id => params[:meeting_id],:page=>params[:page],:page_lines=>params[:page_lines]
    end
end
