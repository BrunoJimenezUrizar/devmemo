class Level < ActiveRecord::Base
  attr_accessible :name, :points, :image
  validates :name, :points, :uniqueness => true
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

end
