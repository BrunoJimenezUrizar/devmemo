class RenameRecicleInfosToRecycleInfos < ActiveRecord::Migration
  def up
  	rename_table :recicle_infos, :recycle_infos
  end

  def down
  	rename_table :recycle_infos, :recicle_infos
  end
end
