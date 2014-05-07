class CreateRecicleInfos < ActiveRecord::Migration
  def change
    create_table :recicle_infos do |t|
      t.integer :mobile_user_id
      t.integer :dump_id
      t.integer :quantity

      t.timestamps
    end
  end
end
