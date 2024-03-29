class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :survey
      t.string :name
      t.text :content
      t.belongs_to :survey

      t.timestamps
    end
    add_index :questions, :survey_id
  end
end
