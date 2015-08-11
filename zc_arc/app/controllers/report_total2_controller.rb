class ReportTotal2Controller < ApplicationController
  def list
    p=PubTool.new()
    @order=params[:order]
    if @order==nil or @order==""
      @order="ca_nowdate,ca_gc asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=2000000
    end
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end 
    if @d2==nil
      @d2=Time.now.to_date
    end
    
    if p.sql_check_3(@d1)!=false and p.sql_check_3(@d2)!=false
      ReportTotal2.delete_all("user_code='#{session[:user_code]}'")
      ActiveRecord::Base.connection.execute("insert into report_total2s (user_code,ca_id,ca_rc,ca_gc,ca_cc,ca_ec,ca_nowdate,ca_clerk)  
   select '#{session[:user_code]}',id,recevice_code,general_code,case_code,end_code,nowdate,clerk  from  
   tb_cases where used='Y' and state>=4 and nowdate>='#{@d1}' and nowdate<='#{@d2}'")
      ActiveRecord::Base.connection.execute("update  report_total2s,users set report_total2s.ca_clerk_name=users.name    where report_total2s.ca_clerk=users.code")
      @c=ReportTotal2.find(:all,:conditions=>"user_code='#{session[:user_code]}'")
      for c in @c
        ### 本请求
        c.je1=Cost.new.get_sum(c.ca_rc,"1","0001")
        if TbCaseAmountDetail.find(:all,:conditions=>"used='Y' and recevice_code='#{c.ca_rc}' and partytype='1' and amount_typ='0001' and currency<>'0001' and f_money<>0").empty?
          c.je1_f='N'
        else
          c.je1_f='Y'
        end
        
        c.je2=Cost.new.get_sum(c.ca_rc,"1","0002")
        if TbCaseAmountDetail.find(:all,:conditions=>"used='Y' and recevice_code='#{c.ca_rc}' and partytype='1' and amount_typ='0002' and currency<>'0001' and f_money<>0").empty?
          c.je2_f='N'
        else
          c.je2_f='Y'
        end
        
        c_a=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'")
        c_a_2=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0001' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3")
        if c_a==nil 
          c_a=0
        end
        if c_a_2==nil
          c_a_2=0
        end
        c.je3=c_a - c_a_2
        # 应交
        c1=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 实交
        c2=TbShouldCharge.sum("re_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 减交
        c3=TbShouldCharge.sum("redu_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 应退
        c4=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3")
        # 实退
        c5=TbShouldRefund.sum("re_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3")
        # 减退
        c6=TbShouldRefund.sum("redu_rmb_money",:conditions=>"payment='0001' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3")
        if c1==nil 
          c1=0
        end
        if c2==nil 
          c2=0
        end
        if c3==nil 
          c3=0
        end
        if c4==nil 
          c4=0
        end
        if c5==nil 
          c5=0
        end
        if c6==nil 
          c6=0
        end
        
        c.c_rmb_money=c1 - (c4 - c6) 
        c.c_redu_rmb_money=c3
        c.c_re_rmb_money=c2 - c5
        c.c_c=c.c_rmb_money - c.c_re_rmb_money - c.c_redu_rmb_money
        if c.c_c < 0 
          c.c_c=0
          c.c_c_out='Y'
        else
          c.c_c_out='N'
        end
        ############################################################
        ### 反请求
        c.je1_2=Cost.new.get_sum(c.ca_rc,"2","0001")
        if TbCaseAmountDetail.find(:all,:conditions=>"used='Y' and recevice_code='#{c.ca_rc}' and partytype='2' and amount_typ='0001' and currency<>'0001' and f_money<>0").empty?
          c.je1_2_f='N'
        else
          c.je1_2_f='Y'
        end
        
        c.je2_2=Cost.new.get_sum(c.ca_rc,"2","0002")
        if TbCaseAmountDetail.find(:all,:conditions=>"used='Y' and recevice_code='#{c.ca_rc}' and partytype='1' and amount_typ='0002' and currency<>'0001' and f_money<>0").empty?
          c.je2_2_f='N'
        else
          c.je2_2_f='Y'
        end
        
        c_a=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}'")
        c_a_2=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0002' and typ='0004' and used='Y' and recevice_code='#{c.ca_rc}' and state<>3")
        if c_a==nil 
          c_a=0
        end
        if c_a_2==nil
          c_a_2=0
        end
        c.je3_2=c_a - c_a_2
        # 应交
        c1=TbShouldCharge.sum("rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 实交
        c2=TbShouldCharge.sum("re_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 减交
        c3=TbShouldCharge.sum("redu_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'")
        # 应退
        c4=TbShouldRefund.sum("rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}' and state<>3")
        # 实退
        c5=TbShouldRefund.sum("re_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3")
        # 减退
        c6=TbShouldRefund.sum("redu_rmb_money",:conditions=>"payment='0002' and (typ='0001' or typ='0004') and used='Y' and recevice_code='#{c.ca_rc}'  and state<>3")
        if c1==nil 
          c1=0
        end
        if c2==nil 
          c2=0
        end
        if c3==nil 
          c3=0
        end
        if c4==nil 
          c4=0
        end
        if c5==nil 
          c5=0
        end
        if c6==nil 
          c6=0
        end
        c.c_rmb_money_2=c1 - (c4 - c6) 
        c.c_redu_rmb_money_2=c3
        c.c_re_rmb_money_2=c2 - c5
        c.c_c_2=c.c_rmb_money_2 - c.c_redu_rmb_money_2 - c.c_re_rmb_money_2
      
        if c.c_c_2 < 0 
          c.c_c_2=0
          c.c_c_2_out='Y'
        else
          c.c_c_2_out='N'
        end
       
        c.save
      end
      @count=ReportTotal2.count("user_code='#{session[:user_code]}'")
      @case_pages,@case=paginate(:report_total2s,:conditions=>"user_code='#{session[:user_code]}'",:order=>@order,:per_page=>@page_lines.to_i)
      ReportTotal2.delete_all("user_code='#{session[:user_code]}'")
    end
  end
  def list_1
    @d1=params[:d1]
    @d2=params[:d2]
    if @d1==nil
      @d1=Time.now.at_beginning_of_year.to_date
    end
    if @d2==nil
      @d2=Time.now.to_date
    end
    @order = params[:order]
    if @order==nil or @order==""
      @order = "e.decideDate desc,c.arbitmantype asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    @casearbitman_pages,@casearbitman =paginate_by_sql(TbCasearbitman,"select c.recevice_code as recevice_code,e.decideDate as decideDate,e.arbitBookNum as arbitBookNum,c.arbitmantype as arbitmantype,c.arbitman as arbitman from tb_casearbitmen as c,tb_caseendbooks as e where  c.used='Y' and c.recevice_code=e.recevice_code and e.used='Y' order by #{@order}",@page_lines.to_i)
  end
end
