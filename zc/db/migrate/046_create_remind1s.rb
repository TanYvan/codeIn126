class CreateRemind1s < ActiveRecord::Migration
  def self.up
    create_table :remind1s do |t|
    end
  end

  def self.down
    drop_table :remind1s
  end
end
