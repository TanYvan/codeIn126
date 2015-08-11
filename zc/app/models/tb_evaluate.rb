class TbEvaluate < ActiveRecord::Base

  def self.set_tb_25(recevice_code)
    task_a=Task_a.new
    task_a.t_25_by_recevice_code(recevice_code)
  end
  
end
