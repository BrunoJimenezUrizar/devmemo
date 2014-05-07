class AddFbIdToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :fb_id, :integer
  end
end
