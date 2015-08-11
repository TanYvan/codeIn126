class CreateTbJurisdictions < ActiveRecord::Migration
  def self.up
    create_table :tb_jurisdictions do |t|
    end
  end

  def self.down
    drop_table :tb_jurisdictions
  end
end
