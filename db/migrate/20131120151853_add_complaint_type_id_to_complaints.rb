class AddComplaintTypeIdToComplaints < ActiveRecord::Migration
  def change
    add_column :complaints, :complaint_type_id, :integer
  end
end
