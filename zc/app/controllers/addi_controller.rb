class AddiController < ApplicationController
  # 2010-9-1  niell 
  #立案后助理是当前助理，或接待为当前助理的案件而没有立案
  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','case_code','立案号','text',[]],['char','recevice_code','咨询号','text',[]]]
    @order=params[:order]
    if @order==nil or @order==""
      @order="recevice_code desc"
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
    c="(state>=4 and state<100 and clerk='#{session[:user_code]}' and used='Y') or (state=1 and clerk_2='#{session[:user_code]}' and used='Y')"#未结案
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @case_pages,@case=paginate(:tb_cases,:order=>@order,:conditions=>c,:per_page=>@page_lines.to_i)
  end
  def list_1
    @party = TbParty.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]],:order=>"partytype,id")
    @tbagent = TbAgent.find(:all,:conditions=>["used='Y' and recevice_code=?",params[:recevice_code]],:order=>"partytype,id")
  end
  def list_2
    @condi_k = params[:condi_k]
    array_con = @condi_k.split(",")
    @arr1=[]
    @arr2=[]
    begin
      i=1
      j=1
      array_con.each do |con|
        if con.slice(0,1)=="a"
          @arr1[i]=TbParty.find(:first,:conditions=>["used='Y' and id=?",con.slice(1,con.length.to_i)])
          i+=1
        elsif con.slice(0,1)=="b"
          @arr2[j]=TbAgent.find(:first,:conditions=>["used='Y' and id=?",con.slice(1,con.length.to_i)])
          j+=1
        else
        end
        
      end
    rescue ActiveRecord::RecordNotSaved =>e
    else
    end
  end
end
