class CreateCampusreporting < ActiveRecord::Migration
  def up
  	create_table :campusreporting do |t|
  		t.references :campus
  		t.references :report
  	end
  	add_index :campusreporting, :campus_id
  	add_index :campusreporting, :report_id
  end

  def down
  	drop_table :campusreporting
  end
end
