class CreateTbAribitmanNameChanges < ActiveRecord::Migration
  def self.up
    create_table :tb_aribitman_name_changes do |t|
    end
  end

  def self.down
    drop_table :tb_aribitman_name_changes
  end
end
