class CreateTbCheckStaffs < ActiveRecord::Migration
  def self.up
    create_table :tb_check_staffs do |t|
    end
  end

  def self.down
    drop_table :tb_check_staffs
  end
end
