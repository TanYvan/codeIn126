class CreateTbReductions < ActiveRecord::Migration
  def self.up
    create_table :tb_reductions do |t|
    end
  end

  def self.down
    drop_table :tb_reductions
  end
end
