class CreateFloors < ActiveRecord::Migration
  def change
    create_table :floors do |t|
      t.references :building
      t.integer :number
      t.string :indoor_path
      t.text :description

      t.timestamps
    end
    add_index :floors, :building_id
  end
end
