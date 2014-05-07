class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.text :description
      t.string :status
      t.belongs_to :campus
      t.belongs_to :mobile_user

      t.timestamps
    end
    add_index :complaints, :campus_id
    add_index :complaints, :mobile_user_id
  end
end
