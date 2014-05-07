class CreateCampusadvertisings < ActiveRecord::Migration
  def up
  	create_table :campusadvertisings do |t|
  		t.references :campus
  		t.references :advertise
  	end
    add_index :campusadvertisings,:campus_id
    add_index :campusadvertisings,:advertise_id
  end

  def down
  	drop_table :campusadvertisings
  end
end
