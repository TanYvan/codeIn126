#2009-7-20  niell   每一个案件在办案过程中都可以随时查看该案件的基本情况信息
class EveryCasebaseController < ApplicationController
  def case_doc
    #发文session
#    session[:case_code_4]=params[:case_code]
#    session[:recevice_code]=params[:recevice_code]
#    session[:general_code_4]=params[:general_code]
    #链接到发文
    redirect_to :controller=>"case_doc",:action=>"list",:recevice_code=>params[:recevice_code]
  end
  def every_list
    @case=nil#当前办理案件
    if params[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      #查出仲裁员
      @case_arbitmen =TbCasearbitman.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
      @arr1=""
      for a in @case_arbitmen
        @arbitmanname = TbArbitman.find(:first,:conditions=>["code=? and used='Y'",a.arbitman])
        if @arbitmanname != nil
          @arr1 += @arbitmanname.name+ " "
        end
      end
      #助理
      @zl = User.find(:first,:conditions=>["code=? and used='Y'",@case.clerk])
      if @zl != nil
        @zl = @zl.name
      end
      #结案方式
      caseendbook = TbCaseendbook.find(:first,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
      if caseendbook != nil
        endcasestyle = caseendbook.endStyle
        @endstyle = TbDictionary.find(:first,:conditions=>"typ_code='8117' and data_val='#{endcasestyle}'")
        if @endstyle != nil
          @endstyle = @endstyle.data_text
        else
          @endstyle = " "
        end
      else
        @endstyle = " "
      end
      #申请人，被申请人地区
      @area1 = TbParty.find(:first,:order=>'id',:conditions=>["recevice_code=? and used='Y' and partytype=1",params[:recevice_code]])
      if @area1 != nil
        if @area1.area !=nil
          @area1 = Region.find_by_code(@area1.area).name
        else
          @area1 = " "
        end
      else
        @area1 = " "
      end
      @area2 = TbParty.find(:first,:order=>'id',:conditions=>["recevice_code=? and used='Y' and partytype=2",params[:recevice_code]])
      if @area2 != nil
        if @area2.area !=nil
          @area2 = Region.find_by_code(@area2.area).name
        else
          @area2 = " "
        end
      else
        @area2 = " "
      end
      #仲裁协议类型
      record = TbDictionary.find(:first,:conditions=>["typ_code='0003' and data_val=?",@case.aribitprotprog_num])
      if record != nil
        @pro_tp = record.data_text
      else
        @pro_tp = " "
      end
      #仲裁类型
      arbit_record = TbDictionary.find(:first,:conditions=>["typ_code='0001' and data_val=?",@case.aribitprog_num])
      if arbit_record != nil
        @arbit_tp = arbit_record.data_text
      else
        @arbit_tp = " "
      end
      #组庭日期
      case_org = TbCaseorg.find(:first,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
      if case_org != nil
        @orgdate = case_org.orgdate
      else
        @orgdate = " "
      end
      #选定的制裁机构
      arbit_agent = TbDictionary.find(:first,:conditions=>["typ_code='0004' and data_val=?",@case.agent])
      if arbit_agent != nil
        @arbit_agent = arbit_agent.data_text
      else
        @arbit_agent = " "
      end
      ######################################################################
      @reduction_pages,@reduction=paginate(:tb_reductions,:order=>'id',:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
    end
  end
  #主界面案件列表链接
  def list_all
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请"}
#    @hant_search_1_page_name="list_all"
#    @hant_search_1=['char','general_code',' 立案号','text',[]]
#    hant_search_1_word=params[:hant_search_1_word]
#    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
#    if hant_search_1_word == nil or hant_search_1_word ==""
#    else
#      @search_condit= " and " + hant_search_1_word
#    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=-1 and state<200 and state<>3 and state<>2"
#    p=PubTool.new()
#    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#      c = c + @search_condit
#    end
    
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>"state desc",:per_page=>@page_lines.to_i)
  end
  def list_right_1
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    @hant_search_1_page_name="list_all"
    @hant_search_1=['char','general_code',' 立案号','text',[]]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  def list_right_2
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
#    @hant_search_1_page_name="list_all"
#    @hant_search_1=['char','general_code',' 立案号','text',[]]
#    hant_search_1_word=params[:hant_search_1_word]
#    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
#    if hant_search_1_word == nil or hant_search_1_word ==""
#    else
#      @search_condit= " and " + hant_search_1_word
#    end
    c="used='Y' and clerk='#{session[:user_code]}' and state=4"
#    p=PubTool.new()
#    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#      c = c + @search_condit
#    end
    
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  def list_right_3
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请"}
#    @hant_search_1_page_name="list_all"
#    @hant_search_1=['char','general_code',' 立案号','text',[]]
#    hant_search_1_word=params[:hant_search_1_word]
#    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
#    if hant_search_1_word == nil or hant_search_1_word ==""
#    else
#      @search_condit= " and " + hant_search_1_word
#    end
    c=""
#    p=PubTool.new()
#    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#      c = c + @search_condit
#    end
    @case_pages,@case=paginate_by_sql(TbCase,"select * from tb_cases where used='Y' and clerk='#{session[:user_code]}' and state=5 and recevice_code not in (select recevice_code from tb_check_staffs where used='Y' )  order by #{@order}",@page_lines.to_i)
  end
  def list_right_4
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"结案",150=>"归档申请"}
#    @hant_search_1_page_name="list_all"
#    @hant_search_1=['char','general_code',' 立案号','text',[]]
#    hant_search_1_word=params[:hant_search_1_word]
#    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
#    if hant_search_1_word == nil or hant_search_1_word ==""
#    else
#      @search_condit= " and " + hant_search_1_word
#    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=-1 and state<200 and state<>3 and state<>2"
#    p=PubTool.new()
#    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
#      c = c + @search_condit
#    end
    @case_pages,@case=paginate_by_sql(TbCase,"select * from tb_cases where used='Y' and clerk='#{session[:user_code]}' and state>=4  and state<100 and recevice_code in (select recevice_code from tb_check_staffs where used='Y') order by #{@order}",@page_lines.to_i)
  end
  
  def every_list_a
    @case=nil#当前办理案件
    if params[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      if (@case.clerk==session[:user_code] or @case.clerk_2==session[:user_code]) and (@case.state>=4 and @case.state<=150)
        session[:case_code]=@case.case_code
        session[:recevice_code]=@case.recevice_code
        session[:general_code]=@case.general_code
        
        #查出仲裁员
        @case_arbitmen =TbCasearbitman.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]])
        @arr1=""
        for a in @case_arbitmen
          @arbitmanname = TbArbitman.find(:first,:conditions=>["code=? and used='Y'",a.arbitman])
          if @arbitmanname != nil
            @arr1 += @arbitmanname.name+ " "
          end
        end
        #助理
        @zl = User.find(:first,:conditions=>["code=? and used='Y'",@case.clerk])
        if @zl != nil
          @zl = @zl.name
        end
        #结案方式
        caseendbook = TbCaseendbook.find(:first,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
        if caseendbook != nil
          endcasestyle = caseendbook.endStyle
          @endstyle = TbDictionary.find(:first,:conditions=>"typ_code='8117' and data_val='#{endcasestyle}'")
          if @endstyle != nil
            @endstyle = @endstyle.data_text
          else
            @endstyle = " "
          end
        else
          @endstyle = " "
        end
        #申请人，被申请人地区
        @area1 = TbParty.find(:first,:order=>'id',:conditions=>["recevice_code=? and used='Y' and partytype=1",params[:recevice_code]])
        if @area1 != nil
          if @area1.area !=nil
            @area1 = Region.find_by_code(@area1.area).name
          else
            @area1 = " "
          end
        else
          @area1 = " "
        end
        @area2 = TbParty.find(:first,:order=>'id',:conditions=>["recevice_code=? and used='Y' and partytype=2",params[:recevice_code]])
        if @area2 != nil
          if @area2.area !=nil
            @area2 = Region.find_by_code(@area2.area).name
          else
            @area2 = " "
          end
        else
          @area2 = " "
        end
        #仲裁协议类型
        record = TbDictionary.find(:first,:conditions=>["typ_code='0003' and data_val=?",@case.aribitprotprog_num])
        if record != nil
          @pro_tp = record.data_text
        else
          @pro_tp = " "
        end
        #仲裁类型
        arbit_record = TbDictionary.find(:first,:conditions=>["typ_code='0001' and data_val=?",@case.aribitprog_num])
        if arbit_record != nil
          @arbit_tp = arbit_record.data_text
        else
          @arbit_tp = " "
        end
        #组庭日期
        case_org = TbCaseorg.find(:first,:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
        if case_org != nil
          @orgdate = case_org.orgdate
        else
          @orgdate = " "
        end
        #选定的制裁机构
        arbit_agent = TbDictionary.find(:first,:conditions=>["typ_code='0004' and data_val=?",@case.agent])
        if arbit_agent != nil
          @arbit_agent = arbit_agent.data_text
        else
          @arbit_agent = " "
        end
        ######################################################################
        @reduction_pages,@reduction=paginate(:tb_reductions,:order=>'id',:conditions=>["recevice_code=? and used='Y'",params[:recevice_code]])
      end
    end
  end
  
  
end
