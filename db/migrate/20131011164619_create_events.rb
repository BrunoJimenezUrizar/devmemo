class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :start_advertising
      t.datetime :end_advertising
      t.references :campus

      t.timestamps
    end
  add_index :events, :campus_id  
  end
end
