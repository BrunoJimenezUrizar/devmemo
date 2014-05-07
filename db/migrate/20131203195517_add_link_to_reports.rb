class AddLinkToReports < ActiveRecord::Migration
  def change
    add_column :reports, :link, :string
  end
end
