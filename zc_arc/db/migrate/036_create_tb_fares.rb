class CreateTbFares < ActiveRecord::Migration
  def self.up
    create_table :tb_fares do |t|
    end
  end

  def self.down
    drop_table :tb_fares
  end
end
