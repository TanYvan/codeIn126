class CreateVProvides < ActiveRecord::Migration
  def self.up
    create_table :v_provides do |t|
    end
  end

  def self.down
    drop_table :v_provides
  end
end
