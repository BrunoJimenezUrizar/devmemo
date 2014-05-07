class CampusSurvey < ActiveRecord::Base
	belongs_to :campus
	belongs_to :question_group, :class_name => "Rapidfire::QuestionGroup"
    attr_accessible :campus_id, :question_group_id, :active
end
