class CreateMoney < ActiveRecord::Migration
  def self.up
    create_table :money do |t|
    end
  end

  def self.down
    drop_table :money
  end
end
