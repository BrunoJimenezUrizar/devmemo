#!/bin/env ruby
# encoding: UTF-8
class University < ActiveRecord::Base
  resourcify
  after_create :create_complaint_type
  has_many :complaint_types
  attr_accessible :logo, :name, :acronym, :campuses_attributes, :json_campuses
  has_many :campuses, :dependent => :destroy	# Si la universidad se borra, es lógico que el campus también
  has_many :categories
  has_many :types
  accepts_nested_attributes_for :campuses, allow_destroy: true
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :acronym
  has_many :question_groups, :class_name => "Rapidfire::QuestionGroup"

  validates_presence_of :logo

  has_attached_file :logo, :default_url => 'missing.png'
  validates_attachment_content_type :logo,
  :content_type =>['image/jpeg','image/jpg','[image/jpeg]','[image/png]', 'image/png'] 

  def create_complaint_type
    self.complaint_types.create(:name=>'Otros')
  end


  def json_campuses
  	if self.campuses.count == 0
      return "no campuses"
    else
     self.campuses.map { |c| c.as_json(:only => [:id, :name, :university_id, :center_coordinates],:methods => :encoded_polygon) }
    end
  end

end
