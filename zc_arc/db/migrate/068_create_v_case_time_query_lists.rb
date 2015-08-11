class CreateVCaseTimeQueryLists < ActiveRecord::Migration
  def self.up
    create_table :v_case_time_query_lists do |t|
    end
  end

  def self.down
    drop_table :v_case_time_query_lists
  end
end
