class CreateTbRemuneration2s < ActiveRecord::Migration
  def self.up
    create_table :tb_remuneration2s do |t|
    end
  end

  def self.down
    drop_table :tb_remuneration2s
  end
end
