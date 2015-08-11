class CreateTbExpertconsults < ActiveRecord::Migration
  def self.up
    create_table :tb_expertconsults do |t|
    end
  end

  def self.down
    drop_table :tb_expertconsults
  end
end
