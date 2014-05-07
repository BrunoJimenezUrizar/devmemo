class AddColumnPolygonToCampus < ActiveRecord::Migration
  def up
		add_column :campuses, :polygon, :polygon, :geographic => true
		
		# Inicializamos con polígono dummy (default: campus San Joaquín):
		Campus.all.each do |campus|
			campus.polygon = "POLYGON ((-70.61604022979736 -33.49669944869526, -70.61501026153564 -33.50102967164019, -70.60895919799805 -33.50067181018617, -70.60981750488281 -33.49618052314795, -70.61604022979736 -33.49669944869526))"
			campus.save
		end
		
		# agregamos NOT_NULL constraint:
		connection.execute(" alter table campuses alter column polygon SET NOT NULL;")
  end
  
  def down
  	remove_column :campuses, :polygon
  end
end
