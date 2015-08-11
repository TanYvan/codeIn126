#
# To change this template, choose Tools | Templates
# and open the template in the editor.

#发文触发
class DocTrigger
  def initialize

  end
  def exec(id)
    @doc=TbDoc.find(id)
    if @doc.typ_code=='0001'
      @aribitprog_num=TbCase.find_by_recevice_code(@doc.recevice_code).aribitprog_num
      @case=TbCase.find(:first,:conditions=>["used='Y' and recevice_code=?",@doc.recevice_code])
      if @case!=nil
        @case.accepttime=@doc.ss_t
        @case.save
      end
    end

  end

end
