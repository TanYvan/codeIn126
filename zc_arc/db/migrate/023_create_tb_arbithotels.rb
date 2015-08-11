class CreateTbArbithotels < ActiveRecord::Migration
  def self.up
    create_table :tb_arbithotels do |t|
    end
  end

  def self.down
    drop_table :tb_arbithotels
  end
end
