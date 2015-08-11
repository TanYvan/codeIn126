class CreateTbAwards < ActiveRecord::Migration
  def self.up
    create_table :tb_awards do |t|
    end
  end

  def self.down
    drop_table :tb_awards
  end
end
