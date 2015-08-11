class PageController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @hant_search_1_page_name="list"
    @hant_search_1=[['char','code','编码','text',[]],
      ['char','name','名称','text',[]],
      ['char','url','url','text',[]],
      ['char','controllers','controllers','text',[]],
      ['char','actions','actions','text',[]],
      ['char','status','status','text',[]]
      ]
    @hant_search_1_r=params[:hant_search_1_r]
    hant_search_1_word=params[:hant_search_1_word]
    @search_condit=params[:search_condit]
    if @search_condit==nil
      @search_condit=""
    end
    if hant_search_1_word == nil or hant_search_1_word ==""
    else
      @search_condit= " and " + hant_search_1_word
    end
    c="status='Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
   @pages = Page.find(:all,:conditions=>c,:order=>'code')
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = '创建成功'
      redirect_to :action => 'list',:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action => 'new',:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = '修改成功'
      redirect_to :action => 'list',:page=>params[:page],:page_lines=>params[:page_lines]
    else
      render :action => 'edit',:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end

  def destroy
    Page.find(params[:id]).destroy
    redirect_to :action => 'list',:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
