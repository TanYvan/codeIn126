class CreateTbOppositions < ActiveRecord::Migration
  def self.up
    create_table :tb_oppositions do |t|
    end
  end

  def self.down
    drop_table :tb_oppositions
  end
end
