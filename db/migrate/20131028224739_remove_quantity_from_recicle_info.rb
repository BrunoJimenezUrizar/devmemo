class RemoveQuantityFromRecicleInfo < ActiveRecord::Migration
  def up
    remove_column :recicle_infos, :quantity
  end

  def down
    add_column :recicle_infos, :quantity, :integer
  end
end
