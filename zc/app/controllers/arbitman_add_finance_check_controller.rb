class ArbitmanAddFinanceCheckController < ApplicationController
    def list
      @order=params[:order]
      if @order==nil or @order==""
        @order="id desc"
      end
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines= session[:lines]
      end
      @remind_pages,@remind=paginate(:tb_arbitmen,:conditions=>"sub_id>0 and (bank_check_u is null or bank_check_u = '')",:order=>@order,:per_page=>@page_lines.to_i)
    end

    def check
      @condi_s = params[:condi_k]
      arary_delay = @condi_s.split(",")
      begin
        arary_delay.each do |delayd|
          @remind = TbArbitman.find_by_id(delayd)
          @remind.bank_check_u = session[:user_code]
          @remind.bank_check_t = Time.now()
          @remind.save
        end
      rescue ActiveRecord::RecordNotSaved =>e
        flash[:notice] = "延期失败"
        render :action => "list_3",:page=>params[:page],:page_lines=>params[:page_lines]
      else
        flash[:notice] = "延期成功"
        redirect_to :action => "list",:page=>params[:page],:page_lines=>params[:page_lines]
      end
    end
    def list_2
      @order=params[:order]
      if @order==nil or @order==""
        @order="id desc"
      end
      @page_lines=params[:page_lines]
      if @page_lines==nil or @page_lines==""
        @page_lines= session[:lines]
      end
      @remind_pages,@remind=paginate(:tb_arbitmen,:conditions=>"sub_id>0 and bank_check_u is not null and bank_check_u <> ''",:order=>@order,:per_page=>@page_lines.to_i)
    end
end
