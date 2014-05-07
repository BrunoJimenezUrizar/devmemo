module Rapidfire
  class CampusQuestionGroup < ActiveRecord::Base
    belongs_to :campus, class_name: "Campus"
    belongs_to :question_group
  end
end