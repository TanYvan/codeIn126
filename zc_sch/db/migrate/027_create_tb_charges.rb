class CreateTbCharges < ActiveRecord::Migration
  def self.up
    create_table :tb_charges do |t|
    end
  end

  def self.down
    drop_table :tb_charges
  end
end
