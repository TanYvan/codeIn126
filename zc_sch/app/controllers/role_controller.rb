class RoleController < ApplicationController
  def select
    @user=User.find_by_code(params[:uid])
    @roles=Role.find(:all,:order=>"code")
  end
  
  def tree
    @out_String="";
    #m=Menu.find_by_sql("select distinct code,name,url,parent from menus where  parent='0' and role_code in " + @role_codes + " order by code")
    m=Menu.find_by_sql("select menus.id as id,menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus where  menus.role_code=#{@session[:role_code]} and menus.parent='0'  order by menus.code") 
    #puts "select distinct menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus,urs where urs.user_code='#{session[:user_code]}' and menus.role_code=urs.role_code and menus.parent='0'  order by menus.code"
    @out_String= @out_String + "treenode_root=tree.add( 0,Tree_ROOT, Tree_LAST,\"" +"树形菜单根节点" + "\");\n"
    @out_String= @out_String + "treenode_root.setScript(\"t_clicked(\\\""+"root"+"\\\")\");\n"
    if m.empty?
      return ""
    else
      for mm in m
        @out_String= @out_String + "treenode1=tree.add(treenode_root.id,Tree_CHILD, Tree_LAST,\"" + mm.name + "(" + mm.code + ")" + "\");\n"
        #if mm.url!='0'
        @out_String= @out_String + "treenode1.setScript(\"t_clicked(\\\""+mm.id.to_s+"\\\")\");\n"
        #end
        @out_String= addtreenode(@out_String,mm.code,mm.name,1);
      end
      @out_String=@out_String + "tree.expandAll();\n"
    end
      
  end



  def addtreenode(out_String,parent_code,subjectname,treenode_parent)
    treenode=treenode_parent + 1
    m=Menu.find_by_sql("select menus.id as id, menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus where menus.role_code=#{@session[:role_code]} and menus.parent='#{parent_code}' order by menus.code")
    if m.empty?
      return out_String
    else
      for mm in m
        out_String = out_String + "treenode" + treenode.to_s + "=tree.add(treenode" + treenode_parent.to_s + ".id,Tree_CHILD, Tree_LAST,\"" + mm.name+ "(" + mm.code + ")" + "\");\n"
        #if mm.url!='0'
        out_String = out_String + "treenode" + treenode.to_s + ".setScript(\"t_clicked(\\\""+mm.id.to_s+"\\\")\");\n"
        #end
        out_String = addtreenode(out_String,mm.code,mm.name,treenode)
      end
      return out_String
    end
  end
   
  #快捷菜单创建时使用的选择目录树
  def tree_1
    @out_String="";
    #m=Menu.find_by_sql("select distinct code,name,url,parent from menus where  parent='0' and role_code in " + @role_codes + " order by code")
    m=Menu.find_by_sql("select menus.id as id,menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus where  menus.role_code=#{@session[:role_code_1]} and menus.parent='0'  order by menus.code") 
    #puts "select distinct menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus,urs where urs.user_code='#{session[:user_code]}' and menus.role_code=urs.role_code and menus.parent='0'  order by menus.code"
    @out_String= @out_String + "treenode_root=tree.add( 0,Tree_ROOT, Tree_LAST,\"" +"树形菜单根节点" + "\");\n"
    @out_String= @out_String + "treenode_root.setScript(\"t_clicked(\\\""+"root"+"\\\")\");\n"
    if m.empty?
      return ""
    else
      for mm in m
        @out_String= @out_String + "treenode1=tree.add(treenode_root.id,Tree_CHILD, Tree_LAST,\"" + mm.name + "(" + mm.code + ")" + "\");\n"
        #if mm.url!='0'
        @out_String= @out_String + "treenode1.setScript(\"t_clicked(\\\"#{mm.id.to_s}\\\",\\\"#{mm.name.to_s}\\\",\\\"#{mm.url.to_s}\\\")\");\n"
        #end
        @out_String= addtreenode_1(@out_String,mm.code,mm.name,1);
      end
      @out_String=@out_String + "tree.expandAll();\n"
    end
      
  end

  def addtreenode_1(out_String,parent_code,subjectname,treenode_parent)
    treenode=treenode_parent + 1
    m=Menu.find_by_sql("select menus.id as id, menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus where menus.role_code=#{@session[:role_code_1]} and menus.parent='#{parent_code}' order by menus.code")
    if m.empty?
      return out_String
    else
      for mm in m
        out_String = out_String + "treenode" + treenode.to_s + "=tree.add(treenode" + treenode_parent.to_s + ".id,Tree_CHILD, Tree_LAST,\"" + mm.name+ "(" + mm.code + ")" + "\");\n"
        #if mm.url!='0'
        out_String = out_String + "treenode" + treenode.to_s + ".setScript(\"t_clicked(\\\"#{mm.id.to_s}\\\",\\\"#{mm.name.to_s}\\\",\\\"#{mm.url.to_s}\\\")\");\n"
        #end
        out_String = addtreenode_1(out_String,mm.code,mm.name,treenode)
      end
      return out_String
    end
  end
  
  def role_main
    @session[:role_code]=Role.find(params[:id]).code
    @session[:role_name]=Role.find(params[:id]).name
  end
  def role_list 
    @r_new=Menu.new()
    @r_new.role_code=@session[:role_code]
    @r_new.url=''
    @r_new.controllers=''
    @r_new.url=''
    if params[:i]=='root'
      @r_new.parent='0'
    else
      @r_new.parent=Menu.find(params[:i]).code
    end
    if params[:i]!='root'
      @r=Menu.find(params[:i])
      if @r!=nil
        @mmm=Menu.find(:all,:conditions=>"parent='#{@r.code}'")
        if @mmm.empty?
          @r_code_read_only="no"
        else
          @r_code_read_only="yes"
        end
      end
      @rrr=@r.name+"("+@r.code+")"
    else
      @rrr="树形菜单根节点"
    end
    
  end
  #添加查询############################
  def page_select
    @hant_search_1_page_name="page_select"
    @hant_search_1=[['char','code','页面编码','text',[]],
      ['char','name','页面名称','text',[]],
      ['char','url','url','text',[]],
      ['char','controllers','控制器','text',[]],
      ['char','actions','action','text',[]]
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
    c="status='Y'"
    p=PubTool.new()
    if @search_condit!= " and " and p.sql_check_3(@search_condit)!=false
      c = c + @search_condit
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    @pages=Page.find(:all,:conditions=>c,:order=>"code")
  end
  ###################################
  def r_create
    @r_new=Menu.new(params[:r_new])
    if @r_new.save
      flash[:notice]="创建成功"
      redirect_to :action=>"right_reload"
    else
      flash[:notice]="创建失败"
      render :action=>"role_list"
    end
    
  end
  
  def r_update
    @r=Menu.find(params[:id])
    if @r.update_attributes(params[:r])
      flash[:notice]="修改成功"
      redirect_to :action=>"right_reload"
    else
      flash[:notice]="修改失败"
      render :action=>"role_list"
    end
    
  end
  
  def r_del
    @r=Menu.find(params[:id])
    if @r.destroy  
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"right_reload"
  end
  
  def list
    @role_pages, @roles=paginate(:roles,:order=>@code,:per_page=>20)
  end
  def new
    @r=Role.new()
  end
  def create
    @r=Role.new(params[:r])
    if @r.save
      flash[:notice]="创建成功"
      redirect_to :action=>"list"
    else
      flash[:notice]="创建失败"
      render :action=>"new"
    end
  end
   
  def edit
    @r=Role.find(params[:id])
  end

  def update
    @r=Role.find(params[:id])
    if @r.update_attributes(params[:r])
      flash[:notice]="修改成功"
    else
      flash[:notice]="修改失败"
      render :action=>"edit"
    end
  end

  def delete
    @r=Role.find(params[:id])
    if @r.destroy
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"list"
  end
  #添加快捷菜单   聂灵灵    2009-8-21    ##########################################################
  def  role_main1
    @session[:role_code_1]=params[:role_code]
    @session[:role_name_1]=Role.find_by_code(params[:role_code]).name
    @order=params[:order]
    if @order==nil or @order==""
      @order="code"
    end
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines= 2000
    end
    @a = Role.find_by_code(params[:role_code])
    c = "role_code='#{params[:role_code]}'"
    @tb_fast_pages,@fast_pages =paginate(:fast_menus,:conditions=>c,:order=>@order,:per_page=>@page_lines.to_i)
  end
  def new_main1
    @fast_menu=FastMenu.new()
  end
  def create_main1
    @a=Role.find_by_code(params[:role_code])
    @fast_menu=FastMenu.new(params[:fast_menu])
    @fast_menu.role_code=@a.code
    if @fast_menu.save
      flash[:notice]="创建成功"
      redirect_to :action=>"role_main1",:role_code=>params[:role_code],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="创建失败"
      render :action=>"new_main1",:role_code=>params[:role_code],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def edit_main1
    @fast_menu=FastMenu.find(params[:id])
  end
  def update_main1
    @fast_menu=FastMenu.find(params[:id])
    if @fast_menu.update_attributes(params[:fast_menu])
      flash[:notice]="修改成功"
      redirect_to :action=>"role_main1",:role_code=>params[:role_code],:page=>params[:page],:page_lines=>params[:page_lines]
    else
      flash[:notice]="修改失败"
      render :action=>"edit_main1",:role_code=>params[:role_code],:page=>params[:page],:page_lines=>params[:page_lines]
    end
  end
  def delete_main1
    @fast_menu=FastMenu.find(params[:id])
    role_code=FastMenu.find(params[:id]).role_code
    if @fast_menu.destroy
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"role_main1",:role_code=>role_code,:page=>params[:page],:page_lines=>params[:page_lines]
  end
end
