class CreateTbCaseorgs < ActiveRecord::Migration
  def self.up
    create_table :tb_caseorgs do |t|
    end
  end

  def self.down
    drop_table :tb_caseorgs
  end
end
