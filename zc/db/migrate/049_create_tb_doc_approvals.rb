class CreateTbDocApprovals < ActiveRecord::Migration
  def self.up
    create_table :tb_doc_approvals do |t|
    end
  end

  def self.down
    drop_table :tb_doc_approvals
  end
end
