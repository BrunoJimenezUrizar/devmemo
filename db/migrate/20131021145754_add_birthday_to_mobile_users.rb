class AddBirthdayToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :birthday, :date
  end
end
