class CreateTbCaseendbooks < ActiveRecord::Migration
  def self.up
    create_table :tb_caseendbooks do |t|
    end
  end

  def self.down
    drop_table :tb_caseendbooks
  end
end
