class CreateTbOtherSpends < ActiveRecord::Migration
  def self.up
    create_table :tb_other_spends do |t|
    end
  end

  def self.down
    drop_table :tb_other_spends
  end
end
