class CreateTbDocFormatObjs < ActiveRecord::Migration
  def self.up
    create_table :tb_doc_format_objs do |t|
    end
  end

  def self.down
    drop_table :tb_doc_format_objs
  end
end
