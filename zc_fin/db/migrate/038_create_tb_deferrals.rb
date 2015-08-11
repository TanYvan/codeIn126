class CreateTbDeferrals < ActiveRecord::Migration
  def self.up
    create_table :tb_deferrals do |t|
    end
  end

  def self.down
    drop_table :tb_deferrals
  end
end
