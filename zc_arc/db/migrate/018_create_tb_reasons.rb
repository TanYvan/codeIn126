class CreateTbReasons < ActiveRecord::Migration
  def self.up
    create_table :tb_reasons do |t|
    end
  end

  def self.down
    drop_table :tb_reasons
  end
end
