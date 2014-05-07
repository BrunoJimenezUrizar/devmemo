class Poi < ActiveRecord::Base
  belongs_to :campus
  has_many :categorizations
  has_many :categories, through: :categorizations
  attr_accessible :description, :name, :category_ids, :latitude, :longitude, :categories_s
  validates_presence_of :name, :latitude, :longitude
  validates_uniqueness_of :name
  
  # Constructor usado por rgeo para los puntos geográficos:
   self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326, :geographic => true)
  
  # definimos atributos vituales para retro-compatibilidad:
  # ---------------------------------------------------------
  def latitude
  	if(self.coordinates != nil)
	  	return self.coordinates.y
	  else
	  	return nil
	  end
  end
  
  def latitude=(value)
    # obtenemos la longitud del punto:
    lng = "0" # si no especificamos un valor, coordinates no se crea
    
    if(self.coordinates != nil)
	    lng = self.coordinates.x
  	end
  	  
    # reescribimos las coordenadas:
    self.coordinates ="POINT(" + lng.to_s + " " + value.to_s + ")"
  end
  
  def longitude
  	if(self.coordinates != nil)
	  	return self.coordinates.x
	  else
	  	return nil
	  end
  end
  
  def longitude=(value)
    # obtenemos la longitud del punto:
    lat = "0"

		if(self.coordinates != nil)
	    lat = self.coordinates.y
  	end
  	  
    # reescribimos las coordenadas:
    self.coordinates ="POINT(" + value.to_s + " " + lat.to_s + ")"
  end

  def categories_s
    categories=self.categories.map{|c| c.as_json(:only => [:name])}
    return categories
  end

end
