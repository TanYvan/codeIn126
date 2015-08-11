#2009-7-21 niell  在聘仲裁员信息表维护
class ExpireController < ApplicationController
  def list_expires
     @hant_search_1_r=params[:hant_search_1_r]
    @hant_search_1_page_name="list_expires"
    @hant_search_1=[['char','tb_arbitmen.spell','姓名拼音缩写','text',[]],
      ['char','tb_arbitmen.name','姓名(系统唯一)','text',[]],
      ['char','tb_arbitmen.code','仲裁员编码','text',[]],
      ['char','tb_arbitmen.country','国籍(中文)','text',[]],
      ['char','tb_arbitmen.country_en','国籍(英文)','text',[]],
      ['char','tb_arbitmen.area_code','地区','select',Region.find(:all, :order=>"code",:select=>"code,name").collect{|p|[p.code,p.name]}.insert(0,["","全部"])],
      ['char','tb_arbitmen.role_code','仲裁规则','selecttext',TbDictionary.find(:all,:conditions=>"typ_code='8143' and state='Y' and used='Y'",:order=>'ind,data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}.insert(0,["","全部"])],
      ['char','tb_arbitmen.special','专长(中文)','text',[]],
      ['char','tb_arbitmen.special_en','专长(英文)','text',[]],
      ['char','tb_arbitmen.area_type','所在地分类','select',TbDictionary.find(:all,:conditions=>"typ_code='9028' and state='Y' and used='Y'",:order=>'ind,data_val',:select=>"data_val,data_text").collect{|p|[p.data_val,p.data_text]}.insert(0,["","全部"])]
      ]
    @hant_search_1_list=["tb_arbitmen.role_code","tb_arbitmen.special","tb_arbitmen.country","tb_arbitmen.area_type","tb_arbitmen.spell"]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="tb_arbitmen.name asc"
    end
    p=PubTool.new()
    c="tb_arbitmen.used='Y' and tb_arbitmannows.used='Y' and tb_arbitmen.code=tb_arbitmannows.arbitman_num"
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @tb_arbitmannow_pages,@tb_arbitmannows=paginate_by_sql(TbArbitmannow,"select tb_arbitmannows.arbitman_num as arbitman_num,tb_arbitmen.id as id,tb_arbitmen.name as name,tb_arbitmen.age as age,tb_arbitmen.spell as spell ,tb_arbitmen.country as country,tb_arbitmen.role_code as role_code ,tb_arbitmen.area_code as area_code,tb_arbitmen.name_idcard as name_idcard,tb_arbitmen.name_idcard_en as name_idcard_en,tb_arbitmen.special as special,tb_arbitmen.special_en as special_en,tb_arbitmen.country_en as country_en,tb_arbitmen.city as city,tb_arbitmen.city_en as city_en,tb_arbitmen.area_type as area_type  from tb_arbitmen,tb_arbitmannows where #{c}  order by #{@order}",@page_lines.to_i)
    @count = TbArbitmannow.find_by_sql("select count(tb_arbitmannows.id) as ccc   from tb_arbitmen,tb_arbitmannows where #{c}")
    @count_num = 0
    @count.each{|c|
      @count_num = c.ccc
    }
    @role_role = TbDictionary.find(:all,:conditions=>"typ_code='8143' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @role = {"0000" => "全部"}
    @role_role.each{|ari|
      @role.merge!({ari.data_val => ari.data_text})
    }
    @area_type = TbDictionary.find(:all,:conditions=>"typ_code='9028' and state='Y' and used='Y'",:order=>'data_val',:select=>"data_val,data_text")
    @area_t = {}
    @area_type.each{|ari|
      @area_t.merge!({ari.data_val => ari.data_text})
    }
  end
  #所有届信息
  def list_expire1
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @expires_pages,@expires=paginate(:expires,:conditions=>"used='Y'",:order=>"expire",:per_page=>@page_lines.to_i)
  end
  def expire_edit
    @expires=Expire.find(params[:id])
  end
  def expire_update
    @expires=Expire.find(params[:id])
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    if @expires.update_attributes(params[:expires])
      flash[:notice]="修改成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"expire_edit",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def expire_delete
    @expires=Expire.find(params[:id])
    @expires.used="N"
    @expires.u=session[:user_code]
    @expires.u_t=Time.now()
    @tb_arbitmanexprire = TbArbitmanexprire.find(:all,:conditions=>"expire='#{@expires.expire}' and used='Y'")
    if @tb_arbitmanexprire!=nil
      for a in @tb_arbitmanexprire
        @tb_arbitmanexprire1 = TbArbitmanexprire.new()
        @tb_arbitmanexprire1.expire = a.expire
        @tb_arbitmanexprire1.arbitman_num = a.arbitman_num
        @tb_arbitmanexprire1.arbitman_name = TbArbitman.find_by_code(a.arbitman_num).name
        @tb_arbitmanexprire1.used='N'
        @tb_arbitmanexprire1.u = session[:user_code]
        @tb_arbitmanexprire1.u_t = Time.now
        @tb_arbitmanexprire1.save
      end
    end
    if @expires.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="删除失败"
      render :action=>"list_expire1",:page=>params[:page],:page_lines=>params[:page_lines]
    end    
  end
  
  def create_expire_many
    if Expire.find(:first,:conditions=>"expire='#{params[:expire]["expire"]}' and used='Y'")==nil
      @expire = Expire.new(params[:expire])
      @expire.expire = params[:expire]["expire"]
      @expire.remark = params[:expire]["remark"]
      @expire.u = session[:user_code]
      @expire.u_t = Time.now
      if @expire.save
        @expire2=TbArbitmannow.find(:all,:conditions=>"used='Y'")
        for e in @expire2
          @tb_arbitmanexprire = TbArbitmanexprire.new()
          @tb_arbitmanexprire.expire = params[:expire]["expire"]
          @tb_arbitmanexprire.arbitman_num = e.arbitman_num
          @tb_arbitmanexprire.arbitman_name = TbArbitman.find_by_code(e.arbitman_num).name
          @tb_arbitmanexprire.u = session[:user_code]
          @tb_arbitmanexprire.u_t = Time.now
          @tb_arbitmanexprire.save
        end
        flash[:notice] = "届信息保存成功！"
        redirect_to :action => "list_expires",:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice] = "创建失败"
        render :action => "new_expire_many",:page=>params[:page],:page_lines=>params[:page_lines]
      end
    else
      flash[:notice] = "届信息已经存在，请重新命名！"
      render :action => "new_expire_many",:page=>params[:page],:page_lines=>params[:page_lines]
    end  
  end
  
end
