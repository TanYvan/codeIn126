class CreateSpecials < ActiveRecord::Migration
  def self.up
    create_table :specials do |t|
    end
  end

  def self.down
    drop_table :specials
  end
end
