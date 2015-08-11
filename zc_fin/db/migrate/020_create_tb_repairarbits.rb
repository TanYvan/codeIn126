class CreateTbRepairarbits < ActiveRecord::Migration
  def self.up
    create_table :tb_repairarbits do |t|
    end
  end

  def self.down
    drop_table :tb_repairarbits
  end
end
