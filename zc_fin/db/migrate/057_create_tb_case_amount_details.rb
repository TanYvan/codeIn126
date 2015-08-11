class CreateTbCaseAmountDetails < ActiveRecord::Migration
  def self.up
    create_table :tb_case_amount_details do |t|
    end
  end

  def self.down
    drop_table :tb_case_amount_details
  end
end
