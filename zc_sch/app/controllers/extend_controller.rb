class ExtendController < ApplicationController
  def list
    @typ1={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减"}
    @provide_p=VProvide.find(:all,:conditions=>"extend_code=''",:order=>"recevice_code,p_typ,p",:select=>"distinct recevice_code,p_typ,p") 
  end
  def extend_do
    extend_code=SysArg.add_0005
    t=Time.now
    tax=Tax.new
    condi=params[:condi]
    dat=params[:dat]
    if condi!=nil and  condi!=""
      #存储发放编码相关信息
      extend_c=TbExtendCode.new()
      extend_c.extend_code=extend_code
      extend_c.extend_dat=dat
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
                  ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                else
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                end 
                ex.should_rmb=reward.zc_rmb * (1 + reward.bonus/100 - reward.penalty/100) + reward.gc_rmb 
                ex.tax_rmb=tax.get_tax(ex.should_rmb)
                ex.extend_rmb=ex.should_rmb - ex.tax_rmb
                ex.extend_code=extend_code
                ex.extend_dat=dat
                ex.u=session[:user_code]
                ex.t=t
                ex.save
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
                  ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                  ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                  ex.id_card=TbArbitman.find_by_code(reward.p).id_card
                else
                  ex.bank_account=User.find_by_code(reward.p).bankaccount
                  ex.bankname=User.find_by_code(reward.p).bankname
                  ex.id_card=User.find_by_code(reward.p).id_card
                end
                
                ex.should_rmb=reward.jh_rmb 
                ex.tax_rmb=tax.get_tax(ex.should_rmb)
                ex.extend_rmb=ex.should_rmb - ex.tax_rmb
                ex.extend_code=extend_code
                ex.extend_dat=dat
                ex.u=session[:user_code]
                ex.t=t
                ex.save
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
                ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                ex.id_card=TbArbitman.find_by_code(reward.p).id_card
              else
                ex.bank_account=User.find_by_code(reward.p).bankaccount
                ex.bankname=User.find_by_code(reward.p).bankname
                ex.id_card=User.find_by_code(reward.p).id_card
              end
              
              ex.should_rmb=reward.rmb 
              ex.tax_rmb=0
              ex.extend_rmb=reward.rmb
              ex.extend_code=extend_code
              ex.extend_dat=dat
              ex.u=session[:user_code]
              ex.t=t
              ex.save 
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
                ex.bank_account=TbArbitman.find_by_code(reward.p).bankaccount
                ex.bankname=TbArbitman.find_by_code(reward.p).bankname
                ex.id_card=TbArbitman.find_by_code(reward.p).id_card
              else
                ex.bank_account=User.find_by_code(reward.p).bankaccount
                ex.bankname=User.find_by_code(reward.p).bankname
                ex.id_card=User.find_by_code(reward.p).id_card
              end
              
              ex.should_rmb=reward.rmb * -1
              ex.tax_rmb=0
              ex.extend_rmb=reward.rmb * -1
              ex.extend_code=extend_code
              ex.extend_dat=dat
              ex.u=session[:user_code]
              ex.t=t
              ex.save 
              reward.extend_code=extend_code
              reward.extend_u=session[:user_code]
              reward.extend_t=t
              reward.save
            end
          end
      }
    end
    flash[:notice]="发放成功，发放编号:#{extend_code}"
    redirect_to :action=>'list'
  end
end
