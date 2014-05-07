class AddMobileUserIdToRapidfireAnswerGroups < ActiveRecord::Migration
  def change
    add_column :rapidfire_answer_groups, :mobile_user_id, :integer
  end
end
