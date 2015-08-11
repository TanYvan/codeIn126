class CreateTbCasearbitmen < ActiveRecord::Migration
  def self.up
    create_table :tb_casearbitmen do |t|
    end
  end

  def self.down
    drop_table :tb_casearbitmen
  end
end
