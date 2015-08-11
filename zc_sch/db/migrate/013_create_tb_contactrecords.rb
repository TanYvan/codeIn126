class CreateTbContactrecords < ActiveRecord::Migration
  def self.up
    create_table :tb_contactrecords do |t|
    end
  end

  def self.down
    drop_table :tb_contactrecords
  end
end
