class AddImageToReport < ActiveRecord::Migration
  def self.up
  	add_column :reports, :image_report_file_name, :string
  	add_column :reports, :image_report_content_type, :string
  	add_column :reports, :image_report_file_size, :integer
  end
  def self.down
  	remove_column :reports, :image_report_file_name
  	remove_column :reports, :image_report_content_type
  	remove_column :reports, :image_report_file_size
  end
end
