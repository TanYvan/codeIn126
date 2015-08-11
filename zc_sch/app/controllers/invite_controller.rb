#仲裁员拒绝管理，添加、显示仲裁员拒绝的功能
#创建人 苏获
#创建时间 20090508
class InviteController < ApplicationController
  #选择仲裁员拒绝
  def select_invite
    #    @tb_invite = TbInvite.new
    @hant_search_1_page_name="select_invite"
    @hant_search_1=[['char','code','仲裁员编码','text',[]],
      ['char','name','姓名','text',[]]]
    @hant_search_1_list=['name','code']
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c = "used = 'Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 20
    end
    @tb_arbitman_pages,@tb_arbitmen=paginate(:tb_arbitmen,:conditions => c,:order=>"id",:per_page=>@page_lines.to_i)
  end
  #新增拒绝仲裁员
  def new_invite
    @arbitman = TbArbitman.find_by_code(params[:code])
    @tb_invite = TbInvite.new
    @tb_invite.confirmdate = Date.today
    @tb_invite.informdate = Date.today
  end
  #创建仲裁员拒绝实例，存入数据库
  def create_invite
    @arbitman = TbArbitman.find_by_code(params[:code])
    @tb_invite = TbInvite.new(params[:tb_invite])
    @tb_invite.arbitman=@arbitman.code
    @tb_invite.u = session[:user_code]
    @tb_invite.u_t = Time.now
    if @tb_invite.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list_invite",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"new_invite",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

    
  #仲裁员拒绝的列表
  def list_invite
    @order=params[:order]
    if @order==nil or @order==""
      @order="id asc"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 2
    end
    c = "used='Y'"
    @tb_invite_pages, @tb_invites=paginate(:tb_invites,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
 end
  #删除仲裁员拒绝的记录
  def delete_invite
    @tb_invite = TbInvite.find(params[:id])
    @tb_invite.used = 'N'
    @tb_invite.u= session[:user_code]
    @tb_invite.u_t = Time.now
    if @tb_invite.save
      flash[:notice]="删除成功"
      redirect_to :action=>"list_invite", :page=>params[:page],:page_lines=>params[:page_lines]#确定怎么得到id进行删除
    else
      flash[:notice]="删除失败"
    end
  end
  #编辑仲裁员拒绝
  def edit_invite
    @tb_invite = TbInvite.find(params[:id])
  end
  #更新仲裁员拒绝
  def update_invite
    @tb_invite = TbInvite.find(params[:id])
    @tb_invite.u = session[:user_code]
    @tb_invite.u_t = Time.now
    if @tb_invite.update_attributes(params[:tb_invite])
      flash[:notice]="修改成功"
      redirect_to :action=>"list_invite",:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit_invite"
    end
  end
end
