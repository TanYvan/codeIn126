#仲裁员管理的仲裁员参与活动部分，包含活动详情和仲裁员参与情况
#创建人 苏获 
#创建时间 20090508
class ArbitmanSessionController < ApplicationController
    #列出仲裁员参与活动情况的统计表
    def list_arbitman_session
#        @tb_arbitmen = TbArbitman.find_arbitman
#        @tb_arbitman_sessions = TbArbitmanSession.find(:all, :order => "id")
        
         @condi_search=params[:condi_search]
        if @condi_search==nil
            @condi_search=""
        end
        @order=params[:order]
        if @order==nil or @order==""
            @order="id asc"
        end
        @page_lines=params[:page_lines]
        if @page_lines==nil or @page_lines==""
            @page_lines = 20
        end        
        if @condi_search==''
            @arbitman_session_pages, @tb_arbitmen = paginate(:tb_arbitmen,:conditions => "used = 'Y'",:order=>@order,:per_page=>@page_lines.to_i)
        else 
            @arbitman_session_pages, @tb_arbitmen = paginate(:tb_arbitmen,:order=>@order,:conditions=>" #{@condi_search} and used = 'Y'",:per_page=>@page_lines.to_i)
        end 
    end
    
    #列出某名仲裁员的参与活动表
    def list_session
        #@tb_arbitman = TbArbitman.find_by_ArbitManNum(params[:arbitman_id])
        @tb_arbitman_sessions = TbArbitmanSession.find_arbitman_sessions(params[:arbitman_id])
    end    

    #新建具体活动的参与人员
    def new_attendant  
        @session_code = params[:session_code]
        @tb_arbitman_session = TbArbitmanSession.new      
    end
    #修改参加活动的人员
    def edit_attendant
        @tb_arbitman_session = TbArbitmanSession.find(params[:id])
        @session_code = params[:session_code]
        
    end
    #更新参与活动人员信息
     def update_attendant
        @tb_arbitman_session = TbArbitmanSession.find(params[:id])
        @tb_arbitman_session.arbitman_num = params[:tb_arbitman_session][:arbitman_num]
#        params[:tb_arbitman_session][:arbitman_num] = TbArbitman.find_by_name(params[:tb_arbitman_session][:arbitman_num]).code
        @tb_arbitman_session.user = session[:user_code]
        @tb_arbitman_session.u_time = Time.now           
        if @tb_arbitman_session.update_attributes(params[:tb_arbitman_session])
            flash[:notice]="修改成功"  
            redirect_to :action=>"attend_person",:session_code => params[:session_code]
        else
            render :action=>"edit_attendant"
        end
    end
    
    def delete_attendant
        @tb_arbitman_session = TbArbitmanSession.find(params[:id])
        @tb_arbitman_session.used = 'N'
        @tb_arbitman_session.user = session[:user_code]
        @tb_arbitman_session.u_time = Time.now   
        if @tb_arbitman_session.save!          
            flash[:notice]="删除成功"
            redirect_to :action=>"attend_person", :session_code => params[:session_code]#确定怎么得到id进行删除
        else 
            flash[:notice]="删除失败"        
        end        
    end

    #添加具体活动的参与人员
    def create_attendant
        #@arbit_name = params[:tb_arbitman_session][:arbitman_num]
        @tb_arbitman_session = TbArbitmanSession.new(params[:tb_arbitman_session])
        @tb_arbitman_session.arbitman_num = params[:tb_arbitman_session][:arbitman_num]
        @tb_arbitman_session.session_code = params[:session_code]
        @tb_arbitman_session.user = session[:user_code]
        @tb_arbitman_session.u_time = Time.now         
        @tb_arbitman_session.save!
        redirect_to :action => "attend_person", :session_code=>params[:session_code]
    rescue ActiveRecord::RecordNotSaved =>e
        flash[:notice]="保存失败"
        render :action=>"new_attendant" 
    end
    
    ######################################################################################
    #                           原本属于session_detail的函数
    ######################################################################################
    #获取活动的条目
    def list_session_detail
        #@session_details = SessionDetail.find_sessions
        @condi_search=params[:condi_search]
        if @condi_search==nil
            @condi_search=""
        end
        @order=params[:order]
        if @order==nil or @order==""
            @order="session_num asc"
        end
        @page_lines=params[:page_lines]
        if @page_lines==nil or @page_lines==""
            @page_lines = 10
        end        
        if @condi_search==''
            @session_detail_pages, @session_details = paginate(:session_details,:conditions => "used = 'Y'",:order=>@order,:per_page=>@page_lines.to_i)
        else 
            @session_detail_pages, @session_details = paginate(:session_details,:order=>@order,:conditions=>" #{@condi_search} and used = 'Y'",:per_page=>@page_lines.to_i)
        end 
    end
    #新添加活动
    def new_session_detail
        @session_detail = SessionDetail.new
    end
    #创建活动
    def create_session_detail
        @session_detail = SessionDetail.new(params[:session_detail])
        @session_detail.user = session[:user_code]
        @session_detail.u_time = Time.now          
        @session_detail.save!
        redirect_to :action=>"list_session_detail"
       
    rescue ActiveRecord::RecordNotSaved =>e
        flash[:notice]="必填项不可为空"
        render :action=>"new_session_detail"  
    end
    #编辑活动
    def edit_session_detail
        @session_detail = SessionDetail.find_by_session_num(params[:id])
    end
    #更新活动
    def update_session_detail
        @session_detail = SessionDetail.find(params[:id])
        @session_detail.user = session[:user_code]
        @session_detail.u_time = Time.now            
        if @session_detail.update_attributes(params[:session_detail])
            flash[:notice]="修改成功"  
            redirect_to :action=>"list_session_detail",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
        else
            render :action=>"edit_session_detail"
        end
    end
    
        #删除活动
    def delete_session_detail
        @session_detail = SessionDetail.find_by_session_num(params[:id])
        @session_detail.used = 'N'
        @session_detail.user = session[:user_code]
        @session_detail.u_time = Time.now            
        if @session_detail.save!
            flash[:notice]="修改成功"  
            redirect_to :action=>"list_session_detail",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
        else
            flash[:notice]="修改失败"
        end
    end
    #显示参加活动的人员列表
    def attend_person
        @session_code = params[:session_code]
        @persons = TbArbitmanSession.find_sessions_with_code(@session_code)
    end    
end
