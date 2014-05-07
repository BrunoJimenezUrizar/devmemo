class Campus::ComplaintSerializer < ActiveModel::Serializer
  attributes :id, :description, :status
  has_one :campus
  has_one :mobile_user
end
