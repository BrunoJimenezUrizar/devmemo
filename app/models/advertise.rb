class Advertise < ActiveRecord::Base
  has_many :campusadvertisings
  has_many :campuses, through: :campusadvertisings
  
  attr_accessible :active, :end_date, :start_date, :campus_ids, :image_advertise, :name, :image_advertise_file_name,:correct_timing,:link
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :image_advertise
  validates_presence_of :name
  validate :validate_end_date_before_start_date
  validates_uniqueness_of :name
  
  has_attached_file :image_advertise
  validates_attachment_content_type :image_advertise,
  :content_type =>['image/jpeg','image/jpg','[image/jpeg]','[image/png]', 'image/png'] 


  def validate_end_date_before_start_date
    if end_date && start_date
      errors.add(:end_date, "La fecha de termino ingresada es menor a la de inicio") if end_date < start_date
    end
  end
end
