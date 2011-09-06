class AddPositionToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :position, :integer
  end

  def self.down
    remove_column :books, :position
  end
end
