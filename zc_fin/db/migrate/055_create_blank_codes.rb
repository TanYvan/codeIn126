class CreateBlankCodes < ActiveRecord::Migration
  def self.up
    create_table :blank_codes do |t|
    end
  end

  def self.down
    drop_table :blank_codes
  end
end
