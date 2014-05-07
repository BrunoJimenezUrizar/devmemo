class RenameTableCampusreportingCampusreportings < ActiveRecord::Migration
  def change
    rename_table :campusreporting, :campusreportings
  end
end
