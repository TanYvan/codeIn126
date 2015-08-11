class TbAward < ActiveRecord::Base
  def after_save
    task_a=Task_a.new
    task_a.t_25_by_recevice_code(self.recevice_code)
  end
end
