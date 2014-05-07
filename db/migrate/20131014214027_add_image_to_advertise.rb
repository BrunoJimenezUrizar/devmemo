class AddImageToAdvertise < ActiveRecord::Migration
  def self.up
  	add_column :advertises, :image_advertise_file_name, :string
  	add_column :advertises, :image_advertise_content_type, :string
  	add_column :advertises, :image_advertise_file_size, :integer
  end
  def self.down
  	remove_column :advertises, :image_advertise_file_name
  	remove_column :advertises, :image_advertise_content_type
  	remove_column :advertises, :image_advertise_file_size
  end
end
