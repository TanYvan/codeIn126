class CreateReportTotal1s < ActiveRecord::Migration
  def self.up
    create_table :report_total1s do |t|
    end
  end

  def self.down
    drop_table :report_total1s
  end
end
