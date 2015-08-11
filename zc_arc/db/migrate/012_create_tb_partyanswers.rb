class CreateTbPartyanswers < ActiveRecord::Migration
  def self.up
    create_table :tb_partyanswers do |t|
    end
  end

  def self.down
    drop_table :tb_partyanswers
  end
end
