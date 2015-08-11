class TExtendController < ApplicationController
  
  def list
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','case_code','立案号','text',[]],['char','end_code','结案号','text',[]],['char','general_code','总案号','text',[]],['char','recevice_code','咨询流水号','text',[]],['char','p_name','姓名','text',[]]]
    @hant_search_1_list=['case_code','end_code','general_code','recevice_code','p_name']
#    @order=params[:order]
#    if @order==nil or @order==""
#      @order="recevice_code desc"
#    end
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="t_extend_code='' and used='Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions => c,:order=>"case_code,p_typ,p_name,typ",:per_page=>1000000000)   
  end
  
  def recall
    @te=TbExtend.find(params[:id])
    if @te.typ=='1'
      @td=TbBonusPenalty.find_by_extend_id(@te.id)
    elsif @te.typ=='2' or @te.typ=='3'
      @td=TbDeduction.find_by_extend_id(@te.id)
    elsif @te.typ=='4' or @te.typ=='5'
      @td=TbRemuneration23.find_by_extend_id(@te.id)
    end
    @td.extend_code=''
    @td.extend_u=session[:user_code]
    @td.extend_t=Time.now()
    @td.extend_id=0
    if @td.save
      @te.used='N'
      @te.save
      flash[:notice]="取消待发成功"
    else
      flash[:notice]="取消待发失败"
    end
    
    redirect_to :action=>"list",:search_condit=>params[:search_condit],:page=>params[:page],:order=>params[:order]
  end
  
  def extend_do
    condi=params[:condi]
    remark=params[:remark]
    
    p=PubTool.new()
    if p.sql_check_3(condi)!=false and p.sql_check_3(remark)!=false
      
      extend_code=''
      t=Time.now
      tax=Tax.new

      if condi!=nil and  condi!=""
        extend_code=SysArg.add_0006
        #存储发放编码相关信息
        extend_c=TbTExtendCode.new()
        extend_c.t_extend_code=extend_code
        extend_c.u=session[:user_code]
        extend_c.remark=remark
        extend_c.t=t
        extend_c.save

        con=condi.split(",")
        con.each{|co|
          ex=TbExtend.find(co.to_i)  
          ex.t_extend_code=extend_c.t_extend_code
          ex.t_extend_u=extend_c.u
          ex.t_extend_t=extend_c.t
          ex.save
        }

      end
      
      @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
      
      @tef=TbExtend.find_by_sql("select  distinct p_typ,p,p_name from tb_extends where t_extend_code='#{extend_code}'")
      for tef in @tef
        @tbs=TbSmsAlert.new()
        @tbs.used='Y'
        @tbs.typ='0001'
        @tbs.content_id="#{extend_code}-#{tef.p_typ}-#{tef.p}-#{tef.p_name}"
        @tbs.p_typ=tef.p_typ
        @tbs.p=tef.p
        @tbs.p_name=tef.p_name
        if tef.p_typ=='0001'
          @tbs.mobiletel=TbArbitman.find_by_code(tef.p).mobiletel
        else
          @tbs.mobiletel=User.find_by_code(tef.p).mobiletel
        end
        @tef_2=TbExtend.find_by_sql("select  distinct case_code from tb_extends where t_extend_code='#{extend_code}' and p_typ='#{tef.p_typ}' and p='#{tef.p}' and p_name='#{tef.p_name}' order by case_code")
        contents=""
        for tef_2 in @tef_2
          contents=contents + "#{tef_2.case_code}案:"
          @tef_tef=TbExtend.find_by_sql("select * from tb_extends where t_extend_code='#{extend_code}' and case_code='#{tef_2.case_code}' and p_typ='#{tef.p_typ}' and p='#{tef.p}' and p_name='#{tef.p_name}' order by typ")
          for tef_tef in @tef_tef
            if tef_tef.typ=='4' or tef_tef.typ=='5'
              contents=contents + "#{TbDictionary.find(:first,:conditions=>"typ_code='0050' and data_val='#{TbRemuneration23.find_by_extend_id(tef_tef.id).typ}'").data_text}实发#{tef_tef.extend_rmb}元，"
            else
              contents=contents + "#{@typ2[tef_tef.typ]}实发#{tef_tef.extend_rmb}元，"
            end
          end
          contents=contents + "已经发放，请查收。"
        end
        @tbs.contents=contents
        @tbs.send_state=100
        @tbs.c_t=Time.now()
        @tbs.save
      end
      
      flash[:notice]="#{extend_code}发放成功"
      redirect_to :action=>'list'
      
    end
    
  end
  
  #某个报酬发放编码下的报酬发放列表
  def list_extend
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    c="used='Y' and t_extend_code=''"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>c,:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
    a=SysArg.add_0006_next
    @title="#{a.slice(0,4).to_i}年#{a.slice(4,2).to_i}月第#{a.slice(6,3).to_i}批办案报酬明细表"
  end
  
  def list_extend_a
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    c="bank_typ='0001' and used='Y' and t_extend_code=''"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>c,:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
    a=SysArg.add_0006_next
    @title="#{a.slice(0,4).to_i}年#{a.slice(4,2).to_i}月第#{a.slice(6,3).to_i}批办案报酬明细表(本地)"
  end
  
  def list_extend_b
    @bank_typ={"0001"=>"本地","0002"=>"外地"}
    @typ2={"1"=>"报酬","2"=>"奖励","3"=>"扣减","4"=>"办案其它报酬","5"=>"出差补助合计"}
    @p_typ2={"0001"=>"仲裁员","0002"=>"助理","0003"=>"校核人员","0004"=>"员工"}
    c="bank_typ<>'0001' and used='Y' and t_extend_code=''"
    @extend_pages,@tb_extends =paginate(:tb_extends,:conditions =>c,:order=>"case_code,p_typ,p_name,typ",:per_page=>10000000)
    a=SysArg.add_0006_next
    @title="#{a.slice(0,4).to_i}年#{a.slice(4,2).to_i}月第#{a.slice(6,3).to_i}批办案报酬明细表(外地)"
  end
  
  
end
