# To change this template, choose Tools | Templates
# and open the template in the editor.

class CaseCopy
  def initialize
    
  end

  def copy(code_old,code_new,user_code)
      pt = PubTool.new
      @case_old = TbCase.find_by_recevice_code(code_old)
      @case_new = TbCase.new
      pt.put_to(@case_old, @case_new)
      @case_new.recevice_code = code_new
      @case_new.clerk_2 = user_code
      @case_new.clerk = ""
      @case_new.state = 1
      @case_new.general_code = ""
      @case_new.case_code = ""
      @case_new.end_code = ""
      @case_new.remun_state = "N"
      @case_new.trial_typ = nil
      @case_new.amount = 0
      @case_new.amount_1 = 0
      @case_new.amount_2 = 0
      @case_new.m_rmb_money = 0
      @case_new.m_re_rmb_money = 0
      @case_new.m_lack_rmb_money = 0
      @case_new.m_rmb_money_2 = 0
      @case_new.m_re_rmb_money_2 = 0
      @case_new.m_lack_rmb_money_2 = 0
      @case_new.nowdate = nil
      @case_new.nowdate_t = nil
      @case_new.limit_dat = nil
      @case_new.finally_limit_dat = nil
      @case_new.limit_deduct_t = nil
      @case_new.limit_deduct_text = nil
      @case_new.end_date = nil
      @case_new.end_u = nil
      @case_new.end_t = nil
      @case_new.re_code = nil
      @case_new.file_submit_remark = nil
      @case_new.file_submit_u = ""
      @case_new.file_submit_t = nil
      @case_new.file_up_u = ''
      @case_new.file_up_t = nil
      @case_new.runstyle = nil
      @case_new.runremark = nil
      @case_new.isback = nil
      @case_new.book_num = 0
      @case_new.caseorg_id_first = nil
      @case_new.caseorg_id_last = nil
      @case_new.sitting_id_first = nil
      @case_new.sitting_id_last = nil
      @case_new.caseendbook_id_first = nil
      @case_new.caseendbook_id_last = nil
      @case_new.file_arbitBookNum = nil
      @case_new.file_num_1 = nil
      @case_new.file_num_2 = nil
      @case_new.file_typ = nil
      @case_new.file_receive_u = nil
      @case_new.file_receive_t = nil
      @case_new.file_num_3 = nil
      @case_new.save

      #如果创建成功，系统自动为申请人和被申请人分别创建案件应收费“当事人多交费用”，金额是 0
      @should1 = TbShouldCharge.new
      @should1.recevice_code = @case_new.recevice_code
      @should1.case_code     = @case_new.case_code
      @should1.general_code  = @case_new.general_code
      @should1.typ           = "0009"
      @should1.payment       = "0001"
      @should1.rmb_money     = 0
      @should1.currency      = "0001"
      @should1.used          = 'Y'
      @should1.u             = "System"
      @should1.u_t           = Time.now()
      @should1.save

      @should2 = TbShouldCharge.new
      @should2.recevice_code = @case_new.recevice_code
      @should2.case_code     = @case_new.case_code
      @should2.general_code  = @case_new.general_code
      @should2.typ           = "0009"
      @should2.payment       = "0002"
      @should2.rmb_money     = 0
      @should2.currency      = "0001"
      @should2.used          = 'Y'
      @should2.u             = "System"
      @should2.u_t           = Time.now()
      @should2.save

      @pary_old = TbParty.find(:all, :conditions=>["recevice_code=? and used='Y'",code_old], :order =>"id")
      for p in @pary_old
        party_new = TbParty.new
        party_new.partyname = p.partyname
        party_new.partytype = p.partytype
        party_new.isperson = p.isperson
        party_new.commissary = p.commissary
        party_new.dutyname = p.dutyname
        party_new.post_tel_code = p.post_tel_code
        party_new.postcode = p.postcode
        party_new.profession = p.profession
        party_new.subprofession = p.subprofession
        party_new.area = p.area
        party_new.addr = p.addr
        party_new.email = p.email
        party_new.mobiletel = p.mobiletel
        party_new.tel = p.tel
        party_new.recevice_code=code_new
        party_new.used = p.used
        party_new.u=user_code
        party_new.u_t=Time.now()
        party_new.save
        @agent_old = TbAgent.find(:all, :conditions=>["recevice_code=? and  party_id=? and used='Y'",code_old,p.id], :order =>"id")
        for a in @agent_old
          agent_new = TbAgent.new
          agent_new.party_id = party_new.id
          agent_new.name = a.name
          agent_new.status = a.status
          agent_new.duty = a.duty
          agent_new.postcode = a.postcode
          agent_new.company = a.company
          agent_new.addr = a.addr
          agent_new.email = a.email
          agent_new.mobiletel = a.mobiletel
          agent_new.tel = a.tel
          agent_new.post_tel_code = a.post_tel_code
          agent_new.partytype = a.partytype
          agent_new.recevice_code=code_new
          agent_new.used = "Y"
          agent_new.u=user_code
          agent_new.u_t=Time.now()
          agent_new.save
        end
      end
      @con = TbContractsign.find(:all, :conditions=>["recevice_code=? and used='Y'",code_old], :order =>"id")
      for c in @con
        contra_new = TbContractsign.new
        contra_new.recevice_code = code_new
        contra_new.contractdate = c.contractdate
        contra_new.pactname = c.pactname
        contra_new.note = c.contractdate
        contra_new.used = "Y"
        contra_new.u = user_code
        contra_new.u_t = Time.now()
        contra_new.save
      end

      @case_book = CaseBook.find(:all, :conditions=>["recevice_code=? and typ='0005' and used='Y'", code_old], :order=>'id')
      for b in @case_book
        f_name = b.book_name.split(".").last
        book_new = CaseBook.new
        book_new.used = "Y"
        book_new.recevice_code = code_new
        book_new.p_id = b.p_id
        book_new.book_typ = b.book_typ
        book_new.typ = b.typ
        book_new.book_code = b.book_code
        book_new.title = b.title
        book_new.remarks = b.remarks
        book_new.book_name = b.book_name
        book_new.book_u = b.book_u
        book_new.book_dat = b.book_dat
        book_new.state = b.state
        book_new.u = user_code
        book_new.u_t = Time.now()
        book_id = book_new.save
        book_new.book_name = "#{book_new.typ}_#{book_new.recevice_code}_contractfile_#{book_id}.#{f_name}"
        book_new.save

        path_old = "#{SysArg.find_by_code("8010").val}/casedocs/#{b.recevice_code.slice(0,4)}/#{b.recevice_code}/#{b.book_name}"
        path_new = "#{SysArg.find_by_code("8010").val}/casedocs/#{book_new.recevice_code.slice(0,4)}/#{book_new.recevice_code}/#{book_new.book_name}"
        if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs")
          Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/")
        end
        if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{book_new.recevice_code.slice(0,4)}")
          Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{book_new.recevice_code.slice(0,4)}")
        end
        if !File.exists?("#{SysArg.find_by_code("8010").val}/casedocs/#{book_new.recevice_code.slice(0,4)}/#{book_new.recevice_code}")
          Dir.mkdir("#{SysArg.find_by_code("8010").val}/casedocs/#{book_new.recevice_code.slice(0,4)}/#{book_new.recevice_code}")
        end
        FileUtils.copy_file(path_old, path_new)
        
      end

    end  
end
