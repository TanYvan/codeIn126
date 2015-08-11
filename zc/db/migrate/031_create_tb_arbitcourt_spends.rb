class CreateTbArbitcourtSpends < ActiveRecord::Migration
  def self.up
    create_table :tb_arbitcourt_spends do |t|
    end
  end

  def self.down
    drop_table :tb_arbitcourt_spends
  end
end
