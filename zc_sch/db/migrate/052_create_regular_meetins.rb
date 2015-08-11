class CreateRegularMeetins < ActiveRecord::Migration
  def self.up
    create_table :regular_meetins do |t|
    end
  end

  def self.down
    drop_table :regular_meetins
  end
end
