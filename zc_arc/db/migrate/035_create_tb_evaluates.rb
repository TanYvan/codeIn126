class CreateTbEvaluates < ActiveRecord::Migration
  def self.up
    create_table :tb_evaluates do |t|
    end
  end

  def self.down
    drop_table :tb_evaluates
  end
end
