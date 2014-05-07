# This migration comes from rapidfire (originally 20131024172115)
class AddActiveToRapidfireQuestionGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_question_groups, :active, :boolean, :default => false
  end
end
