class CreateTbSaves < ActiveRecord::Migration
  def self.up
    create_table :tb_saves do |t|
    end
  end

  def self.down
    drop_table :tb_saves
  end
end
