class CreateTbExperts < ActiveRecord::Migration
  def self.up
    create_table :tb_experts do |t|
    end
  end

  def self.down
    drop_table :tb_experts
  end
end
