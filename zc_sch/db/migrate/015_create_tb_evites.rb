class CreateTbEvites < ActiveRecord::Migration
  def self.up
    create_table :tb_evites do |t|
    end
  end

  def self.down
    drop_table :tb_evites
  end
end
