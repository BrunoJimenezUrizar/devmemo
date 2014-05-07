class AddLatitudeToPors < ActiveRecord::Migration
  def change
    add_column :pors, :latitude, :decimal
    add_column :pors, :longitude, :decimal
  end
end
