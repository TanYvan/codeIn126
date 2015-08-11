class CreateTbParties < ActiveRecord::Migration
  def self.up
    create_table :tb_parties do |t|
    end
  end

  def self.down
    drop_table :tb_parties
  end
end
