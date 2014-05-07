class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :complaint
      t.belongs_to :user
      t.boolean :public
      t.text :body

      t.timestamps
    end
    add_index :comments, :complaint_id
    add_index :comments, :user_id
  end
end
