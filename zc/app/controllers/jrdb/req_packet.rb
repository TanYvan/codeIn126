# To change this template, choose Tools | Templates
# and open the template in the editor.

class Jrdb::ReqPacket
  attr_accessor :sql
  attr_accessor :stamp
  attr_accessor :signmsg
  attr_accessor :select
  attr_accessor :from
  attr_accessor :joins
  attr_accessor :conditions
  attr_accessor :group
  attr_accessor :having
  attr_accessor :offset
  attr_accessor :limit
  attr_accessor :order
  attr_accessor :id
  attr_accessor :values
  attr_accessor :perpage
  attr_accessor :page
  attr_accessor :params
  
  def initialize
    self.sql = ""
    self.stamp = ""
    self.signmsg = ""
    self.select = ""
    self.from = ""
    self.joins = ""
    self.conditions = ""
    self.group = ""
    self.having = ""
    self.offset = ""
    self.limit = ""
    self.order = ""
    self.id = ""
    self.values = ""
    self.perpage = ""
    self.page = ""
    self.params = ""
  end

  def to_xml
    params_params=""
    if @params!=nil
       @params.each{|p|
         params_params = params_params + "<param>" + p.to_xml + "</param>"
       }
    end

    value_value=""
    if @values
       @values.each{|p|
         value_value = value_value + "<value>" + p.to_xml + "</value>"
       }
    end
    
    condition_condition=""
    if @conditions
      @conditions.each{|p|
        condition_condition = condition_condition + "<condition>" + Base64.encode64(p.to_s) + "</condition>"
      }
    end

    having_having=""
    if @havings
      @havings.each{|p|
        having_having = having_having + "<condition>" + Base64.encode64(p.to_s) + "</condition>"
      }
    end

    self.select = Base64.encode64(self.select)
    self.from = Base64.encode64(self.from)
    self.group = Base64.encode64(self.group)
    self.order = Base64.encode64(self.order)

    rrr = ""
    rrr = rrr +  "<sql>#{@sql}</sql>"
    rrr = rrr +  "<stamp>#{@stamp}</stamp>"
    rrr = rrr +  "<signmsg>#{@signmsg}</signmsg>"
    rrr = rrr +  "<select>#{@select}</select>"
    rrr = rrr +  "<from>#{@from}</from>"
    rrr = rrr +  "<joins>#{@joins}</joins>"
    rrr = rrr +  "<conditions>#{condition_condition}</conditions>"
    rrr = rrr +  "<group>#{@group}</group>"
    rrr = rrr +  "<havings>#{having_having}</havings>"
    rrr = rrr +  "<offset>#{@offset}</offset>"
    rrr = rrr +  "<limit>#{@limit}</limit>"
    rrr = rrr +  "<order>#{@order}</order>"
    rrr = rrr +  "<id>#{@id}</id>"
    rrr = rrr +  "<values>#{value_value}</values>"
    rrr = rrr +  "<perpage>#{@perpage}</perpage>"
    rrr = rrr +  "<page>#{@page}</page>"
    rrr = rrr +  "<params>#{params_params}</params>"
#    puts value_value
#    rrr = rrr + rrr.gsub!("&lt;","<") if rrr.include?("&lt;")
#    rrr = rrr + rrr.gsub!("&gt;",">") if rrr.include?("&gt;")
#    rrr = rrr + rrr.gsub!("<hash>","") if rrr.include?("<hash>")
#    rrr = rrr + rrr.gsub!("</hash>","") if rrr.include?("</hash>")
#    rrr = rrr + rrr.gsub!("<?xml version=\"1.0\" encoding=\"UTF-8\"?>","") if rrr.include?("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    return "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xml>" + rrr + "</xml>"
  end
end
