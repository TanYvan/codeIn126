class TbCaseFlow < ActiveRecord::Base
  
  #检测是否违反流程，创建流程性的记录前调用。
  def self.check(recevice_code,flow_code)
    r=true
    if TbFlow.find_by_code(flow_code).res==1
      if TbCaseFlow.find(:first,:conditions=>"recevice_code='#{recevice_code}' and flow_code='#{TbFlow.find_by_code(flow_code).res_code}'")==nil
        r=false
      end 
    end
    
    return r
    #返回true表示不违反约束，可以增加，返回false表示违反约束。
  end
  
  #增加某流程中记录的时候调用，取得要更新的案件状态值
  def self.add_flow(recevice_code,flow_code)
    r=0
    f=TbCaseFlow.find(:first,:conditions=>"recevice_code='#{recevice_code}' and flow_code='#{flow_code}'")
    if f==nil
      f=TbCaseFlow.new()
      f.recevice_code=recevice_code
      f.flow_code=flow_code
      f.flow_num=1
      if f.save
        a=TbCaseFlow.find_by_sql("select tb_flows.case_state as  case_state from tb_case_flows,tb_flows where tb_case_flows.recevice_code='#{recevice_code}' and tb_case_flows.flow_code=tb_flows.code order by tb_flows.num desc ")
        if a.empty?
        else
          for b in a
            r=b.case_state
            break
          end
        end
      end
    else
      f.flow_num=f.flow_num + 1
      f.save
    end
    return r
    #返回0表示不需要更改案件状态值，其它数值表示更新的案件状态值。
  end
  
  #删除某流程中记录的时候调用，取得要更新的案件状态值
  def self.del_flow(recevice_code,flow_code)
    r=0
    f=TbCaseFlow.find(:first,:conditions=>"recevice_code='#{recevice_code}' and flow_code='#{flow_code}'")
    if f==nil

    else
      f.flow_num=f.flow_num - 1
      if f.flow_num==0
        f.destroy
        a=TbCaseFlow.find_by_sql("select tb_flows.case_state as  case_state from tb_case_flows,tb_flows where tb_case_flows.recevice_code='#{recevice_code}' and tb_case_flows.flow_code=tb_flows.code order by tb_flows.num desc ")
        if a.empty?
        else
          for b in a
            r=b.case_state
            break
          end
        end
      else
        f.save
      end     
    end
    return r
    #返回0表示不需要更改案件状态值，其它数值表示更新的案件状态值。
  end
  
end
