class CreateTbDocFormats < ActiveRecord::Migration
  def self.up
    create_table :tb_doc_formats do |t|
    end
  end

  def self.down
    drop_table :tb_doc_formats
  end
end
