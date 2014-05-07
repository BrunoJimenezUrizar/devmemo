class AddUniversityIdToRecicleInfo < ActiveRecord::Migration
  def change
    add_column :recicle_infos, :university_id, :integer
  end
end
