class CreateTbExpendDetails < ActiveRecord::Migration
  def self.up
    create_table :tb_expend_details do |t|
    end
  end

  def self.down
    drop_table :tb_expend_details
  end
end
