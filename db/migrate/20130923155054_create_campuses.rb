class CreateCampuses < ActiveRecord::Migration
  def change
    create_table :campuses do |t|
      t.string :name
      t.references :university

      t.timestamps
    end
    add_index :campuses, :university_id
  end
end
