class CreateTbChargeCorrs < ActiveRecord::Migration
  def self.up
    create_table :tb_charge_corrs do |t|
    end
  end

  def self.down
    drop_table :tb_charge_corrs
  end
end
