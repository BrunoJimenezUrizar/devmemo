class AddActiveToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :active, :boolean, :default => false
  end
end
