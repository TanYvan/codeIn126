class CreateDuties < ActiveRecord::Migration
  def self.up
    create_table :duties do |t|
    end
  end

  def self.down
    drop_table :duties
  end
end
