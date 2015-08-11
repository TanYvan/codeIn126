=begin
创建人：聂灵灵
创建时间：2009-7-1
类的描述：办理案件下合同签订信息。
页面：
合同信息列表:/compact/compact_list
创建合同信息信息:/compact/compact_new
修改合同信息信息:/compact/compact_edit
=end
class CompactController < ApplicationController
  def con_list
    @case=nil#当前办理案件
    if session[:recevice_code]==nil
    else
      @case=TbCase.find_by_recevice_code(session[:recevice_code])
      c="recevice_code='#{session[:recevice_code]}' and used='Y'"
      if @order==nil or @order==""
        @order="id asc"
      end
#      p=PubTool.new()
#      if p.sql_check(params[:recevice_code])!=false
      @con=TbContractsign.find(:all,:conditions=>c,:order=>"id")
#      end
    end
  end

  def con_new
    @con=TbContractsign.new()
    @con.contractdate=TbCase.find_by_recevice_code(params[:recevice_code]).acceptt
    @con.pactname=TbCase.find_by_recevice_code(params[:recevice_code]).casereason
  end

  def con_create
    @con=TbContractsign.new(params[:con])
    @con.recevice_code=params[:recevice_code]
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="创建成功"
      redirect_to :action=>"con_list"
    else
      flash[:notice]="创建失败"
      render :action=>"con_new"
    end

  end

  def con_edit
    @con=TbContractsign.find(params[:id])
  end

  def con_update
    @con=TbContractsign.find(params[:id])
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.update_attributes(params[:con])
      flash[:notice]="修改成功"
      redirect_to :action=>"con_list",:id=>params[:id]
    else
      flash[:notice]="修改失败"
      render :action=>"con_edit",:id=>params[:id]
    end
  end

  def con_delete
    @con=TbContractsign.find(params[:id])
    @con.used="N"
    @con.u=session[:user_code]
    @con.u_t=Time.now()
    if @con.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"con_list"
  end
end
