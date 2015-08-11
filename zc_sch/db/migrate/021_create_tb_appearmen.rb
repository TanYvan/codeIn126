class CreateTbAppearmen < ActiveRecord::Migration
  def self.up
    create_table :tb_appearmen do |t|
    end
  end

  def self.down
    drop_table :tb_appearmen
  end
end
