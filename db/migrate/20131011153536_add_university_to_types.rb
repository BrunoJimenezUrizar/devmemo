class AddUniversityToTypes < ActiveRecord::Migration
  def change
  	add_column :types, :university_id, :integer
    add_index :types, :university_id
  end
end
