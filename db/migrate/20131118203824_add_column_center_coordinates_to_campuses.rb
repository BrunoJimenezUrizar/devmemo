class AddColumnCenterCoordinatesToCampuses < ActiveRecord::Migration
  def up
  	add_column :campuses, :center_coordinates, :point, :srid => 4326, :geographic => true
  	
  	# Procedemos a agregar el valor para todos los campuses:
  	Campus.all.each do |campus|
			campus.calculate_center
			campus.save
  	end
  	
		# agregamos NOT_NULL constraint:
		connection.execute(" alter table campuses alter column center_coordinates SET NOT NULL;")
  end
  
  def down
  	# eliminamos la columna:
  	remove_column :campuses, :center_coordinates
  end
end
