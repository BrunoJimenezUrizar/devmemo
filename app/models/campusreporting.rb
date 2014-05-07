class Campusreporting< ActiveRecord::Base
  belongs_to :campus
  belongs_to :report
  # attr_accessible :title, :body
end