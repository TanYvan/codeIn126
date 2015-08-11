require 'json'
class ArbitmanSynFinanceCheckController < ApplicationController
  def list
    @item_type = {"arbitman_sub" => "基本信息", "educate_sub" => "教育信息", "industry_sub" => "行业信息", "resume_sub" => "简历信息", "language_sub" => "语音信息"}

    @change_type = {1=>"新增", 2=>"修改", 3=>"删除"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]],['date','receivedate','咨询日期','text',[]],['number','amount','争议金额','text',[]],['char',' recevice_code) in (select recevice_code  from  tb_parties where partyname','当事人名称(不能联合查询)','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
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
    c = "status=0 and syn_type='02' "
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @syn_pages,@syn=paginate(:arbitman_syn,:order=>"id asc",:conditions=>c,:per_page=>@page_lines.to_i)
  end

  def list_2
    @item_type = {"arbitman_sub" => "基本信息", "educate_sub" => "教育信息", "industry_sub" => "行业信息", "resume_sub" => "简历信息", "language_sub" => "语音信息"}
    @change_type = {1=>"新增", 2=>"修改", 3=>"删除"}
    @action_type = {1=>"同步", 0=>"不同步"}
    @hant_search_1_page_name="list_2"
    @hant_search_1=[['char','arbitman_name','仲裁员姓名','text',[]],['date','change_time','修改时间','text',[]]]
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

    p=PubTool.new()
    c = "status=1 and syn_type='02' "
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @syn_pages,@syn=paginate(:arbitman_syn,:order=>"id desc",:conditions=>c,:per_page=>@page_lines.to_i)
  end

  def syn_yes
    @condi_k = params[:condi_k]
    #array_con = @condi_k.split(",")
    syn = ArbitmanSyn.find(:all, :conditions =>"id in (#{@condi_k})", :order=> "id asc")
    begin
      syn.each do |arb|
        if arb.status == 0
          if arb.change_type == 1
            sub = get_sub(arb.item_type, arb.sub_id)
            orig = get_orig(arb.item_type, 0)
            j = "{"+ arb.change_after + "}"
            j.gsub!(",}","}")
            result = JSON.parse(j)
            orig.attributes = result
            orig.sub_id = arb.sub_id
            orig.used = "Y"
            orig.save
            sub.p_id = orig.id
            sub.save
          elsif arb.change_type == 2
            #sub = get_sub(arb.item_type, arb.sub_id)
            orig = get_orig(arb.item_type, arb.sub_id)
            orig.attributes = {arb.item => arb.change_after}
            orig.save
          elsif  arb.change_type == 3
            orig = get_orig(arb.item_type, arb.sub_id)
            orig.used="N"
            orig.save
          end
        end
        arb.status = 1
        arb.action_type = 1
        arb.action_time = Time.now()
        arb.save

        remind = RemindIn.new
        remind.status = 0
        remind.remind_type = "01"
        remind.content = get_syn_text(arb.id)
        remind.accept_user_type = "arbitman"
        remind.accept_user = arb.arbitman
        remind.remind_time = Time.now()
        remind.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "批量操作失败！"
      redirect_to :action => "list"
    else
      flash[:notice] = "批量操作成功！"
      redirect_to :action => "list"
    end
  end

  def syn_no
    @condi_k = params[:condi_s]
    #array_con = @condi_k.split(",")
    syn = ArbitmanSyn.find(:all, :conditions =>"id in (#{@condi_k})", :order=> "id asc")
    begin
      syn.each do |arb|
        if arb.status == 0
          if arb.change_type == 1
            sub = get_sub(arb.item_type, arb.sub_id)
            sub.used = "N"
            sub.save
          elsif arb.change_type == 2
            sub = get_sub(arb.item_type, arb.sub_id)
            sub.attributes = {arb.item => arb.change_before}
            sub.save
          elsif  arb.change_type == 3
            sub = get_sub(arb.item_type, arb.sub_id)
            sub.used = "Y"
            sub.save
          end
        end
        arb.status = 1
        arb.action_type = 0
        arb.action_time = Time.now()
        arb.save

        remind = RemindIn.new
        remind.status = 0
        remind.remind_type = "01"
        remind.content = get_syn_text(arb.id)
        remind.accept_user_type = "arbitman"
        remind.accept_user = arb.arbitman
        remind.remind_time = Time.now()
        remind.save
      end
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice] = "批量操作失败！"
      redirect_to :action => "list"
    else
      flash[:notice] = "批量操作成功！"
      redirect_to :action => "list"
    end
  end


  def get_sub(sub, id)
    a=""
    if sub == "arbitman_sub"
      if id==0
        a = ArbitmanSub.new
      else
        a = ArbitmanSub.find(id)
      end
    elsif sub == "educate_sub"
      if id==0
        a = EducateSub.new
      else
        a = EducateSub.find(id)
      end
    elsif sub == "industry_sub"
      if id==0
        a = IndustrySub.new
      else
        a = IndustrySub.find(id)
      end
    elsif sub == "resume_sub"
      if id==0
        a = ResumeSub.new
      else
        a = ResumeSub.find(id)
      end
    elsif sub == "language_sub"
      if id==0
        a = LanguageSub.new
      else
        a = LanguageSub.find(id)
      end
    end
    return a
  end

  def get_orig(orig, sub_id)
    a=""
    if orig == "arbitman_sub"
      if sub_id==0
        a = TbArbitman.new
      else
        a = TbArbitman.find_by_sub_id(sub_id)
      end
    elsif orig == "educate_sub"
      if sub_id==0
        a = TbEducate.new
      else
        a = TbEducate.find_by_sub_id(sub_id)
      end
    elsif orig == "industry_sub"
      if sub_id==0
        a = Industry.new
      else
        a = Industry.find_by_sub_id(sub_id)
      end
    elsif orig == "resume_sub"
      if sub_id==0
        a = TbResume.new
      else
        a = TbResume.find_by_sub_id(sub_id)
      end
    elsif orig == "language_sub"
      if sub_id==0
        a = TbLanguage.new
      else
        a = TbLanguage.find_by_sub_id(sub_id)
      end
    end
    return a
  end

  def get_syn_text(id)
    @item_type = {"arbitman_sub" => "基本信息", "educate_sub" => "教育信息", "industry_sub" => "行业信息", "resume_sub" => "简历信息", "language_sub" => "语音信息"}
    @change_type = {1=>"新增", 2=>"修改", 3=>"删除"}
    @a = {1 => "仲裁员信息审核通过:", 0 =>"仲裁员信息审核不通过:"}
    r=""
    syn = ArbitmanSyn.find(id)
    syn.change_after_text = "" unless syn.change_after_text
    syn.change_before_text = "" unless syn.change_before_text
    if syn.change_type == 1
      r = r + @a[syn.action_type] + @item_type[syn.item_type] + " " + @change_type[syn.change_type] + " [" + syn.change_after_text + "]"
    elsif syn.change_type == 2
      r = r + @a[syn.action_type] + @item_type[syn.item_type] + " " + @change_type[syn.change_type]+ " [" + syn.change_before_text + "]" + "改为" + " [" + syn.change_after_text + "]"
    elsif  syn.change_type == 3
      r = r + @a[syn.action_type] + @item_type[syn.item_type] + " " + @change_type[syn.change_type] + " [" + syn.change_after_text + "]"
    end
    return r
  end
  
end
