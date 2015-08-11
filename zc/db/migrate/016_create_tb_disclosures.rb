class CreateTbDisclosures < ActiveRecord::Migration
  def self.up
    create_table :tb_disclosures do |t|
    end
  end

  def self.down
    drop_table :tb_disclosures
  end
end
