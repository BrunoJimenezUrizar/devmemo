class CreateDumps < ActiveRecord::Migration
  def change
    create_table :dumps do |t|
      t.string :description
      t.string :qr_code
      t.references :type
      t.references :por

      t.timestamps
    end
    add_index :dumps, :type_id
    add_index :dumps, :por_id
  end
end
