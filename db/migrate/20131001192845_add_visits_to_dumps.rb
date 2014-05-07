class AddVisitsToDumps < ActiveRecord::Migration
  def change
    add_column :dumps, :visits, :integer, :default => 0
  end
end
