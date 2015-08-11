# To change this template, choose Tools | Templates
# and open the template in the editor.

class Jrdb::DataSet
  attr_accessor :size
	attr_accessor :count
	attr_accessor :perpage
	attr_accessor :rows
	attr_accessor :page
	attr_accessor :pages

  def get_row( i )
    if i <= self.rows.size
      self.rows[i]
    else
      return nil
    end
  end

  def get_data(i,name )
    
    if i < self.size.to_i
      self.rows[i].value.each{|v|
        if v.name.upcase == name.upcase
          return v.get_val
        end
      }
    else
      return nil
    end
  end

end
