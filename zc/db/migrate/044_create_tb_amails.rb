class CreateTbAmails < ActiveRecord::Migration
  def self.up
    create_table :tb_amails do |t|
    end
  end

  def self.down
    drop_table :tb_amails
  end
end
