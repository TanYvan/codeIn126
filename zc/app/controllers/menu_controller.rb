class MenuController < ApplicationController
  
  def tree
    @out_String="";
    #m=Menu.find_by_sql("select distinct code,name,url,parent from menus where  parent='0' and role_code in " + @role_codes + " order by code")
    if params[:menu_id]=="0"
      m=Menu.find_by_sql("select distinct menus.role_code as role_code,menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus,urs where urs.user_code='#{session[:user_code]}' and menus.role_code=urs.role_code and menus.parent='0' and menus.role_code<'9901' order by role_code,menus.code") 
    else
      m=Menu.find_by_sql("select distinct menus.role_code as role_code,menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus,urs where urs.user_code='#{session[:user_code]}' and menus.role_code=urs.role_code and menus.id='#{params[:menu_id]}' and menus.role_code<'9901' order by role_code,menus.code") 
    end
    if m.empty?
       return "" 
     else
       for mm in m
         @out_String= @out_String + "treenode1=tree.add( 0,Tree_ROOT, Tree_LAST,\""+mm.name+"\");\n"      
	 if mm.url.lstrip!=''
           @out_String= @out_String + "treenode1.setScript(\"t_clicked(\\\""+mm.url+"\\\")\");\n"
	 end 
         @out_String= addtreenode(@out_String,mm.code,mm.role_code,1);
       end 
         @out_String=@out_String + "tree.expandAll();\n"
     end
      
  end



  def addtreenode(out_String,parent_code,role_code,treenode_parent)
     treenode=treenode_parent + 1
     m=Menu.find_by_sql("select distinct menus.role_code, menus.code as code,menus.name as name,menus.url as url,menus.parent as parent from menus,urs where urs.user_code='#{session[:user_code]}' and menus.role_code=urs.role_code and menus.parent='#{parent_code}' and menus.role_code='#{role_code}' order by  menus.role_code,menus.code")
     if m.empty?
       return out_String 
     else
       for mm in m  
         out_String = out_String + "treenode" + treenode.to_s + "=tree.add(treenode" + treenode_parent.to_s + ".id,Tree_CHILD, Tree_LAST,\"" + mm.name + "\");\n"  
	 if mm.url.lstrip!=''
	    out_String = out_String + "treenode" + treenode.to_s + ".setScript(\"t_clicked(\\\""+mm.url+"\\\")\");\n" 
	 end
         out_String = addtreenode(out_String,mm.code,mm.role_code,treenode)  
       end
       return out_String
     end
   end



end