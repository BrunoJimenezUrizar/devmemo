class Category < ActiveRecord::Base
	has_many :categorizations
	has_many :pois, through: :categorizations
	belongs_to :university
  attr_accessible :description, :logo, :name
end
