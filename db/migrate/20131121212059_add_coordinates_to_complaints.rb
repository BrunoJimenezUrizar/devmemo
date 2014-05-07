class AddCoordinatesToComplaints < ActiveRecord::Migration
  def change
  	add_column :complaints, :coordinates, :point, :srid => 4326, :geographic => true
  end
end
