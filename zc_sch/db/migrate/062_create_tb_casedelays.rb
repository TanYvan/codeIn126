class CreateTbCasedelays < ActiveRecord::Migration
  def self.up
    create_table :tb_casedelays do |t|
    end
  end

  def self.down
    drop_table :tb_casedelays
  end
end
