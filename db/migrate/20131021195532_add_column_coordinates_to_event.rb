class AddColumnCoordinatesToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :coordinates, :point, :srid => 4326, :geographic => true	
  end
end
