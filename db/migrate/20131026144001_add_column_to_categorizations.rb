class AddColumnToCategorizations < ActiveRecord::Migration
  def change
  	add_column :categorizations, :event_id, :integer
  end
end
