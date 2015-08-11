class CreateTbOthers < ActiveRecord::Migration
  def self.up
    create_table :tb_others do |t|
    end
  end

  def self.down
    drop_table :tb_others
  end
end
