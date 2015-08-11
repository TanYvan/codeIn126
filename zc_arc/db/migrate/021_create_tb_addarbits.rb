class CreateTbAddarbits < ActiveRecord::Migration
  def self.up
    create_table :tb_addarbits do |t|
    end
  end

  def self.down
    drop_table :tb_addarbits
  end
end
