=begin
创建人：聂灵灵
创建时间：2009-5-12
类的描述：此控制器是处理裁决书更正的信息。首先判断是否有案件，若无可以选择案件，并在相应案件下创建裁决书更正信息及修改删除裁决书更正信息。
页面：
裁决书更正信息列表:/repairarbit/repairarbit_list
创建裁决书更正信息：/repairarbit/repairarbit_new
修改裁决书更正信息：/repairarbit/repairarbit_edit
=end
class RepairarbitController < ApplicationController

   def repairarbit_list    
      c="caseend_book_id = #{params[:caseend_book_id]} and used='Y'"
#      @repairarbit_pages,@repairarbit=paginate(:tb_repairarbits,:order=>'id',:conditions=>["caseend_book_id= ? and used='Y'",params[:caseend_book_id]])
      @repairarbit=TbRepairarbit.find(:all,:order=>'id',:conditions=>c)
   end

  def repairarbit_new
    @repairarbit=TbRepairarbit.new()
    @repairarbit.requestDate=Date.today
  end

  def repairarbit_create
     @repairarbit=TbRepairarbit.new(params[:repairarbit])
     @repairarbit.recevice_code=session[:recevice_code]
     @repairarbit.case_code=session[:case_code]
     @repairarbit.general_code=session[:general_code]
     @repairarbit.caseend_book_id=params[:caseend_book_id]
     @repairarbit.u=session[:user_code]
     @repairarbit.u_t=Time.now()
     if @repairarbit.save
        flash[:notice]="创建成功"
        redirect_to :action=>"repairarbit_list",:caseend_book_id=>params[:caseend_book_id]
     else
        flash[:notice]="创建失败"
        render :action=>"repairarbit_new",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def repairarbit_edit
     @repairarbit=TbRepairarbit.find(params[:id])
  end

  def repairarbit_update
     @repairarbit=TbRepairarbit.find(params[:id])
     @repairarbit.u=session[:user_code]
     @repairarbit.u_t=Time.now()
     if @repairarbit.update_attributes(params[:repairarbit])
        flash[:notice]="修改成功"
        redirect_to :action=>"repairarbit_list",:caseend_book_id=>params[:caseend_book_id]
     else
        flash[:notice]="修改失败"
        render :action=>"repairarbit_edit",:caseend_book_id=>params[:caseend_book_id]
     end
  end

  def repairarbit_delete
     @repairarbit=TbRepairarbit.find(params[:id])
     @repairarbit.used="N"
     @repairarbit.u=session[:user_code]
     @repairarbit.u_t=Time.now()
     if @repairarbit.save
        flash[:notice]="删除成功"
     else
        flash[:notice]="删除失败"
     end
     redirect_to :action=>"repairarbit_list",:caseend_book_id=>params[:caseend_book_id]
  end
end
