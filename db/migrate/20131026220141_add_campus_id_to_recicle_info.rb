class AddCampusIdToRecicleInfo < ActiveRecord::Migration
  def change
    add_column :recicle_infos, :campus_id, :integer
  end
end
