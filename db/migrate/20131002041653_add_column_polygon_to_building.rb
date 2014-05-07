class AddColumnPolygonToBuilding < ActiveRecord::Migration
  def change
		add_column :buildings, :polygon, :polygon, :geographic => true, :null => false
  end
end
