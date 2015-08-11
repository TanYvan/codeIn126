# To change this template, choose Tools | Templates
# and open the template in the editor.
require "crack"
require "base64"
class Jrdb::ResPacket
  attr_accessor :iden;
  attr_accessor :sql;
	attr_accessor :sql1;
	attr_accessor :sql2;
	attr_accessor :status;
	attr_accessor :error;
	attr_accessor :dataset;
	attr_accessor :params;

  def fill(s)
    resp = Crack::XML.parse(s)
    self.iden = resp["xml"]["iden"]
    self.sql = resp["xml"]["sql"]
    self.sql1 = resp["xml"]["sql1"]
    self.sql2 = resp["xml"]["sql2"]
    self.status = resp["xml"]["status"]
    self.error = resp["xml"]["error"]
    data_xml =  resp["xml"]["dataset"]
    params_xml =  resp["xml"]["params"]

    self.sql = Base64.decode64(self.sql) if self.sql
    self.sql1 = Base64.decode64(self.sql1) if self.sql1
    self.sql2 = Base64.decode64(self.sql2) if self.sql2
    self.error = Base64.decode64(self.error) if self.error

    unless  data_xml.blank?
      d_set = Jrdb::DataSet.new
      d_set.size = data_xml["size"]
      d_set.count = data_xml["count"]
      d_set.page = data_xml["page"]
      d_set.perpage = data_xml["perpage"]
      d_set.pages = data_xml["pages"]

      if data_xml["rows"] && data_xml["rows"]["row"]
        rows = data_xml["rows"]["row"]
        if rows.class == Hash
          rows = [rows]
        end
        row_array = Array.new
        rows.each{|row|
          val_array = Array.new
          value_xml = row["value"]
          if row["value"] == Hash
            value_xml = [value]
          end
          value_xml.each{|v|
            val = Jrdb::Value.new
            val.name = v["name"]
            val.val = v["val"]
            val_array << val
          }
          row = Jrdb::Row.new
          row.value = val_array
          row_array << row
        }
        d_set.rows = row_array
      end
      self.dataset = d_set
    end

    unless params_xml.blank?
      if params_xml["param"] 
        param_s = params_xml["param"]
        if param_s.class == Hash
          param_s = [param_s]
        end
        param_array = Array.new
        param_s.each{|param|
          par = Jrdb::Param.new
          par.name = param["name"]
          if param["val"]
            par.val = Base64.decode64(param["val"])
          else
            par.val == ""
          end
          param_array << par
        }
      end
      self.params = param_array
    end

  end

end
