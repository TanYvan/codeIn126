=begin
创建人：聂灵灵
创建时间：2009-5-25
类的描述：此控制器是日常办公时专家咨询文员会信息维护信息，包括：专家信息列表(expertconsult_list)，
         专家信息创建(expertconsult_new)，专家信息修改(expertconsult_edit)
=end
class ExpertconsultController < ApplicationController
  def expertconsult_list
    @hant_search_1_page_name="expertconsult_list"
    @hant_search_1=[
      ['char','code','编号','text',[]],['char','name','姓名','text',[]],
      ['char','sex','性别','select',[["男","男"],["女","女"]]],
      ['char','addr','联系地址','text',[]],
      ['char','tel','联系电话','text',[]],
      ['char','email','电子邮件','text',[]],
      ['char','postcode','邮政编码 ','text',[]],
    ]
        
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word 
    end
    c="used='Y' "
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
      
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    @expertconsult_pages,@expertconsult=paginate(:tb_expertconsults,:conditions=>c,:order=>"code",:per_page=>@page_lines.to_i)
  end

  def expertconsult_new
    @expertconsult=TbExpertconsult.new()
  end

  def expertconsult_create
    @expertconsult=TbExpertconsult.new(params[:expertconsult])
    @expertconsult.u=session[:user_code]
    @expertconsult.u_t=Time.now()
    if @expertconsult.save
      flash[:notice]="创建成功"
      redirect_to :action=>"expertconsult_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action=>"expertconsult_new",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def expertconsult_edit
    @expertconsult=TbExpertconsult.find(params[:id])
  end

  def expertconsult_update
    @expertconsult=TbExpertconsult.find(params[:id])
    @expertconsult.u=session[:user_code]
    @expertconsult.u_t=Time.now()
    if @expertconsult.update_attributes(params[:expertconsult])
      flash[:notice]="修改成功"
      redirect_to :action=>"expertconsult_list",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"expertconsult_edit",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def expertconsult_delete
    @expertconsult=TbExpertconsult.find(params[:id])
    @expertconsult.used="N"
    @expertconsult.u=session[:user_code]
    @expertconsult.u_t=Time.now()
    if @expertconsult.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"expertconsult_list",:page=>params[:page],:page_lines=>params[:page_lines]
  end
  #专家精通专业
  def expert_list
    #添加分页
    @expertconsult_id = params[:expertconsult_id]
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=10
    end
    c="expertconsult_id=#{@expertconsult_id} and used='Y'"
    @expert_pages,@expert=paginate(:expert_specialties,:conditions=>c,:per_page=>@page_lines.to_i)
  end

  def expert_new
    @expert=ExpertSpecialty.new()
  end

  def expert_create
    @expert=ExpertSpecialty.new(params[:expert])
    @expert.expertconsult_id=params[:expertconsult_id]
    @expert.user=session[:user_code]
    @expert.u_t=Time.now()
    if @expert.save
      flash[:notice]="创建成功"
      redirect_to :action=>"expert_list",:expertconsult_id=>params[:expertconsult_id],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"expert_new" ,:expertconsult_id=>params[:expertconsult_id],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def expert_edit
    @expert=ExpertSpecialty.find(params[:id])
  end

  def expert_update
    @expert=ExpertSpecialty.find(params[:id])
    @expert.user=session[:user_code]
    @expert.u_t=Time.now()
    if @expert.update_attributes(params[:expert])
      flash[:notice]="修改成功"
      redirect_to :action=>"expert_list",:expertconsult_id=>params[:expertconsult_id],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"expert_edit" ,:expertconsult_id=>params[:expertconsult_id],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def expert_delete
    @expert=ExpertSpecialty.find(params[:id])
    @expert.used="N"
    @expert.user=session[:user_code]
    @expert.u_t=Time.now()
    if @expert.save
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"expert_list",:expertconsult_id=>params[:expertconsult_id],:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
