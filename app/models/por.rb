class Por < ActiveRecord::Base
  belongs_to :campus
  has_many :dumps, inverse_of: :por, :dependent => :destroy
  has_many :types, through: :dumps
  attr_accessible :name,:types, :dumps_attributes, :_destroy, :latitude, :longitude, :campus, :types_of_dumps, :dumps
  attr_accessor :_destroy
  accepts_nested_attributes_for :dumps, :reject_if => :all_blank, allow_destroy: true
  validates_presence_of :name, :latitude,:longitude
  validates_uniqueness_of :name, scope: :campus_id
  scope :ordered, order("created_at DESC")
  
  validate :dumps, presence: true 
  
  before_save :check_dump_count
  
  # Método de validación, verifica que el Por tenga al menos un basurero asociado:
  # aparentemente está rechazando en todos los casos :/, se deja comentado hasta
  # arreglarlo.
  def check_dump_count
#  	return self.dumps.count >= 1							# Si retorna false, se anula el save
		return true																# no hacemos nada por ahora
  end

  self.per_page = 3
  
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

  def types_of_dumps
    dumps=self.dumps.map{|dump| dump.as_json(:only => [:type_s],:methods => [:type_s])}
    return dumps
  end

  def stat_name
    return self.campus.name + " - "+ self.name
  end

end
