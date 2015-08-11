class RegionController < ApplicationController
  
  def tree
    @out_String="";
    m=Region.find_by_sql("select regions.id as id,regions.code as code,regions.name as name,regions.parent as parent from regions where  regions.parent='0'  order by regions.code") 
    @out_String= @out_String + "treenode_root=tree.add( 0,Tree_ROOT, Tree_LAST,\"" +"树形地区根节点" + "\");\n"
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
     m=Region.find_by_sql("select regions.id as id, regions.code as code,regions.name as name,regions.parent as parent from regions where regions.parent='#{parent_code}' order by regions.code")
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
  
  def r_main
  end
  def r_list 
    @r_new=Region.new()
    if params[:i]=='root'
      @r_new.parent='0'
    else
      @r_new.parent=Region.find(params[:i]).code
    end
    if params[:i]!='root'
      @r=Region.find(params[:i])
      @rrr=@r.name+"("+@r.code+")"
      
      if @r!=nil
        @mmm=Region.find(:all,:conditions=>"parent='#{@r.code}'")
        if @mmm.empty?
          @r_code_read_only="no"
        else
          @r_code_read_only="yes"
        end
      end
      
    else
      @rrr="树形地区根节点"
    end
    
  end
  
  def r_create
    @r_new=Region.new(params[:r_new])
    if @r_new.save
      flash[:notice]="创建成功"
      redirect_to :action=>"right_reload"
    else
        flash[:notice]="创建失败"
        render :action=>"r_list"        
    end
    
  end
  
  def r_update
     @r=Region.find(params[:id])
     if @r.update_attributes(params[:r])
        flash[:notice]="修改成功"
        redirect_to :action=>"right_reload"
     else
        flash[:notice]="修改失败"
        render :action=>"r_list" 
     end
     
  end
  
  def r_del
    @r=Region.find(params[:id])
    if @r.destroy  
      flash[:notice]="删除成功"
    else
      flash[:notice]="删除失败"
    end
    redirect_to :action=>"right_reload"
  end

end
