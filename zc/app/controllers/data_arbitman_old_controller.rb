class DataArbitmanOldController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=session[:lines]
    end
    @data_old_t_pages,@data_old_ts= paginate(:data_arbitman_imp,:conditions=>"st=0",:order=>"id",:per_page=>@page_lines.to_i)
  end

  def insert_do
    @condi = params[:condi]
    array_con = @condi.split(",")
#    begin
      array_con.each do |con|
        d=DataArbitmanImp.find(con)
        ###
        @tb_arbitman=TbArbitman.new()
        @tb_arbitman.code=SysArg.add_0008()
        @tb_arbitman.spell=d.spell
        @tb_arbitman.sex=d.sex
        @tb_arbitman.name=d.name
        @tb_arbitman.name_idcard=d.name
        @tb_arbitman.area_code=d.addr_1
        @tb_arbitman.role_code=d.roles
        @tb_arbitman.yearbelong=d.yearbe
        @tb_arbitman.company=d.workp
        @tb_arbitman.country=d.jg
        @tb_arbitman.telo=d.phone
        @tb_arbitman.mobiletel=d.tel
        @tb_arbitman.fax=d.send_code
        @tb_arbitman.email=d.email
        @tb_arbitman.addr=d.addr_2
        @tb_arbitman.title=d.zw
        @tb_arbitman.save
        d.st=1
        d.save
      end
      flash[:notice]="数据批量创建成功！"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
#    rescue ActiveRecord::RecordNotSaved =>e
#      flash[:notice]="数据批量创建失败！"
#      render :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
#    end
  end
  def update_do
    @condi = params[:condi_2]
    array_con = @condi.split(",")
    begin
      array_con.each do |con|
        d=DataArbitmanImp.find(con)
        ###
        @tb_arbitman=TbArbitman.find_by_code(d.code)
        @tb_arbitman.spell=d.spell
        @tb_arbitman.sex=d.sex
        @tb_arbitman.name=d.name
        @tb_arbitman.yearbelong=d.yearbe
        @tb_arbitman.company=d.workp
        @tb_arbitman.area_code=d.addr_1
	@tb_arbitman.role_code=d.roles
        @tb_arbitman.country=d.jg
        @tb_arbitman.telo=d.phone
        @tb_arbitman.mobiletel=d.tel
        @tb_arbitman.fax=d.send_code
        @tb_arbitman.email=d.email
        @tb_arbitman.addr=d.addr_2
        @tb_arbitman.title=d.zw
        @tb_arbitman.save
        d.st=1
        d.save
      end
      flash[:notice]="数据批量修改成功！"
      redirect_to :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    rescue ActiveRecord::RecordNotSaved =>e
      flash[:notice]="数据批量修改失败！"
      render :action=>"list",:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  
end
