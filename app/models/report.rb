
#coding: utf-8
class Report < ActiveRecord::Base
  has_many :campusreportings
  has_many :campuses , through: :campusreportings

  attr_accessible :active, :end_date, :start_date, :campus_ids, :image_report, :campuses, :name, :link
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :image_report
  validates_presence_of :name
  validate :validate_end_date_before_start_date
  validates_uniqueness_of :name
  validate :validate_selected_one_campus

  has_attached_file :image_report
  validates_attachment_content_type :image_report,
  :content_type =>['image/jpeg','image/jpg','[image/jpeg]','[image/png]', 'image/png'] 


  def validate_end_date_before_start_date
    if end_date && start_date
      errors.add(:end_date, "La fecha de termino ingresada es menor a la de inicio") if end_date < start_date
    end
  end

  #Se valida si una noticia esta asociada a un campus
  def validate_selected_one_campus
    if campuses.empty?
      errors.add(:campuses, "No se ha seleccionado un campus para publicar esta noticia")
    end
  end
end
