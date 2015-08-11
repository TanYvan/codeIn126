class CreateRegularMeetings < ActiveRecord::Migration
  def self.up
    create_table :regular_meetings do |t|
    end
  end

  def self.down
    drop_table :regular_meetings
  end
end
