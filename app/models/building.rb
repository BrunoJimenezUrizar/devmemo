class Building < ActiveRecord::Base
  has_many :floors, :dependent => :destroy
  belongs_to :campus
  attr_accessible :name, :floors, :floors_attributes, :polygon_s, :polygon, :center_coordinates, :center_longitude,:center_latitude
  accepts_nested_attributes_for :floors, allow_destroy: true
  validates_presence_of :name, :polygon
  validates_uniqueness_of :name, scope: :campus_id 

	# Actualizamos el centro del edificio si es que se actualiza su polígono
	before_save :calculate_center, :if => :polygon_changed?

  self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326, :geographic => true)

	# Método para recalcular el centro del polígono asociado al edificio
  def calculate_center
  	# Si no hay un polígono asociado, entonces no hacemos nada
  	if self.polygon == nil
  		return
  	end
  	
  	# Si el campus posee un polígono, entonces procedemos a calcular su centro:
  	# -------------------------------------------------------------------------------------
  	lat = 0				# Suma de las latitudes de todos los puntos
  	lng = 0				# Suma de las longitudes de todos los puntos
  	count = 0			# Cantidad de puntos que componen el polígono
  	
  	points = self.polygon.exterior_ring.points		# Extraemos listado de puntos que componen el polígono
  	points = points[0..-2]												# Quitamos el último punto (es el mismo que el primero)
  	count = points.count													# Cantidad de puntos a promediar
  	
  	# Recorremos el arreglo de puntos y sumamos los valores de latitud y longitud para promediarlos:
  	points.each do |point|
  		lat += point.y
  		lng += point.x
  	end
  	
  	# Promediamos los valores:
  	lat = lat / count
  	lng = lng / count
  	
  	# Finalmente, seteamos el valor de center_coordinates
  	self.center_coordinates = "POINT(" + lng.to_s + " " + lat.to_s + ")"
  end
  
  def encoded_polygon
  	if(self.polygon != nil)
	  	encoded = PolylineEncoder.encode(self.polygon.exterior_ring)
	  	return encoded.inspect[1..-2]
	  else
	  	return nil
	  end
  end
  
  # Atributo virtual para poder acceder al string del polígono, no a la variable
  def polygon_s
  	return self.polygon.to_s
  end
  
  def polygon_s=(value)
  	self.polygon = value
  end

  def center_longitude
    return center_coordinates.x
  end
  def center_latitude
    return center_coordinates.y
  end
  def floors?
    if self.floors.count == 0
      false
    else
      true
    end
  end
end
