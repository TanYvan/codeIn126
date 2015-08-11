class CreateInterims < ActiveRecord::Migration
  def self.up
    create_table :interims do |t|
    end
  end

  def self.down
    drop_table :interims
  end
end
