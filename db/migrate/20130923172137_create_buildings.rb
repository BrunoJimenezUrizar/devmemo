class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.references :campus
      t.string :name

      t.timestamps
    end
    add_index :buildings, :campus_id
  end
end
