#begin
#2010-1-27  处理结果  费用开支部分 助理录入
#end
class DisposalController < ApplicationController
  def list
    @pe={1=>"申请人",2=>"被申请人"}
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      @disposal=TbDisposal.find(:all,:conditions=>c,:order=>'id') 
    end
  end
  def rate_set
    render :update do |page|
      page.remove 'disposal_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end
  def disposal_new
    @disposal=TbDisposal.new()
  end
  def disposal_create
    @disposal=TbDisposal.new(params[:disposal])
    @disposal.recevice_code=params[:recevice_code]
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    @disposal.case_code=@case.case_code
    @disposal.general_code=@case.general_code
    @disposal.u=session[:user_code]
    @disposal.u_t=Time.now()
    if @disposal.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="创建失败"
      render :action=>"disposal_new"
    end
  end
  def disposal_edit
    @disposal=TbDisposal.find(params[:id])
  end
  def disposal_update
    @disposal=TbDisposal.find(params[:id])
    @disposal.u=session[:user_code]
    @disposal.u_t=Time.now()
    if @disposal.update_attributes(params[:disposal])
      flash[:notice]="修改成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="修改失败"
      render :action=>"edit"
    end
  end
  def disposal_delete
    @disposal=TbDisposal.find(params[:id])
    @disposal.used="N"
    @disposal.u=session[:user_code]
    @disposal.u_t=Time.now()
    if @disposal.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list"
  end
  #查看仲裁员开支费用明细信息
  def p_s
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @clerk=@case.clerk
    @case_code=@case.case_code
    @end_code=@case.end_code
    @aribitprog_num = @case.aribitprog_num
    @zl=User.find(:first,:conditions=>["used='Y' and code=?",@clerk]).name
    @money=Money.find(:all,:conditions=>["used='Y'"],:order=>"code")
    #申请人预缴实际开支
    @should=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f2 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    #被申请人预缴实际开支
    @should_r=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2_r=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f11 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f12 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
   
    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
      @a = PubTool.arbitrator(params[:recevice_code],'0002')
      @b = PubTool.arbitrator(params[:recevice_code],'0003')
      @c = PubTool.arbitrator(params[:recevice_code],'0004')
    else#if @aribitprog_num=='0002' or @aribitprog_num=='0004'
      @a = PubTool.arbitrator(params[:recevice_code],'0001')
    end
    @typ=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0036' and data_val<>'0001'"])
    @typ1=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0037'"])
    @sitting=TbSitting.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8142' and state='Y'",:order=>"typ_code")
    @typ21=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=1 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @typ22=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=2 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @r1 = ""
    @r2 = ""
    @typ21.each do |r1|
      if r1!=nil
        @r1 =@r1 + r1.remark + " "
      end
    end
    @typ22.each do |r1|
      if r1!=nil
        @r2 =@r2 + r1.remark + " "
      end
    end
    #当事人实际开支费用总计(￥)
    @app_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @res_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=2 and recevice_code=?",params[:recevice_code]])
    #当事人抹零费用总计(￥)
    @a_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @r_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=2 and recevice_code=?",params[:recevice_code]])

  end
  def p_s_2
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @clerk=@case.clerk
    @case_code=@case.case_code
    @end_code=@case.end_code
    @aribitprog_num = @case.aribitprog_num
    @zl=User.find(:first,:conditions=>["used='Y' and code=?",@clerk]).name
    @money=Money.find(:all,:conditions=>["used='Y'"],:order=>"code")
    #申请人预缴实际开支
    @should=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f1 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f2 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0001' and recevice_code=? and typ='0008'",params[:recevice_code]])
    #被申请人预缴实际开支
    @should_r=TbShouldCharge.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @should2_r=TbShouldRefund.find(:all,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f11 = TbShouldCharge.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])
    @f12 = TbShouldRefund.sum(:re_rmb_money,:conditions=>["used='Y' and payment='0002' and recevice_code=? and typ='0008'",params[:recevice_code]])

    if @aribitprog_num=='0001' or @aribitprog_num=='0003' or @aribitprog_num=='0005' or @aribitprog_num=='0007'
      @a = PubTool.arbitrator(params[:recevice_code],'0002')
      @b = PubTool.arbitrator(params[:recevice_code],'0003')
      @c = PubTool.arbitrator(params[:recevice_code],'0004')
    else#if @aribitprog_num=='0002' or @aribitprog_num=='0004'
      @a = PubTool.arbitrator(params[:recevice_code],'0001')
    end
    @typ=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0036' and data_val<>'0001'"])
    @typ1=TbDictionary.find(:all,:conditions=>["state='Y' and typ_code='0037'"])
    @sitting=TbSitting.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='8142' and state='Y'",:order=>"typ_code")
    @typ21=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=1 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @typ22=TbDisposal.find(:all,:conditions=>["used='Y' and partytype=2 and recevice_code=?",params[:recevice_code]],:order=>"typ")
    @r1 = ""
    @r2 = ""
    @typ21.each do |r1|
      if r1!=nil
        @r1 =@r1 + r1.remark + " "
      end
    end
    @typ22.each do |r1|
      if r1!=nil
        @r2 =@r2 + r1.remark + " "
      end
    end
    #当事人实际开支费用总计(￥)
    @app_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @res_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0001' and partytype=2 and recevice_code=?",params[:recevice_code]])
    #当事人抹零费用总计(￥)
    @a_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=1 and recevice_code=?",params[:recevice_code]])
    @r_disposal = TbDisposal.sum(:rmb_money,:conditions=>["used='Y' and typ='0100' and partytype=2 and recevice_code=?",params[:recevice_code]])
   
  end
end
