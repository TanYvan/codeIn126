class ExtendController < ApplicationController
  def list
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ1={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1_list=['case_code','end_code','general_code','recevice_code']
#    @order=params[:order]
#    if @order==nil or @order==""
#      @order="recevice_code desc"
#    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="extend_code=''"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @provide_p=VProvide.find(:all,:conditions=>c,:order=>"case_code,p_typ,p,typ",:select=>"distinct recevice_code,p_typ,p") 
  end
  def extend_do
    extend_code=SysArg.add_0005
    t=Time.now
    tax=Tax.new
    condi=params[:condi]
    
    p=PubTool.new()
    if p.sql_check_3(condi)!=false
    
      if condi!=nil and  condi!=""
        #存储发放编码相关信息
        extend_c=TbExtendCode.new()
        extend_c.extend_code=extend_code
        extend_c.u=session[:user_code]
        extend_c.t=t
        extend_c.save

        con=condi.split(",")
        con.each{|co|
          exte=co.split("_")
            typ=exte[0]
            p_typ=exte[1]
            id_id=exte[2].to_i
            if typ=='1'
              if p_typ=='0001' or p_typ=='0002'
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
                    ex.p_name=TbArbitman.find_by_code(reward.p).name
                    ex.bank_typ=TbArbitman.find_by_code(reward.p).bank_typ
                    ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                    ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                    ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                  else
                    ex.p_name=User.find_by_code(reward.p).name
                    ex.bank_typ=User.find_by_code(reward.p).bank_typ
                    ex.bank_account=User.find_by_code(reward.p).bankaccount
                    ex.bankname=User.find_by_code(reward.p).bankname
                    ex.id_card=User.find_by_code(reward.p).id_card
                  end 
                  ex.should_rmb=(reward.zc_rmb * (1 + reward.bonus/100 - reward.penalty/100) + reward.gc_rmb).round
                  ex.tax_rmb=tax.get_tax(ex.should_rmb.round)
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
                    ex.p_name=TbArbitman.find_by_code(reward.p).name
                    ex.bank_typ=TbArbitman.find_by_code(reward.p).bank_typ
                    ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                    ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                    ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                  else
                    ex.p_name=User.find_by_code(reward.p).name
                    ex.bank_typ=User.find_by_code(reward.p).bank_typ
                    ex.bank_account=User.find_by_code(reward.p).bankaccount
                    ex.bankname=User.find_by_code(reward.p).bankname
                    ex.id_card=User.find_by_code(reward.p).id_card
                  end

                  ex.should_rmb=reward.jh_rmb.round 
                  ex.tax_rmb=tax.get_tax(ex.should_rmb.round)
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
                  ex.p_name=TbArbitman.find_by_code(reward.p).name
                  ex.bank_typ=TbArbitman.find_by_code(reward.p).bank_typ
                  ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                else
                  ex.p_name=User.find_by_code(reward.p).name
                  ex.bank_typ=User.find_by_code(reward.p).bank_typ
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                end

                ex.should_rmb=reward.rmb 
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
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                else
                  ex.p_name=User.find_by_code(reward.p).name
                  ex.bank_typ=User.find_by_code(reward.p).bank_typ
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                end

                ex.should_rmb=reward.rmb * -1
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
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                else
                  ex.p_name=User.find_by_code(reward.p).name
                  ex.bank_typ=User.find_by_code(reward.p).bank_typ
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                end

                ex.should_rmb=reward.should_rmb
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
end
