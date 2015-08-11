#2009-7-20  niell   每一个案件在办案过程中都可以随时查看该案件的基本情况信息
class EveryCasebaseController < ApplicationController
  def case_doc
    #链接到发文
    redirect_to :controller=>"case_doc",:action=>"list",:recevice_code=>params[:recevice_code]
  end
   #下载庭审笔录
  def book_down
    @doc=CaseBook.find(:first,:conditions=>["used='Y' and p_id=? and typ='0001' and recevice_code=?",params[:p_id],params[:recevice_code]])
    @yea=params[:recevice_code].slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{params[:recevice_code]}/#{@doc.book_name}")
  end
  #裁决书下载查看
  def book_down2
    @doc=CaseBook.find(:first,:conditions=>["used='Y' and p_id=? and typ='0002' and book_typ=? and recevice_code=?",params[:p_id],params[:book_typ],params[:recevice_code]])
    @yea=params[:recevice_code].slice(0,4)
    name=TbCaseendbook.find(params[:p_id]).arbitBookNum
    if name==nil
      name='裁决书.doc'
    end
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{params[:recevice_code]}/#{@doc.book_name}",:filename=>"#{name}.doc")
  end
  #专家咨询文件下载
  def book_down3
    @doc=CaseBook.find(params[:id])
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.recevice_code.slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@doc.recevice_code}/#{@doc.book_name}")
  end
  def every_list
    @case=nil#当前办理案件
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    session[:case_code]=@case.case_code
    session[:recevice_code]=@case.recevice_code
    session[:general_code]=@case.general_code
    @case=TbCase.find_by_recevice_code(session[:recevice_code])
    #查出仲裁员
    @case_arbitmen =TbCasearbitman.find(:all,:conditions=>"used='Y' and recevice_code='#{session[:recevice_code]}'")
    @arr1=""
    if PubTool.new.get_first_record(@case_arbitmen)!=nil
      for a in @case_arbitmen
        @arbitmanname = TbArbitman.find(:first,:conditions=>["code=? and used='Y'",a.arbitman])
        if @arbitmanname != nil
          @arr1 += @arbitmanname.name+ " "
        end
      end
    end
    #助理
    if @case!=nil
      @zl = User.find(:first,:conditions=>["code=? and used='Y'",@case.clerk])
      if @zl!=nil
        @zl = @zl.name
      else
        @zl=""
      end
    end
    #结案方式
    caseendbook = TbCaseendbook.find(:first,:conditions=>["recevice_code='#{session[:recevice_code]}' and used='Y'"])
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
    @area11=""
    @area1 = TbParty.find(:all,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=1")
    @area1.each do|ar|
      if ar!=nil
        if ar.area!=nil
          @area11 = @area11 + Region.find_by_code(ar.area).name+"、"
        end
      else
        @area11 = ""
      end
    end
    if @area11!=""
      @area11=@area11.slice(0,@area11.length-3)
    end
    @area22=""
    @area2 = TbParty.find(:all,:order=>'id',:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y' and partytype=2")
    if PubTool.new.get_first_record(@area2)!= nil
      @area2.each do |ar2|
        if ar2.area !=nil
          @area22 = @area22 + Region.find_by_code(ar2.area).name+"、"
        end
      end
      if @area22!=""
        @area22=@area22.slice(0,@area22.length-3)
      end
    else
      @area22 = ""
    end
    #仲裁协议类型
    if @case!=nil
      record = TbDictionary.find(:first,:conditions=>"typ_code='0003' and data_val='#{@case.aribitprotprog_num}'")
      if record != nil
        @pro_tp = record.data_text
      else
        @pro_tp = " "
      end
      #仲裁类型
      arbit_record = TbDictionary.find(:first,:conditions=>"typ_code='0001' and data_val='#{@case.aribitprog_num}'")
      if arbit_record != nil
        @arbit_tp = arbit_record.data_text
      else
        @arbit_tp = " "
      end
    end
    #组庭日期
    case_org = TbCaseorg.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
    if case_org != nil
      @orgdate = case_org.orgdate
    else
      @orgdate = " "
    end
    #选定的制裁机构
    if @case!=nil
      arbit_agent = TbDictionary.find(:first,:conditions=>"typ_code='0004' and data_val='#{@case.agent}'")
      if arbit_agent != nil
        @arbit_agent = arbit_agent.data_text
      else
        @arbit_agent = " "
      end
    end
  end
  def file_down
    @file = CaseBook.find(params[:id])
    @yea = @file.recevice_code.slice(0,4)
    send_file("#{SysArg.find_by_code("8010").val}/casedocs/#{@yea}/#{@file.recevice_code}/#{@file.book_name}")
  end
  #主界面案件列表链接
  def list_all
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    if @search_condit==nil
      @search_condit=""
    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=-1 and state<200 and state<>3 and state<>2 and state<>100"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>"state desc",:per_page=>@page_lines.to_i)
  end
  def list_right_a
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="nowdate,case_code desc"
    end
    #未结案的案件
    c=" used='Y' and  clerk='#{session[:user_code]}' and state>=4 and  state<150  and  state<>100 and caseendbook_id_first is null"
    @case_pages,@case=paginate(:tb_cases,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
    @n1 = TbCase.count(:id,:conditions=>c)
    #已结案案件
    @page_lines2=params[:page_lines]
    if @page_lines2==nil or @page_lines2==""
      @page_lines2=session[:lines]
    end
    c2=" used='Y' and  clerk='#{session[:user_code]}' and state>=4 and  state<150  and  state<>100  and caseendbook_id_first is null and file_submit_u=''"
    @case_pages2,@case2=paginate(:tb_cases,:conditions=>c2,:order=>@order,:per_page=>@page_lines2.to_i)
    @n2 = TbCase.count(:id,:conditions=>c2)
  end
  def list_right_2
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    if @search_condit==nil
      @search_condit=""
    end
    c="used='Y' and clerk='#{session[:user_code]}' and state=4  and caseendbook_id_first is null"    
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
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    if @search_condit==nil
      @search_condit=""
    end
    @case_pages,@case=paginate_by_sql(TbCase,"select * from tb_cases where used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null and recevice_code not in (select recevice_code from tb_check_staffs where used='Y'  and typ='0001')  order by #{@order}",@page_lines.to_i)
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
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    if @search_condit==nil
      @search_condit=""
    end
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and state<100 and caseendbook_id_first is null and recevice_code in (select recevice_code from tb_check_staffs where used='Y')"
    @case_pages,@case=paginate_by_sql(TbCase,"select * from tb_cases where #{c} order by #{@order}",@page_lines.to_i)
  end
  def list_right_5
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=30
    end
    @order=params[:order]
    if @order==nil or @order==""
      @order="case_code desc"
    end
    @state={-1=>"重审",1=>"咨询",4=>"立案",5=>"组庭",6=>"开庭",100=>"终审",150=>"归档申请"}
    c="used='Y' and clerk='#{session[:user_code]}' and state>=4 and  state<150  and  state<>100 and caseendbook_id_first is null and file_submit_u=''"
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
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
  #结案未归档案件的修改
  def edit
    @case=nil#当前办理案件
    if params[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      if @case!=nil
        @t_typ=TbDictionary.find(:all,:conditions=>"typ_code='0043' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_val + " " + p.data_text,p.data_val]}
        @typ1=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent=''",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
        @typ2=TbDictionary.find(:all,:conditions=>"typ_code='0002' and state='Y' and data_parent='#{@case.casetype_num}'",:order=>'data_val',:select=>"data_val,data_text").collect{|p|[p.data_text,p.data_val]}
      end
    end
  end
  def update
    @case=TbCase.find_by_recevice_code(params[:recevice_code])
    if @case.update_attributes(params[:case])
      @case.case_code=@case.case_code.strip
      @case.general_code=@case.general_code.strip
      @case.save
      flash[:notice]="修改成功"
      redirect_to :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit",:search_condit=>params[:search_condit],:recevice_code=>params[:recevice_code],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
  #案件基本信息，包括财务信息
  def every_list_2
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
  
  
end
