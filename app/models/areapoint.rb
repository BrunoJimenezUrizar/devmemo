class Areapoint < ActiveRecord::Base
  attr_accessible :area_id, :point_id
  belongs_to :area
  belongs_to :point
end
