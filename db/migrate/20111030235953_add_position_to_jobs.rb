class AddPositionToJobs < ActiveRecord::Migration
  def self.up 
    add_column :jobs, :position, :integer 
  end

  def self.down
    remove_column :jobs, :position
  end
end
