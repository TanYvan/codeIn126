class CreateTbArbitmanSpends < ActiveRecord::Migration
  def self.up
    create_table :tb_arbitman_spends do |t|
    end
  end

  def self.down
    drop_table :tb_arbitman_spends
  end
end
