=begin
创建人：聂灵灵
创建时间：2009-5-12
类的描述：此控制器是处理补充裁决页面的信息。首先判断是否有案件，若无可以选择案件，并在相应案件下创建补充裁决书更正信息及修改删除补充裁决书更正信息。
页面：
补充裁决书更正信息列表:/addarbit/addarbit_list
创建补充裁决书更正信息：/addarbit/addarbit_new
修改补充裁决书更正信息：/addarbit/addarbit_edit
=end
class AddarbitController < ApplicationController

  def addarbit_list
      c="caseend_book_id = #{params[:caseend_book_id]} and used='Y'"
      @addarbit_pages,@addarbit=paginate(:tb_addarbits,:order=>'id',:conditions=>c)
  end

  def addarbit_new
    @addarbit=TbAddarbit.new()
    @addarbit.requestDate=Date.today
  end

  def addarbit_create
     @addarbit=TbAddarbit.new(params[:addarbit])
     @addarbit.recevice_code=session[:recevice_code]
     @addarbit.case_code=session[:case_code]
     @addarbit.general_code=session[:general_code]
     @addarbit.caseend_book_id=params[:caseend_book_id]
     @addarbit.u=session[:user_code]
     @addarbit.u_t=Time.now()
     if @addarbit.save
        flash[:notice]="创建成功"
        redirect_to :action=>"addarbit_list",:caseend_book_id=>params[:caseend_book_id]
     else
        render :action=>"addarbit_new",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def addarbit_edit
     @addarbit=TbAddarbit.find(params[:id])
  end

  def addarbit_update
     @addarbit=TbAddarbit.find(params[:id])
     @addarbit.u=session[:user_code]
     @addarbit.u_t=Time.now()
     if @addarbit.update_attributes(params[:addarbit])
        flash[:notice]="修改成功"
        redirect_to :action=>"addarbit_list",:caseend_book_id=>params[:caseend_book_id]
     else
        flash[:notice]="修改失败"
        render :action=>"addarbit_edit",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def addarbit_delete
     @addarbit=TbAddarbit.find(params[:id])
     @addarbit.used="N"
     @addarbit.u=session[:user_code]
     @addarbit.u_t=Time.now()
     if @addarbit.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"addarbit_list",:caseend_book_id=>params[:caseend_book_id]
  end
end
