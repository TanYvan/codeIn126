class CreateTbExtends < ActiveRecord::Migration
  def self.up
    create_table :tb_extends do |t|
    end
  end

  def self.down
    drop_table :tb_extends
  end
end
