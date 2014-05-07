class Campusadvertising < ActiveRecord::Base
  belongs_to :campus
  belongs_to :advertise
  # attr_accessible :title, :body
end
	