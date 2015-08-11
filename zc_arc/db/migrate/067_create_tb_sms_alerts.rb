class CreateTbSmsAlerts < ActiveRecord::Migration
  def self.up
    create_table :tb_sms_alerts do |t|
    end
  end

  def self.down
    drop_table :tb_sms_alerts
  end
end
