class AddPostgisSupportToPoi < ActiveRecord::Migration
  def up
  	# agregamos la nueva columna:
		add_column :pois, :coordinates, :point, :srid => 4326, :geographic => true
		
		# procedemos a traducir los datos antes guardados al nuevo formato
		Poi.all.each do |poi|
			poi.coordinates = "POINT(" + poi.longitude.to_s + " " + poi.latitude.to_s + ")"
			poi.save
		end
		
		# eliminamos las columnas latitude y longitude:
		remove_column :pois, :latitude
		remove_column :pois, :longitude
		
		# agregamos NOT_NULL constraint:
		connection.execute(" alter table pois alter column coordinates SET NOT NULL;")
  end
  def down
  	# creamos columnas borradas:
		add_column :pois, :latitude, :decimal
		add_column :pois, :longitude, :decimal
		
		# pasamos de coordinates a latitude & longitude:
		Poi.all.each do |poi|
			poi.latitude = poi.coordinates.y
			poi.longitude = poi.coordinates.x
			poi.save
		end
		
		# removemos la columna geométrica:
		remove_column :pois, :coordinates
		
		# agregamos NOT_NULL constraint:
		change_column :pois, :latitude, :decimal, :null => false
		change_column :pois, :longitude, :decimal, :null => false
  end
end
