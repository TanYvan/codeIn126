class CreateTbShouldRefunds < ActiveRecord::Migration
  def self.up
    create_table :tb_should_refunds do |t|
    end
  end

  def self.down
    drop_table :tb_should_refunds
  end
end
