class CreateTbSittings < ActiveRecord::Migration
  def self.up
    create_table :tb_sittings do |t|
    end
  end

  def self.down
    drop_table :tb_sittings
  end
end
