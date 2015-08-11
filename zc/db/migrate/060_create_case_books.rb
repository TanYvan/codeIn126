class CreateCaseBooks < ActiveRecord::Migration
  def self.up
    create_table :case_books do |t|
    end
  end

  def self.down
    drop_table :case_books
  end
end
