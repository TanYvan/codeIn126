class ClerkChangeCzController < ApplicationController
  
  def list
    @hant_search_1_page_name="list"
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
    c="used='Y' and state<100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
   
  def change_list
    @falg={'0'=>"立案前",'1'=>"立案后"}
    @change=TbClerkchange.find(:all,:conditions=>"recevice_code='#{TbCase.find(params[:case_id]).recevice_code}'",:order=>"id") 
  end
  
  def new
    @clerks=User.find_by_sql("select code,name from users where used='Y' and code in (select user_code from user_duties where duty_code='0003') order by name")
    @change=TbClerkchange.new()
  end
   
  def create
     @change=TbClerkchange.new(params[:change])
     @change.recevice_code=TbCase.find(params[:case_id]).recevice_code
     @change.case_code=TbCase.find(params[:case_id]).case_code
     @change.general_code=TbCase.find(params[:case_id]).general_code
     @change.recevice_code=TbCase.find(params[:case_id]).recevice_code
     @change.beforeclerk=TbCase.find(params[:case_id]).clerk
     @change.u=session[:user_code]
     @change.t=Time.now()
     
     @case=TbCase.find(params[:case_id])
     @case.clerk=@change.afterclerk
     if @change.save and @case.save
        flash[:notice]="创建成功"
        redirect_to :action=>"change_list",:case_id=>"#{params[:case_id]}",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
     else
        flash[:notice]="创建失败"
        render :action=>"change_list",:case_id=>"#{params[:case_id]}",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
     end
     
  end
  
end
