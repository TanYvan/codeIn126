class CreateMoneyLogs < ActiveRecord::Migration
  def self.up
    create_table :money_logs do |t|
    end
  end

  def self.down
    drop_table :money_logs
  end
end
