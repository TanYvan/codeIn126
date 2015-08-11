class CreateTbAgents < ActiveRecord::Migration
  def self.up
    create_table :tb_agents do |t|
    end
  end

  def self.down
    drop_table :tb_agents
  end
end
