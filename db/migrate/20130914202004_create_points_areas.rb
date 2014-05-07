class CreatePointsAreas < ActiveRecord::Migration
  def change
    create_table :points_areas do |t|
    	t.integer :point_id
    	t.integer :area_id

      t.timestamps
    end
      add_index :points_areas, :point_id
      add_index :points_areas, :area_id
  end
end
