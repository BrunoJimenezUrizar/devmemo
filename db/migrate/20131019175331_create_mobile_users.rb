class CreateMobileUsers < ActiveRecord::Migration
  def change
    create_table :mobile_users do |t|
      t.string :email
      t.string :api_token
      t.string :name

      t.timestamps
    end
  end
end
