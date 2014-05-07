class Point < ActiveRecord::Base
  attr_accessible :description, :location, :name, :latitude, :longitude, :type_id, :area_id, :area_ids
  belongs_to :type
  has_many :areapoints
  has_many :areas, through: :areapoints

  accepts_nested_attributes_for :areas
  validates_presence_of :name, :latitude,:longitude
  validates_uniqueness_of :name
end
