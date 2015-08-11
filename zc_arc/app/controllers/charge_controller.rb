class ChargeController < ApplicationController
  
  def list
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','p','付款人','text',[]],['number','rmb_money','金额￥','text',[]],['char','bill','是否已开发票','select',[['',''],['是','是'],['否','否']]],['char','code','收款号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1_list=['p','rmb_money']
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
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
    c="used='Y' and state_2=1 and typ<>'c'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @charge_pages,@charge=paginate(:tb_charges,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  #标记为完成的
  def list_2
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','p','付款人','text',[]],['number','rmb_money','金额￥','text',[]],['char','bill','是否已开发票','select',[['',''],['是','是'],['否','否']]],['char','code','收款号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1_list=['p','rmb_money']
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
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
    c="used='Y' and typ<>'c'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @condi_k = params[:condi_k]
    array_con = @condi_k.split(",")
    begin
      array_con.each do |con|
        @charge=TbCharge.find(:first,:conditions=>["used='Y' and id=?",con])
        @charge.state_2=2  #标记为历史数据
        @charge.save
        @charge1 = TbCharge.find(:first,:conditions=>["used='Y' and parent_id=?",con])
        if @charge1!=nil
          @charge1.state_2=2 #标记为历史数据
          @charge1.save
        end
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "标记完成失败！"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice] = "标记完成成功！"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  #出纳已确认收款信息
  def list_1
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    @hant_search_1_page_name="list_1"
    @hant_search_1=[['char','p','付款人','text',[]],['number','rmb_money','金额￥','text',[]],['char','bill','是否已开发票','select',[['',''],['是','是'],['否','否']]],['char','code','收款号','text',[]],['char','recevice_code','咨询流水号','text',[]]]
    @hant_search_1_list=['p','rmb_money']
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
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
    c="used='Y' and state_2=2 and typ<>'c'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @charge_pages,@charge=paginate(:tb_charges,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  #回退到当前数据
  def back_to
    @charge=TbCharge.find(params[:id])
    @charge.state_2=1
    @charge.save
    if @charge.save
      flash[:notice]="回退成功"
    else
      flash[:notice]="回退失败"
    end
    redirect_to :action=>"list_1",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
  #出纳对汇率的修改
  def rate_set
    render :update do |page|
      page.remove 'charge_rate'
      page.replace_html 'rate_set', :partial => 'rate',:object=>Money.find_by_code(params[:money_code]).rate
    end
  end  
  def new
    @charge=TbCharge.new()
    @charge.c_dt=Date.today()
    @charge.code=SysArg.get_0004
  end

  def create
    @charge=TbCharge.new(params[:charge])
    SysArg.set_0004(@charge.code)
    @charge.typ='a'
    @charge.u=session[:user_code]
    @charge.u_t=Time.now()
    if @charge.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"new",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end

  end
  
  def edit
    @charge=TbCharge.find(params[:id])
  end

  def update
    @charge=TbCharge.find(params[:id])
    if @charge.state==1 and @charge.typ=='a'
      if @charge.update_attributes(params[:charge])
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit",:search_condit=>params[:search_condit],:id=>params[:id],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
      end
    end
  end
  
  def edit_2
    @charge=TbCharge.find(params[:id])
  end
  
  def update_2
    @charge=TbCharge.find(params[:id])
    if @charge.state==2 or @charge.typ=='b'
      @charge.code=params[:charge][:code]
      if @charge.save
        TbCharge.update_all("code=#{@charge.code}","parent_id=#{@charge.id}")
        flash[:notice]="修改成功"
        redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice]="修改失败"
        render :action=>"edit_2",:search_condit=>params[:search_condit],:id=>params[:id],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
      end
    end
  end
  
  def delete
    @charge=TbCharge.find(params[:id])
    if @charge.state==1
      @charge.used="N"
      if @charge.save
        flash[:notice]="删除成功"
      else
        flash[:notice]="删除失败"
      end
      redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  def split_list
    @state={1=>"未确认",2=>"已确认",3=>"已召回"}
    if @order==nil or @order==""
      @order="id asc"
    end
    c="used='Y' and typ='c' and parent_id=#{params[:charge_id]}"
    @charge=TbCharge.find(params[:charge_id])
    @split_pages,@split=paginate(:tb_charges,:order=>@order,:conditions=>c)
  end
   
  def bill_change
    @c=TbCharge.find(params[:id])
    if @c.bill=="是"
      cc="bill='否'"
    else
      cc="bill='是'"
    end
    TbCharge.update_all(cc,["id=? or parent_id=?",params[:id],params[:id]])
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
  end
   
end
