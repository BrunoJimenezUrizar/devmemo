class Floor < ActiveRecord::Base
  belongs_to :building
  attr_accessible :description, :indoor_path, :number, :building_id, :photo
  validates_presence_of :number
  validates_uniqueness_of :number, scope: :building_id 
  has_attached_file :photo, :styles => { :small => "150x150>", :medium => "300x300>", :large => "600x600>" }

  scope :ordered, order("number DESC")

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
