module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    attr_accessor :campus
  	#has_and_belongs_to_many :campus, class_name: "Campus"
    has_many  :questions
    validates :name, :presence => true
    has_many :answer_groups
    has_many :campus_surveys, :class_name => "CampusSurvey"
    has_many :campuses, through: :campus_surveys
    belongs_to :university

    has_attached_file :photo, :styles => { :small => "150x150>", :medium => "300x300>", :large => "600x600>"}


    if Rails::VERSION::MAJOR == 3
      attr_accessible :name, :active,:campus_ids, :photo, :university_id
    end

    def active?
        self.active
    end
    
    def activate
    	self.active = true
    	self.save
    end
    def deactivate
    	self.active = false
    	self.save
    end

    def active?
    	return self.active
    end
  end
end
