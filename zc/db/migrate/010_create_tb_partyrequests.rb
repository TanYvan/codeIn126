class CreateTbPartyrequests < ActiveRecord::Migration
  def self.up
    create_table :tb_partyrequests do |t|
    end
  end

  def self.down
    drop_table :tb_partyrequests
  end
end
