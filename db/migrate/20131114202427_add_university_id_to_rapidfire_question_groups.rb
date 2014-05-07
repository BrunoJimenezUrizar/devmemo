class AddUniversityIdToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :university_id, :integer
  end
end
