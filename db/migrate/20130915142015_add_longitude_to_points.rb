class AddLongitudeToPoints < ActiveRecord::Migration
  def change
    add_column :points, :longitude, :decimal
  end
end
