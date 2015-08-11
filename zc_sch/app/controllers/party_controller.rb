class PartyController < ApplicationController
  def p_list
    partyname=params[:partyname]
    cov  = Iconv.new('utf-8','gbk')  # Iconv 编码转换
    partyname=cov.iconv(partyname)
    if partyname.strip!='' and PubTool.new().sql_check_3(partyname)!=false
    p_case=VCaseQuery1List1.find_by_sql("select distinct tb_cases_state,tb_cases_recevice_code,tb_cases_general_code,tb_cases_case_code, 
tb_cases_end_code,tb_cases_clerk from v_case_query1_list1s where tb_parties_partyname like '%#{partyname}%'")
    else
      p_case=nil
    end
    render :update do |page|
      page.replace_html 'p_list', :partial => 'p_l',:object=>p_case
    end
  end
  def party_list
    @isperson={1=>"是",2=>"否"}
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and partytype=1 and used='Y'"
      @party=TbParty.find(:all,:conditions=>c,:order=>'id') 
    end
  end
  
  def party_new
    @party=TbParty.new()
  end
   
  def party_create
     @party=TbParty.new(params[:party])
     @party.partytype=1
     @party.partyname=@party.partyname.strip
     @party.addr=@party.addr.strip
     @party.recevice_code=session[:recevice_code]
     @party.case_code=session[:case_code]
     @party.general_code=session[:general_code]
     @party.u=session[:user_code]
     @party.u_t=Time.now()
     if @party.save
        flash[:notice]="创建成功"
        redirect_to :action=>"party_list"
     else
        render :action=>"party_new" 
     end
     
  end
   
  def party_edit
     @party=TbParty.find(params[:id])
  end 

  def party_update
     @party=TbParty.find(params[:id])
     @party.u=session[:user_code]
     @party.u_t=Time.now()
     if @party.update_attributes(params[:party]) 
        @party.partyname=@party.partyname.strip
        @party.addr=@party.addr.strip
        @party.save
        flash[:notice]="修改成功"
        redirect_to :action=>"party_list"
     else
	flash[:notice]="修改失败"
        render :action=>"party_edit",:id=>params[:id]
     end
     
  end
   
  def party_delete
     @party=TbParty.find(params[:id])
     @party.used="N"
     @party.u=session[:user_code]
     @party.u_t=Time.now()
     if @party.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"party_list"
  end
  
end
