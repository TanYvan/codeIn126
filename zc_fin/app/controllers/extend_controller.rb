class ExtendController < ApplicationController

  # 新案件报酬
  # 显示除了本单位工作人员（助理、仲裁员、校核人员、其他员工）之外的其余仲裁员的报酬情况
  def list
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "list"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]],['char','name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','general_code','recevice_code','name']
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p_typ ='0001' and p not in (select code from tb_arbitmen where isunit='Y') "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
  end

  def tax_count
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p_typ ='0001' and p not in (select code from tb_arbitmen where isunit='Y') "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
    tax=Tax.new
    @provide_p.each{|pp|
      if pp.typ == "1"
        @tax_a=TaxDetail.find(:first,:conditions=>["name='合计_理论值' and mark=?", pp.typ + "_" + pp.p_typ + "_" + pp.id_id.to_s])
        @tax_b=TaxDetail.find(:first,:conditions=>["name='合计' and mark=?", pp.typ + "_" + pp.p_typ + "_" + pp.id_id.to_s])
        if (@tax_a && @tax_b && @tax_a.rmb ==@tax_b.rmb) || !@tax_b
          ynssde = SysArg.round2f(tax.get_tax_base_1(pp.yf_rmb))
          TaxDetail.set_tax(pp.typ + "_" + pp.p_typ + "_" + pp.id_id.to_s, ynssde)
        end
      end
    }
    flash[:notice] = "全部扣税计算完成"
    redirect_to :action=>"list", :hant_search_1_word=>params[:hant_search_1_word] ,:hant_search_1_text =>params[:hant_search_1_text], :search_condit => params[:search_condit]
  end

  def edit_tax
    TaxDetail.set_tax(params[:mark],params[:ynssde])
    @tax_a=TaxDetail.find(:first,:conditions=>["name='合计_理论值' and mark=?", params[:mark]])
    @tax=TaxDetail.find(:all,:conditions=>["name<>'合计_理论值' and mark=?",params[:mark]], :order => "id")
  end

  def reset_tax
    TaxDetail.del_tax(params[:mark])
    flash[:notice] = "重置成功"
    redirect_to :action=>"list", :hant_search_1_word=>params[:hant_search_1_word] ,:hant_search_1_text =>params[:hant_search_1_text], :search_condit => params[:search_condit]
  end

  def update_tax
    for tax in TaxDetail.find(:all,:conditions=>["name<>'合计_理论值' and mark=?",params[:mark]])
     tax.rmb= params["rmb_"+tax.id.to_s].to_d
     tax.remark= params["remark_"+tax.id.to_s]
     tax.save
    end
    flash[:notice] = "修改成功"
    redirect_to :action=>"list", :hant_search_1_word=>params[:hant_search_1_word] ,:hant_search_1_text =>params[:hant_search_1_text], :search_condit => params[:search_condit]
  end

  # 新案件报酬页面导出当前查询的已发放报酬信息 Ajax 方式查询 导出 Excel 调用
  def list_remote
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "list"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1_list = ['case_code','end_code','general_code','recevice_code']
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p_typ ='0001' and p not in (select code from tb_arbitmen where isunit='Y') "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
  end

  # 本单位报酬
  # 只显示本单位工作人员（助理、仲裁员、校核人员、其他员工）的报酬，不用计算应纳税所得额、个税、营业税、营业税附加税
  def list_1
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "list_1"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]],['char','name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','general_code','recevice_code','name']
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p not in (select code from tb_arbitmen where isunit='N') and isextend<>'Y'"
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
  end

  # 本单位已发报酬
  def list_2
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "list_2"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]],['char','name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','general_code','recevice_code','name']
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p not in (select code from tb_arbitmen where isunit='N') and isextend='Y' "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
  end

  # 本单位已发报酬导出
  def list_2_a
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "list_2_a"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]],['char','name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','general_code','recevice_code','name']
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="extend_code='' and p not in (select code from tb_arbitmen where isunit='N') and isextend='Y' "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @provide_p = VProvide.find(:all,:conditions=>c,:order=>"right(case_code,7) desc,p_typ,p,typ")
  end
  
  # 转为待发放  非本单位人员
  # 将 案件报酬（非本单位仲裁员） 页面选择的报酬转为代发放状态
  def extend_do
    extend_code = SysArg.add_0005  #新生成一个发放编号
    t = Time.now
    tax = Tax.new
    condi = params[:condi]

    p = PubTool.new()
    if p.sql_check_3(condi) != false

      if condi != nil and condi != ""
        #存储发放编码相关信息
        extend_c = TbExtendCode.new()
        extend_c.extend_code = extend_code
        extend_c.u = session[:user_code]
        extend_c.t = t
        extend_c.save

        con = condi.split(",")
        con.each{|co|
          exte = co.split("_")
            typ = exte[0]    # typ 1：报酬 2：奖励 3：惩罚 4：办案其它报酬 5：出差补助
            p_typ = exte[1]  # p_typ 0001:仲裁员   0002:办案助理   0003:校核人员   0004:员工
            id_id = exte[2].to_i
            ttt=TaxDetail.find_by_mark_and_name(typ + "_" + p_typ + "_" + id_id.to_s ,"合计")
            if typ == '1'
              if p_typ == '0001' or p_typ == '0002'
                reward = TbBonusPenalty.find(id_id)
                if reward.used == 'Y' and reward.extend_code = ''
                  ex = TbExtend.new()
                  ex.recevice_code = reward.recevice_code
                  ex.case_code = reward.case_code
                  ex.general_code = reward.general_code
                  ex.end_code = TbCase.find_by_recevice_code(reward.recevice_code).end_code
                  ex.typ=typ
                  ex.p_typ=p_typ
                  ex.p=reward.p
                  if p_typ=='0001'
                    tb_arbitman = TbArbitman.find_by_code(reward.p)
                    ex.p_name=tb_arbitman.name
                    ex.bank_typ=tb_arbitman.bank_typ
                    ex.bank_account=tb_arbitman.bankaccount
                    ex.bank_code=tb_arbitman.bank_code
                    ex.bankname=tb_arbitman.bankname
                    ex.id_card=tb_arbitman.id_card
                    ex.email=tb_arbitman.email
                  else
                    user = User.find_by_code(reward.p)
                    ex.p_name=user.name
                    ex.bank_typ=user.bank_typ
                    ex.bank_account=user.bankaccount
                    ex.bank_code=user.bank_code
                    ex.bankname=user.bankname
                    ex.id_card=user.id_card
                    ex.email=user.email
                  end
                  ex.should_rmb=(reward.zc_rmb * (1 + reward.bonus/100 - reward.penalty/100) + reward.gc_rmb).round
                  ex.tax_base_rmb = tax.get_tax_base_1(ex.should_rmb.round)
                  ex.tax_rmb=ttt.rmb #tax.get_tax_1(ex.should_rmb.to_i,'N') # 全部是非本单位仲裁员
                  ex.extend_rmb=ex.should_rmb - ex.tax_rmb
                  ex.extend_code=extend_code
                  ex.extend_u=session[:user_code]
                  ex.extend_t=t
                  ex.save
                  reward.extend_id=ex.id
                  reward.extend_code=extend_code
                  reward.extend_u=session[:user_code]
                  reward.extend_t=t
                  reward.save
                end
              elsif p_typ=='0003'
                reward=TbBonusPenalty.find(id_id)
                if reward.used=='Y' and reward.extend_code=''
                  ex=TbExtend.new()
                  ex.recevice_code=reward.recevice_code
                  ex.case_code=reward.case_code
                  ex.general_code=reward.general_code
                  ex.end_code=TbCase.find_by_recevice_code(reward.recevice_code).end_code
                  ex.typ=typ
                  ex.p_typ=p_typ
                  ex.p=reward.p

                  if p_typ=='0001'
                    tb_arbitman = TbArbitman.find_by_code(reward.p)
                    ex.p_name=tb_arbitman.name
                    ex.bank_typ=tb_arbitman.bank_typ
                    ex.bank_account=tb_arbitman.bankaccount
                    ex.bank_code=tb_arbitman.bank_code
                    ex.bankname=tb_arbitman.bankname
                    ex.id_card=tb_arbitman.id_card
                    ex.email=tb_arbitman.email
                  else
                    user = User.find_by_code(reward.p)
                    ex.p_name=user.name
                    ex.bank_typ=user.bank_typ
                    ex.bank_account=user.bankaccount
                    ex.bank_code=user.bank_code
                    ex.bankname=user.bankname
                    ex.id_card=user.id_card
                    ex.email=user.email
                  end

                  ex.should_rmb=reward.jh_rmb.round
                  ex.tax_base_rmb=tax.get_tax_base(ex.should_rmb.round)
                  ex.tax_rmb=ttt.rmb #tax.get_tax(ex.should_rmb.round)
                  ex.extend_rmb=ex.should_rmb - ex.tax_rmb
                  ex.extend_code=extend_code
                  ex.extend_u=session[:user_code]
                  ex.extend_t=t
                  ex.save
                  reward.extend_id=ex.id
                  reward.extend_code=extend_code
                  reward.extend_u=session[:user_code]
                  reward.extend_t=t
                  reward.save
                end
              end
            elsif typ=='2'
              reward=TbDeduction.find(id_id)
              if reward.used=='Y' and reward.extend_code=''
                ex=TbExtend.new()
                ex.recevice_code=reward.recevice_code
                ex.case_code=reward.case_code
                ex.general_code=reward.general_code
                ex.end_code=TbCase.find_by_recevice_code(reward.recevice_code).end_code
                ex.typ=typ
                ex.p_typ=p_typ
                ex.p=reward.p

                if p_typ=='0001'
                  tb_arbitman = TbArbitman.find_by_code(reward.p)
                  ex.p_name=tb_arbitman.name
                  ex.bank_typ=tb_arbitman.bank_typ
                  ex.bank_account=tb_arbitman.bankaccount
                  ex.bank_code=tb_arbitman.bank_code
                  ex.bankname=tb_arbitman.bankname
                  ex.id_card=tb_arbitman.id_card
                  ex.email=tb_arbitman.email
                else
                  user = User.find_by_code(reward.p)
                  ex.p_name=user.name
                  ex.bank_typ=user.bank_typ
                  ex.bank_account=user.bankaccount
                  ex.bank_code=user.bank_code
                  ex.bankname=user.bankname
                  ex.id_card=user.id_card
                  ex.email=user.email
                end

                ex.should_rmb=reward.rmb
                ex.tax_base_rmb=0
                ex.tax_rmb=0
                ex.extend_rmb=reward.rmb
                ex.extend_code=extend_code
                ex.extend_u=session[:user_code]
                ex.extend_t=t
                ex.save
                reward.extend_id=ex.id
                reward.extend_code=extend_code
                reward.extend_u=session[:user_code]
                reward.extend_t=t
                reward.save
              end
            elsif typ=='3'
              reward=TbDeduction.find(id_id)
              if reward.used=='Y' and reward.extend_code=''
                ex=TbExtend.new()
                ex.recevice_code=reward.recevice_code
                ex.case_code=reward.case_code
                ex.general_code=reward.general_code
                ex.end_code=TbCase.find_by_recevice_code(reward.recevice_code).end_code
                ex.typ=typ
                ex.p_typ=p_typ
                ex.p=reward.p

                if p_typ=='0001'
                  ex.p_name=TbArbitman.find_by_code(reward.p).name
                  ex.bank_typ=TbArbitman.find_by_code(reward.p).bank_typ
                  ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                  ex.bank_code=TbArbitman.find_by_code(reward.p).bank_code
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                  ex.email=TbArbitman.find_by_code(reward.p).email
                else
                  ex.p_name=User.find_by_code(reward.p).name
                  ex.bank_typ=User.find_by_code(reward.p).bank_typ
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bank_code=User.find_by_code(reward.p).bank_code
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                  ex.email=User.find_by_code(reward.p).email
                end

                ex.should_rmb=reward.rmb * -1
                ex.tax_base_rmb=0
                ex.tax_rmb=0
                ex.extend_rmb=reward.rmb * -1
                ex.extend_code=extend_code
                ex.extend_u=session[:user_code]
                ex.extend_t=t
                ex.save
                reward.extend_id=ex.id
                reward.extend_code=extend_code
                reward.extend_u=session[:user_code]
                reward.extend_t=t
                reward.save
              end
            elsif typ=='4' or typ=='5'
              reward=TbRemuneration23.find(id_id)
              if reward.used=='Y' and reward.extend_code=''
                ex=TbExtend.new()
                ex.recevice_code=reward.recevice_code
                ex.case_code=reward.case_code
                ex.general_code=reward.general_code
                if reward.ope_typ=='0001'
                  ex.end_code=TbCase.find_by_recevice_code(reward.recevice_code).end_code
                else
                  ex.end_code=reward.end_code
                end
                ex.typ=typ
                ex.p_typ=p_typ
                ex.p=reward.p

                if p_typ=='0001'
                  ex.p_name=TbArbitman.find_by_code(reward.p).name
                  ex.bank_typ=TbArbitman.find_by_code(reward.p).bank_typ
                  ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                  ex.bank_code=TbArbitman.find_by_code(reward.p).bank_code
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                  ex.email=TbArbitman.find_by_code(reward.p).email
                else
                  ex.p_name=User.find_by_code(reward.p).name
                  ex.bank_typ=User.find_by_code(reward.p).bank_typ
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bank_code=User.find_by_code(reward.p).bank_code
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                  ex.email=User.find_by_code(reward.p).email
                end

                ex.should_rmb=reward.should_rmb
                ex.tax_base_rmb=reward.tax_base_rmb
                ex.tax_rmb=reward.tax_rmb
                ex.extend_rmb=reward.extend_rmb
                ex.extend_code=extend_code
                ex.extend_u=session[:user_code]
                ex.extend_t=t
                ex.save
                reward.extend_id=ex.id
                reward.extend_code=extend_code
                reward.extend_u=session[:user_code]
                reward.extend_t=t
                reward.save
              end
            end
        }
      end
      flash[:notice]="转为待发放成功"
      redirect_to :action=>'list'

    end

  end

  # 已发放报酬查询
  def search
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "search"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['date','extend_date','发放日期','text',[]],['char','t_extend_code','发放编号','text',[]],['char','p_name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','extend_date','t_extend_code','p_name']
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines = 20
    end

    @order=params[:order]
    if @order==nil or @order==""
      #@order="right(case_code,7) desc,p_typ,p,typ"
      @order="p_name asc,extend_date"
    end

    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word == ""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c=" used='Y' and t_extend_code <>''  "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end

    @extend_pages,@tb_extends = paginate(:tb_extends,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end

  # 已发放报酬查询
  def gxh
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "search"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['date','extend_date','发放日期','text',[]],['char','t_extend_code','发放编号','text',[]],['char','p_name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','extend_date','t_extend_code','p_name']
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines = 20000000000
    end

    @order=params[:order]
    if @order==nil or @order==""
      #@order="right(case_code,7) desc,p_typ,p,typ"
      @order="p_name asc,extend_date"
    end

    hant_search_1_word  = params[:rmb_hant_search_1_word]
    #@hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word == ""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c=" used='Y' and t_extend_code <>''  "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end
    @person = TbExtend.find(:all, :conditions => c,:select =>"distinct t_extend_code,p_typ,p,p_name,bank_account,bankname ", :conditions=>c)
    #@extend_pages,@tb_extends = paginate(:tb_extends,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  
  # 导出当前查询的已发放报酬信息 Ajax方式查询 导出 Excel 调用
  def search_remote
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}

    @typ1 = {"0001" => "仲裁员", "0002" => "助理", "0003" => "校核人员", "0004" => "员工"}
    @typ2 = {"1" => "报酬", "2" => "奖励", "3" => "扣减", "4" => "办案其它报酬", "5" => "出差补助合计"}

    @hant_search_1_page_name = "search_remote"
    @hant_search_1 = [['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['date','extend_date','发放日期','text',[]],['char','t_extend_code','发放编号','text',[]],['char','p_name','姓名','text',[]]]
    @hant_search_1_list = ['case_code','end_code','extend_date','t_extend_code','p_name']

        @order=params[:order]
    if @order==nil or @order==""
      #@order="right(case_code,7) desc,p_typ,p,typ"
      @order="p_name asc,extend_date"
    end
    hant_search_1_word  = params[:hant_search_1_word]
    @hant_search_1_text = params[:hant_search_1_text]
    @search_condit = params[:search_condit]
    if @search_condit == nil
      @search_condit = ""
    end
    @hant_search_1_r=params[:hant_search_1_r]
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit = " and " + hant_search_1_word
    end

    c="used='Y'  and t_extend_code <>''  "
    p = PubTool.new()
    if @search_condit != " and " and p.sql_check_3(@search_condit) != false
      c = c + @search_condit
    end

    @tb_extends = TbExtend.find(:all,:conditions=>c,:order=>@order)
  end

  # 转为已发放  本单位人员
  def extend_do_1
    t = Time.now
    condi = params[:condi]
    p = PubTool.new()
    if p.sql_check_3(condi) != false

      if condi != nil and condi != ""
        #存储发放编码相关信息
        con = condi.split(",")
        con.each{|co|
          exte = co.split("_")
            typ = exte[0]    # typ 1：报酬 2：奖励 3：惩罚 4：办案其它报酬 5：出差补助
            p_typ = exte[1]  # p_typ 0001:仲裁员 0002：办案助理   0003：校核人员 0004：员工
            id_id = exte[2].to_i
            if typ == '1'
              if p_typ == '0001' or p_typ == '0002' or p_typ=='0003'
                reward = TbBonusPenalty.find(id_id)
                if reward.used == 'Y' and reward.extend_code = '' and reward.isextend = ''
                  reward.isextend = "Y"
                  reward.save
                end
              end
            elsif typ=='2' or typ=='3'
              reward=TbDeduction.find(id_id)
              if reward.used=='Y' and reward.extend_code='' and reward.isextend = ''
                reward.isextend = "Y"
                reward.save
              end
            elsif typ=='4' or typ=='5'
              reward=TbRemuneration23.find(id_id)
              if reward.used=='Y' and reward.extend_code='' and reward.isextend = ''
                reward.isextend = "Y"
                reward.save
              end
            end
        }
      end
      flash[:notice]="转为已发放成功"
      redirect_to :action=>'list_1'
    end
  end

  # 转为未发放  本单位人员
  def extend_do_2
    t = Time.now
    condi = params[:condi]
    p = PubTool.new()
    if p.sql_check_3(condi) != false

      if condi != nil and condi != ""
        #存储发放编码相关信息
        con = condi.split(",")
        con.each{|co|
          exte = co.split("_")
            typ = exte[0]    # typ 1：报酬 2：奖励 3：惩罚 4：办案其它报酬 5：出差补助
            p_typ = exte[1]  # p_typ 0001:仲裁员 0002：办案助理   0003：校核人员 0004：员工
            id_id = exte[2].to_i
            if typ == '1'
              if p_typ == '0001' or p_typ == '0002' or p_typ=='0003'
                reward = TbBonusPenalty.find(id_id)
                if reward.used == 'Y' and reward.extend_code = '' and reward.isextend = 'Y'
                  reward.isextend = ""
                  reward.save
                end
              end
            elsif typ=='2' or typ=='3'
              reward=TbDeduction.find(id_id)
              if reward.used=='Y' and reward.extend_code='' and reward.isextend = 'Y'
                reward.isextend = ""
                reward.save
              end
            elsif typ=='4' or typ=='5'
              reward=TbRemuneration23.find(id_id)
              if reward.used=='Y' and reward.extend_code='' and reward.isextend = 'Y'
                reward.isextend = ""
                reward.save
              end
            end
        }
      end
      flash[:notice]="转为已发放成功"
      redirect_to :action=>'list_2'
    end
  end

end
