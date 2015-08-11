class ChargeCorrespondenceController < ApplicationController
  
  def charge_list 
    session[:charge_correspondence_charge_id]=nil
    @order=params[:order]
    if @order==nil or @order==""
      @order="code desc,id asc"
    end
    c="used='Y' and state=1 and typ='a'"
    #@charge_pages,@charge=paginate(:tb_charges,:order=>@order,:conditions=>c)
    @charge=TbCharge.find(:all,:order=>@order,:conditions=>c)
  end
  
  def case_list 
    if params[:charge_id]!=nil
     session[:charge_correspondence_charge_id]=params[:charge_id] #为了支持查询，所以在这里使用session
    end
    @hant_search_1_page_name="case_list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="used='Y' and ((clerk='#{session[:user_code]}' and state>=4 and state<=100) or ((clerk='#{session[:user_code]}' or clerk_2='#{session[:user_code]}') and state>=1 and state<3)) "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def correspondence
    session[:charge_correspondence_charge_id]=nil
    case_id=params[:case_id]
    charge_id=params[:charge_id]
    if TbCase.find(case_id).clerk==session[:user_code] or TbCase.find(case_id).clerk==''
      t=""
      if TbCharge.find(charge_id).state==1
        begin
          TbCharge.find_by_sql("update tb_charges set state=2,clerk='#{session[:user_code]}',check_dt=now(),recevice_code='#{TbCase.find(case_id).recevice_code}',case_code='#{TbCase.find(case_id).case_code}',general_code='#{TbCase.find(case_id).general_code}' where id=#{charge_id}")
        rescue
        end
        t="<link href='/stylesheets/style.css' rel='stylesheet' type='text/css'>    对照成功！  <br>    <a href='/charge_correspondence/charge_list'>返回到 收款信息</a>  <br> <a href='/charge_correspondence_detail/list?recevice_code=#{TbCase.find(case_id).recevice_code}'>维护 案件收费明细信息</a>"
      else
        t="<link href='/stylesheets/style.css' rel='stylesheet' type='text/css'>   对照失败！该记录已经被其它案件对应。      <br>    <a href='/charge_correspondence/case_list?charge_id=#{params[:charge_id]}'>返回到 收款信息</a>"
      end
      render :text=>t
    end
  end
  
end
