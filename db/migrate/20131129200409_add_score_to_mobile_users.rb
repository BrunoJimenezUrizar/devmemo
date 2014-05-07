class AddScoreToMobileUsers < ActiveRecord::Migration
  def change
    add_column :mobile_users, :score, :integer, :default => 0
  end
end
