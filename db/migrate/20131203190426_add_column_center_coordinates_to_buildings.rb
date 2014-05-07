class AddColumnCenterCoordinatesToBuildings < ActiveRecord::Migration
  def up
  	add_column :buildings, :center_coordinates, :point, :srid => 4326, :geographic => true
  	
  	# Procedemos a agregar el valor para todos los campuses:
  	Building.all.each do |building|
			building.calculate_center
			building.save
  	end
  	
		# agregamos NOT_NULL constraint:
		connection.execute(" alter table buildings alter column center_coordinates SET NOT NULL;")
  end
  
  def down
  	# eliminamos la columna:
  	remove_column :buildings, :center_coordinates
  end
end
