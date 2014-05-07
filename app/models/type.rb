class Type < ActiveRecord::Base
  attr_accessible :logo, :name, :university
  has_many :points
  has_many :dumps
  belongs_to :university

  validates_presence_of :name

end
