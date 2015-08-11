class OrgController < ApplicationController
  
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[
      ['char','name','名称','text',[]],['char','code','编号','text',[]],
      ['char','addr','联系地址','text',[]],
      ['char','tel','联系电话','text',[]],
      ['char','email','电子邮件','text',[]],
      ['char','postcode','邮政编码 ','text',[]],
    ]
    @order=params[:order]
    if @order==nil or @order==""
      @order="code asc"
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
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
      
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @org_pages,@org=paginate(:tb_orgs,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end

  def new
    @org=TbOrg.new()
  end

  def create
    @org=TbOrg.new(params[:org])
    @org.code=SysArg.add_0011()
    @org.u=session[:user_code]
    @org.u_t=Time.now()
    if @org.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action=>"new",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def edit
    @org=TbOrg.find(params[:id])
  end

  def update
    @org=TbOrg.find(params[:id])
    @org.u=session[:user_code]
    @org.u_t=Time.now()
    if @org.update_attributes(params[:org])
      flash[:notice]="修改成功"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def delete
    @org=TbOrg.find(params[:id])
    @org.used="N"
    @org.u=session[:user_code]
    @org.u_t=Time.now()
    if @org.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
  
end
