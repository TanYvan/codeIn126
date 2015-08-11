class CreateTbDocs < ActiveRecord::Migration
  def self.up
    create_table :tb_docs do |t|
    end
  end

  def self.down
    drop_table :tb_docs
  end
end
