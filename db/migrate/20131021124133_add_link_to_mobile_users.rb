class AddLinkToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :link, :string
  end
end
