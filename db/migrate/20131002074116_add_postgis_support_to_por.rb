class AddPostgisSupportToPor < ActiveRecord::Migration
  def up
  	# agregamos la nueva columna (los datos deberán ser traducidos en la siguiente migración):
		add_column :pors, :coordinates, :point, :srid => 4326, :geographic => true
	end
	
	def down
			
		# pasamos de coordinates a latitude & longitude:
		Por.all.each do |por|
			por.latitude = por.coordinates.y
			por.longitude = por.coordinates.x
			por.save
		end
		
		# removemos la columna geométrica:
		remove_column :pors, :coordinates
		
		# agregamos restriccion NOT_NULL:
		change_column :pors, :latitude, :decimal, :null => false
		change_column :pors, :longitude, :decimal, :null => false
	end
end
