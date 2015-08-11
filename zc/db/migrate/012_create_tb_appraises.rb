class CreateTbAppraises < ActiveRecord::Migration
  def self.up
    create_table :tb_appraises do |t|
    end
  end

  def self.down
    drop_table :tb_appraises
  end
end
