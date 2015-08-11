class CreateTbPrizes < ActiveRecord::Migration
  def self.up
    create_table :tb_prizes do |t|
    end
  end

  def self.down
    drop_table :tb_prizes
  end
end
