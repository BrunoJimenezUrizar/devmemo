class CreateCampusSurveys < ActiveRecord::Migration
  def change
    create_table :campus_surveys do |t|
      t.integer :campus_id
      t.integer :question_group_id

      t.timestamps
    end
    add_index :campus_surveys, :campus_id
    add_index :campus_surveys, :question_group_id
  end
end
