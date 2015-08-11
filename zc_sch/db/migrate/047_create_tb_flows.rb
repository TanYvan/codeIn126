class CreateTbFlows < ActiveRecord::Migration
  def self.up
    create_table :tb_flows do |t|
    end
  end

  def self.down
    drop_table :tb_flows
  end
end
