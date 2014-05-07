class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :location
      t.string :name
      t.string :description
      t.integer :type_id

      t.timestamps
    end
      add_index :points, :type_id
  end
end
