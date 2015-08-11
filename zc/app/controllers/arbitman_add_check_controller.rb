class ArbitmanAddCheckController < ApplicationController
  def create
    arbitman_id = "0"
    if params[:arbitman_code].blank?
      flash[:notice]="仲裁员编码为空！仲裁员信息同步失败"
    else
      jrdb=Jrdb::Jrdb.new
      req = Jrdb::ReqPacket.new
      req.from = "arbitman"
      con = Array.new
      ccc = "code=? and status_a=0 and used='Y'"
      con << ccc
      con << params[:arbitman_code]
      req.conditions = con
      @res = jrdb.find_all(req)
      check(@res.dataset.get_data(0,"name"), @res.dataset.get_data(0,"mobiletel"), @res.dataset.get_data(0,"email"))
      if @res.status == "1" && @res.dataset.size!="0" && @res.dataset.get_data(0,"status_a")=="0"
        check_mes = check(@res.dataset.get_data(0,"name"), @res.dataset.get_data(0,"mobiletel"), @res.dataset.get_data(0,"email"))
        if check_mes != "ok"
          flash[:notice]=check_mes + "仲裁员信息同步失败"
        else
          arbitman_id = @res.dataset.get_data(0,"id")
          atbitman_sub = ArbitmanSub.new
          atbitman_sub = @res.dataset.rows[0].put_to(atbitman_sub)
          atbitman_sub.save!

          atbitman = TbArbitman.new
          atbitman = @res.dataset.rows[0].put_to(atbitman)
          atbitman.save!

          atbitman_sub.p_id=atbitman.id
          atbitman_sub.save!

          atbitman.sub_id = atbitman_sub.id
          atbitman.save!

          jrdb=Jrdb::Jrdb.new
          req = Jrdb::ReqPacket.new
          req.from = "educate"
          con = Array.new
          ccc = "arbitman=? and used='Y'"
          con << ccc
          con << params[:arbitman_code] unless params[:arbitman_code].blank?
          req.conditions = con
          req.order = "id asc"
          @res = jrdb.find_all(req)
          if @res.status == "1" && @res.dataset.size!="0"
            for r in @res.dataset.rows
              educate_sub = EducateSub.new
              educate_sub = r.put_to(educate_sub)
              educate_sub.save!

              educate = TbEducate.new
              educate = r.put_to(educate)
              educate.save!

              educate_sub.p_id=educate.id
              educate_sub.save!

              educate.sub_id = educate_sub.id
              educate.save!
            end

          end

          jrdb=Jrdb::Jrdb.new
          req = Jrdb::ReqPacket.new
          req.from = "industry"
          con = Array.new
          ccc = "arbitman_num=? and used='Y'"
          con << ccc
          con << params[:arbitman_code] unless params[:arbitman_code].blank?
          req.conditions = con
          req.order = "id asc"
          @res = jrdb.find_all(req)
          if @res.status == "1" && @res.dataset.size!="0"
            for r in @res.dataset.rows
              industry_sub = IndustrySub.new
              industry_sub = r.put_to(industry_sub)
              industry_sub.save!

              industry = Industry.new
              industry = r.put_to(industry)
              industry.save!

              industry_sub.p_id=industry.id
              industry_sub.save!

              industry.sub_id = industry_sub.id
              industry.save!
            end
          end

          jrdb=Jrdb::Jrdb.new
          req = Jrdb::ReqPacket.new
          req.from = "resume"
          con = Array.new
          ccc = "arbit_id=? and used='Y'"
          con << ccc
          con << params[:arbitman_code] unless params[:arbitman_code].blank?
          req.conditions = con
          req.order = "id asc"
          @res = jrdb.find_all(req)
          if @res.status == "1" && @res.dataset.size!="0"
            for r in @res.dataset.rows
              resume_sub = ResumeSub.new
              resume_sub = r.put_to(resume_sub)
              resume_sub.save!

              resume = TbResume.new
              resume = r.put_to(resume)
              resume.save!

              resume_sub.p_id=resume.id
              resume_sub.save!

              resume.sub_id = resume_sub.id
              resume.save!
            end
          end

          jrdb=Jrdb::Jrdb.new
          req = Jrdb::ReqPacket.new
          req.from = "language"
          con = Array.new
          ccc = "arbitman=? and used='Y'"
          con << ccc
          con << params[:arbitman_code] unless params[:arbitman_code].blank?
          req.conditions = con
          req.order = "lannum asc,id asc"
          @res = jrdb.find_all(req)
          if @res.status == "1" && @res.dataset.size!="0"
            for r in @res.dataset.rows
              language_sub = LanguageSub.new
              language_sub = r.put_to(language_sub)
              language_sub.save!

              language = TbLanguage.new
              language = r.put_to(language)
              language.save!

              language_sub.p_id=language.id
              language_sub.save!

              language.sub_id = language_sub.id
              language.save!
            end
          end

          jrdb=Jrdb::Jrdb.new
          req = Jrdb::ReqPacket.new
          req.from = "arbitman_att,attachment"
          req.select = "attachment.category as category,attachment.up_time as up_time,attachment.file_name as file_name,attachment.ext_file_path as ext_file_path,attachment.ext_file_url as ext_file_url,attachment.remark as remark,attachment.description as description,attachment.content_type as content_type"
          con = Array.new
          con << "arbitman_att.arbitman=? and arbitman_att.used='Y' and arbitman_att.att_id=attachment.id"
          con << params[:arbitman_code] unless params[:arbitman_code].blank?
          req.conditions = con
          req.order = "attachment.id asc"
          @res = jrdb.find_all(req)
          if @res.status == "1" && @res.dataset.size!="0"
            fd = Extranet::FileDown.new
            for r in @res.dataset.rows

              attachment = Attachment.new
              attachment = r.put_to(attachment)
              #下载文件
              path = fd.down(attachment)
              //
              attachment.file_path = path
              attachment.file_url = path
              attachment.save!

              arbitman_att = ArbitmanAtt.new
              arbitman_att.arbitman = params[:arbitman_code]
              arbitman_att.att_id = attachment.id
              arbitman_att.u = session[:user_code]
              arbitman_att.u_t = Time.now()
              arbitman_att.used = "Y"
              arbitman_att.save!
            end
          end

          jrdb=Jrdb::Jrdb.new
          req_arbitman_up = Jrdb::ReqPacket.new
          req_arbitman_up.from = "arbitman"
          req_arbitman_up.id = arbitman_id
          values = Array.new
          p = Jrdb::Param.new
          p.name="status_a"
          p.val="1"
          values << p
          req_arbitman_up.values = values
          jrdb.update(req_arbitman_up)

          flash[:notice]="仲裁员信息同步成功"
        end
      else
        flash[:notice]="远程数据获取失败，仲裁员信息同步失败"
      end
    end
    redirect_to :action => "list"
  end
  
  def list
    @name = params[:name]
    @d1 = params[:d1]
    @d2 = params[:d2]
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "arbitman"
		con = Array.new
    ccc = "status_a=0"
    unless @d1.blank?
      ccc= ccc + " and register_time>? "
    end
    unless @d2.blank?
      ccc= ccc + " and register_time<? "
    end
    unless @name.blank?
      ccc= ccc + " and (name_idcard like ? )"
    end
    
    con << ccc

    unless @d1.blank?
      con << @d1
    end
    unless @d2.blank?
      con << @d2
    end
    unless @name.blank?
      con << "%#{@name}%"
    end
    req.order="code desc"
		req.conditions = con
    if params["parpage"].blank?
      req.perpage=session[:lines]
    else
      req.perpage=params["parpage"]
    end
    req.perpage = "50"
    unless params["page"].blank?
      req.page=params["page"]
    end
		@res = jrdb.paginate_jr(req)
		if @res.status == "1"
      @page_bar = jrdb.page_bar(@res,"/arbitman_add_check/list","") + "<br/>"
    else
      flash[:notice]="仲裁员信息获取失败"
    end
  end
  
  def list_2
    @name = params[:name]
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "arbitman"
		con = Array.new
    ccc = "status_a=1"
    unless @name.blank?
      ccc= ccc + " and name_idcard like ?"
    end
    con << ccc
    unless @name.blank?
      con << "%#{@name}%"
    end
    req.order="code desc"
		req.conditions = con
    if params["parpage"].blank?
      req.perpage=session[:lines]
    else
      req.perpage=params["parpage"]
    end
    req.perpage = "50"
    unless params["page"].blank?
      req.page=params["page"]
    end
		@res = jrdb.paginate_jr(req)
		if @res.status == "1"
      @page_bar = jrdb.page_bar(@res,"/arbitman_add_check/list_2","") + "<br/>"
    else
      flash[:notice]="仲裁员信息获取失败"
    end
  end

  def show_base
    @identity = {"01"=>"仲裁员","02"=>"调解员","01,02"=>"仲裁员，调解员","02，01"=>"调解员,仲裁员"}
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "arbitman"
		con = Array.new
    ccc = "code=? and used='Y'"
    con << ccc
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
		@res = jrdb.find_all(req)
		if @res.status == "1"
    else
      flash[:notice]="仲裁员信息获取失败"
    end
  end

  def show_educate
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "educate"
		con = Array.new
    ccc = "arbitman=? and used='Y'"
    con << ccc
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
    req.order = "id asc"
		@res = jrdb.find_all(req)
		if @res.status == "1"
    else
      flash[:notice]="信息获取失败"
    end
  end

  def show_industry
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "industry"
		con = Array.new
    ccc = "arbitman_num=? and used='Y'"
    con << ccc
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
    req.order = "id asc"
		@res = jrdb.find_all(req)
		if @res.status == "1"
    else
      flash[:notice]="信息获取失败"
    end
  end

  def show_resume
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "resume"
		con = Array.new
    ccc = "arbit_id=? and used='Y'"
    con << ccc
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
    req.order = "id asc"
		@res = jrdb.find_all(req)
		if @res.status == "1"
    else
      flash[:notice]="信息获取失败"
    end
  end

  def show_language
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "language"
		con = Array.new
    ccc = "arbitman=? and used='Y'"
    con << ccc
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
    req.order = "lannum asc,id asc"
		@res = jrdb.find_all(req)
		if @res.status == "1"
    else
      flash[:notice]="信息获取失败"
    end
  end

  def show_att
    jrdb=Jrdb::Jrdb.new
    req = Jrdb::ReqPacket.new
		req.from = "arbitman_att,attachment"
    req.select = "attachment.id as id,attachment.category as category,attachment.up_time as up_time,attachment.file_name as file_name,attachment.remark as remark"
		con = Array.new
    con << "arbitman_att.arbitman=? and arbitman_att.used='Y' and arbitman_att.att_id=attachment.id"
    con << params[:arbitman_code] unless params[:arbitman_code].blank?
		req.conditions = con
    req.order = "attachment.id asc"
    @res = jrdb.find_all(req)
    if @res.status == "1"
    else
      flash[:notice]="信息获取失败"
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

  def update_arb
      if check(params[:name], params[:mobiletel], params[:email]) == "ok"
        req_up = Jrdb::ReqPacket.new
        req_up.from = "arbitman"
        req_up.id = params[:id]
        values = Array.new
        p = Jrdb::Param.new
        p.name="name"
        p.val = params[:name]
        values << p
        p = Jrdb::Param.new
        p.name="mobiletel"
        p.val= params[:mobiletel]
        values << p
        p = Jrdb::Param.new
        p.name="email"
        p.val= params[:email]
        values << p

        req_up.values = values
        jrdb = Jrdb::Jrdb.new
        res = jrdb.update(req_up)
        if res.status=="1"
          flash[:notice]="修改成功"
        else
          flash[:notice]="修改失败"
        end
      else
        flash[:notice]="修改失败"
      end
      redirect_to :action=>"show_base",:arbitman_code=>params[:arbitman_code],:show=>""
    
  end

  def check_do
    r = check(params[:name], params[:mobiletel], params[:email])
    render :text => r
  end
  
  def check(name,mobiletel,email)
    r=""

    if TbArbitman.find_by_name(name)
      r = r + "名称重复 "
    end

    if TbArbitman.find_by_mobiletel(mobiletel)
      r = r + "手机号码重复 "
    end

    if TbArbitman.find_by_email(email)
      r = r + "email重复 "
    end
    if r==""
      r = "ok"
    else
      r = r + ",请修改后保存。"
    end
    return r
  end
end
