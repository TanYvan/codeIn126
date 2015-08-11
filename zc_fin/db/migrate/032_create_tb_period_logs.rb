class CreateTbPeriodLogs < ActiveRecord::Migration
  def self.up
    create_table :tb_period_logs do |t|
    end
  end

  def self.down
    drop_table :tb_period_logs
  end
end
