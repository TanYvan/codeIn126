class CreateUserDuties < ActiveRecord::Migration
  def self.up
    create_table :user_duties do |t|
    end
  end

  def self.down
    drop_table :user_duties
  end
end
