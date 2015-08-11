class CreateTbDictionaries < ActiveRecord::Migration
  def self.up
    create_table :tb_dictionaries do |t|
    end
  end

  def self.down
    drop_table :tb_dictionaries
  end
end
