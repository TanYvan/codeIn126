=begin
创建人：聂灵灵
创建时间：2009-5-22
类的描述：此控制器是前台日常办公时订房管理信息维护
页面：
订房管理信息列表:/arbithotel/arbithotel_list
创建订房管理信息：/arbithotel/arbithotel_new
修改订房管理信息：/arbithotel/arbithotel_edit
=end
class ArbithotelController < ApplicationController
  def arbithotel_list
    @hant_search_1_page_name="arbithotel_list"
    @hant_search_1=[
      ['char','tb_arbithotels.case_code','案件编号','text',[]],
      ['char','tb_arbithotels.usestyle','使用类型','select',TbDictionary.find(:all,:conditions=>"typ_code='0029' and data_val<>'0000'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
      ['char','tb_arbitmen.name','仲裁员','text',[]],
      ['date','tb_arbithotels.usedate','使用时间','text',[]],
      ['number','tb_arbithotels.days','住宿天数','text',[]],
      ['number','tb_arbithotels.rooms','房间数量','text',[]],
      ]
 
    @order=params[:order]
    if @order==nil or @order==""
      @order="usedate desc"
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
    c="tb_arbithotels.used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @arbithotel_pages,@arbithotel=paginate(:tb_arbithotels,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  def arbithotel_new
    @arbithotel=TbArbithotel.new()
    @arbithotel.usedate=Date.today
    @arbithotel.arbitman='A'
  end
  def arbithotel_create
    @arbithotel=TbArbithotel.new(params[:arbithotel])
    @arbithotel.u=session[:user_code]
    @arbithotel.u_t=Time.now()
    if @arbithotel.save
      flash[:notice]="预订成功"
      redirect_to :action=>"arbithotel_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="预订失败"
      render :action=>"arbithotel_new",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def arbithotel_edit
    @arbithotel=TbArbithotel.find(params[:id])
  end

  def arbithotel_update
    @arbithotel=TbArbithotel.find(params[:id])
    if @arbithotel.usestyle!='0001'
      @arbithotel.u=session[:user_code]
      @arbithotel.u_t=Time.now()
      if @arbithotel.update_attributes(params[:arbithotel])
        flash[:notice]="修改成功"
        redirect_to :action=>"arbithotel_list",:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"arbithotel_edit",:page=>params[:page],:page_lines=>params[:page_lines]
      end
    end
  end

  def arbithotel_delete
    @arbithotel=TbArbithotel.find(params[:id])
    if @arbithotel.usestyle!='0001'
      @arbithotel.used="N"
      @arbithotel.u=session[:user_code]
      @arbithotel.u_t=Time.now()
      if @arbithotel.save
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"arbithotel_list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
end
