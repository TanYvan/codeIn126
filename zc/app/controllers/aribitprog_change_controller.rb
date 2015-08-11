class AribitprogChangeController < ApplicationController
  def p_set_2
    typ2=TbDictionary.find_by_sql(["select data_val,data_text from tb_dictionaries where used='Y' and state='Y' and typ_code = '0001' and data_val in (select app_code from charge_fun_detail where role_code=?  and used='Y')  order by ind,data_val", params[:p_typ]])
    render :update do |page|
      page.remove 'aribitprog_change_aribitprog_after'
      page.replace_html 'pv_set_2', :partial => 'pv_2',:object=>typ2
    end
  end
  
  def case_list
    @case=nil#当前办理案件
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    #立案阶段的案件 在办案件
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @n1 = TbCase.count(:id,:conditions=>c)
    #已结未终审案件
    @order3=params[:order]
    if @order3==nil or @order3==""
      @order3="recevice_code desc"
    end
    @page_lines3=params[:page_lines]
    if @page_lines3==nil or @page_lines3==""
      @page_lines3= session[:lines]
    end
    c3=" used='Y' and  clerk='#{session[:user_code]}' and state>=4 and  state<150  and  state<>100  and caseendbook_id_first is not null and file_submit_u=''"
    @case_pages3,@case3=paginate(:tb_cases,:conditions=>c3,:order=>@order3,:per_page=>@page_lines3.to_i)
    @n3 = TbCase.count(:id,:conditions=>c3)
    #咨询阶段的案件
    @order2=params[:order]
    if @order2==nil or @order2==""
      @order2="recevice_code desc"
    end
    @page_lines2=params[:page_lines]
    if @page_lines2==nil or @page_lines2==""
      @page_lines2= session[:lines]
    end
    c2="used='Y' and state=1 and (clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') "
    @case_pages2,@case2=paginate(:tb_cases,:conditions=>c2,:order=>@order2,:per_page=>@page_lines2.to_i)
    @n2 = TbCase.count(:id,:conditions=>c2)
