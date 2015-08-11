class WuserSelectController < ApplicationController
  def wuser_select
    @page_lines=params[:page_lines]
    if @page_lines==nil or @page_lines==""
      @page_lines=20
    end
    @name=params[:name]
    c="active=1 and status='Y'"
    unless @name.blank?
      c = c + " and (name like '%#{@name}%' or name_idcard like '%#{@name}%')"
    end
    @user_pages,@user =paginate(:w_user,:conditions=>c,:order=>"name",:per_page=>@page_lines.to_i)
  end
end
