class CreateTbReports < ActiveRecord::Migration
  def self.up
    create_table :tb_reports do |t|
    end
  end

  def self.down
    drop_table :tb_reports
  end
end
