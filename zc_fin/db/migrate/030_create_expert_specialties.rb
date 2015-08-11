class CreateExpertSpecialties < ActiveRecord::Migration
  def self.up
    create_table :expert_specialties do |t|
    end
  end

  def self.down
    drop_table :expert_specialties
  end
end
