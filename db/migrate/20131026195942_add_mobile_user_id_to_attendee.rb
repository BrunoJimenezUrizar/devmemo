class AddMobileUserIdToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :mobile_user_id, :integer
  end
end
