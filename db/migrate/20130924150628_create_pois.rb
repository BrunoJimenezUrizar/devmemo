class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.references :campus
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :pois, :campus_id
  end
end
