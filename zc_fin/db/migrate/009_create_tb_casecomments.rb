class CreateTbCasecomments < ActiveRecord::Migration
  def self.up
    create_table :tb_casecomments do |t|
    end
  end

  def self.down
    drop_table :tb_casecomments
  end
end
