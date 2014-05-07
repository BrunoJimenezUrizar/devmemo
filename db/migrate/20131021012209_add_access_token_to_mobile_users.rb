class AddAccessTokenToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :access_token, :string
  end
end
