class CreateTbCaseFlows < ActiveRecord::Migration
  def self.up
    create_table :tb_case_flows do |t|
    end
  end

  def self.down
    drop_table :tb_case_flows
  end
end
