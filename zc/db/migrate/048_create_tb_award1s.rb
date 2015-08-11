class CreateTbAward1s < ActiveRecord::Migration
  def self.up
    create_table :tb_award1s do |t|
    end
  end

  def self.down
    drop_table :tb_award1s
  end
end
