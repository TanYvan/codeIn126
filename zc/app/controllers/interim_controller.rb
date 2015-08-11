=begin
创建人：聂灵灵
创建时间：2009-5-8
类的描述：实体类是tb_interim,table是tb_interims
此类主要实现中间(部分)裁决的创建(interim下的interim_new页面)，
修改(interim下的interim_edit页面)，
删除(interim下的interim_list页面)功能,
以及interim下的interim_list页面中间(部分)裁决信息列表功能
=end
class InterimController < ApplicationController
  def interim_list
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
          c="recevice_code='#{session[:recevice_code]}' and used='Y'"
          @interim=TbInterim.find(:all,:order=>'id',:conditions=>c)
        end
    end
#添加中间(部分)裁决信息
      def interim_new
        @interim=TbInterim.new()
        @interim.rule_date=Date.today
        @interim.deliver_date=Date.today
        @interim.delivered_date=Date.today
        @interim.approval_date=Date.today
      end
     def interim_create
       @interim=TbInterim.new(params[:interim])
       @interim.recevice_code=session[:recevice_code]
       @interim.case_code=session[:case_code]
       @interim.general_code=session[:general_code]
       @interim.u=session[:user_code]
       @interim.u_t=Time.now()
       if @interim.save
          flash[:notice]="创建成功"
          redirect_to :action=>"interim_list"
       else
          flash[:notice]="创建失败"
          render :action=>"interim_new"
       end
    end
#修改中间(部分)裁决信息
  def interim_edit
     @interim=TbInterim.find(params[:id])
  end

  def interim_update
     @interim=TbInterim.find(params[:id])
     @interim.u=session[:user_code]
     @interim.u_t=Time.now()
     if @interim.update_attributes(params[:interim])
        flash[:notice]="修改成功"
        redirect_to :action=>"interim_list"
     else
        flash[:notice]="修改失败"
        render :action=>"interim_edit",:id=>params[:id]
     end
  end
#删除中间(部分)裁决信息
  def interim_delete
     @interim=TbInterim.find(params[:id])
     @interim.used="N"
     @interim.u=session[:user_code]
     @interim.u_t=Time.now()
     if @interim.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"interim_list"
  end

end
