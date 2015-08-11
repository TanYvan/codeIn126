class CreateTbInstitutions < ActiveRecord::Migration
  def self.up
    create_table :tb_institutions do |t|
    end
  end

  def self.down
    drop_table :tb_institutions
  end
end
