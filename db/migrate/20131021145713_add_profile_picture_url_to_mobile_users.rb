class AddProfilePictureUrlToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :profile_picture_url, :string
  end
end
