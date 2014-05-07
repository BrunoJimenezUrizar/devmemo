class AddLatitudeToPoints < ActiveRecord::Migration
  def change
    add_column :points, :latitude, :decimal
  end
end
