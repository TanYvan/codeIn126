# To change this template, choose Tools | Templates
# and open the template in the editor.

class Jrdb::Value
  attr_accessor :name;
	attr_accessor :val;
  
  def get_val
    if val
      return Base64.decode64(val)
    else
      return ""
    end
  end

  def to_xml
#    {:name => @name,
#    :val => @val}.to_xml
    if @val
      @val = Base64.encode64(@val)
    else
      @val = ""
    end
    return "<name>#{@name}</name><val>#{@val}</val>"
  end
end
