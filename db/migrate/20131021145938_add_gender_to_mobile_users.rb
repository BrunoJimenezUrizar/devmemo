class AddGenderToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :gender, :string
  end
end