#    @hant_search_1_page_name="case_list"
#    @hant_search_1=[['char','tb_cases_case_code','案号','text',[]],['char','tb_parties_partyname','当事人名称','text',[]],['char','tb_parties_partytype','当事人类型','select',[[1,'申请人'],[2,'被申请人']]],['char','tb_cases_recevice_code','咨询流水号','text',[]]]
#    @order=params[:order]
#    if @order==nil or @order==""
#      @order="tb_cases_recevice_code desc"
#    end
#    @page_lines=params[:page_lines]
#    if @page_lines==nil or @page_lines==""
#      @page_lines=session[:lines]
#    end
#    hant_search_1_word=params[:hant_search_1_word]
#    @search_condit=params[:search_condit]
#    if @search_condit==nil
#      @search_condit=""
#    end
#    if hant_search_1_word == nil or hant_search_1_word ==""
#    else
#      @search_condit= " and " + hant_search_1_word
#    end
#    c="((tb_cases_clerk='#{session[:user_code]}' and tb_cases_state>=4 and tb_cases_state<=100) or ((tb_cases_clerk='#{session[:user_code]}' or tb_cases_clerk_2='#{session[:user_code]}') and tb_cases_state>=1 and tb_cases_state<3)) "
#    p=PubTool.new()
#    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#      c = c + @search_condit
#    end
#    #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
#    #@case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
#    @case_pages,@case=paginate_by_sql(VCaseQuery1List1,"select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, tb_cases_end_code,tb_cases_clerk,tb_cases_clerk_2,tb_cases_receivedate,tb_cases_nowdate from v_case_query1_list1s where #{c}  order by #{@order}",@page_lines.to_i)
  end
  
  def list
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    c="recevice_code='#{params[:recevice_code]}' and used='Y'"
    @aribitprog_change=TbAribitprogChange.find(:all,:order=>'u_t desc',:conditions=>c)
  end
  
  def new
    @aribitprog_change = TbAribitprogChange.new()
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @aribitprog_change.app_role_before = @case.app_rules
    @aribitprog_change.aribitprog_before = @case.aribitprog_num
    
    ### 有 案件收费（争议金额）记录的已收款数额为0 的记录的时候不能创建仲裁变更记录，否则会形成在还未收款的情况下同时有两个案件收费记录，这样是不合理的。
    #申请人
    @should_2 = TbShouldCharge.find(:all,:conditions=>["payment='0001' and recevice_code=? and used='Y' and typ='0001' and aribitprog_change_id=0 and rmb_money<>0 and re_rmb_money=0",params[:recevice_code]])
    @ccc=0
    if  @should_2.empty?
    else
      @ccc=1
    end
    #被申请人
    @should_22=TbShouldCharge.find(:all,:conditions=>["payment='0002' and recevice_code=? and used='Y' and typ='0001' and aribitprog_change_id=0 and rmb_money<>0 and re_rmb_money=0",params[:recevice_code]])
    @ddd=0
    if  @should_22.empty?
    else
      @ddd=1
    end
    @alert_mes=""
    if @ccc==1
      @alert_mes=@alert_mes + "请删除申请人的争议金额后，进行仲裁程序变更，然后再重新录入争议金额。"
    end
    if @ddd==1
      @alert_mes=@alert_mes + "请删除被申请人的争议金额后，进行仲裁程序变更，然后再重新录入争议金额 。" 
    end
  
  end
  
  def create
    @case = TbCase.find_by_recevice_code(params[:recevice_code])
    @aribitprog_change = TbAribitprogChange.new(params[:aribitprog_change])
    @aribitprog_change.recevice_code = params[:recevice_code]
    @aribitprog_change.case_code = @case.case_code
    @aribitprog_change.general_code = @case.general_code
    @aribitprog_change.app_role_before = @case.app_rules
    @aribitprog_change.aribitprog_before = @case.aribitprog_num
    @aribitprog_change.u = session[:user_code]
    @aribitprog_change.u_t = Time.now()
    #因为反请求争议金额有个人提出的情况,tb_parties为相关人员的ID,所以求出人员的id(公共的为0),逐个处理.
    @fee_1 = TbParty.find_by_sql(["select distinct party_id from tb_case_amounts where partytype='1' and used='Y' and recevice_code=?", params[:recevice_code]]).map{|p| {"party_id" => p.party_id, "old_registration_fee_1"=>Cost.new.get_fee1('1',1,params[:recevice_code],p.party_id), "old_arbitration_fee_1"=>Cost.new.get_fee1('1',2,params[:recevice_code], p.party_id) }}
    @fee_2 = TbParty.find_by_sql(["select distinct party_id from tb_case_amounts where partytype='2' and used='Y' and recevice_code=?", params[:recevice_code]]).map{|p| {"party_id" => p.party_id, "old_registration_fee_2"=>Cost.new.get_fee1('2',1,params[:recevice_code],p.party_id), "old_arbitration_fee_2"=>Cost.new.get_fee1('2',2,params[:recevice_code], p.party_id) }}
