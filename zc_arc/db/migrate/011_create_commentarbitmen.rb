class CreateCommentarbitmen < ActiveRecord::Migration
  def self.up
    create_table :commentarbitmen do |t|
    end
  end

  def self.down
    drop_table :commentarbitmen
  end
end
