=begin
创建人：聂灵灵
创建时间：2009-5-14
类的描述：此控制器是处理历史案件页面的信息及维护。
页面：
历史案件信息列表:/arbitroom/arbitroom_list
创建历史案件信息：/arbitroom/arbitroom_new
修改历史案件信息：/arbitroom/arbitroom_edit
=end
class ArbitroomController < ApplicationController

  def arbitroom_list
      @hant_search_1_page_name="arbitroom_list"
      @hant_search_1=[
        ['date','sittingdate','使用日期','text',[]],['char','userId','预订人','text',[]],
        ['char','sittingplace','仲裁庭','select',TbDictionary.find(:all,:conditions=>"typ_code='0023' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
        ['char','open_t','开庭时间','text',TbDictionary.find(:all,:conditions=>"typ_code='0024' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_text").collect{|p|[p.data_text,p.data_text]}],
        ['char','close_t','闭庭时间','text',TbDictionary.find(:all,:conditions=>"typ_code='0024' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_text").collect{|p|[p.data_text,p.data_text]}],
        ['number','usetime','占用时间','text',[]],
        ['char','usestyle','使用类型 ','select',TbDictionary.find(:all,:conditions=>"typ_code='0028' and data_val<>'0000'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}],
        ]
        
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
      @arbitroom_pages,@arbitroom=paginate(:tb_arbitrooms,:conditions=>c ,:order=>"sittingdate desc",:per_page=>@page_lines.to_i)
  end
  def arbitroom_new
    @arbitroom=TbArbitroom.new()
    @arbitroom.sittingdate=Date.today
  end
  def arbitroom_create
     @arbitroom=TbArbitroom.new(params[:arbitroom])
     @arbitroom.u=session[:user_code]
     @arbitroom.u_t=Time.now()
     @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @arbitroom.usetime = @use_time[params[:arbitroom][:close_t]] - @use_time[params[:arbitroom][:open_t]]
     if @arbitroom.save
        flash[:notice]="预订成功"
        redirect_to :action=>"arbitroom_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
       flash[:notice]="预订失败"
       render :action=>"arbitroom_new",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def arbitroom_edit
     @arbitroom=TbArbitroom.find(params[:id])
  end

  def arbitroom_update
     @arbitroom=TbArbitroom.find(params[:id])
     @arbitroom.u=session[:user_code]
     @arbitroom.u_t=Time.now()
     @use_time={"08:00"=>8,"08:30"=>8.5,"09:00"=>9,"09:30"=>9.5,"10:00"=>10,"10:30"=>10.5,"11:00"=>11,"11:30"=>11.5,"12:00"=>12,
         "12:30"=>12.5,"13:00"=>13,"13:30"=>13.5,"14:00"=>14,"14:30"=>14.5,"15:00"=>15,"15:30"=>15.5,
         "16:00"=>16,"16:30"=>16.5,"17:00"=>17,"17:30"=>17.5,"18:00"=>18,"18:30"=>18.5,
         "19:00"=>19,"19:30"=>19.5,"20:00"=>20}
    @arbitroom.usetime = @use_time[params[:arbitroom][:close_t]] - @use_time[params[:arbitroom][:open_t]]

     if @arbitroom.update_attributes(params[:arbitroom])
        flash[:notice]="修改成功"
        redirect_to :action=>"arbitroom_list",:page=>params[:page],:page_lines=>params[:page_lines]
     else
        flash[:notice]="修改失败"
        render :action=>"arbitroom_edit",:page=>params[:page],:page_lines=>params[:page_lines]
     end
  end

  def arbitroom_delete
     @arbitroom=TbArbitroom.find(params[:id])
     @arbitroom.used="N"
     @arbitroom.u=session[:user_code]
     @arbitroom.u_t=Time.now()
     if @arbitroom.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"arbitroom_list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
