class AddPorIdToRecycleInfos < ActiveRecord::Migration
  def change
    add_column :recycle_infos, :por_id, :integer
  end
end
