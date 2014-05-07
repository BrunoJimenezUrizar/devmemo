class PointsArea < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :points
  has_many :areas
end
