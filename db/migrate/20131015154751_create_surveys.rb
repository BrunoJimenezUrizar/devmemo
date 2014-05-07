class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.boolean :active
      t.belongs_to :campus

      t.timestamps
    end
    add_index :surveys, :campus_id
  end
end
