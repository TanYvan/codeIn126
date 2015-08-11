# To change this template, choose Tools | Templates
# and open the template in the editor.

class Jrdb::Row
  attr_accessor :value
  def get_data(name)
    rrr = ""
		self.value.each{|v|
      if v.name.upcase == name.upcase
        return v.get_val
      end
    }
		return rrr;
  end
  
  def get_data_2(name)
    rrr = nil
		self.value.each{|v|
      if v.name.upcase == name.upcase
        return v.get_val
      end
    }
		return rrr;
  end

  def put_to(m)
    m_v = {}
    m.attribute_names.each{|f|
      v = get_data_2(f)
      if f!="id" && v
        m_v.merge!({f => v})
      end
    }
    m.attributes = m_v
    return m
  end
end
