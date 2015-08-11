class TaxDetail < ActiveRecord::Base
  set_table_name :tax_detail
  def self.set_tax(mark,ynssde)
    if mark.index("remuneration23")
      t=mark.split("_")
      recevice_code = TbRemuneration23.find(t[1].to_i).recevice_code
    else
      t=mark.split("_")
      recevice_code = VProvide.find_by_typ_and_p_typ_and_id_id(t[0],t[1],t[2]).recevice_code
    end
    
    unless TaxDetail.find_by_mark(mark)
      for t in TbDictionary.find(:all,:conditions=>"typ_code like '9027%' and used='Y' and state='Y' ", :order=>"ind,typ_code")
        tax = TaxDetail.new
        tax.mark = mark
        tax.code = t.typ_code
        tax.name = t.data_text
        tax.rmb =ynssde.to_f
        t.data_val.split("*").each{|v|
          tax.rmb = SysArg.round_2(tax.rmb * v.to_f)
        }
        tax.recevice_code = recevice_code
        tax.save
      end
        tax = TaxDetail.new
        tax.mark = mark
        tax.code = "0000-0000"
        tax.name = "合计_理论值"#按纳税理论值计算所得,未经过二次修改
        tax.rmb = TaxDetail.sum(:rmb, :conditions => ["mark = ?", mark])
        tax.recevice_code = recevice_code
        tax.save
        
        tax = TaxDetail.new
        tax.mark = mark
        tax.code = "0000"
        tax.name = "合计"
        tax.rmb = TaxDetail.sum(:rmb, :conditions => ["name<>'合计_理论值' and mark = ?", mark])
        tax.recevice_code = recevice_code
        tax.save
    end
  end

  def self.del_tax(mark)
    TaxDetail.delete_all(["mark = ?", mark])

  end

end
