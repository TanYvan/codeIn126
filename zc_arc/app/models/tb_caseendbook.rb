class TbCaseendbook < ActiveRecord::Base
  validates_presence_of :arbitBookNum, :message => "请填写文书编号"
  def self.count_by_sql_wrapping_select_query(sql)
    sql = sanitize_sql(sql)
    count_by_sql("select count(*) from (#{sql}) as my_table")
  end
  def self.find_by_sql_with_limit(sql, offset, limit)
    sql = sanitize_sql(sql)
    add_limit!(sql, {:limit => limit, :offset => offset})
    find_by_sql(sql)
  end
  #结案检测:1.裁决书：case_books表裁决书的属性book_name是否有
  #2.费用：当事人是否欠费（应收-应交=0，未交齐和未退费都不行）
  #3.报酬：
#  def self.whether_case(recevice_code)
#    @sty = TbCaseendbook.find(:first,:conditions=>["used='Y' and recevice_code=?",recevice_code]).endStyle
#    @book_name1 = CaseBook.find(:all,:conditions=>["used='Y' and recevice_code=? and book_name!='' and book_typ=?",recevice_code,@sty])
#    @book_name = PubTool.new.get_first_record(@book_name1)
#    if @book_name!=nil
#      r1 = ""
#    else
#      r1 = "没有裁决书；"
#    end
#    @ccc=TbShouldCharge.count(:conditions=>"used='Y' and recevice_code='#{recevice_code}'")
#    @sss=TbShouldCharge.count(:conditions=>"used='Y' and typ<>'0002' and typ<>'0003' and recevice_code='#{recevice_code}' and (rmb_money - re_rmb_money)>0")
#    if ((@ccc==nil or @ccc==0) or (@sss!=nil and @sss!=0))
#      if (@ccc==nil or @ccc==0)
#        r2 = "没有交费记录；"
#      elsif @sss!=nil and @sss!=0
#        r2 = "有欠缴费用未交；"
#      end
#    else
#      r2 = ""
#    end
#    r = r1 + r2
#    return r
#  end
end
