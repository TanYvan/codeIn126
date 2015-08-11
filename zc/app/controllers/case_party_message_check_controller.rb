class CasePartyMessageCheckController < ApplicationController
  def list
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c = "recevice_code='#{session[:recevice_code]}' and u='' and used='Y'"
      @messyn_pages,@mes=paginate(:party_message,:order=>"id asc",:conditions=>c,:per_page=>100000)
    end
  end

  def list_2
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c = "recevice_code='#{session[:recevice_code]}' and u<>'' and used='Y'"
      @mes_pages,@mes=paginate(:party_message,:order=>"id asc",:conditions=>c,:per_page=>100000)
    end
  end

  def check
    if session[:recevice_code]==nil
    else
      @condi_k = params[:condi_k]
      #array_con = @condi_k.split(",")
      mes = PartyMessage.find(:all, :conditions =>"id in (#{@condi_k})", :order=> "id asc")
      begin
       mes.each do |m| 
          m.u=session[:user_code]
          m.u_t=Time.now()
          m.save
        end
      rescue ActiveRecord::RecordNotSaved =>e
        flash[:notice] = "批量操作失败！"
        redirect_to :action => "list"
      else
        flash[:notice] = "批量操作成功！"
        redirect_to :action => "list"
      end
    end
  end

end
