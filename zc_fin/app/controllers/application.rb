# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  
  
  before_filter :configure_charsets
  before_filter :user_role
   
  def configure_charsets
    response.headers["Content-Type"] = "text/html; charset=utf-8" 
    # Set connection charset. MySQL 4.0 doesn’t support this so it 
    # will throw an error, MySQL 4.1 needs this 

    suppress(ActiveRecord::StatementInvalid) do 
      ActiveRecord::Base.connection.execute 'SET NAMES utf8'
    end
  end

  def user_role
    if (self.controller_name=="docformat" and self.action_name=="dc_update") or (self.controller_name=="case_doc" and self.action_name.slice(0,3)=="doc") or (self.controller_name=="welcome" and self.action_name=="login") or (self.controller_name=="welcome" and self.action_name=="login_do") or (self.controller_name=="welcome" and self.action_name=="log_out")
    else
      if session[:user_code]==nil
        render :text=>"页面超时，请重新<a href='/welcome/login' target='_parent'>登录</a>"
      else
        #@act=Action.find_by_sql("select distinct actions.controller_name as controller_name from urs,actions where urs.user_code='#{session[:user_code]}' and urs.role_code=actions.role_code and  actions.controller_name='#{self.controller_name}'")
        @act_1=PubAction.find_by_sql("select * from pub_actions where controllers like '%|#{self.controller_name}|%'")
        @act_2=PubAction.find_by_sql("select * from pub_actions where actions like '%|#{self.controller_name}/#{self.action_name}|%'")

        rrr="/case_p/arbitmannow_select/every_casebase/casebase/census3/case_query1/jurisdiction/filing_up"
        if session[:user_typ]=="9001"
          rrr=rrr + '/bonus_penalty,/remuneration1_set,/remuneration11_set,/remuneration2_set,/remuneration3_set,/remuneration4_set,/remuneration5_set,/remuneration6_set,/remuneration8_set,/remuneration9_set'
          rrr=rrr + "0,'工时汇总','工时汇总','','','',3,'','','',-1,2,'工时汇总','工时汇总','','',4,'t_clicked(\'/remuneration_set/list\');','','',2,'仲裁报酬汇总信息','仲裁报酬汇总信息','','',4,'t_clicked(\'/remuneration_sum/list\');','','',2,'报酬报表','报酬报表','','',4,'t_clicked(\'/remuneration_set_report_a/list\');','','',2,'仲裁员评价加减分统计','仲裁员评价加减分统计','','',4,'t_clicked(\'/add_less/list\');','','',2,'仲裁员评价信息查询','仲裁员评价信息查询','','',4,'t_clicked(\'/case_query1/list_50\');','','',1,5"
        elsif session[:user_typ]=='9002'
          rrr=rrr + "0,'报酬','报酬','','','',4,'','','',-1,2,'办案其它报酬_案件','办案其它报酬_案件','','',4,'t_clicked(\'/remuneration23_set/list\');','','',2,'办案其它报酬_独立维护','办案其它报酬_独立维护','','',4,'t_clicked(\'/remuneration23_set2/list\');','','',2,'案件报酬','案件报酬','','',4,'t_clicked(\'/extend/list\');','','',2,'报酬发放','报酬发放','','',4,'t_clicked(\'/t_extend/list\');','','',2,'报酬发放信息','报酬发放信息','','',4,'t_clicked(\'/show_extend/list_extend_code\');','','',1,5"
        elsif session[:user_typ]=='9003'
          rrr=rrr + "0,'财务','财务','','','',3,'','','',-1,2,'案件费用统计','案件费用统计','','',4,'t_clicked(\'/report_total2/list\');','','',2,'受理案件仲裁条款及争议金额分析','受理案件仲裁条款及争议金额分析','','',4,'t_clicked(\'/report_total3/list\');','','',2,'仲裁员费用情况','仲裁员费用情况','','',4,'t_clicked(\'/report_total2/list_1\');','','',2,'仲裁员人案统计','仲裁员人案统计','','',4,'t_clicked(\'/census3/list3_9\');','','',2,'结案查询','结案查询','','',4,'t_clicked(\'/census3/list3_6\')','','',2,'撤案查询','撤案查询','','',4,'t_clicked(\'/census3/list3_7\')','','',2,'案件财务平衡表','案件财务平衡表','','',4,'t_clicked(\'/finance_balance/case_list_1\')','','',2,'立结审案件数统计','立结审案件数统计','','',4,'t_clicked(\'/census3/list3_34\')','','',2,'仲裁员评价加减分统计','仲裁员评价加减分统计','','',4,'t_clicked(\'/add_less/list\')','','',2,'仲裁员评价信息查询','仲裁员评价信息查询','','',4,'t_clicked(\'/case_query1/list_50\')','','',2,'前一月数据统计','前一月数据统计','','',4,'t_clicked(\'/region_total/list_1\')','','',1,5"
        elsif session[:user_typ]=='9004'
          rrr=rrr + "0,'查询统计','','','','',4,'','','',-1,2,'案件费用统计','案件费用统计','','',4,'t_clicked(\'/report_total2/list\');','','',2,'结案查询','结案查询','','',4,'t_clicked(\'/census3/list3_6\')','','',2,'撤案查询','撤案查询','','',4,'t_clicked(\'/census3/list3_7\')','','',1,5"
        end

        if @act_1.empty? and @act_2.empty? and rrr.index("/#{self.controller_name}")==nil

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