class University::ComplaintTypeSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :university
end
