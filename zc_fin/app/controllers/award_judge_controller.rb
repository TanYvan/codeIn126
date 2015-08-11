#校核评价
class AwardJudgeController < ApplicationController

  # 裁决书校核评价案件选择列表，按照未进行评价和已进行评价分类显示
  def list
    @order=params[:order]
    if @order==nil or @order==""
      @order="right(c.case_code,7) desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    #未进行裁决书校核评价  and c.state<200
    sql = "
            SELECT
              c.recevice_code,c.receivedate,c.case_code,c.nowdate,c.aribitprog_num
            FROM
              tb_cases AS c, tb_check_staffs AS s
            WHERE
              c.used = 'Y' AND c.state >= 4 AND c.state < 220 AND 
              c.recevice_code NOT IN (SELECT recevice_code FROM tb_award_judges WHERE used = 'Y' AND u = '#{session[:user_code]}')
              AND c.recevice_code = s.recevice_code AND s.used = 'Y' AND s.typ = '0001' AND s.staff = '#{session[:user_code]}' order by #{@order}
          "
    @case_pages,@case=paginate_by_sql(TbCase,sql,99999) #要求不分页
    #已进行裁决书校核评价  and c.state<200
    sql = "
            SELECT
              c.recevice_code,c.receivedate,c.case_code,c.nowdate,c.aribitprog_num
            FROM
              tb_cases AS c,tb_check_staffs AS s
            WHERE
              c.used = 'Y' AND c.state >= 4 AND c.state < 220 AND
              c.recevice_code IN (SELECT recevice_code FROM tb_award_judges WHERE used = 'Y' AND u = '#{session[:user_code]}')
              AND c.recevice_code = s.recevice_code AND s.used = 'Y' AND s.typ = '0001' AND s.staff = '#{session[:user_code]}'
            ORDER BY
              #{@order}
         "
    @case2_pages,@case2=paginate_by_sql(TbCase,sql,@page_lines.to_i)
    @num_case = TbCase.find_by_sql("select c.recevice_code from tb_cases as c,tb_check_staffs as s where c.used='Y' and c.state>=4  and c.state<220 and c.recevice_code in (select recevice_code from tb_award_judges where used='Y' and u='#{session[:user_code]}') and c.recevice_code=s.recevice_code and s.used='Y' and s.typ='0001' and s.staff='#{session[:user_code]}' order by #{@order}").length
  end

  # 校核评价列表
  def judge_list
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    c = "recevice_code='#{params[:recevice_code]}' and used='Y' and u='#{session[:user_code]}'"
    @judge_pages, @judge = paginate(:tb_award_judges, :order => 'id', :conditions => c)
  end

  def judge_new

    @flag1 = false # 是否显示完整裁决书评价
    @flag2 = false # 是否显示仲裁庭意见评价
    @flag3 = false # 是否显示中间裁决、部分裁决评价
    award = TbAward.find(:first,:conditions => "recevice_code='#{params[:recevice_code]}' and used='Y'")
    awarddetail = nil
    unless award.blank?
      awarddetail = TbAwardDetail.find(:all,
        :order => 'typ,draftsman_typ,draftsman',
        :conditions => ["recevice_code=? and used='Y' and p_id=? and draftsman_typ='0001' and (typ='0002' or typ='0003' or typ='0005') ", params[:recevice_code], award.id]
      )
    end
    if awarddetail.blank? or awarddetail.size == 0
      flash[:notice] = "系统未查询到裁决书制作信息！"
    else
      awarddetail.each do |a|
        @flag1 = true if a.typ == "0003"
        @flag2 = true if a.typ == "0002"
        @flag3 = true if a.typ == "0005"
      end
    end

    @judge = TbAwardJudge.new()
    @case  = TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code = @case.case_code
    @c3 = User.find(:first,:conditions=>["used='Y' and code=?",@case.clerk]).name

    # 立案日期
    if @case.nowdate != nil
      arr_date = @case.nowdate.to_s.split("-")
      arr_date[1] = arr_date[1].to_i.to_s
      arr_date[2] = arr_date[2].to_i.to_s
      @sdate4 = arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @sdate4 = ""
    end

    # 组庭日期
    @caseorg_date = TbCaseorg.find(:all, :conditions => ["used = 'Y' and recevice_code = ?",params[:recevice_code]])
    @c5 = ""
    @caseorg_date.each do |t|
      arr_date = t.orgdate.to_s.split("-")
      arr_date[1] = arr_date[1].to_i.to_s
      arr_date[2] = arr_date[2].to_i.to_s
      @caseorg_date1 = arr_date[0]+"年"+arr_date[1]+"月"+arr_date[2]+"日"+"  "
      @c5= @c5 + @caseorg_date1
    end

    # 审限日期
    if @case.finally_limit_dat!=nil
      arr_date = @case.finally_limit_dat.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @c6=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @c6=""
    end

    #　审限是否延期
    @ampliation=TbCasedelay.find(:first,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    if @ampliation!=nil
      @c7="是"
    else
      @c7="否"
    end
    
    @c9=""
    @c22=""
    @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]],:order=>"id desc")
    if @award!=nil
      if @award.end_typ=='0001'
        @c9="完整裁决书"
        @c22="一般裁决"
      elsif @award.end_typ=='0002'
        @c9="完整裁决书"
        arbit=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",@award.arbiter])
        @c22="多数/首仲裁决        持少数意见的仲裁员：" + arbit.name
      elsif @award.end_typ=='0003'
        @c9="完整裁决书"
        @c22="和解裁决"
      else
        @c9="撤案决定书"
        @c22="撤案"
      end
      if @award.advice==1
        @c23="有意见       具体意见：" + @award.remark
      else
        @c23="无意见"
      end
    else
      @c9="撤案决定/完整裁决书"
      @c22=""
    end
    @c11=""
    @c12=""
    @c13=""
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0001'",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code1=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_1=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001' #仲裁员
        if @draftsman_code1!=nil
          @c11=@c11 + @draftsman_code1.name + " "
        end
      else #助理
        if @draftsman_code_1!=nil
          @c11=@c11 + @draftsman_code_1.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0002'",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code2=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_2=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code1!=nil
          @c12=@c12 + @draftsman_code2.name + " "
        end
      else
        if @draftsman_code_2!=nil
          @c12=@c12 + @draftsman_code_2.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and (d.typ='0003' or d.typ='0004')",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code3=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_3=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code3!=nil
          @c13=@c13 + @draftsman_code3.name + " "
        end
      else
        if @draftsman_code_3!=nil
          @c13=@c13 + @draftsman_code_3.name + " "
        end
      end
    end
    #费用部分
    #申请人  应收=应交- （应退 - 减退 ）
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f2=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    af = a_f1.to_i - (a_f2.to_i - a_f3.to_i)
    @c14=SysArg.compart2(af)
    @c17=SysArg.compart2(a_f4)
    #被申请人  应收 、 实收
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f22=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    af = a_f1.to_i - (a_f22.to_i - a_f3.to_i)
    @c15=SysArg.compart2(af)
    @c18=SysArg.compart2(a_f4)

    c16=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c16 = SysArg.compart2(c16)
    c19=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c19 = SysArg.compart2(c19)
    #应退费用
    @c20=SysArg.compart2(a_f2.to_i + a_f22.to_i)
    c21=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c21=SysArg.compart2(c21)
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

    @flag1 = false # 是否显示完整裁决书评价
    @flag2 = false # 是否显示仲裁庭意见评价
    @flag3 = false # 是否显示中间裁决、部分裁决评价
    award = TbAward.find(:first,:conditions => "recevice_code='#{params[:recevice_code]}' and used='Y'")
    awarddetail = nil
    unless award.blank?
      awarddetail = TbAwardDetail.find(:all,
        :order => 'typ,draftsman_typ,draftsman',
        :conditions => ["recevice_code=? and used='Y' and p_id=? and draftsman_typ='0001' and (typ='0002' or typ='0003' or typ='0005') ", params[:recevice_code], award.id]
      )
    end
    if awarddetail.blank? or awarddetail.size == 0
      flash[:notice] = "系统未查询到裁决书制作信息！"
    else
      awarddetail.each do |a|
        @flag1 = true if a.typ == "0003"
        @flag2 = true if a.typ == "0002"
        @flag3 = true if a.typ == "0005"
      end
    end

    @judge=TbAwardJudge.find(params[:id])
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @case_code=@case.case_code
    @c3=User.find(:first,:conditions=>["used='Y' and code=?",@case.clerk]).name
    if @case.nowdate!=nil
      arr_date = @case.nowdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @sdate4=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @sdate4=""
    end
    @caseorg_date = TbCaseorg.find(:all, :conditions => ["used = 'Y' and recevice_code = ?",params[:recevice_code]])
    @c5=""
    @caseorg_date.each do |t|
      arr_date = t.orgdate.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @caseorg_date1 = arr_date[0]+"年"+arr_date[1]+"月"+arr_date[2]+"日"+"  "
      @c5= @c5 + @caseorg_date1
    end
    if @case.finally_limit_dat!=nil
      arr_date = @case.finally_limit_dat.to_s.split("-")
      arr_date[1]=arr_date[1].to_i.to_s
      arr_date[2]=arr_date[2].to_i.to_s
      @c6=arr_date[0].to_i.to_s+"年"+arr_date[1]+"月"+arr_date[2]+"日"
    else
      @c6=""
    end
    @ampliation=TbCasedelay.find(:first,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    if @ampliation!=nil
      @c7="是"
    else
      @c7="否"
    end
    @c9=""
    @c22=""
    @award=TbAward.find(:first,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]],:order=>"id desc")
    if @award!=nil
      if @award.end_typ=='0001'
        @c9="完整裁决书"
        @c22="一般裁决"
      elsif @award.end_typ=='0002'
        @c9="完整裁决书"
        arbit=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",@award.arbiter])
        @c22="多数/首仲裁决        持少数意见的仲裁员：" + arbit.name
      elsif @award.end_typ=='0003'
        @c9="完整裁决书"
        @c22="和解裁决"
      else
        @c9="撤案决定书"
        @c22="撤案"
      end
      if @award.advice==1
        @c23="有意见       具体意见：" + @award.remark
      else
        @c23="无意见"
      end
    else
      @c9="撤案决定/完整裁决书"
      @c22=""
    end
    @c11=""
    @c12=""
    @c13=""
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0001'",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code1=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_1=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001' #仲裁员
        if @draftsman_code1!=nil
          @c11=@c11 + @draftsman_code1.name + " "
        end
      else #助理
        if @draftsman_code_1!=nil
          @c11=@c11 + @draftsman_code_1.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and d.typ='0002'",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code2=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_2=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code1!=nil
          @c12=@c12 + @draftsman_code2.name + " "
        end
      else
        if @draftsman_code_2!=nil
          @c12=@c12 + @draftsman_code_2.name + " "
        end
      end
    end
    @award2=TbAwardDetail.find(:all,:conditions=>["d.used='Y' and d.recevice_code=? and (d.typ='0003' or d.typ='0004')",params[:recevice_code]],:joins=>"as d inner join tb_awards as aa on aa.recevice_code=d.recevice_code and aa.used='Y' and d.p_id=aa.id",:select=>"d.draftsman as draftsman,d.draftsman_typ as draftsman_typ",:order=>"d.id desc")
    @award2.each do |a|
      @draftsman_code3=TbArbitman.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      @draftsman_code_3=User.find(:first,:conditions=>["used='Y' and code=?",a.draftsman])
      if a.draftsman_typ=='0001'
        if @draftsman_code3!=nil
          @c13=@c13 + @draftsman_code3.name + " "
        end
      else
        if @draftsman_code_3!=nil
          @c13=@c13 + @draftsman_code_3.name + " "
        end
      end
    end
    #费用部分
    #申请人  应收=应交- （应退 - 减退 ）
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f2=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0001' and (typ='0001' or typ='0004')",params[:recevice_code]])
    af = a_f1.to_i - (a_f2.to_i - a_f3.to_i)
    @c14=SysArg.compart2(af)
    @c17=SysArg.compart2(a_f4)
    #被申请人  应收 、 实收
    a_f1=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f22=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f3=TbShouldRefund.sum(:redu_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    a_f4=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and payment='0002' and (typ='0001' or typ='0004')",params[:recevice_code]])
    af = a_f1.to_i - (a_f22.to_i - a_f3.to_i)
    @c15=SysArg.compart2(af)
    @c18=SysArg.compart2(a_f4)

    c16=TbShouldCharge.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c16 = SysArg.compart2(c16)
    c19=TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c19 = SysArg.compart2(c19)
    #应退费用
    @c20=SysArg.compart2(a_f2.to_i + a_f22.to_i)
    c21=TbShouldRefund.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @c21=SysArg.compart2(c21)
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
