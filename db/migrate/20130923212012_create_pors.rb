class CreatePors < ActiveRecord::Migration
  def change
    create_table :pors do |t|
      t.references :campus
      t.text :description

      t.timestamps
    end
    add_index :pors, :campus_id
  end
end
