#显示报酬发放信息的控制器
#添加人 苏获
#添加时间 20090527
class ShowExtendController < ApplicationController
  #显示所有的报酬发放的列表 外单位仲裁员
  def list_extend_code
    @last_code = SysArg.find_by_code('0006').val
    @hant_search_1_page_name="list_extend_code"
    @hant_search_1=[['char','t_extend_code','发放编号','text',[]],['char','remark','备注','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    p=PubTool.new()
    c="used='Y' "
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @extend_code_pages,@extend_codes =paginate(:tb_t_extend_codes,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
 end

  # 撤销本批次发放的所有报酬
  def cancel
    @extend_codes = TbTExtendCode.find(params[:id])
    if @extend_codes.t_extend_code == SysArg.find_by_code('0006').val
      @tef=TbExtend.update_all("t_extend_code = ''", ["t_extend_code=? and used = 'Y' ",@extend_codes.t_extend_code])
      @extend_codes.used='N'
      @extend_codes.u=session[:user_code]
      @extend_codes.t=Time.now()
      if @extend_codes.save
        SysArg.reduce_0006
        flash[:notice]="#{@extend_codes.t_extend_code}删除成功"
      else
        flash[:notice]="#{@extend_codes.t_extend_code}删除失败"
      end
      redirect_to :action=>"list_extend_code"
    end
  end

  #某个报酬发放编码下的报酬发放列表
  def list_extend
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"id",:per_page=>10000000)#case_code,p_typ,p_name,typ
  end
  def extend_edit
     @tb_extend=TbExtend.find(params[:id])
  end
  def extend_update
     @tb_extend=TbExtend.find(params[:id])
     if @tb_extend.update_attributes(params[:tb_extend])
        @tb_extend.t_extend_u=session[:user_code]
        @tb_extend.t_extend_t=Time.now()
        @tb_extend.save
        flash[:notice]="修改成功"
        redirect_to :action=>"extend_edit",:id=>params[:id]
     else
        render :action=>"extend_edit",:id=>params[:id]
     end
  end
  def list_extend_a
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ='0001' and used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"id",:per_page=>10000000)#case_code,p_typ,p_name,typ
  end

  def list_extend_b
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ<>'0001' and used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>[c,t_extend_code],:order=>"id",:per_page=>10000000)#case_code,p_typ,p_name,typ
  end

  # 导出银行 excel 表格
  def list_extend_c
    t_extend_code = params[:t_extend_code]
    @bank_type = params[:bank_type]
    @rmb = params[:rmb]
    if @bank_type == "0001"
      c = " bank_typ='0001' and used='Y' and t_extend_code=? "
      c = c + " and extend_rmb > #{@rmb}" unless @rmb.blank?
    else
      c = "bank_typ<>'0001' and used='Y' and t_extend_code=?"
      c = c + " and extend_rmb > #{@rmb}" unless @rmb.blank?
    end

    @tb_extends =TbExtend.find(:all,:conditions => [c,t_extend_code], :order => "id")#case_code,p_typ,p_name,typ
  end

  def list_extend_d
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="bank_typ='0002' and used='Y' and t_extend_code=?"
    @tb_extends =TbExtend.find_by_sql(["select bankname,bank_account,p_name,extend_rmb from tb_extends where  bank_typ='0002' and used='Y' and t_extend_code=? order by  id",t_extend_code])#bankname,bank_account,p_name,p
  end

  def list_extend_e
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @tb_extends =TbExtend.find_by_sql(["select distinct t_extend_code,bankname,bank_account,p,p_name,email from tb_extends where  used='Y' and t_extend_code=? order by  id",t_extend_code])#p_name,p,bankname,bank_account
  end

  def list_extend_f
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    #c="used='Y' and t_extend_code=?"
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @tb_extends =TbExtend.find_by_sql(["select distinct bankname,bank_account,p,p_name,email from tb_extends where  used='Y' and (bank_typ='0003' or bank_typ='0004') and t_extend_code=? order by  id",t_extend_code])#p_name,p,bankname,bank_account
  end

  def list_extend_g
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    #c="used='Y' and t_extend_code=?"
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @tb_extends =TbExtend.find_by_sql(["select distinct t_extend_code,bankname,bank_account,p,p_name,email from tb_extends where  used='Y' and bank_typ='0005' and t_extend_code=?  order by  id",t_extend_code])#p_name,p,bankname,bank_account
  end

  def list_extend_h
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @tb_extends =TbExtend.find_by_sql(["select distinct t_extend_code,bankname,bank_account,p,p_name,email  from tb_extends where typ<>'5' and  used='Y' and t_extend_code=? order by  id",t_extend_code])#p_name,p,bankname,bank_account
  end

  def list_extend_k
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @p_extends =TbExtend.find_by_sql(["select distinct t_extend_code,p,p_name from tb_extends where typ<>'5' and  used='Y' and t_extend_code=? order by  id,recevice_code",t_extend_code])#p_name,p,bankname,bank_account
  end
  
  def list_extend_tax
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code = params[:t_extend_code]
    c = "used='Y' and t_extend_code=?"
    @tb_extends = TbExtend.find(:all,:conditions =>[c,t_extend_code],:order=>"id")#case_code,p_typ,p_name,typ
    tim = @tb_extends.first.t_extend_t
    extend_t = tim.year.to_s + "年" + tim.month.to_s + "月"
    @tablename = "#{extend_t}（发放批次:#{t_extend_code}）扣税总表"
  end

  # 导出本次发放的全部感谢函
  def gxh
    @person = TbExtend.find(:all, :conditions => ["used='Y' and t_extend_code=?", params[:t_extend_code]],:select =>"distinct t_extend_code,p_typ,p,p_name,bank_account,bankname ",:order=>"id")
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
  end
  
  # 导出本次发放的某一个人的感谢函
  def gxh_self
    params[:t_extend_code] = "" unless params[:t_extend_code]
    params[:bankname] = "" unless params[:bankname]
    params[:bank_account] = "" unless params[:bank_account]
    params[:p] = "" unless params[:p]
    params[:p_name] = "" unless params[:p_name]
    params[:email] = "" unless params[:email]
    @person = TbExtend.find(:all, :conditions => ["used='Y' and t_extend_code=? and bankname=? and bank_account=? and p=? and p_name=? and email=?", params[:t_extend_code],params[:bankname],params[:bank_account],params[:p],params[:p_name],params[:email]],:select =>"distinct t_extend_code,p_typ,p,p_name,bank_account,bankname ",:order=>"id")
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    render :action=>"gxh"
  end

  # 导出地址
  def address
    @person = TbExtend.find(:all, :conditions => ["used='Y' and t_extend_code=?", params[:t_extend_code]],:select =>"distinct t_extend_code,p_typ,p,p_name ",:order=>"id")
  end

  # 生成代开发票清单
  def invoice
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @extend = TbExtend.find(:all, :conditions => ["used='Y' and t_extend_code=? and tax_rmb<>0", params[:t_extend_code]],:select =>" should_rmb, t_extend_code,p_typ,p,p_name,id_card,tax_base_rmb ",:order=>"id")
    send_data(render,:type => "application/msword",:filename=> Iconv.iconv('gbk','utf-8',"代开发票清单.doc").to_s, :disposition => 'attachment')
  end


    # 导出感谢函
  def gxh_h
    @person = TbExtend.find(:all, :conditions => ["used='Y' and typ<>'5' and t_extend_code=?", params[:t_extend_code]],:select =>"distinct t_extend_code,p_typ,p,p_name,bank_account,bankname ",:order=>"id")
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
  end

  # 导出地址
  def address_h
    @person = TbExtend.find(:all, :conditions => ["used='Y' and typ<>'5' and t_extend_code=?", params[:t_extend_code]],:select =>"distinct t_extend_code,p_typ,p,p_name ",:order=>"id")
  end

  # 生成代开发票清单
  def invoice_h
    @extend_code=TbTExtendCode.find_by_t_extend_code(params[:t_extend_code])
    @extend = TbExtend.find(:all, :conditions => ["used='Y' and typ<>'5' and t_extend_code=?  and tax_rmb<>0", params[:t_extend_code]],:select =>" should_rmb, t_extend_code,p_typ,p,p_name,id_card,tax_base_rmb ",:order=>"id")
    send_data(render,:type => "application/msword",:filename=> Iconv.iconv('gbk','utf-8',"代开发票清单.doc").to_s, :disposition => 'attachment')
  end

    #显示所有的报酬发放的列表 本单位仲裁员及员工
  def list_extend_code_2
    @last_code = SysArg.find_by_code('0006_1').val
    @hant_search_1_page_name="list_extend_code_2"
    @hant_search_1=[['char','t_extend_code','发放编号','text',[]],['char','remark','备注','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= session[:lines]
    end
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @hant_search_1_text=params[:hant_search_1_text]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    p=PubTool.new()
    c="used='Y' "
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @extend_code_pages,@extend_codes =paginate(:tb_self_t_extend_codes,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
 end

 
  #某个报酬发放编码下的报酬发放列表
  def list_extend_2
    #@bank_typ={"0001"=>"本地","0002"=>"外地"}
    @bank_typ = {}
    TbDictionary.find(:all,:conditions=>"typ_code='8201'").each{|bbb|  @bank_typ.merge!({bbb.data_val => bbb.data_text})}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    t_extend_code=params[:t_extend_code]
    c="used='Y' and t_extend_code=?"
    @extend_pages,@tb_extends =paginate(:tb_self_extends,:conditions =>[c,t_extend_code],:order=>"id",:per_page=>10000000)#case_code,p_typ,p_name,typ
  end


    # 撤销本批次发放的所有报酬
  def cancel_2
    @extend_codes = TbSelfTExtendCode.find(params[:id])
    if @extend_codes.t_extend_code == SysArg.find_by_code('0006_1').val
      @tef=TbSelfExtend.update_all("t_extend_code = ''", ["t_extend_code=? and used = 'Y' ",@extend_codes.t_extend_code])
      @extend_codes.used='N'
      @extend_codes.u=session[:user_code]
      @extend_codes.t=Time.now()
      if @extend_codes.save
        SysArg.reduce_0006_1
        flash[:notice]="#{@extend_codes.t_extend_code}删除成功"
      else
        flash[:notice]="#{@extend_codes.t_extend_code}删除失败"
      end
      redirect_to :action=>"list_extend_code_2"
    end
  end
  
end
