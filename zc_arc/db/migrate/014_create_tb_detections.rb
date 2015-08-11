class CreateTbDetections < ActiveRecord::Migration
  def self.up
    create_table :tb_detections do |t|
    end
  end

  def self.down
    drop_table :tb_detections
  end
end
