class CreateAreapoints < ActiveRecord::Migration
  def change
    create_table :areapoints do |t|
      t.integer :area_id
      t.integer :point_id

      t.timestamps
    end
    	add_index :areapoints, :area_id
    	add_index :areapoints, :point_id

  end
end
