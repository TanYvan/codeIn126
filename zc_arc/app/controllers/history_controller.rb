=begin
创建人：聂灵灵
创建时间：2009-5-14
类的描述：此控制器是处理历史案件页面的信息及维护。
页面：
历史案件信息列表:/history/list
=end
class HistoryController < ApplicationController
  def list
      @hant_search_1_page_name="list"
      @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
      @order=params[:order]
      if @order==nil or @order==""
        @order="recevice_code desc"
      end
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines=session[:lines]
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
#      if session["0001"]=="Y"  #0001代表处长
#        c="used='Y' and state=2"
#      elsif session["0003"]=="Y"  #0003代表仲裁助理
#        c="used='Y' and state=2 and (clerk='#{session[:user_code]}' or clerk='') "
#      else
#        c="1=2"
#      end
      c="used='Y' and state=2"
      p=PubTool.new()
      if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
        c = c + @search_condit
      end
      @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
   end
   
   def party_edit
     @tbparty=TbParty.find_by_recevice_code(params[:recevice_code])
   end

   def edit
     @case=TbCase.find_by_recevice_code(params[:recevice_code])
     @t_typ=TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
   end

   def delete
     @case=TbCase.find(params[:id])
     @case.used="N"
     if @case.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
   end
   #设为咨询案件
   def set_case
     @case=TbCase.find(params[:id]) 
     if  @case.state==2    
       f=TbCaseFlow.del_flow(@case.recevice_code,'0002')
       if f!=0
        @case.state=f
       end
     end
     @case.u=session[:user_code]
     @case.u_t=Time.now()
     @case.state=1
     @case.recevice_code_limit_dat = @case.recevice_code_limit_dat + SysArg.find_by_code("1010").val.to_i
     if @case.save
        flash[:notice]="成功设为咨询案件"
     else
        flash[:notice]="设置咨询案件失败"
     end
     redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
   end
#将到期咨询案件###################################
  def tern_list
      @hant_search_1_page_name="list"
      @hant_search_1=[['char','recevice_code','咨询流水号','text',[]]]
      @order=params[:order]
      if @order==nil or @order==""
        @order="recevice_code desc"
      end
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines=session[:lines]
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
      p=PubTool.new()
      if session["0001"]=="Y"  #0001代表处长
        c="used='Y' and state=1 and recevice_code_limit_dat<'#{Date.today}'"
      elsif session["0003"]=="Y"  #0003代表仲裁助理
        c="used='Y' and state=1 and (clerk='#{session[:user_code]}' or clerk='') and recevice_code_limit_dat<'#{Date.today}'"
      else
        c="1=2"
      end
      if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
        c = c + @search_condit
      end
      @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
#  修改咨询案件
#  def p_set
#    typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{params[:p_typ]}'",:order=>'data_val',:select=>"data_val,data_text")
#    render :update do |page|
#      page.remove 'case_casetype_num2'
#      page.replace_html 'pv_set', :partial => 'pv',:object=>typ2
#    end
#  end
#  def tern_edit
#    @case=TbCase.find_by_recevice_code(params[:recevice_code])
#    @typ1=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
#    @typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{@case.casetype_num}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
#  end
#
#  def tern_update
#    @case=TbCase.find_by_recevice_code(params[:recevice_code])
#    if @case.update_attributes(params[:case])
#      flash[:notice]="修改成功"
#      redirect_to :action=>"tern_list",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
#    else
#      flash[:notice]="修改失败"
#      render :action=>"tern_edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
#    end
#  end
  #查看案件信息
  def check_case
     @case=TbCase.find_by_recevice_code(params[:recevice_code])
   end
  #设置为历史案件
  def set_case2
     @case=TbCase.find(params[:id])
     @case.u=session[:user_code]
     @case.u_t=Time.now()
     if @case.state==1
       f=TbCaseFlow.add_flow(@case.recevice_code,'0002')
       if f!=0
        @case.state=f
       end
     end
     if @case.save
        flash[:notice]="成功设为历史案件"
     else
        flash[:notice]="设置历史案件失败"
     end
     redirect_to :action=>"tern_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
   end
  #设置为新案件
   def tern_new
     @case=TbCase.find(params[:id])
     @case.u=session[:user_code]
     @case.u_t=Time.now()
     @case.recevice_code_limit_dat=@case.recevice_code_limit_dat + SysArg.find_by_code("1010").val.to_i
     if @case.save
        flash[:notice]="成功设为新的案件"
     else
        flash[:notice]="设置新案件失败"
     end
     redirect_to :action=>"tern_list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
   end
end
