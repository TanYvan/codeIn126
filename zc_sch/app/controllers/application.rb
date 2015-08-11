# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  
  
  before_filter :configure_charsets
  before_filter :user_role
   
  def configure_charsets

    @response.headers["Content-Type"] = "text/html; charset=utf-8" 
    # Set connection charset. MySQL 4.0 doesn’t support this so it 

    # will throw an error, MySQL 4.1 needs this 

    suppress(ActiveRecord::StatementInvalid) do 

      ActiveRecord::Base.connection.execute 'SET NAMES utf8'

    end

    def user_role
      if self.controller_name=="step1"
      elsif  self.controller_name=="case_consultation3"
        if session[:user_code_2]==nil
          render :text=>"页面超时，请重新<a href='/step1/login' target='_parent'>登录</a>"
        end
      elsif self.controller_name=='should_charge' and session[:user_code_2]!=nil and session[:user_code]==nil
      elsif self.controller_name=='should_refund' and session[:user_code_2]!=nil and session[:user_code]==nil
      elsif (self.controller_name=="docformat" and self.action_name=="dc_update") or (self.controller_name=="case_doc" and self.action_name.slice(0,3)=="doc") or (self.controller_name=="welcome" and self.action_name=="login") or (self.controller_name=="welcome" and self.action_name=="login_do") or (self.controller_name=="welcome" and self.action_name=="log_out")
      else
        if session[:user_code]==nil
          render :text=>"页面超时，请重新<a href='/welcome/login' target='_parent'>登录</a>"
        else
          #@act=Action.find_by_sql("select distinct actions.controller_name as controller_name from urs,actions where urs.user_code='#{session[:user_code]}' and urs.role_code=actions.role_code and  actions.controller_name='#{self.controller_name}'")
         
          @act_1=PubAction.find_by_sql("select * from pub_actions where controllers like '%|#{self.controller_name}|%'")
          @act_2=PubAction.find_by_sql("select * from pub_actions where actions like '%|#{self.controller_name}/#{self.action_name}|%'")
          @act_3=PubAction.find_by_sql("select * from urs,menus where urs.user_code='#{session[:user_code]}' and urs.role_code=menus.role_code and  menus.controllers like '%|#{self.controller_name}|%'")
          @act_4=PubAction.find_by_sql("select * from urs,menus where urs.user_code='#{session[:user_code]}' and urs.role_code=menus.role_code and  menus.actions like '%|#{self.controller_name}/#{self.action_name}|%'")
         
          if @act_1.empty? and @act_2.empty? and @act_3.empty? and @act_4.empty?
           
            render_text "您无权访问该页面，请重新<a href='/welcome/login' target='_parent'>登录</a>"
          end
        end
      end
    end
  
    
    def paginate_by_sql(model, sql, per_page, options={})
      if options[:count]
        if options[:count].is_a? Integer
          total = options[:count]
        else
          total = model.count_by_sql(options[:count])
        end
      else
        total = model.count_by_sql_wrapping_select_query(sql)
      end
     
      object_pages = Paginator.new self, total, per_page,
        @params['page']
      objects = model.find_by_sql_with_limit(sql,
        object_pages.current.to_sql[1], per_page)
      return [object_pages, objects]
    end
    
    
    def paginate_by_sql_for_multi_results(model, sql, per_page, page_param_name, options={})
      if options[:count]
        if options[:count].is_a? Integer
          total = options[:count]
        else
          total = model.count_by_sql(options[:count])
        end
      else
        total = model.count_by_sql_wrapping_select_query(sql)
      end

      object_pages = Paginator.new self, total, per_page,
        @params[page_param_name]
      objects = model.find_by_sql_with_limit(sql,
        object_pages.current.to_sql[1], per_page)
      return [object_pages, objects]
    end   

    
    
  end
end