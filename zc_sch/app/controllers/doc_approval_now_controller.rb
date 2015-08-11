class DocApprovalNowController < ApplicationController
  def list
    @state={-1=>"待重新审批",0=>"待审批",1=>"批准",2=>"不批准",3=>"需要修改"}
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','recevice_code','咨询流水号','text',[]],['char','send_serial_code','发文流水号','text',[]],['char','send_code','发文编号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="file_code desc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
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
    c="a_u='#{session[:user_code]}' and (state=0 or state=-1)"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @approval_pages,@approval=paginate(:tb_doc_approvals,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  
  def vie_word
    appr=TbDocApproval.find(params[:id])
    @doc=TbDoc.find(appr.doc_id)
    @case=TbCase.find_by_recevice_code(@doc.recevice_code)
    @yea=@case.receivedate.to_s.slice(0,4)
    @file_path=SysArg.find_by_code('8002').val+"\\\\"+ @yea + "\\\\" +@doc.recevice_code + "\\\\" + @doc.file_name
  end
  
  def vie
    @a=TbDocApproval.find(params[:id])
    if @a.a_u==session[:user_code]
      @doc=TbDoc.find(@a.doc_id)
      @case=TbCase.find_by_recevice_code(@doc.recevice_code)
      @yea=@case.receivedate.to_s.slice(0,4)
      #########################################
      @doc_path="http://#{SysArg.find_by_code('9000').val}:#{SysArg.find_by_code('9001').val}/fdocs/#{@yea}/#{@doc.recevice_code}/#{@doc.file_name}"
    end
  end
  
  def edit
    @state={"1"=>"批准","2"=>"不批准","3"=>"需要修改"}
    @a=TbDocApproval.find(params[:id])
  end
  
  def update
    @a=TbDocApproval.find(params[:id])
    if @a.a_u==session[:user_code]
      @a.update_attributes(params[:a])
      @a.t=Time.now()
      @a.state=params[:state]
      if @a.save 
        flash[:notice]="成功"
      else
        flash[:notice]="失败"
      end
      redirect_to :action=>"list",:order=>params[:order],:page=>params[:page],:search_condit=>params[:search_condit],:page_lines=>params[:page_lines]
    end
  end

end
