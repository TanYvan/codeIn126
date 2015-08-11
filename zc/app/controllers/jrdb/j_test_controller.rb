class Jrdb::JTestController < ApplicationController
  def index
    
  end

  def create
    jrdb=Jrdb::Jrdb.new
    req= Jrdb::ReqPacket.new
		req.from="aaa"
		values = Array.new
    p = Jrdb::Param.new
    p.name="code"
    p.val="0001"
    values << p
    p = Jrdb::Param.new
    p.name="name"
    p.val="北京"
    values << p
    req.values = values
    res=jrdb.create(req)
    if res.status=="1"
      render :text=> "create 成功<br/>"  + res.sql
    else
      render :text=> "create 失败<br/>"  + res.error
    end
  end
  
  def update
    jrdb=Jrdb::Jrdb.new
    req= Jrdb::ReqPacket.new
		req.from="aaa"
		values = Array.new
    p = Jrdb::Param.new
    p.name="code"
    p.val="00010001"
    values << p
    p = Jrdb::Param.new
    p.name="name"
    p.val="北京北京"
    values << p
    req.values = values
    req.id="22"
    res=jrdb.update(req)
    if res.status=="1"
      render :text=> "update 成功<br/>"  + res.sql
    else
      render :text=> "update 失败<br/>"  + res.error
    end
  end

  def update_all
    jrdb=Jrdb::Jrdb.new
    req= Jrdb::ReqPacket.new
		req.from="aaa"
		values = Array.new
    p = Jrdb::Param.new
    p.name="code"
    p.val="000100010001"
    values << p
    p = Jrdb::Param.new
    p.name="name"
    p.val="北京北京北京"
    values << p
    req.values = values
    con = Array.new
    con << "id>=? and id<=?"
    con << "22"
    con << "23"
    req.conditions=con
    res=jrdb.update_all(req)
    if res.status=="1"
      render :text=> "update 成功<br/>"  + res.sql
    else
      render :text=> "update 失败<br/>"  + res.error
    end
  end

  def find_all
    jrdb=Jrdb::Jrdb.new
    req = Jrdb::ReqPacket.new
		req.from = "aaa"
		req.select = "id,code,name"
		con = Array.new
    con << "id<?"
    con << "30"
		req.conditions = con
		res = jrdb.find_all(req)

    rrr = ""
		rrr = rrr + "Sql----------------------------<br/>"
		rrr = rrr + res.sql + "<br/>"
		if res.status == "1"
			rrr = rrr + "Dataset------------------------<br/>"
      rrr = rrr + res.dataset.size + "<br/>"
			ds= res.dataset
			rrr = rrr + "遍历方法1---------------------------<br/>"
			for r in ds.rows
				rrr = rrr + r.get_data("id") + "<br/>"
				rrr = rrr + r.get_data("code") + "<br/>"
			end

			rrr = rrr + "遍历方法2---------------------------<br/>"
      i = 0
			while i < ds.size.to_i
				rrr = rrr + ds.get_data(i,"id") + "<br/>"
				rrr = rrr + ds.get_data(i,"code") + "<br/>"
        i = i + 1
      end
    end

    render :text => rrr
  end

  def  paginate_jr
    jrdb=Jrdb::Jrdb.new
		req = Jrdb::ReqPacket.new
		req.from = "aaa"
		req.select = "id,code,name"
		con = Array.new
    con << "id<?"
    con << "30"
		req.conditions = con
    req.perpage = "2"
		res = jrdb.paginate_jr(req)
    
		rrr = ""
		rrr = rrr + "Sql1----------------------------<br/>"
		rrr = rrr + res.sql1 + "<br/>"
    rrr = rrr + "Sql2----------------------------<br/>"
		rrr = rrr + res.sql2 + "<br/>"
		if res.status == "1"
			rrr = rrr + "Dataset------------------------<br/>"
      rrr = rrr + res.dataset.size + "<br/>"
			ds= res.dataset
			rrr = rrr + "遍历方法1---------------------------<br/>"
			for r in ds.rows
				rrr = rrr + r.get_data("id") + "<br/>"
				rrr = rrr + r.get_data("code") + "<br/>"
			end

			rrr = rrr + "遍历方法2---------------------------<br/>"
      i = 0
			while i < ds.size.to_i
				rrr = rrr + ds.get_data(i,"id") + "<br/>"
				rrr = rrr + ds.get_data(i,"code") + "<br/>"
        i = i + 1
      end
    end
    rrr = rrr + "翻页----------------------------<br/>"
		rrr = rrr + jrdb.page_bar(res,"http://www.baidu.com","haha") + "<br/>"
    
    render :text => rrr
  end

  def att_down
    fd = Extranet::FileDown.new
    a=""
    fd.down(23,Attachment.find(76))
    render :text => "aaaa"
  end

end
