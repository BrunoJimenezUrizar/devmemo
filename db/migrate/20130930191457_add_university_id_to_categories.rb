class AddUniversityIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :university_id, :integer
    add_index :categories, :university_id
  end
end
