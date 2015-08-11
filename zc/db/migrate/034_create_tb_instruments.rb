class CreateTbInstruments < ActiveRecord::Migration
  def self.up
    create_table :tb_instruments do |t|
    end
  end

  def self.down
    drop_table :tb_instruments
  end
end
