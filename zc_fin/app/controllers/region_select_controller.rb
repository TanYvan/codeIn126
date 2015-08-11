class RegionSelectController < ApplicationController  
  def tree
    @out_String="";
    m=Region.find_by_sql("select regions.id as id,regions.code as code,regions.name as name,regions.parent as parent from regions where  regions.parent='0'  order by regions.code")
    @out_String= @out_String + "treenode_root=tree.add( 0,Tree_ROOT, Tree_LAST,\"" +"树形地区根节点" + "\");\n"
    @out_String= @out_String + "treenode_root.setScript(\"t_clicked(\\\""+"root"+"\\\",\\\""+"root"+"\\\")\");\n"
    if m.empty?
      return ""
    else
      for mm in m
        @out_String= @out_String + "treenode1=tree.add(treenode_root.id,Tree_CHILD, Tree_LAST,\"" + mm.name + "(" + mm.code + ")" + "\");\n"
        #if mm.url!='0'
        @out_String= @out_String + "treenode1.setScript(\"t_clicked(\\\""+mm.code.to_s+"\\\",\\\""+mm.name.to_s+"\\\")\");\n"
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
        out_String = out_String + "treenode" + treenode.to_s + ".setScript(\"t_clicked(\\\""+mm.code.to_s+"\\\",\\\""+mm.name.to_s+"\\\")\");\n"
        #end
        out_String = addtreenode(out_String,mm.code,mm.name,treenode)
      end
      return out_String
    end
  end
  
  
end
