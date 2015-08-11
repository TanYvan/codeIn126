class CreateExpires < ActiveRecord::Migration
  def self.up
    create_table :expires do |t|        
    end
  end

  def self.down
    drop_table :expires
  end
end
