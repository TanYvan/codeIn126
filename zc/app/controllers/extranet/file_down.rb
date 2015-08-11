require 'guid'
# To change this template, choose Tools | Templates
# and open the template in the editor.

class Extranet::FileDown
  attr_accessor :file_url;
  attr_accessor :key;
  def initialize
    self.file_url= "http://115.29.137.114/"
    self.key = "yihua123456"
  end

  def down_for_id(id, att)
    #ran = rand(99999)
    ran = Guid.new.to_s
    base_path = AttachmentConfig.find_by_code(att.category).network_dir
    s = Time.now.to_s(:db)
    aaa = s.split(" ")[0]
    bbb = s.split(" ")[1]
    year = aaa.split("-")[0]
    month = aaa.split("-")[1]
    date = aaa.split("-")[2]
    hour = bbb.split(":")[0]
    minute = bbb.split(":")[1]
    if !File.exists?("#{base_path}/#{year}")
      Dir.mkdir("#{base_path}/#{year}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}")
      Dir.mkdir("#{base_path}/#{year}/#{month}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
    end
    stamp = s
    sign_msg = Digest::MD5.hexdigest("#{id}"+ s + key)
    uri = URI.parse(file_url + "fileProvide/fileDownForId.do")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"stamp" => stamp, "sign_msg" => sign_msg,"id" => id})
    response = http.request(request)
    #response.body
    f = File.new("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{ran}_#{att.file_name}", "wb")
    f.write(response.body)
    f.close
    return "/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{ran}_#{att.file_name}"
  end

  def down(att)
    #ran = rand(99999)
    ran = Guid.new.to_s
    base_path = AttachmentConfig.find_by_code(att.category).network_dir
    s = Time.now.to_s(:db)
    aaa = s.split(" ")[0]
    bbb = s.split(" ")[1]
    year = aaa.split("-")[0]
    month = aaa.split("-")[1]
    date = aaa.split("-")[2]
    hour = bbb.split(":")[0]
    minute = bbb.split(":")[1]
    if !File.exists?("#{base_path}/#{year}")
      Dir.mkdir("#{base_path}/#{year}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}")
      Dir.mkdir("#{base_path}/#{year}/#{month}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}")
    end
    if !File.exists?("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
      Dir.mkdir("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}")
    end
    stamp = s
    sign_msg = Digest::MD5.hexdigest(att.ext_file_path + s + key)
    uri = URI.parse(file_url + "fileProvide/fileDown.do")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"stamp" => stamp, "sign_msg" => sign_msg,"category" => att.category,"file_path" => att.ext_file_path})
    response = http.request(request)
    #response.body
    f = File.new("#{base_path}/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{ran}_#{att.file_name}", "wb")
    f.write(response.body)
    f.close
    return "/#{year}/#{month}/#{date}/#{hour}/#{minute}/#{ran}_#{att.file_name}"
  end

  def get_file(att)
    s = Time.now.to_s(:db)
    stamp = s
    sign_msg = Digest::MD5.hexdigest(att.ext_file_path + s + key)
    uri = URI.parse(file_url + "fileProvide/fileDown.do")
		http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"stamp" => stamp, "sign_msg" => sign_msg,"category" => att.category,"file_path" => att.ext_file_path})
    response = http.request(request)
    #response.body
    return response.body
  end
  
end
