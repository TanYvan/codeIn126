=begin
创建人：聂灵灵
创建时间：2009-6-2,3
描述：实体类是TbEvaluate,table是tb_evaluates
此类主要实现仲裁员评价的创建(evaluate下的evaluate_new页面)，
修改(evaluate下的evaluate_edit页面)，
列表显示(evaluate下的evaluate_list页面)功能,
=end
class EvaluateController < ApplicationController
  #2009-10-12  聂灵灵   校核人员（user_duties 中 code为0007）对办案人员进行仲裁员评价
  def list
    @code1=UserDuty.find(:all,:conditions=>"user_code='#{session[:user_code]}'")
    @code1.each do|c|
      @c=c.duty_code
      if @c=='0007'
        @code=@c
      end
    end
    if @code=='0007'
      @order=params[:order]
      if @order==nil or @order==""
        @order="recevice_code desc"
      end
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines= 20
      end
      c="used='Y' and state>=4"
      @case_pages,@case=paginate(:tb_cases,:order=>'id',:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    else
      render :text=>"对不起，您没有该权限！"
    end
  end
  #选择不同评价内容时显示相应的评价结果选项
  def p_set
    typ2=TbDictionary.find(:all,:conditions=>"typ_code='8136' and state='Y' and data_parent='#{params[:p_typ]}'",:order=>'data_val',:select=>"data_val,data_text")
    render :update do |page|
      page.remove 'evaluate_evaluate_result'
      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
    end
  end
  def evaluate_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @evaluate_pages,@evaluate=paginate(:tb_evaluates,:order=>'id',:conditions=>c)
  end

  def evaluate_new
    @recevice_code=params[:recevice_code]
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='8136' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    oopp=TbDictionary.find(:first,:conditions=>"typ_code='8136' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val")
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8136' and state='Y' and data_parent='#{oopp.data_val}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @evaluate=TbEvaluate.new()
  end
  def evaluate_create
    @case=TbCase.find_by_recevice_code(params[:recevice_code] )
    @evaluate=TbEvaluate.new(params[:evaluate])
    @evaluate.recevice_code=params[:recevice_code]
    @evaluate.case_code=@case.case_code
    @evaluate.general_code=@case.general_code
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.save
      flash[:notice]="创建成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render_to :action=>"evaluate_new",:recevice_code=>params[:recevice_code]
    end
  end

  def evaluate_edit
    @recevice_code=params[:recevice_code]
    @evaluate=TbEvaluate.find(params[:id])
    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='8136' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8136' and state='Y' and data_parent='#{@evaluate.evaluate_content}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
  end

  def evaluate_update
    @evaluate=TbEvaluate.find(params[:id])
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.update_attributes(params[:evaluate])
      flash[:notice]="修改成功"
      redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="修改失败"
      render :action=>"evaluate_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end

  def evaluate_delete
    @evaluate=TbEvaluate.find(params[:id])
    @evaluate.used="N"
    @evaluate.u=session[:user_code]
    @evaluate.u_t=Time.now()
    if @evaluate.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"evaluate_list",:recevice_code=>params[:recevice_code]
  end
end
