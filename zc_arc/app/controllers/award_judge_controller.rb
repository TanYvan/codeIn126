#校核评价
class AwardJudgeController < ApplicationController
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="c.recevice_code desc"
    end
    @page_lines=params[:page_lines]
    sql="select c.recevice_code as recevice_code,c.receivedate as receivedate,c.case_code as case_code,c.nowdate as nowdate,c.aribitprog_num as aribitprog_num from tb_cases as c,tb_check_staffs as s where c.used='Y' and c.state>=4 and c.state<100 and c.caseendbook_id_first is not null and c.recevice_code=s.recevice_code and s.used='Y' and s.typ='0001' and s.staff='#{session[:user_code]}' order by #{@order}"
    @case_pages,@case=paginate_by_sql(TbCase,sql,90000)
  end
  def judge_list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @judge_pages,@judge=paginate(:tb_award_judges,:order=>'id',:conditions=>c)
  end

  def judge_new
    @judge=TbAwardJudge.new()
  end
  def judge_create
    @a_case=TbCasearbitman.find(:all,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]],:order=>"arbitmantype")

    @judge=TbAwardJudge.new(params[:judge])
    @judge.recevice_code=params[:recevice_code]
    @judge.u=session[:user_code]
    @judge.u_t=Time.now()
    i=1
    @a_case.each do |a|
      if i==1
        @judge.arbitman1 = a.arbitman
      elsif i==2
        @judge.arbitman2 = a.arbitman
      else
        @judge.arbitman3 = a.arbitman
      end
      i=i+1
    end
    if @judge.save
      flash[:notice]="创建成功"
      redirect_to :action=>"judge_list",:recevice_code=>params[:recevice_code]
    else
      flash[:notice]="创建失败"
      render_to :action=>"judge_new",:recevice_code=>params[:recevice_code]
    end
  end
  def judge_edit
    @judge=TbAwardJudge.find(params[:id])
  end

  def judge_update
    @judge=TbAwardJudge.find(params[:id])
    @a_case=TbCasearbitman.find(:all,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]],:order=>"arbitmantype")
    @judge.recevice_code=params[:recevice_code]
    @judge.u=session[:user_code]
    @judge.u_t=Time.now()
    i=1
    @a_case.each do |a|
      if i==1
        @judge.arbitman1 = a.arbitman
      elsif i==2
        @judge.arbitman2 = a.arbitman
      else
        @judge.arbitman3 = a.arbitman
      end
      i=i+1
    end
    if @judge.update_attributes(params[:judge])
      flash[:notice]="修改成功"
      redirect_to :action=>"judge_list",:recevice_code=>params[:recevice_code],:id=>params[:id]
    else
      flash[:notice]="修改失败"
      render :action=>"judge_edit",:id=>params[:id],:recevice_code=>params[:recevice_code]
    end
  end

  def judge_delete
    @judge=TbAwardJudge.find(params[:id])
    @judge.used="N"
    @judge.u=session[:user_code]
    @judge.u_t=Time.now()
    if @judge.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"judge_list",:recevice_code=>params[:recevice_code]
  end
end
