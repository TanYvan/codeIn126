class CreateTbSittingdelays < ActiveRecord::Migration
  def self.up
    create_table :tb_sittingdelays do |t|
    end
  end

  def self.down
    drop_table :tb_sittingdelays
  end
end
