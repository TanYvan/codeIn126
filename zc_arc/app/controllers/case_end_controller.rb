class CaseEndController < ApplicationController
  #检查条件：无立案号、无办案助理、无受理日期不能终审、有欠费不能终审，简易程序无仲裁员不能终审、
  #普通程序没有三个仲裁员不能终审，无结案号、结案方式、结案日期、无裁决书不能终审，
  def list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case = TbCase.find_by_recevice_code(session[:recevice_code])
      if @case.accepttime==nil
        r0 = "无受理日期；"
      else
        r0 = ""
      end
      if @case.aribitprog_num=='0002' or @case.aribitprog_num=='0004' or @case.aribitprog_num=='0006' or @case.aribitprog_num=='0008'
        if SysArg.new.independent_arbitrator(session[:recevice_code])==""
          r3 = "无仲裁员；"
        else
          r3=""
        end
      else
        @ar1 = PubTool.arbitrator(session[:recevice_code],'0002')
        @ar2 = PubTool.arbitrator(session[:recevice_code],'0003')
        @ar3 = PubTool.arbitrator(session[:recevice_code],'0004')
        if @ar1=="" or @ar2=="" or @ar3==""
          r3 = "仲裁员不够三个；"
        else
          r3=""
        end
      end
      if TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])==nil
        r1 = "没有结案信息；"
      else
        @sty = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]]).endStyle
        @book_name1 = CaseBook.find(:all,:conditions=>["used='Y' and recevice_code=? and book_name!='' and book_typ=?",session[:recevice_code],@sty])
        @book_name = PubTool.new.get_first_record(@book_name1)
        if @book_name!=nil
          r1 = ""
        else
          r1 = "没有裁决书；"
        end
      end
      @ccc=TbShouldCharge.count(:conditions=>"used='Y' and recevice_code='#{session[:recevice_code]}'")
      @sss=TbShouldCharge.count(:conditions=>"used='Y' and typ<>'0002' and typ<>'0003' and typ<>'0005' and typ<>'0006'and recevice_code='#{session[:recevice_code]}' and (rmb_money - redu_rmb_money - re_rmb_money)<>0")
      if ((@ccc==nil or @ccc==0) or (@sss!=nil and @sss!=0))
        if (@ccc==nil or @ccc==0)
          r2 = "没有交费记录；"
        elsif @sss!=nil and @sss!=0
          r2 = "有欠缴费用未交；"
        end
      else
        r2 = ""
      end
      #仲裁员实际开支费用 :当事人预缴仲裁员开支费用 - 退给当事人的预缴费用 - (助理录入)仲裁员实际开支、抹零数据
#      @shoud1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",session[:recevice_code]])
#      @should2= TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and recevice_code=? and typ='0008'",params[:recevice_code]])
#      #@arbitspend=TbArbitmanSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]]) 出纳录入的仲裁员开支费用
#      #      @sroom = TbArbitcourtSpend.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])  助理录入的仲裁庭支出费用
#      @disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and recevice_code=?",session[:recevice_code]])
#      fe1 = @shoud1.to_i - @should2.to_i - @disposal.to_i
#      r4 = ""
#      if @shoud1.to_i==0
#        r4 = "未交实际开支费用；"
#      else
#        if fe1!=0
#          r4="实际开支未用未交齐；"
#        end
#      end
      @r_mes = r0 + r3 + r1 + r2 #+ r4
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
    end
  end
  
  def final_do
    if TbCaseFlow.check(session[:recevice_code],'0007')
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      f=TbCaseFlow.add_flow(session[:recevice_code],'0007')
      if f!=0
        @case.state=f
      end
      recevice_code=session[:recevice_code]
      @case.end_date=params[:dat]
      @case.end_u=session[:user_code]
      @case.end_t=Time.now
       
      if @case.save
        session[:recevice_code]=nil
        session[:case_code]=nil
        session[:general_code]=nil
        a_p="final_tex"
      else
        flash[:notice]="终审操作失败！"
        a_p="list"
      end
      redirect_to :action=>a_p,:r_code=>recevice_code
    else
      render :text=>"该操作违反了流程约束，请严格按办案流程填写案件信息！"
    end
  end
  
  def final_tex
    
  end
  
end