#    old_registration_fee_1 = Cost.new.get_fee('1',1,params[:recevice_code])
#    old_arbitration_fee_1  = Cost.new.get_fee('1',2,params[:recevice_code])
#    old_registration_fee_2 = Cost.new.get_fee('2',1,params[:recevice_code])
#    old_arbitration_fee_2  = Cost.new.get_fee('2',2,params[:recevice_code])

    if @aribitprog_change.save
      @case.app_rules = @aribitprog_change.app_role_after
      @case.aribitprog_num = @aribitprog_change.aribitprog_after
      @case.save

      @fee_1.each{|f|
        party_id = f["party_id"]
        old_registration_fee_1 = f["old_registration_fee_1"]
        old_arbitration_fee_1 = f["old_arbitration_fee_1"]
        should_add(session[:user_code], @aribitprog_change.recevice_code, '1', @aribitprog_change, old_registration_fee_1,old_arbitration_fee_1, party_id)
      }
      @fee_2.each{|f|
        party_id = f["party_id"]
        old_registration_fee_2 = f["old_registration_fee_2"]
        old_arbitration_fee_2 = f["old_arbitration_fee_2"]
        should_add(session[:user_code], @aribitprog_change.recevice_code, '2', @aribitprog_change, old_registration_fee_2,old_arbitration_fee_2, party_id)
      }

      flash[:notice]="创建成功"
      redirect_to :action=>"list",:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    else
      render :action=>"new" ,:recevice_code=>params[:recevice_code],:search_condit=>params[:search_condit],:order=>params[:order],:page_lines=>params[:page_lines]
    end
  end
   
  
  
  private

  def get_party(party_id)
    if party_id == 0 || party_id == "0"
      return ""
    else
      @party_p=TbParty.find(party_id.to_i)
      if @party_p
        return "当事人个人请求:#{@party_p.partyname} "
      else
        return ""
      end
    end
  end
  
  # 该函数在仲裁程序变更的时候进行应收或应退的增加
  # user_code  操作用户的编码
  # recevice_code 咨询流水号
  # partytype 当事人类型，'1'是申请人，'2'是被申请人
  # aribitprog_change 增加的仲裁程序变更信息的对象参数，根据该参数可以判断到当事人类型
  # old_registration_fee 增加前的立案费或受理费
  # old_arbitration_fee 增加前的处理费或仲裁费

  # 这个方法貌似没用，可能是之前遗留的代码，因为在程序变更的时候已经要求删除了当事人的争议金额。
  def should_add(user_code,recevice_code,partytype,aribitprog_change,old_registration_fee,old_arbitration_fee,party_id)
    
    @case = TbCase.find_by_recevice_code(recevice_code)
    @partytype = {"1"=>"申请人","2"=>"被申请人"}
    @case_amount_typ = {"0001"=>"争议金额","0002"=>"追加争议金额","0003"=>"减少争议金额"}
    @amount_typ = {"0001"=>"明确金额","0002"=>"不明确金额"}
    #添加相应的应收款信息####################################################
    new_registration_fee = Cost.new.get_fee1(partytype,1,recevice_code,party_id)
    new_arbitration_fee  = Cost.new.get_fee1(partytype,2,recevice_code,party_id)

    if ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))>0  #增加应收费记录 案件费用
      @should=TbShouldCharge.new()
      @should.used='Y'
      @should.recevice_code=recevice_code
      @should.case_code=@case.case_code
      @should.general_code=@case.general_code
      @should.aribitprog_change_id=aribitprog_change.id
      @should.typ="0001"
      if partytype=='1'
        @should.payment='0001'
      else
        @should.payment='0002'
      end
      @should.rmb_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.currency='0001'
      @should.f_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.re_rmb_money=0
      @should.rate=1
      @should.remark = get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
      @should.u=user_code
      @should.u_t=Time.now()
      @should.save
      parent_id=@should.id

      if new_registration_fee - old_registration_fee !=0 #增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.aribitprog_change_id=aribitprog_change.id
        @should.typ="0002"
        if partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_registration_fee - old_registration_fee
        @should.currency='0001'
        @should.f_money= new_registration_fee - old_registration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.aribitprog_change_id=aribitprog_change.id
        @should.typ="0003"
        if partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_arbitration_fee - old_arbitration_fee
        @should.currency='0001'
        @should.f_money= new_arbitration_fee - old_arbitration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

    elsif  ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))==0 and (new_registration_fee - old_registration_fee )!=0  #增加应收费记录 案件费用
      @should=TbShouldCharge.new()
      @should.used='Y'
      @should.recevice_code=recevice_code
      @should.case_code=@case.case_code
      @should.general_code=@case.general_code
      @should.aribitprog_change_id=aribitprog_change.id
      @should.typ="0001"
      if partytype=='1'
        @should.payment='0001'
      else
        @should.payment='0002'
      end
      @should.rmb_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.currency='0001'
      @should.f_money= (new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee )
      @should.re_rmb_money=0
      @should.rate=1
      @should.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
      @should.u=user_code
      @should.u_t=Time.now()
      @should.save
      parent_id=@should.id

      if new_registration_fee - old_registration_fee !=0 #增加应收 立案费或受理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.aribitprog_change_id=aribitprog_change.id
        @should.typ="0002"
        if partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_registration_fee - old_registration_fee
        @should.currency='0001'
        @should.f_money= new_registration_fee - old_registration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应收 仲裁费或处理费
        @should=TbShouldCharge.new()
        @should.used='Y'
        @should.recevice_code=recevice_code
        @should.case_code=@case.case_code
        @should.general_code=@case.general_code
        @should.aribitprog_change_id=aribitprog_change.id
        @should.typ="0003"
        if partytype=='1'
          @should.payment='0001'
        else
          @should.payment='0002'
        end
        @should.rmb_money= new_arbitration_fee - old_arbitration_fee
        @should.currency='0001'
        @should.f_money= new_arbitration_fee - old_arbitration_fee
        @should.re_rmb_money=0
        @should.rate=1
        @should.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should.parent_id=parent_id
        @should.u=user_code
        @should.u_t=Time.now()
        @should.save
      end
      
    elsif  ((new_registration_fee - old_registration_fee ) + (new_arbitration_fee - old_arbitration_fee ))<0  #增加应退费记录 案件费用
      @should_r=TbShouldRefund.new()
      @should_r.used='Y'
      @should_r.recevice_code=recevice_code
      @should_r.case_code=@case.case_code
      @should_r.general_code=@case.general_code
      @should_r.aribitprog_change_id=aribitprog_change.id
      @should_r.typ="0001"
      if partytype=='1'
        @should_r.payment='0001'
      else
        @should_r.payment='0002'
      end
      @should_r.rmb_money= -1 * ((new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee ))
      @should_r.currency='0001'
      @should_r.f_money= -1 * ((new_registration_fee - old_registration_fee) + (new_arbitration_fee - old_arbitration_fee ))
      @should_r.rate=1
      @should_r.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
      @should_r.state=1
      @should_r.u=user_code
      @should_r.u_t=Time.now()
      @should_r.refund_date=aribitprog_change.u_t.to_date
      @should_r.refund_case="仲裁程序变更"
      @should_r.save
      parent_id=@should_r.id

      if new_registration_fee - old_registration_fee !=0 #增加应退费记录 立案费或受理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.aribitprog_change_id=aribitprog_change.id
        @should_r.typ="0002"
        if partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * (new_registration_fee - old_registration_fee)
        @should_r.currency='0001'
        @should_r.f_money= -1 * (new_registration_fee - old_registration_fee)
        @should_r.rate=1
        @should_r.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.refund_date=aribitprog_change.u_t.to_date
        @should_r.refund_case="仲裁程序变更"
        @should_r.save
      end

      if new_arbitration_fee - old_arbitration_fee!=0      #增加应退费记录 仲裁费或处理费
        @should_r=TbShouldRefund.new()
        @should_r.used='Y'
        @should_r.recevice_code=recevice_code
        @should_r.case_code=@case.case_code
        @should_r.general_code=@case.general_code
        @should_r.aribitprog_change_id=aribitprog_change.id
        @should_r.typ="0003"
        if partytype=='1'
          @should_r.payment='0001'
        else
          @should_r.payment='0002'
        end
        @should_r.rmb_money= -1 * (new_arbitration_fee - old_arbitration_fee)
        @should_r.currency='0001'
        @should_r.f_money= -1 * (new_arbitration_fee - old_arbitration_fee)
        @should_r.rate=1
        @should_r.remark=get_party(party_id) + "对应仲裁程序变更 变更人：#{User.find_by_code(aribitprog_change.u).name} 变更时间：#{aribitprog_change.u_t.to_s(:db)} 变更前：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_before}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_before}'").data_text}   变更后：#{TbDictionary.find(:first,:conditions=>"typ_code='8143' and data_val='#{aribitprog_change.app_role_after}'").data_text} #{TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{aribitprog_change.aribitprog_after}'").data_text}"
        @should_r.parent_id=parent_id
        @should_r.state=1
        @should_r.u=user_code
        @should_r.u_t=Time.now()
        @should_r.refund_date=aribitprog_change.u_t.to_date
        @should_r.refund_case="仲裁程序变更"
        @should_r.save
      end
       
    end

  end
  
end
