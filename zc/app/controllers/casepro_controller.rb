=begin
创建人：聂灵灵
创建时间：2009-5-14
类的描述：此控制器是处理日常办公的咨询工作日志信息及维护。
页面：
历史案件信息列表:/casepro/casepro_list
创建历史案件信息：/casepro/casepro_new
修改历史案件信息：/casepro/casepro_edit
=end
class CaseproController < ApplicationController

  def casepro_list
    #添加分页
    @hant_search_1_page_name="casepro_list"
    @hant_search_1=[['date','happdate','咨询日期','text',[]],['char','keyword','系争合同争议性质','text',[]],['char','purpuse','涉案标的','text',[]],
      ['char','app1','申请人信息及联系方式','text',[]],['char','res1','被申请人信息及联系方式','text',[]],
      ['char','agent','机构名称','select',TbDictionary.find(:all,:conditions=>"typ_code='0004' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','dat1','仲裁条款或协议订立的时间','text',[]],['char','term_source','仲裁条款或协议订立来源','text',[]],
      ['char','note','备注','text',[]],['char','content','处理结果小结','text',[]],['char','content2','后续跟进情况补充','text',[]],
      ['char','u','助理姓名','select',UserDuty.find_by_sql("select users.code as code,users.name as name from users,user_duties where users.states='Y' and users.used='Y' and users.code=user_duties.user_code and user_duties.duty_code='0003' order by users.ord,users.name").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @casepro_pages,@casepro=paginate(:tb_casepros,:conditions=>c,:order=>"happdate desc",:per_page=>@page_lines.to_i)
  end

  def casepro_new
    @casepro=TbCasepro.new()
    @casepro.happdate=Date.today
    @casepro.clerk_id=session[:user_code]
  end

  def casepro_create
     @casepro=TbCasepro.new(params[:casepro])
     @casepro.u=session[:user_code]
     @casepro.u_t=Time.now()
     if @casepro.save
        flash[:notice]="创建成功"
        redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
        render :action=>"casepro_new",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def casepro_edit
     @casepro=TbCasepro.find(params[:id])
  end

  def casepro_update
     @casepro=TbCasepro.find(params[:id])
     if  @casepro.u==session[:user_code]
       @casepro.u=session[:user_code]
       @casepro.u_t=Time.now()
       if @casepro.update_attributes(params[:casepro])
          flash[:notice]="修改成功"
          redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
       else
          flash[:notice]="修改失败"
          render :action=>"casepro_edit",:page=>params[:page],:page_lines=>params[:page_lines]
       end
     else
       flash[:notice]="修改失败，只能修改自己录入的信息"
       redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def casepro_delete
     @casepro=TbCasepro.find(params[:id])
     if  @casepro.u==session[:user_code]
       @casepro.used="N"
       @casepro.u=session[:user_code]
       @casepro.u_t=Time.now()
       if @casepro.save
          flash[:notice]="删除成功"
       else
          flash[:notice]="删除失败"
       end
       redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
       flash[:notice]="修改失败，只能修改自己录入的信息"
       redirect_to :action=>"casepro_list",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end
end
