class CreateTbShouldCharges < ActiveRecord::Migration
  def self.up
    create_table :tb_should_charges do |t|
    end
  end

  def self.down
    drop_table :tb_should_charges
  end
end
