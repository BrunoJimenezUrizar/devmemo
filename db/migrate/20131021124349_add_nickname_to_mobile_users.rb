class AddNicknameToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :nickname, :string
  end
end
