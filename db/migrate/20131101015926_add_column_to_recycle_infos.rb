class AddColumnToRecycleInfos < ActiveRecord::Migration
  def change
    add_column :recycle_infos, :type_id, :integer
  end
end
