=begin
创建人：聂灵灵
创建时间：2009-6-2,3
描述：实体类是TbEvaluate,table是tb_evaluates
此类主要实现仲裁员评价的创建(evaluate下的evaluate_new页面)，
修改(evaluate下的evaluate_edit页面)，
列表显示(evaluate下的evaluate_list页面)功能
niell 2010-5-5  修改，根据新的评价体系
=end
class EvaluateController < ApplicationController
  #2009-10-12  聂灵灵   校核人员（user_duties 中 code为0007）对办案人员进行仲裁员评价
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  #选择不同评价内容时显示相应的评价结果选项
  def p_set
    typ2=TbDictionary.find(:all,:conditions=>"typ_code='8160' and state='Y' and used='Y' and data_parent='#{params[:p_typ]}'",:order=>'data_val',:select=>"data_val,data_text")
    render :update do |page|
      page.remove 'evaluate_data_val'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  def p_set2
    typ2=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and tb_casearbitmen.arbitmantype='#{params[:p_typ]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    render :update do |page|
      page.remove 'evaluate_arbitman'
      page.replace_html 'pv_set2', :partial => 'pv2',:object=>typ2
    end
  end
  def p_set3
    typ3=TbCasearbitman.find_by_sql("select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code='#{params[:recevice_code]}' and tb_casearbitmen.arbitmantype='#{params[:arbitman_type]}' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name" )
    render :update do |page|
      page.remove "evaluate_arbitman_id_#{params[:arbitman]}"
      ttt=[]
      ttt[0]=params[:arbitman]
      ttt[1]=typ3
      page.replace_html "pv_set3_#{params[:arbitman]}", :partial => 'pv3',:object=>ttt
    end
  end
  def evaluate_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @evaluate=TbEvaluate.find(:all,:conditions=>c,:order=>'arbitman_type,arbitman,parent_val,data_val')
  end

  def evaluate_new
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='8160' and  state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    oopp=TbDictionary.find(:first,:conditions=>"typ_code='8160' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val")
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8160' and  state='Y' and used='Y' and data_parent='#{oopp.data_val}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @arbit=TbDictionary.find(:all,:conditions=>["used='Y' and state='Y' and typ_code='0014'"],:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @casearbitman=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code=? and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name",params[:recevice_code]] )
    @evaluate=TbEvaluate.new()
  end
  #批量创建
  def new_all_2
    @tb_mark=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y' and data_parent<>''"],:order=>"data_val")
    @aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
    @arbit=TbDictionary.find(:all,:conditions=>["used='Y' and state='Y' and typ_code='0014'"],:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}#.insert(0,["",""])
    @ty2=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code=? and tb_casearbitmen.arbitmantype<>'0001' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name",params[:recevice_code]] ).collect{|p|[p.name,p.code]}#.insert(0,["",""])
    @casearbitman=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code,tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmantype_name from tb_casearbitmen,tb_arbitmen,tb_dictionaries where tb_casearbitmen.used='Y' and tb_dictionaries.typ_code='0014' and tb_casearbitmen.recevice_code=?  and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.arbitmantype=tb_dictionaries.data_val order by tb_casearbitmen.arbitmantype",params[:recevice_code]])
    @evaluate=TbEvaluate.new()
  end

  def evaluate_create
    @case=TbCase.find_by_recevice_code(params[:recevice_code] )
    @evaluate=TbEvaluate.new(params[:evaluate])
    @evaluate.recevice_code=params[:recevice_code]
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.save
      TbEvaluate.set_tb_25(params[:recevice_code])
      flash[:notice]="创建成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render_to :action=>"evaluate_new",:recevice_code=>params[:recevice_code]
    end
  end
  def create_all_2
    @tb_mark=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y' and data_parent<>''"],:order=>"data_val")
    @casearbitman=TbCasearbitman.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    begin
      for mark in @tb_mark
        for arb in @casearbitman
          if params["score_name_#{mark.data_val}_#{arb.arbitman}"]!=nil
            @evaluate=TbEvaluate.new()
            @evaluate.used='Y'
            @evaluate.recevice_code=params[:recevice_code]
            @evaluate.u=session[:user_code]
            @evaluate.u_t=Time.now()
            @evaluate.parent_val=params["evaluate_hid_name_#{mark.data_val}"].slice(0,4)
            @evaluate.data_val=params["evaluate_hid_name_#{mark.data_val}"]
            if params["score_name_#{mark.data_val}_#{arb.arbitman}"]!=""
              @evaluate.score=params["score_name_#{mark.data_val}_#{arb.arbitman}"]
            else
              @evaluate.score=0
            end
           
            @evaluate.remark=params["remark_name_#{mark.data_val}_#{arb.arbitman}"]
            @evaluate.arbitman_type=arb.arbitmantype
            @evaluate.arbitman=arb.arbitman
            @evaluate.save
          end
        end
      end
      TbEvaluate.set_tb_25(params[:recevice_code])
      flash[:notice]="批量创建成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    rescue
      flash[:notice]="批量创建失败"
      redirect_to :action=>"new_all_2",:recevice_code=>params[:recevice_code]
    end
  end
  
  def evaluate_edit
    @recevice_code=params[:recevice_code]
    @evaluate=TbEvaluate.find(params[:id])
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='8160' and state='Y' and used='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8160' and state='Y' and used='Y' and data_parent<>''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
  end
  
  def edit_all_2
    @tb_mark=TbDictionary.find_by_sql(["select * from tb_dictionaries tb_dictionaries where typ_code='8160' and state='Y' and data_parent<>'' and data_val in (select distinct data_val from tb_evaluates where used='Y' and recevice_code=?) order by data_val",params[:recevice_code]])
    @aribitprog_num=TbCase.find_by_recevice_code(params[:recevice_code]).aribitprog_num
    @arbit=TbDictionary.find(:all,:conditions=>["used='Y' and state='Y' and typ_code='0014'"],:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}#.insert(0,["",""])
    @ty2=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code ,tb_arbitmen.name as name from tb_casearbitmen ,tb_arbitmen where tb_casearbitmen.recevice_code=? and tb_casearbitmen.arbitmantype<>'0001' and tb_casearbitmen.used='Y' and tb_casearbitmen.arbitman=tb_arbitmen.code order by tb_arbitmen.name",params[:recevice_code]] ).collect{|p|[p.name,p.code]}#.insert(0,["",""])
    @casearbitman=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code,tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmantype_name from tb_casearbitmen,tb_arbitmen,tb_dictionaries where tb_casearbitmen.used='Y' and tb_dictionaries.typ_code='0014' and tb_casearbitmen.recevice_code=?  and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.arbitmantype=tb_dictionaries.data_val order by tb_casearbitmen.arbitmantype",params[:recevice_code]])
    @evaluate=TbEvaluate.new()
  end
  
  def evaluate_update
    @evaluate=TbEvaluate.find(params[:id])
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.update_attributes(params[:evaluate])
      TbEvaluate.set_tb_25(@evaluate.recevice_code)
      flash[:notice]="修改成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"evaluate_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end
  
  def update_all_2
    @tb_mark=TbDictionary.find(:all,:conditions=>["typ_code='8160'  and state='Y' and data_parent<>''"],:order=>"data_val")
    @casearbitman=TbCasearbitman.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    begin
      for mark in @tb_mark
        for arb in @casearbitman
          if params["score_name_#{mark.data_val}_#{arb.arbitman}"]!=nil
            @evaluate=TbEvaluate.find(:first,:conditions=>["used='Y' and recevice_code=? and arbitman=? and data_val=?",params[:recevice_code],arb.arbitman,mark.data_val])
            if @evaluate==nil
              @evaluate=TbEvaluate.new()
              @evaluate.used='Y'
              @evaluate.recevice_code=params[:recevice_code]
              @evaluate.u=session[:user_code]
              @evaluate.u_t=Time.now()
              @evaluate.parent_val=params["evaluate_hid_name_#{mark.data_val}"].slice(0,4)
              @evaluate.data_val=params["evaluate_hid_name_#{mark.data_val}"]
              if params["score_name_#{mark.data_val}_#{arb.arbitman}"]!=""
                @evaluate.score=params["score_name_#{mark.data_val}_#{arb.arbitman}"]
              else
                @evaluate.score=0
              end

              @evaluate.remark=params["remark_name_#{mark.data_val}_#{arb.arbitman}"]
              @evaluate.arbitman_type=arb.arbitmantype
              @evaluate.arbitman=arb.arbitman
              @evaluate.save
            else
              if params["score_name_#{mark.data_val}_#{arb.arbitman}"]!=""
                @evaluate.score=params["score_name_#{mark.data_val}_#{arb.arbitman}"]
              else
                @evaluate.score=0
              end
              @evaluate.remark=params["remark_name_#{mark.data_val}_#{arb.arbitman}"]
              @evaluate.save
            end
          end
        end
      end
      TbEvaluate.set_tb_25(params[:recevice_code])
      flash[:notice]="批量修改成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    rescue
      flash[:notice]="批量修改失败"
      redirect_to :action=>"update_all_2",:recevice_code=>params[:recevice_code]
    end
  end
  
  def evaluate_delete
    @evaluate=TbEvaluate.find(params[:id])
    @evaluate.used="N"
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.save
      TbEvaluate.set_tb_25(@evaluate.recevice_code)
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
  end
  #生成word文档
  def marke_2
    #    @tbmark=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y' and data_parent=''"])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=@case.case_code
    @user=User.find(:first,:conditions=>["used='Y' and code=?",session[:user_code]]).name
    arr_date = Date.today.to_s.split("-")
    arr_date[1]=arr_date[1].to_i.to_s
    arr_date[2]=arr_date[2].to_i.to_s
    @send_time=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    @casearbitman=TbCasearbitman.find_by_sql(["select tb_arbitmen.code as code,tb_arbitmen.name as name ,tb_dictionaries.data_text as arbitmantype_name from tb_casearbitmen,tb_arbitmen,tb_dictionaries where tb_casearbitmen.used='Y' and tb_dictionaries.typ_code='0014' and tb_casearbitmen.recevice_code=?  and tb_casearbitmen.arbitman=tb_arbitmen.code and tb_casearbitmen.arbitmantype=tb_dictionaries.data_val order by tb_casearbitmen.arbitmantype",params[:recevice_code]])
    @tbmark1=TbDictionary.find(:all,:conditions=>["typ_code='8160' and used='Y' and state='Y'"])
  end
end
