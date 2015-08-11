class CreateTbBonusPenalties < ActiveRecord::Migration
  def self.up
    create_table :tb_bonus_penalties do |t|
    end
  end

  def self.down
    drop_table :tb_bonus_penalties
  end
end
