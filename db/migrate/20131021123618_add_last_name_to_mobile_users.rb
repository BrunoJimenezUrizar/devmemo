class AddLastNameToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :last_name, :string
  end
end
