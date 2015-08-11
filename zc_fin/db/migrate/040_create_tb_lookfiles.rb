class CreateTbLookfiles < ActiveRecord::Migration
  def self.up
    create_table :tb_lookfiles do |t|
    end
  end

  def self.down
    drop_table :tb_lookfiles
  end
end
