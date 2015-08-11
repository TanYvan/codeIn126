class CreateTbChangereasons < ActiveRecord::Migration
  def self.up
    create_table :tb_changereasons do |t|
    end
  end

  def self.down
    drop_table :tb_changereasons
  end
end
