class CreateTbSeefiles < ActiveRecord::Migration
  def self.up
    create_table :tb_seefiles do |t|
    end
  end

  def self.down
    drop_table :tb_seefiles
  end
end
