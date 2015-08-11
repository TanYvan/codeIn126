class CaseApplyController < ApplicationController
  def list
    @apply_code = params[:apply_code]
    @party_name = params[:party_name]
    @apply_code = @apply_code.lstrip.rstrip if @apply_code
    @party_name = @party_name.lstrip.rstrip if @party_name
    
    @new_url = params[:new_url]
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "case_apply_base"
    req.select = "id, apply_code, status, fun_partyinfo_1(apply_code) as partyinfo_1, fun_partyinfo_2(apply_code) as partyinfo_2"
		con = Array.new
    ccc = "status=1"
    unless @apply_code.blank?
      ccc= ccc + " and apply_code like ?"
    end
    unless @party_name.blank?
      ccc= ccc + " and fun_partyinfo_1(apply_code) like ?"
    end
    con << ccc
    unless @apply_code.blank?
      con << "%#{@apply_code}%"
    end
    unless @party_name.blank?
      con << "%#{@party_name}%"
    end
		req.conditions = con
    req.order = "id desc"
    if params[:new_url]
      par = Jrdb::Param.new
      par.name = "new_url"
      par.val = params[:new_url]
      pars = Array.new
      pars << par
      req.params = pars
    end
    if params["parpage"].blank?
      req.perpage=session[:lines]
    else
      req.perpage=params["parpage"]
    end

    unless params["page"].blank?
      req.page=params["page"]
    else
      req.page=1
    end  
		@res = jrdb.paginate_jr(req)
		if @res.status == "1"
      @page_bar = jrdb.page_bar(@res,"/case_apply/list","") + "<br/>"
    else
      flash[:notice]="案件申请信息获取失败"
    end
		
  end

  def show_case
    jrdb=Jrdb::Jrdb.new
		req_case = Jrdb::ReqPacket.new
		req_case.from = "case_apply_base"
		con = Array.new
    con << "apply_code=? and status=1"
    con << params[:apply_code]
		req_case.conditions = con
    @res_case = jrdb.find_all(req_case)

		req_party = Jrdb::ReqPacket.new
		req_party.from = "party"
		con = Array.new
    con << "apply_code=? and partytype=1 and used='Y'"
    con << params[:apply_code]
		req_party.conditions = con
    req_party.order = "id asc"
    @res_party = jrdb.find_all(req_party)

    req_party2 = Jrdb::ReqPacket.new
		req_party2.from = "party"
		con = Array.new
    con << "apply_code=? and partytype=2 and used='Y'"
    con << params[:apply_code]
		req_party2.conditions = con
    req_party2.order = "id asc"
    @res_party2 = jrdb.find_all(req_party2)

    req_agent = Jrdb::ReqPacket.new
		req_agent.from = "agents"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << params[:apply_code]
		req_agent.conditions = con
    req_agent.order = "id asc"
    @res_agent = jrdb.find_all(req_agent)

    req_party_request = Jrdb::ReqPacket.new
		req_party_request.from = "party_request"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << params[:apply_code]
		req_party_request.conditions = con
    req_party_request.order = "id asc"
    @res_party_request = jrdb.find_all(req_party_request)

    req_contractsign = Jrdb::ReqPacket.new
		req_contractsign.from = "contractsign"
		con = Array.new
    con << "apply_code=? and used='Y'"
    con << params[:apply_code]
		req_contractsign.conditions = con
    req_contractsign.order = "id asc"
    @res_contractsign = jrdb.find_all(req_contractsign)
    if @res_contractsign.dataset.size!="0"
      @apply_acceptt = @res_contractsign.dataset.get_data(0,"contractdate")
    else
      @apply_acceptt = ""
    end

    req_att = Jrdb::ReqPacket.new
		req_att.from = "case_att,attachment"
    req_att.select = "attachment.id as id,attachment.category as category,attachment.up_time as up_time,attachment.file_name as file_name,attachment.remark as remark"
		con = Array.new
    con << "case_att.apply_code=? and case_att.used='Y' and case_att.att_id=attachment.id"
    con << params[:apply_code]
		req_att.conditions = con
    req_att.order = "attachment.id asc"
    @res_att = jrdb.find_all(req_att)

    if @res_case.dataset.get_data(0, "u_typ")=="party"
      @w_user = WUser.find_by_code(@res_case.dataset.get_data(0, "u"))
      if @w_user==nil
        jrdb=Jrdb::Jrdb.new
        req_w_user = Jrdb::ReqPacket.new
        req_w_user.from = "w_user"
        con = Array.new
        con << "code=?"
        con << @res_case.dataset.get_data(0, "u")
        req_w_user.conditions = con
        @res_w_user = jrdb.find_all(req_w_user)
      end
    else
      @user = User.find_by_code(@res_case.dataset.get_data(0, "u"))
    end

  end

  def get_file
    jrdb=Jrdb::Jrdb.new
    req = Jrdb::ReqPacket.new
		req.from = "attachment"
    con = Array.new
    con << "id=?"
    con << params["id"]
		req.conditions = con
    @res = jrdb.find_all(req)
    if @res.status == "1"
      att = Attachment.new
      att.category = @res.dataset.get_data(0, "category")
      att.ext_file_path = @res.dataset.get_data(0, "ext_file_path")
      fd = Extranet::FileDown.new
      send_data(fd.get_file(att), :filename => @res.dataset.get_data(0, "file_name"))
    end
  end

end
