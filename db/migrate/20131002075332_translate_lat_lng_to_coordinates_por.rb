class TranslateLatLngToCoordinatesPor < ActiveRecord::Migration
  def up		
		# procedemos a traducir los datos antes guardados al nuevo formato:
		Por.all.each do |por|
			por.coordinates = "POINT(" + por.longitude.to_s + " " + por.latitude.to_s + ")"
			por.save
		end
		
		# eliminamos las columnas latitude y longitude:
		remove_column :pors, :latitude
		remove_column :pors, :longitude
		
		# agregamos restricción NOT_NULL:
		connection.execute(" alter table pors alter column coordinates SET NOT NULL;")
  end

  def down
  	# agregamos las columnas latitude & longitude:
  	add_column :pors, :latitude, :decimal
  	add_column :pors, :longitude, :decimal
  end
end
