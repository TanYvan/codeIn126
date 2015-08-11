class CreateTbPeriods < ActiveRecord::Migration
  def self.up
    create_table :tb_periods do |t|
    end
  end

  def self.down
    drop_table :tb_periods
  end
end
