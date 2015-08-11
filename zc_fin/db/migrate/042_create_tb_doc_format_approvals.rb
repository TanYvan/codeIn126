class CreateTbDocFormatApprovals < ActiveRecord::Migration
  def self.up
    create_table :tb_doc_format_approvals do |t|
    end
  end

  def self.down
    drop_table :tb_doc_format_approvals
  end
end
