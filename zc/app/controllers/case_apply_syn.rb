# To change this template, choose Tools | Templates
# and open the template in the editor.

class CaseApplySyn
  def initialize
    
  end

  def create(recevice_code, apply_code, user_code)
    jrdb = Jrdb::Jrdb.new

    req_case = Jrdb::ReqPacket.new
		req_case.from = "case_apply_base"
		con = Array.new
    con << "apply_code=? "
    con << apply_code
		req_case.conditions = con
    req_case.order = "id asc"
    @res_case = jrdb.find_all(req_case)

		req_party = Jrdb::ReqPacket.new
		req_party.from = "party"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << apply_code
		req_party.conditions = con
    req_party.order = "id asc"
    @res_party = jrdb.find_all(req_party)

    req_agent = Jrdb::ReqPacket.new
		req_agent.from = "agents"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << apply_code
		req_agent.conditions = con
    req_agent.order = "id asc"
    @res_agent = jrdb.find_all(req_agent)

    req_party_request = Jrdb::ReqPacket.new
		req_party_request.from = "party_request"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << apply_code
		req_party_request.conditions = con
    req_party_request.order = "id asc"
    @res_party_request = jrdb.find_all(req_party_request)

    req_contractsign = Jrdb::ReqPacket.new
		req_contractsign.from = "contractsign"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << apply_code
		req_contractsign.conditions = con
    req_contractsign.order = "id asc"
    @res_contractsign = jrdb.find_all(req_contractsign)

    req_att = Jrdb::ReqPacket.new
		req_att.from = "case_att,attachment"
    req_att.select = "case_att.u as u, attachment.ext_file_path as ext_file_path, attachment.ext_file_url as ext_file_url, attachment.category as category,attachment.up_time as up_time,attachment.file_name as file_name,attachment.remark as remark,attachment.guid as guid,attachment.content_type as content_type"
		con = Array.new
    con << "case_att.apply_code=? and case_att.used='Y' and case_att.att_id=attachment.id"
    con << apply_code
		req_att.conditions = con
    req_att.order = "attachment.id asc"
    @res_att = jrdb.find_all(req_att)
    
    party_id_hash = {}
    if @res_case.status == "1" &&@res_party.status == "1" && @res_agent.status == "1" && @res_party_request.status == "1" && @res_contractsign.status == "1" && @res_att.status == "1"
      if @res_party && @res_party.dataset.size!="0"
        for r in @res_party.dataset.rows
          party = TbParty.new
          party.partyname = r.get_data("partyname")
          party.partytype = r.get_data("partytype")
          party.isperson = r.get_data("isperson")
          party.commissary = r.get_data("commissary")
          party.dutyname = r.get_data("dutyname")
          party.post_tel_code = r.get_data("post_tel_code")
          party.postcode = r.get_data("postcode")
          party.profession = r.get_data("profession")
          party.subprofession = r.get_data("subprofession")
          party.area = r.get_data("area")
          party.addr = r.get_data("addr")
          party.email = r.get_data("email")
          party.mobiletel = r.get_data("mobiletel")
          party.tel = r.get_data("tel")
          party.recevice_code=recevice_code
          party.used = "Y"
          party.u=user_code
          party.u_t=Time.now()
          p_id = party.save
          party_id_hash.merge!({r.get_data("id") => party.id })
        end
      end

      if  @res_agent &&  @res_agent.dataset.size!="0"
        for r in @res_agent.dataset.rows
          agent = TbAgent.new
          agent.party_id = party_id_hash[r.get_data("party_id")]
          agent.name = r.get_data("name")
          agent.status = r.get_data("status")
          agent.duty = r.get_data("duty")
          agent.postcode = r.get_data("postcode")
          agent.company = r.get_data("company")
          agent.addr = r.get_data("addr")
          agent.email = r.get_data("email")
          agent.mobiletel = r.get_data("mobiletel")
          agent.tel = r.get_data("tel")
          agent.post_tel_code = r.get_data("post_tel_code")
          agent.partytype = 1
          agent.recevice_code=recevice_code
          agent.used = "Y"
          agent.u=user_code
          agent.u_t=Time.now()
          agent.save
        end
      end

      if @res_party_request && @res_party_request.dataset.size!="0"
        for r in @res_party_request.dataset.rows
          pq = TbPartyrequest.new
          pq.party_id = r.get_data("party_id")
          pq.request_text = r.get_data("request_text")
          pq.factreason = r.get_data("factreason")
          pq.recevice_code = recevice_code
          pq.used = "Y"
          pq.u = user_code
          pq.u_t = Time.now()
          pq.save
        end
      end

      if @res_contractsign && @res_contractsign.dataset.size!="0"
        for r in @res_contractsign.dataset.rows
          contra = TbContractsign.new
          contra.contractdate = r.get_data("contractdate")
          contra.pactname = r.get_data("pactname")
          contra.note = r.get_data("note")
          contra.recevice_code = recevice_code
          contra.used = "Y"
          contra.u = user_code
          contra.u_t = Time.now()
          contra.save
        end
      end

      fd = Extranet::FileDown.new
      if @res_att && @res_att.dataset.size!="0"
        for r in @res_att.dataset.rows
          att = Attachment.new
          att.category = r.get_data("category")
          att.up_time = r.get_data("up_time")
          att.file_name = r.get_data("file_name")
          att.remark = r.get_data("remark")
          att.guid = r.get_data("guid")
          att.content_type  = r.get_data("content_type")
          att.ext_file_path  = r.get_data("ext_file_path")
          att.ext_file_url  = r.get_data("ext_file_url")
          #下载文件
          path =fd.down(att)
          //
          att.file_path = path
          att.file_url = path
          att_id = att.save

          ct= CaseAtt.new
          ct.recevice_code = recevice_code
          ct.category = "party"
          ct.att_id = att.id
          ct.used = "Y"
          ct.u_typ = "party"
          ct.u = r.get_data("u")
          ct.u_t = Time.now()
          ct.save
        end
      end


      #如果提交人是当事方则同步该当事当用户信息，并分配到案件。
      if @res_case.dataset.rows[0].get_data("u_typ") == "party"
        w_u = @res_case.dataset.rows[0].get_data("u")
        unless WUser.find_by_code(w_u)
          req_user = Jrdb::ReqPacket.new
          req_user.from = "w_user"
          con = Array.new
          con << "code=? "
          con << w_u
          req_user.conditions = con
          req_user.order = "id asc"
          @res_user = jrdb.find_all(req_user)
          r = @res_user.dataset.rows[0]
          w_user = WUser.new
          w_user.code = r.get_data("code")
          w_user.name = r.get_data("name")
          w_user.password = r.get_data("password")
          w_user.name_idcard = r.get_data("name_idcard")
          w_user.name = w_user.name_idcard if w_user.name.blank?
          w_user.id_card = r.get_data("id_card")
          w_user.telephone = r.get_data("telephone")
          w_user.email = r.get_data("email")
          w_user.identity = r.get_data("identity")
          w_user.remark = r.get_data("remark")
          w_user.paperwork_type = r.get_data("paperwork_type")
          w_user.paperwork_id = r.get_data("paperwork_id")
          w_user.fax = r.get_data("fax")
          w_user.postcode = r.get_data("postcode")
          w_user.company = r.get_data("company")
          w_user.addr = r.get_data("addr")
          w_user.other_contact = r.get_data("other_contact")
          w_user.active = "1"
          w_user.status = "Y"
          w_user.u = user_code
          w_user.u_t = Time.now()


          fd = Extranet::FileDown.new
          req_wuser_att = Jrdb::ReqPacket.new
          req_wuser_att.from = "attachment"
          con = Array.new
          con << "id=?"
          con << r.get_data("paperwork_id")
          req_wuser_att.conditions = con

          @res_wuser_att = jrdb.find_all(req_wuser_att)
          if @res_wuser_att && @res_wuser_att.dataset.size!="0"
            rr =  @res_wuser_att.dataset.rows[0]
            att = Attachment.new
            att.category = rr.get_data("category")
            att.up_time = rr.get_data("up_time")
            att.file_name = rr.get_data("file_name")
            att.remark = rr.get_data("remark")
            att.guid = rr.get_data("guid")
            att.content_type  = rr.get_data("content_type")
            att.ext_file_path  = rr.get_data("ext_file_path")
            att.ext_file_url  = rr.get_data("ext_file_url")
            #下载文件
            path =fd.down(att)
            ###
            att.file_path = path
            att.file_url = path
            att.save
          end

          if att
            w_user.paperwork_id = att.id
          else
            w_user.paperwork_id = 0
          end
          w_user.save

          req_w_user = Jrdb::ReqPacket.new
          req_w_user.from = "w_user"
          req_w_user.id = r.get_data("id")
          values = Array.new
          p = Jrdb::Param.new
          p.name="status_a"
          p.val="1"
          values << p
          req_w_user.values = values
          @res_w_user_up = jrdb.update(req_w_user)

        end

        cuser = CaseWUser.new
        cuser.recevice_code = recevice_code
        cuser.user_type = 1
        cuser.user_code = w_u
        cuser.used = "Y"
        cuser.u = user_code
        cuser.u_t = Time.now()
        cuser.save
      end


      req_case_up = Jrdb::ReqPacket.new
      req_case_up.from = "case_apply_base"
      req_case_up.id = @res_case.dataset.rows[0].get_data("id")
      values = Array.new
      p = Jrdb::Param.new
      p.name="status"
      p.val="2"
      values << p
      req_case_up.values = values
      @res_case_up = jrdb.update(req_case_up)

      
      return true
    else

      return false
    end
 end
  
end
