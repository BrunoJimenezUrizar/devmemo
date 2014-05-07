class AddAddressAddressCoordinatesToCampus < ActiveRecord::Migration
  def change
  	add_column :campuses, :address, :string
  	add_column :campuses, :address_coordinates, :point, :srid => 4326, :geographic => true
  end
end
