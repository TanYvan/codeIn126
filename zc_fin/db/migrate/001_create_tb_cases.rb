class CreateTbCases < ActiveRecord::Migration
  def self.up
    create_table :tb_cases do |t|
    end
  end

  def self.down
    drop_table :tb_cases
  end
end
