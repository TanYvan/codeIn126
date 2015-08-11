class CreateTbContractsigns < ActiveRecord::Migration
  def self.up
    create_table :tb_contractsigns do |t|
    end
  end

  def self.down
    drop_table :tb_contractsigns
  end
end
