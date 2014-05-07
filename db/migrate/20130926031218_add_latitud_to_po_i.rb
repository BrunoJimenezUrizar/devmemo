class AddLatitudToPoI < ActiveRecord::Migration
  def change
    add_column :pois, :latitude, :decimal
    add_column :pois, :longitude, :decimal
  end
end
