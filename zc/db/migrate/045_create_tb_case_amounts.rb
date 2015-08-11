class CreateTbCaseAmounts < ActiveRecord::Migration
  def self.up
    create_table :tb_case_amounts do |t|
    end
  end

  def self.down
    drop_table :tb_case_amounts
  end
end
