class CreateTbArbitrooms < ActiveRecord::Migration
  def self.up
    create_table :tb_arbitrooms do |t|
    end
  end

  def self.down
    drop_table :tb_arbitrooms
  end
end
