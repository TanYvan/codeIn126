class CreateTbCasepros < ActiveRecord::Migration
  def self.up
    create_table :tb_casepros do |t|
    end
  end

  def self.down
    drop_table :tb_casepros
  end
end
