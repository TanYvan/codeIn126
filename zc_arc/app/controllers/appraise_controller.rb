#仲裁员案内案外评价
#创建人 苏获
#创建时间 20090508
class AppraiseController < ApplicationController
    #新建案外评价
    def new_prize
        @tb_prize = TbPrize.new
    end
    #创建案外评价
    def create_prize
        @tb_prize = TbPrize.new(params[:tb_prize])
        @tb_prize.clerk_id = TbArbitman.find_by_name(params[:tb_prize][:clerk_id]).code
        @tb_prize.user = session[:user_code]
        @tb_prize.u_time = Time.now
        if @tb_prize.save!           
            flash[:notice]="创建成功"
            redirect_to  :action=>"list_prize"
        else
            flash[:notice]="必填项不可为空"
            render :action=>"new_prize", :id => @tb_prize.id        
        end
    end
    #案外评价列表
    def list_prize
       # @tb_prizes = TbPrize.find(:all, :conditions => "used = 'Y'")
        @hant_search_1_page_name="list_prize"
        @hant_search_1=[['char','name','姓名','text',[]]]
        @order=params[:order]
        if @order==nil or @order==""
            @order="id asc"
        end
        @page_lines=params[:page_lines]
        if @page_lines==nil or @page_lines==""
            @page_lines= 10
        end
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
        #s="a.id as id,a.order_type as order_type,a.reviewed_suggestion as reviewed_suggestion,a.journal_id as journal_id,a.institute as institute,a.reviewed as reviewed,a.memo as memo,a.reviewed_suggestion_memo as reviewed_suggestion_memo,a.reviewed_shop_checked as reviewed_shop_checked,b.subject as subject,b.title as title,b.pissn as pissn"
        @tb_prize_pages,@tb_prizes =paginate(:tb_prize,:conditions => c,:order=>@order,:per_page=>@page_lines.to_i)
    end
    
    #修改案外评价
    def edit_prize
        @tb_prize = TbPrize.find(params[:id])
        @tb_prize.clerk_id = TbArbitman.find_by_code(@tb_prize.clerk_id).name
    end
    #删除案外评价
    def delete_prize
        @tb_prize = TbPrize.find(params[:id])      
        @tb_prize.used = 'N'
        @tb_prize.user = session[:user_code]
        @tb_prize.u_time = Time.now         
        if @tb_prize.save!         
            flash[:notice]="删除成功"
            redirect_to :action=>"list_prize",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines] 
        else 
            flash[:notice]="删除失败"        
        end        
    end
    #更新案外评价
    def update_prize
        @tb_prize= TbPrize.find(params[:id]) 
        @tb_prize.update_attributes(params[:tb_prize])
        @tb_prize.clerk_id = TbArbitman.find_by_name(params[:tb_prize][:clerk_id]).code        
        @tb_prize.user = session[:user_code]
        @tb_prize.u_time = Time.now           
        if @tb_prize.save! 
            flash[:notice]="修改成功"  
            redirect_to :action=>"list_prize",:search_condit=>params[:search_condit],:order=>params[:order],:page=>params[:page],:page_lines=>params[:page_lines] 
        else
            render :action=>"edit_prize"
        end        
    end
    
    #####################################################################
    #                      案内评价部分
    ###################################################################

    #显示案内评价的列表
    def list_arbitman_appraise  
        @arbitmanmen_appraised = TbAppraise.find_arbitman
    end
    
    #查看某位仲裁员案内评价
    def list_appraise      
        @arbitman_name = TbArbitman.find_by_code(params[:arbitman_code]).name
        @tb_appraises = TbAppraise.find_appraises(params[:arbitman_code])
    end    
end
