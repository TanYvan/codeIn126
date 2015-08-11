=begin
创建人：聂灵灵
创建时间：2009-6-12
类的描述：选择案件后可以查看案件的基本情况。
页面：
案件基本情况信息列表:/progress/list
=end
class ProgressController < ApplicationController
    def list
        @case=nil#当前办理案件
        if session[:recevice_code]==nil
        else
          @case=TbCase.find_by_recevice_code(session[:recevice_code])
        end
        @a=TbDictionary.find_by_sql("select tb_dictionaries.data_text from tb_dictionaries,tb_caseendbooks where tb_dictionaries.data_val=tb_caseendbooks.endStyle and tb_dictionaries.typ_code='8117' and tb_dictionaries.state='Y' and tb_caseendbooks.recevice_code='#{session[:recevice_code]}'")
        @should_chargrs = TbShouldCharge.find(:all, :conditions => ["recevice_code = ? and used = 'Y'",session[:recevice_code]])
        @total_charge = 0
        if @should_chargrs != nil
            @should_chargrs.each do |s_c|
                @total_charge = @total_charge + s_c.rmb_money
            end  
        end
        #欠缴费用
        #
        #组庭日期
        case_org = TbCaseorg.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
        if case_org != nil
            @orgdate = case_org.orgdate
        else
            @orgdate = " "
        end
        #开庭日期
        sitting = TbSitting.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'") 
        if sitting != nil
            @sittingdate = sitting.sittingdate
        else
            @sittingdate = " "
        end
        #提交证据材料期限
        #
        #案件合议日期
        case_comment = TbCasecomment.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
        if case_comment != nil
            @comment_date = case_comment.comment_date
        else
            @comment_date = " "
        end
        #管辖权异议申请日期
        jurisdiction = TbJurisdiction.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
        if jurisdiction != nil
            @request_date = jurisdiction.request_date
            @decide_date = jurisdiction.decide_date
        else
            @request_date = " "
            @decide_date = " "
        end
        #仲裁员回避申请日期
        evite = TbEvite.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
        if evite != nil
            @avoid_requestdate = evite.requestdate
        else
            @avoid_requestdate = " "
        end
        #仲裁员回避决定作出日期
        disclosure = TbDisclosure.find(:first,:conditions=>"recevice_code='#{session[:recevice_code]}' and used='Y'")
        if disclosure != nil
            @pdate = disclosure.pdate
        else
            @pdate = " "
        end
  end

end
