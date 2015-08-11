class CreateTbInterims < ActiveRecord::Migration
  def self.up
    create_table :tb_interims do |t|
    end
  end

  def self.down
    drop_table :tb_interims
  end
end
