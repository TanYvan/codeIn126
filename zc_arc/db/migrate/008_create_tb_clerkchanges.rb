class CreateTbClerkchanges < ActiveRecord::Migration
  def self.up
    create_table :tb_clerkchanges do |t|
    end
  end

  def self.down
    drop_table :tb_clerkchanges
  end
end
