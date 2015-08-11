class CreateTbDeductions < ActiveRecord::Migration
  def self.up
    create_table :tb_deductions do |t|
    end
  end

  def self.down
    drop_table :tb_deductions
  end
end
