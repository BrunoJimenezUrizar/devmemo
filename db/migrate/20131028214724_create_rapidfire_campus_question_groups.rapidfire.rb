# This migration comes from rapidfire (originally 20131028214348)
class CreateRapidfireCampusQuestionGroups < ActiveRecord::Migration
  def change
    create_table :rapidfire_campus_question_groups, :id => false do |t|
	  t.integer :campus_id
      t.integer :question_group_id

      t.timestamps
    end
  end
end
