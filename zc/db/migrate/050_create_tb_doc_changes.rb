class CreateTbDocChanges < ActiveRecord::Migration
  def self.up
    create_table :tb_doc_changes do |t|
    end
  end

  def self.down
    drop_table :tb_doc_changes
  end
end
