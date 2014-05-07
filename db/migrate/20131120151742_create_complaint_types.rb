class CreateComplaintTypes < ActiveRecord::Migration
  def change
    create_table :complaint_types do |t|
      t.belongs_to :university
      t.string :name

      t.timestamps
    end
    add_index :complaint_types, :university_id
  end
end
