#!/bin/env ruby
# encoding: UTF-8
## =========================================================================================
## Campus
## -----------------------------------------------------------------------------------------
## Entidad que representa los campus en la base de datos
## =========================================================================================
## IIC2154 - Grupo 1
## =========================================================================================
## Segundo Semestre 2013
## =========================================================================================
class Campus < ActiveRecord::Base
  resourcify
  has_many :complaints
  has_many :campusadvertisings
  has_many :advertises ,through: :campusadvertisings
  has_many :campusreportings
  has_many :reports , through: :campusreportings
  has_many :usercampuses
  has_many :users , through: :usercampuses
  has_many :pois, :dependent => :destroy
  has_many :pors, :dependent => :destroy
  has_many :buildings, :dependent => :destroy
  has_many :events, :dependent => :destroy
  
  has_many :campus_surveys, :class_name => "CampusSurvey"
  has_many :question_groups, through: :campus_surveys
		
	attr_accessible :name, :university_id, :center_longitude,:center_latitude,:buildings_attributes, :pors_attributes, :pois_attributes, :polygon_s, :address, :address_coordinates, :university, :polygon, :advertise_ids, :center_coordinates, :complaints,:calculate_center
  
  #has_and_belongs_to_many :surveys, :class_name => "Rapidfire::QuestionGroup"
  #has_many :surveys, :class_name => "Rapidfire::QuestionGroup" # las encuestas (question_groups) se llaman con 'campus.surveys'

  belongs_to :university
  accepts_nested_attributes_for :buildings, allow_destroy: true
  accepts_nested_attributes_for :pors, allow_destroy: true
  accepts_nested_attributes_for :pois, allow_destroy: true
  validates_presence_of :name, :university_id, :polygon, :address
  validates_uniqueness_of :name, scope: :university_id
  has_many :events 

	# Actualizamos el centro del campus si es que se actualiza su polígono
	before_save :calculate_center, :if => :polygon_changed?

   # Constructor usado por rgeo para los puntos geográficos:
  self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326, :geographic => true)
    
	# Método para recalcular el centro del polígono asociado al campus
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
  
  # Método que retorna el polígono encodeado según la api de google maps
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
end
