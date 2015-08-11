class CreateReminds < ActiveRecord::Migration
  def self.up
    create_table :reminds do |t|
    end
  end

  def self.down
    drop_table :reminds
  end
end
