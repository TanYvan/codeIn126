class TbDictionary < ActiveRecord::Base
    #用于选择精通专业的函数
    def self.find_name_with_code(code)
        find(:first, :conditions => ["typ_code = 9012 and data_val = ?",code], :select => "data_val,data_text")
    end
    #用于由类型编码得到类型名称
    def self.find_arbit_type(typ_code, data_val)
        @type = find(:first, :conditions => ["typ_code = ? and data_val = ?",typ_code,data_val], :select => "data_val,data_text")
        if @type
          return @type.data_text
        else
          return data_val
        end
    end
end
