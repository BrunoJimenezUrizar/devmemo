class CreateCampusesQuestionGroups < ActiveRecord::Migration
  def change
    create_table :campuses_question_groups, :id => false do |t|
	  t.integer :campus_id
      t.integer :question_group_id

      t.timestamps
    end
    add_index :campuses_question_groups, :campus_id
    add_index :campuses_question_groups, :question_group_id
  end
end
