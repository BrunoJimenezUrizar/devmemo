#encoding:utf-8
class Event < ActiveRecord::Base
  belongs_to :campus	
  attr_accessible :description, :end_advertising, :end_date, :name, :start_advertising, :start_date, :friendly_date, :image, :latitude,:longitude, :campus, :mobile_users, :category_ids 

  has_many :categorizations
  has_many :categories, through: :categorizations
 
  validates_presence_of :end_advertising,:end_date, :name, :start_date, :start_advertising, :latitude
  has_attached_file :image 
  belongs_to :mobile_users
  has_many :attendees, :dependent => :destroy
  has_many :mobile_users, :through => :attendees

  validate :start_date_before_end_date ,:start_ad_date_before_end_ad_date, :end_ad_date_before_end_date

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

  def start_date_before_end_date
    if self.end_date.present? && self.start_date.present? && self.end_date < self.start_date 
      errors.add(:end_date, "Fecha de término debe ser posterior a la fecha de inicio")
    end
  end
  def start_ad_date_before_end_ad_date
    if self.end_advertising.present? && self.start_advertising.present? && self.end_advertising < self.start_advertising
      errors.add(:end_advertising, "Fecha de término de publicación debe ser posterior a la fecha de inicio de publicación")
    end
  end

  def end_ad_date_before_end_date
    if self.end_advertising.present? && self.end_date.present? && self.end_advertising > self.end_date
      errors.add(:end_advertising, "Fecha de término de publicación no debe ser posterior a la fecha de término")
    end
  end

  def friendly_date
    day = start_date.strftime("%A")

    if day == "Monday"
      day = "Lunes"
    elsif day == "Tuesday"
      day = "Martes"
    elsif day == "Wednesday"
      day = "Miércoles"
    elsif day == "Thursday"
      day = "Jueves"
    elsif day == "Friday"
      day = "Viernes"
    elsif day == "Saturday"
      day = "Sábado"
    elsif day == "Sunday"
      day = "Domingo"
    end

    hour = start_date.strftime("%H:%M")

    return day+", "+hour
      
  end

end


