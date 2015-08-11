# To change this template, choose Tools | Templates
# and open the template in the editor.
require "net/http"
require "uri"
require "digest/md5"
class Jrdb::Jrdb
  #
  attr_accessor :jrdb_url;
  attr_accessor :key

  def initialize
    self.jrdb_url= "http://115.29.137.114:9091/"
    self.key = "yihua123456"
  end

  def set_jrdb_url(i)
    if i==1

    elsif i==2

    elsif i==3

    elsif i==4

    elsif i==5

    end
  end

  def stamp_do(req)
    s = Time.now.to_s(:db)
    req.stamp = s
    req.signmsg = Digest::MD5.hexdigest(s + key)
    return req
  end

	def create(req)		
		if req.from.blank?
			raise "JrDb local error: create 'from' can't null"
    end
		if req.values.blank?
			raise "JrDb local error:  create 'values' can't null"
    end
    
    req = stamp_do(req)
		uri = URI.parse(jrdb_url + "jrdb/create")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"xml" => req.to_xml})
    response = http.request(request)
    res = Jrdb::ResPacket.new
    res.fill(response.body)
    if res.status=="0"
      r = "JrDb remote error:"
      r = r + "\nsql:#{res.sql}" if res.sql
      r = r + " \nerror:#{res.error}" if res.error
      raise r
    end
    return  res
  end

  def update(req)
		if req.from.blank?
			raise "JrDb local error: update 'from' can't null"
    end
		if req.id.blank?
			raise "JrDb local error: update 'id' can't null"
    end
		if req.values.blank?
			raise "JrDb local error:  update 'values' can't null"
    end
    
    req = stamp_do(req)
	  uri = URI.parse(jrdb_url + "jrdb/update")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"xml" => req.to_xml})
    response = http.request(request)
    res = Jrdb::ResPacket.new
    res.fill(response.body)

		res.fill(response.body)
    if res.status=="0"
      r = "JrDb remote error:"
      r = r + "\nsql:#{res.sql}" if res.sql
      r = r + " \nerror:#{res.error}" if res.error
      raise r
    end
    return  res
  end

	def update_all(req)
		if req.from.blank?
			raise "JrDb local error: update_all 'from' can't null";
    end
		if req.values.blank?
			raise "JrDb local error:  update_all 'values' can't null";
    end
		if req.conditions.blank?
			raise "JrDb local error:  update_all 'conditions' can't null";
    end

    req = stamp_do(req)
		uri = URI.parse(jrdb_url + "jrdb/update_all")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"xml" => req.to_xml})
    response = http.request(request)
    res = Jrdb::ResPacket.new
    res.fill(response.body)
    if res.status=="0"
      r = "JrDb remote error:"
      r = r + "\nsql:#{res.sql}" if res.sql
      r = r + " \nerror:#{res.error}" if res.error
      raise r
    end
    return  res
  end

  def find_all(req)
		if req.from.blank?
			raise "JrDb local error: find_all 'from' can't null";
    end
		if req.conditions.blank?
			raise "JrDb local error: find_all 'conditions' can't null";
    end

    req = stamp_do(req)
		uri = URI.parse(jrdb_url + "jrdb/find_all_first")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"xml" => req.to_xml})
    response = http.request(request)
    res = Jrdb::ResPacket.new
    res.fill(response.body)
		if res.status=="0"
      r = "JrDb remote error:"
      r = r + "\nsql1:#{res.sql1}" if res.sql1
      r = r + "\nsql2:#{res.sql2}" if res.sql2
      r = r + " \nerror:#{res.error}" if res.error
      raise r
		end
    return  res
  end

  def paginate_jr(req)
		if req.from.blank?
			raise "JrDb local error: find_all 'from' can't null";
    end
		if req.conditions.blank?
			raise "JrDb local error: find_all 'conditions' can't null";
    end

    req = stamp_do(req)
		uri = URI.parse(jrdb_url + "jrdb/paginate_jr")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"xml" => req.to_xml})
    response = http.request(request)
    res = Jrdb::ResPacket.new
    res.fill(response.body)
		if res.status=="0"
      r = "JrDb remote error:"
      r = r + "\nsql1:#{res.sql1}" if res.sql1
      r = r + "\nsql2:#{res.sql2}" if res.sql2
      r = r + " \nerror:#{res.error}" if res.error
      raise r
		end
    return  res
  end

  def page_bar(res,url,css)
		param_str = "";
		if res.params
			for p in  res.params
				param_str = param_str + p.name + "=" + p.val + "&";
      end
		else
			param_str = "";
    end
		page = res.dataset.page.to_i
		rrr = "";
		rrr= rrr + "<div class='" + css + "'>";
        if (res.dataset.pages!="1" && res.dataset.pages!="0")
        	rrr = rrr + "<form action='#{url}?#{}param_str}' method='post' onsubmit=\"return page_bar_check('perpage','page')\">"
        	if (res.dataset.page!="1")
            rrr = rrr + "<a href='" + url + "?perpage=#{res.dataset.perpage}&page=#{page - 1}&#{param_str}'>上一页<a>&nbsp;&nbsp;"
          end
          if (res.dataset.page !=res.dataset.pages)
            rrr = rrr + "<a href='" + url + "?perpage=#{res.dataset.perpage}&page=#{page + 1}&#{param_str}'>下一页<a>&nbsp;&nbsp;"
          end
        	rrr = rrr + "共" + res.dataset.pages + "页,"
        	rrr = rrr + "每页<input type=text id='perpage' name='perpage' size='4' value='#{res.dataset.perpage}'/>条记录,第"
        	rrr = rrr + "<input type='text' id='page' name='page' size='4' value='#{res.dataset.page}'/>"
        	rrr = rrr + "<input type='submit' value='确定' />"
        	rrr = rrr + "</form>"
        end
        rrr = rrr + "</div>"
        rrr = rrr + "<script language='javascript'>"
        rrr = rrr + "function page_bar_check(obj1,obj2){"
        rrr = rrr + "if ( /^[0-9]*[1-9][0-9]*$/.test(document.getElementById(obj1).value)  &&  /^[0-9]*[1-9][0-9]*$/.test(document.getElementById(obj2).value) )"
        rrr = rrr + "{"
        rrr = rrr + "return true;"
        rrr = rrr + "}else{"
        rrr = rrr + "alert('请正确输入数字！');"
        rrr = rrr + "return false;"
        rrr = rrr + "}"
        rrr = rrr + "}"
        rrr = rrr + "</script>"
        return rrr
  end


end
