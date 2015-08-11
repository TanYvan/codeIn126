class CreateTbWitnesses < ActiveRecord::Migration
  def self.up
    create_table :tb_witnesses do |t|
    end
  end

  def self.down
    drop_table :tb_witnesses
  end
end
