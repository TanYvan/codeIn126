class CreateTbRemuneration1s < ActiveRecord::Migration
  def self.up
    create_table :tb_remuneration1s do |t|
    end
  end

  def self.down
    drop_table :tb_remuneration1s
  end
end
