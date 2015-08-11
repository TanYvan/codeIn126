class CreateSysArgs < ActiveRecord::Migration
  def self.up
    create_table :sys_args do |t|
    end
  end

  def self.down
    drop_table :sys_args
  end
end
