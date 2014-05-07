class Complaint < ActiveRecord::Base
  has_many :comments
  belongs_to :campus
  belongs_to :complaint_type
  belongs_to :mobile_user
  attr_accessible :description,:admin_comments, :status, :complaint_type_id, :longitude, :latitude,:campus_id, :photo, :video

  scope :ordered, order("created_at desc")

  has_attached_file :photo, :styles => { :small => "150x150>", :medium => "300x300>", :large => "600x600>" }
  has_attached_file :video


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
  
  #provee los comentarios de la denuncia a la api show_profile
  def admin_comments
    if self.comments.count > 0 
      return self.comments.where("public = ?",true).map{|c| c.as_json(:only=>[:body],:methods=>[:admin_name])}
    else
      return "No hay comentarios"
    end
  end
end
